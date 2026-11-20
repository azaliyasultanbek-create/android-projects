import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
class CartScreen extends StatelessWidget {
  const CartScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (context, cart, child) {
        final theme = Theme.of(context);
        final colors = theme.colorScheme;
        return Scaffold(
          appBar: AppBar(
            title: const Text('My Cart'),
          ),
          body: cart.items.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.shopping_cart_outlined,
                        size: 80,
                        color: colors.onSurfaceVariant,
                      ),
                      const SizedBox(height: 15),
                      const Text(
                        'Your cart is empty',
                        style: TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                )
              : Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.all(12),
                        itemCount: cart.items.length,
                        itemBuilder: (context, index) {
                          final product = cart.items[index];
                          final quantity = cart.quantityFor(product);
                          return Card(
                            margin: const EdgeInsets.only(bottom: 12),
                            color: theme.cardColor,
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Row(
                                children: [
                                  Image.network(
                                    product.imageUrl,
                                    width: 65,
                                    height: 65,
                                    fit: BoxFit.contain,
                                    errorBuilder:
                                        (context, error, stackTrace) {
                                      return const Icon(
                                        Icons.image_not_supported,
                                        size: 50,
                                      );
                                    },
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          product.title,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        Text(
                                          '\$${product.price.toStringAsFixed(2)} each',
                                        ),
                                        const SizedBox(height: 8),
                                        Row(
                                          children: [
                                            IconButton(
                                              onPressed: () {
                                                cart.decreaseProduct(product);
                                              },
                                              icon: const Icon(
                                                Icons.remove_circle_outline,
                                              ),
                                            ),
                                            Text(
                                              '$quantity',
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                            IconButton(
                                              onPressed: () {
                                                cart.addProduct(product);
                                              },
                                              icon: const Icon(
                                                Icons.add_circle_outline,
                                              ),
                                              color: const Color(0xFFB76E79),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      cart.removeProduct(product);
                                    },
                                    icon: const Icon(
                                      Icons.delete_outline,
                                      color: Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(20),
                      color: theme.cardColor,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Total:',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '\$${cart.totalPrice.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFFB76E79),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                cart.clearCart();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFB76E79),
                                foregroundColor: Colors.white,
                              ),
                              child: const Text('Clear All'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
        );
      },
    );
  }
}
