import 'package:flutter/material.dart';
import '../models/product.dart';
class CartProvider extends ChangeNotifier {
  final Map<int, Product> _items = {};
  final Map<int, int> _quantities = {};
  List<Product> get items => _items.values.toList();
  int get itemCount {
    return _quantities.values.fold(
      0,
          (sum, quantity) => sum + quantity,
    );
  }
  double get totalPrice {
    double total = 0;

    _items.forEach((id, product) {
      total += product.price * _quantities[id]!;
    });
    return total;
  }
  int quantityFor(Product product) {
    return _quantities[product.id] ?? 0;
  }
  bool contains(Product product) {
    return _items.containsKey(product.id);
  }
  void addProduct(Product product) {
    if (_items.containsKey(product.id)) {
      _quantities[product.id] =
          _quantities[product.id]! + 1;
    } else {
      _items[product.id] = product;
      _quantities[product.id] = 1;
    }

    notifyListeners();
  }
  void decreaseProduct(Product product) {
    if (!_items.containsKey(product.id)) return;
    if (_quantities[product.id]! > 1) {
      _quantities[product.id] =
          _quantities[product.id]! - 1;
    } else {
      _items.remove(product.id);
      _quantities.remove(product.id);
    }
    notifyListeners();
  }
  void removeProduct(Product product) {
    _items.remove(product.id);
    _quantities.remove(product.id);
    notifyListeners();
  }
  void clearCart() {
    _items.clear();
    _quantities.clear();
    notifyListeners();
  }
}
