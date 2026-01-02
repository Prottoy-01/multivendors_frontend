// import 'user_model.dart';

// class VendorModel {
//   final int id;
//   final int userId;
//   final String shopName;
//   final String status; // pending, approved, rejected
//   final double commissionPercentage;
//   final DateTime createdAt;
//   final UserModel? user;

//   VendorModel({
//     required this.id,
//     required this.userId,
//     required this.shopName,
//     required this.status,
//     required this.commissionPercentage,
//     required this.createdAt,
//     this.user,
//   });

//   factory VendorModel.fromJson(Map<String, dynamic> json) {
//     return VendorModel(
//       id: json['id'] ?? 0,
//       userId: json['user_id'] ?? 0,
//       shopName: json['shop_name'] ?? '',
//       status: json['status'] ?? 'pending',
//       commissionPercentage: (json['commission_percentage'] ?? 0).toDouble(),
//       createdAt: json['created_at'] != null
//           ? DateTime.parse(json['created_at'])
//           : DateTime.now(),
//       user: json['user'] != null ? UserModel.fromJson(json['user']) : null,
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'user_id': userId,
//       'shop_name': shopName,
//       'status': status,
//       'commission_percentage': commissionPercentage,
//       'created_at': createdAt.toIso8601String(),
//       //if (user != null) 'user': user!.toJson(),
//     };
//   }

//   bool get isPending => status == 'pending';
//   bool get isApproved => status == 'approved';
//   bool get isRejected => status == 'rejected';

//   String get statusColor {
//     switch (status) {
//       case 'approved':
//         return 'green';
//       case 'rejected':
//         return 'red';
//       default:
//         return 'orange';
//     }
//   }
// }
import 'user_model.dart';

class VendorModel {
  final int id;
  final int userId;
  final String shopName;
  final String status; // pending, approved, rejected
  final double commissionPercentage;
  final DateTime createdAt;
  final UserModel? user;

  VendorModel({
    required this.id,
    required this.userId,
    required this.shopName,
    required this.status,
    required this.commissionPercentage,
    required this.createdAt,
    this.user,
  });

  factory VendorModel.fromJson(Map<String, dynamic> json) {
    return VendorModel(
      id: json['id'] ?? 0,
      userId: json['user_id'] ?? 0,
      shopName: json['shop_name'] ?? '',
      status: json['status'] ?? 'pending',
      commissionPercentage: _parseDouble(
        json['commission_percentage'],
      ), // ✅ FIXED
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
      user: json['user'] != null ? UserModel.fromJson(json['user']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'shop_name': shopName,
      'status': status,
      'commission_percentage': commissionPercentage,
      'created_at': createdAt.toIso8601String(),
      if (user != null) 'user_id': user!.id,
      if (user != null) 'user_name': user!.name,
      if (user != null) 'user_email': user!.email,
    };
  }

  bool get isPending => status == 'pending';
  bool get isApproved => status == 'approved';
  bool get isRejected => status == 'rejected';

  String get statusColor {
    switch (status) {
      case 'approved':
        return 'green';
      case 'rejected':
        return 'red';
      default:
        return 'orange';
    }
  }

  // ✅ NEW: Helper method to safely parse commission_percentage
  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) {
      return double.tryParse(value) ?? 0.0;
    }
    return 0.0;
  }
}
