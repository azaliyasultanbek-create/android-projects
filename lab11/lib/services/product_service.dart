import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';
class ProductService {
  static const String apiUrl =
      'https://dummyjson.com/products/category/beauty';
  Future<List<Product>> fetchProducts() async {
    final response = await http
        .get(Uri.parse(apiUrl))
        .timeout(const Duration(seconds: 15));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data =
      jsonDecode(response.body);
      final List<dynamic> productsJson = data['products'];
      return productsJson
          .map((json) => Product.fromJson(json))
          .toList();
    } else if (response.statusCode == 404) {
      throw Exception('Products not found');
    } else if (response.statusCode >= 500) {
      throw Exception('Server error');
    } else {
      throw Exception(
        'Failed to load products: ${response.statusCode}',
      );
    }
  }
}
