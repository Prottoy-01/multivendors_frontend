import 'order_item_model.dart';

class OrderModel {
  final int id;
  final int userId;
  final int vendorId;
  final double totalAmount;
  final double discountTotal;
  final String status;
  final String recipientName;
  final String phone;
  final String addressLine;
  final String city;
  final String state;
  final String postalCode;
  final String country;
  final List<OrderItemModel> items;
  final String? vendorName;
  final DateTime createdAt;
  final DateTime updatedAt;

  OrderModel({
    required this.id,
    required this.userId,
    required this.vendorId,
    required this.totalAmount,
    required this.discountTotal,
    required this.status,
    required this.recipientName,
    required this.phone,
    required this.addressLine,
    required this.city,
    required this.state,
    required this.postalCode,
    required this.country,
    required this.items,
    this.vendorName,
    required this.createdAt,
    required this.updatedAt,
  });

  String get fullAddress => '$addressLine, $city, $state $postalCode, $country';

  String get orderNumber => 'ORD${id.toString().padLeft(6, '0')}';

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'],
      userId: json['user_id'],
      vendorId: json['vendor_id'],
      totalAmount: double.parse(json['total_amount'].toString()),
      discountTotal: double.parse(json['discount_total'].toString()),
      status: json['status'],
      recipientName: json['recipient_name'],
      phone: json['phone'],
      addressLine: json['address_line'],
      city: json['city'],
      state: json['state'],
      postalCode: json['postal_code'],
      country: json['country'],
      items: json['items'] != null
          ? (json['items'] as List)
                .map((item) => OrderItemModel.fromJson(item))
                .toList()
          : [],
      vendorName: json['vendor']?['shop_name'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}
