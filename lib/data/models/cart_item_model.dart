import 'product_model.dart';

class CartItemModel {
  final int id;
  final int cartId;
  final int productId;
  final int quantity;
  final double price;
  final double finalPrice;
  final ProductModel? product;
  final DateTime createdAt;
  final DateTime updatedAt;

  CartItemModel({
    required this.id,
    required this.cartId,
    required this.productId,
    required this.quantity,
    required this.price,
    required this.finalPrice,
    this.product,
    required this.createdAt,
    required this.updatedAt,
  });

  double get totalPrice => finalPrice * quantity;
  double get totalDiscount => (price - finalPrice) * quantity;

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      id: json['id'],
      cartId: json['cart_id'],
      productId: json['product_id'],
      quantity: json['quantity'],
      price: double.parse(json['price'].toString()),
      finalPrice: double.parse(json['final_price'].toString()),
      product: json['product'] != null
          ? ProductModel.fromJson(json['product'])
          : null,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}
