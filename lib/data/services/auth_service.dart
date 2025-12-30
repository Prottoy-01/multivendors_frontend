import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants/api_constants.dart';
import '../models/user_model.dart';
import 'api_service.dart';

class AuthService {
  static Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
    required String role,
    String? phone, //change
  }) async {
    try {
      final response = await ApiService.post(ApiConstants.register, {
        'name': name,
        'email': email,
        'password': password,
        'role': role,
        if (phone != null && phone.isNotEmpty) 'phone': phone, //change
      });

      if (response['access_token'] != null) {
        await _saveToken(response['access_token']);
        final user = UserModel.fromJson(response['user']);
        return {'success': true, 'user': user};
      }

      return {'success': false, 'message': 'Invalid response'};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await ApiService.post(ApiConstants.login, {
        'email': email,
        'password': password,
      });

      if (response['access_token'] != null) {
        await _saveToken(response['access_token']);
        final user = UserModel.fromJson(response['user']);
        return {'success': true, 'user': user};
      }

      return {'success': false, 'message': 'Invalid response'};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  static Future<Map<String, dynamic>> registerVendor({
    required String name,
    required String email,
    required String password,
    required String shopName,
  }) async {
    try {
      final response = await ApiService.post(ApiConstants.registerVendor, {
        'name': name,
        'email': email,
        'password': password,
        'shop_name': shopName,
      });

      return {
        'success': true,
        'message': response['message'] ?? 'Vendor registration submitted',
      };
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  static Future<bool> logout() async {
    try {
      await ApiService.post(ApiConstants.logout, {}, requiresAuth: true);
      await _clearToken();
      return true;
    } catch (e) {
      await _clearToken();
      return false;
    }
  }

  static Future<UserModel?> getCurrentUser() async {
    try {
      final response = await ApiService.get(
        ApiConstants.profile,
        requiresAuth: true,
      );
      return UserModel.fromJson(response);
    } catch (e) {
      return null;
    }
  }

  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey('access_token');
  }

  static Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('access_token', token);
  }

  static Future<void> _clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token');
  }
}
