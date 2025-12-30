import 'package:flutter/material.dart';
import '../data/models/product_model.dart';
import '../data/services/api_service.dart';
import '../core/constants/api_constants.dart';

class ProductProvider extends ChangeNotifier {
  List<ProductModel> _products = [];
  bool _isLoading = false;
  String? _errorMessage;
  int _currentPage = 1;
  bool _hasMore = true;

  List<ProductModel> get products => _products;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get hasMore => _hasMore;

  Future<void> fetchProducts({
    String? search,
    int? categoryId,
    String? sortBy,
    bool refresh = false,
  }) async {
    if (refresh) {
      _products = [];
      _currentPage = 1;
      _hasMore = true;
    }

    if (_isLoading || !_hasMore) return;

    _isLoading = true;
    notifyListeners();

    try {
      String url = '${ApiConstants.products}?page=$_currentPage';
      if (search != null && search.isNotEmpty) {
        url += '&search=$search';
      }
      if (categoryId != null) {
        url += '&category_id=$categoryId';
      }
      if (sortBy != null) {
        url += '&sort_by=$sortBy';
      }

      final response = await ApiService.get(url);

      final newProducts = (response['data']['data'] as List)
          .map((json) => ProductModel.fromJson(json))
          .toList();

      _products.addAll(newProducts);
      _currentPage++;
      _hasMore = newProducts.length >= 10;

      _isLoading = false;
      _errorMessage = null;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<ProductModel?> getProductById(int id) async {
    try {
      final response = await ApiService.get('${ApiConstants.products}/$id');
      return ProductModel.fromJson(response['data']);
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return null;
    }
  }

  void clearProducts() {
    _products = [];
    _currentPage = 1;
    _hasMore = true;
    notifyListeners();
  }
}
