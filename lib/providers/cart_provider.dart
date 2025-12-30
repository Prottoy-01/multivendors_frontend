import 'package:flutter/material.dart';
import '../data/models/cart_model.dart';
import '../data/models/cart_item_model.dart';
import '../data/models/product_model.dart';
import '../data/services/api_service.dart';
import '../core/constants/api_constants.dart';

class CartProvider extends ChangeNotifier {
  CartModel? _cart;
  bool _isLoading = false;

  CartModel? get cart => _cart;
  List<CartItemModel> get items => _cart?.items ?? [];
  bool get isLoading => _isLoading;
  int get itemCount => items.length;
  double get subtotal => _cart?.subtotal ?? 0;
  double get totalDiscount => _cart?.totalDiscount ?? 0;

  Future<void> fetchCart() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await ApiService.get(
        ApiConstants.cart,
        requiresAuth: true,
      );

      if (response['message'] == 'Cart is empty') {
        _cart = null;
      } else {
        _cart = CartModel.fromJson(response);
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> addToCart(ProductModel product, {int quantity = 1}) async {
    try {
      await ApiService.post(ApiConstants.addToCart, {
        'product_id': product.id,
        'quantity': quantity,
      }, requiresAuth: true);

      await fetchCart();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateQuantity(int cartItemId, int quantity) async {
    try {
      await ApiService.put(ApiConstants.updateCartItem(cartItemId), {
        'quantity': quantity,
      }, requiresAuth: true);

      await fetchCart();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> removeFromCart(int cartItemId) async {
    try {
      await ApiService.delete(
        ApiConstants.removeCartItem(cartItemId),
        requiresAuth: true,
      );

      await fetchCart();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> clearCart() async {
    _cart = null;
    notifyListeners();
  }
}
