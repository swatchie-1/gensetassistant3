class Product {
  final int id;
  final String name;
  final String price;
  final String permalink;
  final List<ProductImage> images;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.permalink,
    required this.images,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    List<ProductImage> productImages = [];
    if (json['images'] != null) {
      productImages = (json['images'] as List)
          .map((imageJson) => ProductImage.fromJson(imageJson))
          .toList();
    }

    return Product(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      price: json['price'] ?? '0',
      permalink: json['permalink'] ?? '',
      images: productImages,
    );
  }

  String get formattedPrice {
    if (price.isEmpty) return 'Price on Request';
    
    // Try to parse as double and format with currency
    try {
      double priceValue = double.parse(price);
      return 'RM ${priceValue.toStringAsFixed(2)}';
    } catch (e) {
      return 'RM $price';
    }
  }

  String? get thumbnailUrl {
    if (images.isNotEmpty) {
      return images.first.src;
    }
    return null;
  }

  String get shortName {
    if (name.length <= 50) return name;
    return '${name.substring(0, 50)}...';
  }
}

class ProductImage {
  final int id;
  final String src;
  final String name;
  final String alt;

  ProductImage({
    required this.id,
    required this.src,
    required this.name,
    required this.alt,
  });

  factory ProductImage.fromJson(Map<String, dynamic> json) {
    return ProductImage(
      id: json['id'] ?? 0,
      src: json['src'] ?? '',
      name: json['name'] ?? '',
      alt: json['alt'] ?? '',
    );
  }
}
