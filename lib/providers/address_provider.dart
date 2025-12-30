import 'package:flutter/material.dart';
import '../data/models/user_address_model.dart';
import '../data/services/api_service.dart';
import '../core/constants/api_constants.dart';

class AddressProvider extends ChangeNotifier {
  List<UserAddressModel> _addresses = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<UserAddressModel> get addresses => _addresses;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  UserAddressModel? get defaultAddress =>
      _addresses.firstWhere((a) => a.isDefault, orElse: () => _addresses.first);

  Future<void> fetchAddresses() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await ApiService.get(
        ApiConstants.addresses,
        requiresAuth: true,
      );

      _addresses = (response as List)
          .map((json) => UserAddressModel.fromJson(json))
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

  Future<bool> addAddress(Map<String, dynamic> addressData) async {
    try {
      await ApiService.post(
        ApiConstants.addresses,
        addressData,
        requiresAuth: true,
      );

      await fetchAddresses();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateAddress(int id, Map<String, dynamic> addressData) async {
    try {
      await ApiService.put(
        ApiConstants.updateAddress(id),
        addressData,
        requiresAuth: true,
      );

      await fetchAddresses();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteAddress(int id) async {
    try {
      await ApiService.delete(
        ApiConstants.deleteAddress(id),
        requiresAuth: true,
      );

      await fetchAddresses();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> setDefaultAddress(int id) async {
    try {
      await ApiService.post(
        ApiConstants.setDefaultAddress(id),
        {},
        requiresAuth: true,
      );

      await fetchAddresses();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }
}
