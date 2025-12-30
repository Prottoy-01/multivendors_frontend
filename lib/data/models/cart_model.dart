import 'cart_item_model.dart';

class CartModel {
  final int id;
  final int userId;
  final List<CartItemModel> items;
  final DateTime createdAt;
  final DateTime updatedAt;

  CartModel({
    required this.id,
    required this.userId,
    required this.items,
    required this.createdAt,
    required this.updatedAt,
  });

  double get subtotal => items.fold(0.0, (sum, item) => sum + item.totalPrice);

  double get totalDiscount =>
      items.fold(0.0, (sum, item) => sum + item.totalDiscount);

  int get itemCount => items.length;

  int get totalQuantity => items.fold(0, (sum, item) => sum + item.quantity);

  factory CartModel.fromJson(Map<String, dynamic> json) {
    return CartModel(
      id: json['id'],
      userId: json['user_id'],
      items: json['items'] != null
          ? (json['items'] as List)
                .map((item) => CartItemModel.fromJson(item))
                .toList()
          : [],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}
