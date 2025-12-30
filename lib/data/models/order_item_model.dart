import 'product_model.dart';

class OrderItemModel {
  final int id;
  final int orderId;
  final int productId;
  final double price;
  final double finalPrice;
  final int quantity;
  final ProductModel? product;
  final DateTime createdAt;
  final DateTime updatedAt;

  OrderItemModel({
    required this.id,
    required this.orderId,
    required this.productId,
    required this.price,
    required this.finalPrice,
    required this.quantity,
    this.product,
    required this.createdAt,
    required this.updatedAt,
  });

  double get totalPrice => finalPrice * quantity;
  double get discount => (price - finalPrice) * quantity;

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      id: json['id'],
      orderId: json['order_id'],
      productId: json['product_id'],
      price: double.parse(json['price'].toString()),
      finalPrice: double.parse(json['final_price'].toString()),
      quantity: json['quantity'],
      product: json['product'] != null
          ? ProductModel.fromJson(json['product'])
          : null,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}
