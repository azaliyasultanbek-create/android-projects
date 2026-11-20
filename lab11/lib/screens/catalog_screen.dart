import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../services/product_service.dart';
import '../providers/cart_provider.dart';
import 'cart_screen.dart';
import 'product_detail_screen.dart';
import 'notes_screen.dart';

class CatalogScreen extends StatefulWidget {
  final bool isDarkMode;
  final String username;
  final Future<void> Function(bool) onThemeChanged;
  final Future<void> Function(String) onUsernameSaved;

  const CatalogScreen({
    super.key,
    required this.isDarkMode,
    required this.username,
    required this.onThemeChanged,
    required this.onUsernameSaved,
  });

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  final ProductService _productService = ProductService();
  final TextEditingController _usernameController =
      TextEditingController();

  List<Product> products = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _usernameController.text = widget.username;
    loadProducts();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
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
        errorMessage =
            'Не удалось загрузить товары. Проверьте интернет.';
        isLoading = false;
      });
    }
  }

  Future<void> saveUsername() async {
    await widget.onUsernameSaved(_usernameController.text);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Имя успешно сохранено!'),
      ),
    );
  }

  void openNotes() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const NotesScreen(),
      ),
    );
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
          IconButton(
            tooltip: 'My Notes',
            onPressed: openNotes,
            icon: const Icon(Icons.note_alt_outlined),
          ),
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
        itemCount: products.length + 1,
        separatorBuilder: (context, index) =>
            const SizedBox(height: 12),
        itemBuilder: (context, index) {
          if (index == 0) {
            return _buildSettingsCard();
          }

          final product = products[index - 1];

          return Card(
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

  Widget _buildSettingsCard() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hello, ${widget.username}!',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(
                labelText: 'Your username',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person_outline),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: saveUsername,
                child: const Text('Save'),
              ),
            ),
            const Divider(height: 24),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Dark Mode'),
              secondary: const Icon(Icons.dark_mode_outlined),
              value: widget.isDarkMode,
              activeThumbColor: const Color(0xFFB76E79),
              onChanged: widget.onThemeChanged,
            ),
            const Divider(height: 16),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(
                Icons.note_alt_outlined,
                color: Color(0xFFB76E79),
              ),
              title: const Text(
                'My Notes',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: const Text('Create and manage your notes'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: openNotes,
            ),
          ],
        ),
      ),
    );
  }
}
