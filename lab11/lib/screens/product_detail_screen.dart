import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../providers/cart_provider.dart';
class ProductDetailScreen extends StatefulWidget {
  final Product product;
  const ProductDetailScreen({
    super.key,
    required this.product,
  });
  @override
  State<ProductDetailScreen> createState() =>
      _ProductDetailScreenState();
}
class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int currentPage = 0;
  List<String> get galleryImages {
    if (widget.product.images.isNotEmpty) {
      return widget.product.images;
    }
    return [widget.product.imageUrl];
  }
  void showShareSheet() {
    final link = 'narxoz://store/product/${widget.product.id}';
    final messenger = ScaffoldMessenger.of(context);
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    showModalBottomSheet(
      context: context,
      backgroundColor: colors.surface,
      builder: (sheetContext) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Share Product',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 15),
              const Text('Product Deep Link:'),
              const SizedBox(height: 8),
              SelectableText(link),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    await Clipboard.setData(
                      ClipboardData(text: link),
                    );
                    if (!sheetContext.mounted) return;
                    Navigator.pop(sheetContext);
                    messenger.showSnackBar(
                      const SnackBar(
                        content: Text('Link copied to clipboard!'),
                      ),
                    );
                  },
                  icon: const Icon(Icons.copy),
                  label: const Text('Copy Link'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFB76E79),
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Details'),
        actions: [
          IconButton(
            onPressed: showShareSheet,
            icon: const Icon(Icons.share_outlined),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 350,
              child: PageView.builder(
                itemCount: galleryImages.length,
                onPageChanged: (index) {
                  setState(() {
                    currentPage = index;
                  });
                },
                itemBuilder: (context, index) {
                  return Hero(
                    tag: index == 0
                        ? 'product_image_${product.id}'
                        : 'product_image_${product.id}_$index',
                    child: Image.network(
                      galleryImages[index],
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(
                          Icons.image_not_supported,
                          size: 80,
                          color: colors.onSurfaceVariant,
                        );
                      },
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
            Center(
              child: Text(
                '${currentPage + 1} / ${galleryImages.length}',
                style: TextStyle(
                  fontSize: 14,
                  color: colors.onSurfaceVariant,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                galleryImages.length,
                (index) {
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: currentPage == index ? 22 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: currentPage == index
                          ? const Color(0xFFB76E79)
                          : colors.outlineVariant,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: theme.brightness == Brightness.dark
                          ? const Color(0xFF49343B)
                          : const Color(0xFFF2DDE0),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      product.category.toUpperCase(),
                      style: const TextStyle(
                        color: Color(0xFFB76E79),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    product.title,
                    style: const TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '\$${product.price.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 22,
                      color: Color(0xFFB76E79),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        '${product.rating} (${product.reviewCount} reviews)',
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Description',
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    product.description,
                    style: const TextStyle(
                      fontSize: 15,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          color: colors.surface,
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            height: 52,
            child: ElevatedButton(
              onPressed: () {
                context.read<CartProvider>().addProduct(product);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Added to cart!'),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFB76E79),
                foregroundColor: Colors.white,
              ),
              child: const Text(
                'Add to Cart',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
