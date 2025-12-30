import 'package:flutter/material.dart';
import '../data/models/order_model.dart';
import '../data/services/api_service.dart';
import '../core/constants/api_constants.dart';

class OrderProvider extends ChangeNotifier {
  List<OrderModel> _orders = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<OrderModel> get orders => _orders;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchOrders() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await ApiService.get(
        ApiConstants.myOrders,
        requiresAuth: true,
      );

      _orders = (response as List)
          .map((json) => OrderModel.fromJson(json))
          .toList();

      _isLoading = false;
      _errorMessage = null;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<Map<String, dynamic>> placeOrder(int addressId) async {
    try {
      await ApiService.post(ApiConstants.checkout, {
        'address_id': addressId,
      }, requiresAuth: true);

      await fetchOrders();
      return {'success': true};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }
}
