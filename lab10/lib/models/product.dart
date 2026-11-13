class Product {
  final int id;
  final String title;
  final String description;
  final double price;
  final String category;
  final String imageUrl;
  final List<String> images;
  final double rating;
  final int reviewCount;
  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.category,
    required this.imageUrl,
    required this.images,
    required this.rating,
    required this.reviewCount,
  });
  factory Product.fromJson(Map<String, dynamic> json) {
    final reviews = json['reviews'] as List? ?? [];

    final firstReview = reviews.isNotEmpty
        ? reviews[0] as Map<String, dynamic>
        : null;
    return Product(
      id: (json['id'] as num).toInt(),
      title: json['title']?.toString() ?? 'Unknown product',
      description: json['description']?.toString() ?? '',
      price: (json['price'] as num).toDouble(),
      category: json['category']?.toString() ?? 'beauty',
      imageUrl: json['thumbnail']?.toString() ?? '',
      images: (json['images'] as List?)
          ?.map((image) => image.toString())
          .toList() ??
          [],
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      reviewCount: (firstReview?['rating'] as num?)?.toInt() ?? 0,
    );
  }
}
