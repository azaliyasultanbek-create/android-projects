import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../services/product_service.dart';
import '../providers/cart_provider.dart';
import 'cart_screen.dart';
import 'product_detail_screen.dart';
class CatalogScreen extends StatefulWidget {
  const CatalogScreen({super.key});
  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}
class _CatalogScreenState extends State<CatalogScreen> {
  final ProductService _productService = ProductService();
  List<Product> products = [];
  bool isLoading = true;
  String? errorMessage;
  @override
  void initState() {
    super.initState();
    loadProducts();
  }
  Future<void> loadProducts() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });
    try {
      final result = await _productService.fetchProducts();
      if (!mounted) return;
      setState(() {
        products = result;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        errorMessage = 'Не удалось загрузить товары. Проверьте интернет.';
        isLoading = false;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'AZI Cosmetics',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
        actions: [
          Consumer<CartProvider>(
            builder: (context, cart, child) {
              return Stack(
                children: [
                  IconButton(
                    icon: const Icon(Icons.shopping_bag_outlined),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CartScreen(),
                        ),
                      );
                    },
                  ),
                  if (cart.itemCount > 0)
                    Positioned(
                      right: 5,
                      top: 5,
                      child: CircleAvatar(
                        radius: 9,
                        backgroundColor: const Color(0xFFB76E79),
                        child: Text(
                          '${cart.itemCount}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
      body: _buildBody(),
    );
  }
  Widget _buildBody() {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          color: Color(0xFFB76E79),
        ),
      );
    }
    if (errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.wifi_off,
                size: 65,
                color: Color(0xFFB76E79),
              ),
              const SizedBox(height: 16),
              const Text(
                'Нет подключения',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                errorMessage!,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: loadProducts,
                child: const Text('Повторить'),
              ),
            ],
          ),
        ),
      );
    }
    return RefreshIndicator(
      color: const Color(0xFFB76E79),
      onRefresh: loadProducts,
      child: ListView.separated(
        padding: const EdgeInsets.all(12),
        itemCount: products.length,
        separatorBuilder: (context, index) =>
        const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final product = products[index];
          return Card(
            color: Colors.white,
            elevation: 2,
            child: ListTile(
              contentPadding: const EdgeInsets.all(12),
              leading: Hero(
                tag: 'product_image_${product.id}',
                child: Image.network(
                  product.imageUrl,
                  width: 65,
                  height: 65,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.image_not_supported);
                  },
                ),
              ),
              title: Text(
                product.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 6),
                  Text(
                    '\$${product.price.toStringAsFixed(2)}',
                    style: const TextStyle(
                      color: Color(0xFFB76E79),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        Icons.star,
                        color: Colors.amber,
                        size: 18,
                      ),
                      const SizedBox(width: 4),
                      Text('${product.rating}'),
                    ],
                  ),
                ],
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProductDetailScreen(
                      product: product,
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
