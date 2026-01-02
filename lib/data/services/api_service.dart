// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
// import '../../core/constants/api_constants.dart';

// class ApiService {
//   static Future<String?> _getToken() async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.getString('access_token');
//   }

//   static Future<Map<String, String>> _getHeaders({
//     bool requiresAuth = false,
//   }) async {
//     Map<String, String> headers = {
//       'Content-Type': 'application/json',
//       'Accept': 'application/json',
//     };

//     if (requiresAuth) {
//       final token = await _getToken();
//       if (token != null) {
//         headers['Authorization'] = 'Bearer $token';
//       }
//     }

//     return headers;
//   }

//   static Future<dynamic> get(
//     String endpoint, {
//     bool requiresAuth = false,
//   }) async {
//     try {
//       final headers = await _getHeaders(requiresAuth: requiresAuth);
//       final response = await http.get(Uri.parse(endpoint), headers: headers);
//       return _handleResponse(response);
//     } catch (e) {
//       throw Exception('Network error: $e');
//     }
//   }

//   static Future<dynamic> post(
//     String endpoint,
//     Map<String, dynamic> body, {
//     bool requiresAuth = false,
//   }) async {
//     try {
//       final headers = await _getHeaders(requiresAuth: requiresAuth);
//       final response = await http.post(
//         Uri.parse(endpoint),
//         headers: headers,
//         body: jsonEncode(body),
//       );
//       return _handleResponse(response);
//     } catch (e) {
//       throw Exception('Network error: $e');
//     }
//   }

//   static Future<dynamic> put(
//     String endpoint,
//     Map<String, dynamic> body, {
//     bool requiresAuth = false,
//   }) async {
//     try {
//       final headers = await _getHeaders(requiresAuth: requiresAuth);
//       final response = await http.put(
//         Uri.parse(endpoint),
//         headers: headers,
//         body: jsonEncode(body),
//       );
//       return _handleResponse(response);
//     } catch (e) {
//       throw Exception('Network error: $e');
//     }
//   }

//   static Future<dynamic> delete(
//     String endpoint, {
//     bool requiresAuth = false,
//   }) async {
//     try {
//       final headers = await _getHeaders(requiresAuth: requiresAuth);
//       final response = await http.delete(Uri.parse(endpoint), headers: headers);
//       return _handleResponse(response);
//     } catch (e) {
//       throw Exception('Network error: $e');
//     }
//   }

//   static dynamic _handleResponse(http.Response response) {
//     final int statusCode = response.statusCode;

//     if (statusCode >= 200 && statusCode < 300) {
//       if (response.body.isEmpty) return {'success': true};
//       return jsonDecode(response.body);
//     } else if (statusCode == 401) {
//       throw Exception('Unauthorized. Please login again.');
//     } else if (statusCode == 403) {
//       final errorData = jsonDecode(response.body);
//       throw Exception(errorData['message'] ?? 'Access forbidden');
//     } else if (statusCode == 404) {
//       throw Exception('Resource not found.');
//     } else if (statusCode >= 500) {
//       throw Exception('Server error. Please try again later.');
//     } else {
//       try {
//         final errorData = jsonDecode(response.body);
//         throw Exception(errorData['message'] ?? 'Something went wrong');
//       } catch (e) {
//         throw Exception('Request failed with status: $statusCode');
//       }
//     }
//   }
// }
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants/api_constants.dart';

class ApiService {
  static Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token');
  }

  static Future<Map<String, String>> _getHeaders({
    bool requiresAuth = false,
  }) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (requiresAuth) {
      final token = await _getToken();
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }
    }

    return headers;
  }

  // ✅ FIXED: Added baseUrl construction
  static String _buildUrl(String endpoint) {
    // If endpoint already has http/https, return as is
    if (endpoint.startsWith('http://') || endpoint.startsWith('https://')) {
      return endpoint;
    }
    // Otherwise, combine with baseUrl
    return '${ApiConstants.baseUrl}$endpoint';
  }

  static Future<dynamic> get(
    String endpoint, {
    bool requiresAuth = false,
  }) async {
    try {
      final headers = await _getHeaders(requiresAuth: requiresAuth);
      final url = _buildUrl(endpoint); // ✅ CHANGED

      print('🔵 [API GET] URL: $url'); // DEBUG
      print('🔵 [API GET] Headers: $headers'); // DEBUG

      final response = await http.get(
        Uri.parse(url),
        headers: headers,
      ); // ✅ CHANGED

      print('📥 [API GET] Status: ${response.statusCode}'); // DEBUG

      return _handleResponse(response);
    } catch (e) {
      print('❌ [API GET] Error: $e'); // DEBUG
      throw Exception('Network error: $e');
    }
  }

  static Future<dynamic> post(
    String endpoint,
    Map<String, dynamic> body, {
    bool requiresAuth = false,
  }) async {
    try {
      final headers = await _getHeaders(requiresAuth: requiresAuth);
      final url = _buildUrl(endpoint); // ✅ CHANGED

      print('🔵 [API POST] URL: $url'); // DEBUG

      final response = await http.post(
        Uri.parse(url), // ✅ CHANGED
        headers: headers,
        body: jsonEncode(body),
      );

      print('📥 [API POST] Status: ${response.statusCode}'); // DEBUG

      return _handleResponse(response);
    } catch (e) {
      print('❌ [API POST] Error: $e'); // DEBUG
      throw Exception('Network error: $e');
    }
  }

  static Future<dynamic> put(
    String endpoint,
    Map<String, dynamic> body, {
    bool requiresAuth = false,
  }) async {
    try {
      final headers = await _getHeaders(requiresAuth: requiresAuth);
      final url = _buildUrl(endpoint); // ✅ CHANGED

      final response = await http.put(
        Uri.parse(url), // ✅ CHANGED
        headers: headers,
        body: jsonEncode(body),
      );
      return _handleResponse(response);
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  static Future<dynamic> delete(
    String endpoint, {
    bool requiresAuth = false,
  }) async {
    try {
      final headers = await _getHeaders(requiresAuth: requiresAuth);
      final url = _buildUrl(endpoint); // ✅ CHANGED

      final response = await http.delete(
        Uri.parse(url),
        headers: headers,
      ); // ✅ CHANGED
      return _handleResponse(response);
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  static dynamic _handleResponse(http.Response response) {
    final int statusCode = response.statusCode;

    if (statusCode >= 200 && statusCode < 300) {
      if (response.body.isEmpty) return {'success': true};
      return jsonDecode(response.body);
    } else if (statusCode == 401) {
      throw Exception('Unauthorized. Please login again.');
    } else if (statusCode == 403) {
      final errorData = jsonDecode(response.body);
      throw Exception(errorData['message'] ?? 'Access forbidden');
    } else if (statusCode == 404) {
      throw Exception('Resource not found.');
    } else if (statusCode >= 500) {
      throw Exception('Server error. Please try again later.');
    } else {
      try {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['message'] ?? 'Something went wrong');
      } catch (e) {
        throw Exception('Request failed with status: $statusCode');
      }
    }
  }
}
