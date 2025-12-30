class ProductModel {
  final int id;
  final int vendorId;
  final int categoryId;
  final String name;
  final String description;
  final double price;
  final int stock;
  final bool hasOffer;
  final String? discountType;
  final double? discountValue;
  final DateTime? offerStart;
  final DateTime? offerEnd;
  final double finalPrice;
  final List<String> images;
  final String? vendorName;
  final String? categoryName;
  final DateTime createdAt;
  final DateTime updatedAt;

  ProductModel({
    required this.id,
    required this.vendorId,
    required this.categoryId,
    required this.name,
    required this.description,
    required this.price,
    required this.stock,
    required this.hasOffer,
    this.discountType,
    this.discountValue,
    this.offerStart,
    this.offerEnd,
    required this.finalPrice,
    required this.images,
    this.vendorName,
    this.categoryName,
    required this.createdAt,
    required this.updatedAt,
  });

  bool get hasDiscount => hasOffer && finalPrice < price;
  int get discountPercentage {
    if (!hasDiscount) return 0;
    return (((price - finalPrice) / price) * 100).round();
  }

  bool get inStock => stock > 0;
  String get mainImage => images.isNotEmpty ? images[0] : '';

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    List<String> imagesList = [];

    if (json['images'] != null && json['images'] is List) {
      imagesList = List<String>.from(json['images']);
    }

    if (json['images_url'] != null && json['images_url'] is List) {
      imagesList = List<String>.from(json['images_url']);
    }

    return ProductModel(
      id: json['id'],
      vendorId: json['vendor_id'],
      categoryId: json['category_id'],
      name: json['name'],
      description: json['description'] ?? '',
      price: double.parse(json['price'].toString()),
      stock: json['stock'] ?? 0,
      hasOffer: json['has_offer'] == 1 || json['has_offer'] == true,
      discountType: json['discount_type'],
      discountValue: json['discount_value'] != null
          ? double.parse(json['discount_value'].toString())
          : null,
      offerStart: json['offer_start'] != null
          ? DateTime.parse(json['offer_start'])
          : null,
      offerEnd: json['offer_end'] != null
          ? DateTime.parse(json['offer_end'])
          : null,
      finalPrice: double.parse(json['final_price'].toString()),
      images: imagesList,
      vendorName: json['vendor']?['shop_name'],
      categoryName: json['category']?['name'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}
