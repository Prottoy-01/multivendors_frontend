class UserAddressModel {
  final int id;
  final int userId;
  final String recipientName;
  final String phone;
  final String addressLine;
  final String city;
  final String state;
  final String postalCode;
  final String country;
  final bool isDefault;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserAddressModel({
    required this.id,
    required this.userId,
    required this.recipientName,
    required this.phone,
    required this.addressLine,
    required this.city,
    required this.state,
    required this.postalCode,
    required this.country,
    required this.isDefault,
    required this.createdAt,
    required this.updatedAt,
  });

  String get fullAddress => '$addressLine, $city, $state $postalCode, $country';

  factory UserAddressModel.fromJson(Map<String, dynamic> json) {
    return UserAddressModel(
      id: json['id'],
      userId: json['user_id'],
      recipientName: json['recipient_name'],
      phone: json['phone'],
      addressLine: json['address_line'],
      city: json['city'],
      state: json['state'],
      postalCode: json['postal_code'],
      country: json['country'],
      isDefault: json['is_default'] == 1 || json['is_default'] == true,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'recipient_name': recipientName,
      'phone': phone,
      'address_line': addressLine,
      'city': city,
      'state': state,
      'postal_code': postalCode,
      'country': country,
      'is_default': isDefault,
    };
  }
}
