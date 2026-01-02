// import 'dart:io';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
// import 'dart:convert';
// import '../../core/constants/api_constants.dart';
// import '../models/product_model.dart';

// class ProductService {
//   static Future<Map<String, dynamic>> getVendorProducts() async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       final token = prefs.getString('access_token');

//       if (token == null) {
//         return {'success': false, 'message': 'Not authenticated'};
//       }

//       final url = Uri.parse(
//         '${ApiConstants.baseUrl}/vendor/dashboard/products',
//       );

//       print('🔵 [ProductService] Getting vendor products from: $url');

//       final response = await http.get(
//         url,
//         headers: {
//           'Content-Type': 'application/json',
//           'Accept': 'application/json',
//           'Authorization': 'Bearer $token',
//         },
//       );

//       print('📥 [ProductService] Response: ${response.statusCode}');
//       print('📥 [ProductService] Body: ${response.body}');

//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);

//         // Handle pagination format
//         List<dynamic> productsJson;

//         if (data is Map && data.containsKey('data')) {
//           productsJson = data['data'] as List? ?? [];
//         } else if (data is List) {
//           productsJson = data;
//         } else if (data is Map && data.containsKey('products')) {
//           productsJson = data['products'] as List? ?? [];
//         } else {
//           return {'success': false, 'message': 'Invalid response format'};
//         }

//         final productsList = productsJson
//             .map((json) => ProductModel.fromJson(json))
//             .toList();

//         return {'success': true, 'products': productsList};
//       } else {
//         return {
//           'success': false,
//           'message': 'Failed to load products: ${response.statusCode}',
//         };
//       }
//     } catch (e) {
//       print('❌ [ProductService] Error: $e');
//       return {'success': false, 'message': e.toString()};
//     }
//   }

//   // Get all categories - FIXED VERSION
//   static Future<Map<String, dynamic>> getCategories() async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       final token = prefs.getString('access_token');

//       // Use the baseUrl from ApiConstants
//       final url = Uri.parse('${ApiConstants.baseUrl}/categories');

//       print('🔵 [ProductService] Getting categories from: $url');

//       final headers = {
//         'Content-Type': 'application/json',
//         'Accept': 'application/json',
//       };

//       // Add token if available (for authenticated access)
//       if (token != null) {
//         headers['Authorization'] = 'Bearer $token';
//         print('🔑 [ProductService] Using auth token');
//       }

//       print('📤 [ProductService] Request headers: $headers');

//       final response = await http.get(url, headers: headers);

//       print('📥 [ProductService] Categories status: ${response.statusCode}');
//       print('📥 [ProductService] Categories body: ${response.body}');

//       if (response.statusCode == 200) {
//         final responseBody = response.body;

//         // Parse JSON
//         dynamic data = jsonDecode(responseBody);

//         print('📦 [ProductService] Parsed data type: ${data.runtimeType}');
//         print('📦 [ProductService] Parsed data: $data');

//         // Handle different response formats from Laravel
//         List<dynamic> categoriesData;

//         if (data is List) {
//           // Direct array: [{"id": 1, "name": "Electronics"}, ...]
//           categoriesData = data;
//         } else if (data is Map) {
//           // Wrapped in object: {"data": [...]}
//           if (data['data'] != null) {
//             categoriesData = data['data'] as List;
//           } else if (data['categories'] != null) {
//             categoriesData = data['categories'] as List;
//           } else {
//             // Maybe it's paginated: {"current_page": 1, "data": [...]}
//             categoriesData = data['data'] ?? [];
//           }
//         } else {
//           print('❌ [ProductService] Unexpected data format');
//           return {'success': false, 'message': 'Invalid response format'};
//         }

//         print('✅ [ProductService] Found ${categoriesData.length} categories');

//         // Convert to List<Map<String, dynamic>>
//         final categories = categoriesData.map((cat) {
//           return {
//             'id': cat['id'] is int
//                 ? cat['id']
//                 : int.parse(cat['id'].toString()),
//             'name': cat['name']?.toString() ?? 'Unknown',
//             'description': cat['description']?.toString(),
//           };
//         }).toList();

//         print('✅ [ProductService] Processed categories: $categories');

//         return {'success': true, 'categories': categories};
//       } else if (response.statusCode == 401) {
//         return {
//           'success': false,
//           'message': 'Unauthorized. Please login again.',
//         };
//       } else if (response.statusCode == 404) {
//         return {
//           'success': false,
//           'message': 'Categories endpoint not found. Check backend routes.',
//         };
//       } else {
//         return {
//           'success': false,
//           'message': 'Failed to load categories: ${response.statusCode}',
//         };
//       }
//     } catch (e, stackTrace) {
//       print('❌ [ProductService] Error loading categories: $e');
//       print('❌ [ProductService] Stack trace: $stackTrace');
//       return {'success': false, 'message': 'Error: $e'};
//     }
//   }

//   // Create new product with images
//   static Future<Map<String, dynamic>> createProduct({
//     required String name,
//     required String description,
//     required double price,
//     required int stock,
//     required int categoryId,
//     required List<File> images,
//   }) async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       final token = prefs.getString('access_token');

//       if (token == null) {
//         return {'success': false, 'message': 'Not authenticated'};
//       }

//       final url = Uri.parse('${ApiConstants.baseUrl}/products');

//       print('🔵 [ProductService] Creating product at: $url');

//       // Create multipart request
//       var request = http.MultipartRequest('POST', url);

//       // Add headers
//       request.headers.addAll({
//         'Accept': 'application/json',
//         'Authorization': 'Bearer $token',
//       });

//       // Add text fields
//       request.fields['name'] = name;
//       request.fields['description'] = description;
//       request.fields['price'] = price.toString();
//       request.fields['stock'] = stock.toString();
//       request.fields['category_id'] = categoryId.toString();

//       print('📝 [ProductService] Product data:');
//       print('   Name: $name');
//       print('   Category ID: $categoryId');
//       print('   Price: $price');
//       print('   Stock: $stock');

//       // Add images
//       for (int i = 0; i < images.length; i++) {
//         final file = images[i];
//         final stream = http.ByteStream(file.openRead());
//         final length = await file.length();

//         final multipartFile = http.MultipartFile(
//           'images[]', // Laravel expects array
//           stream,
//           length,
//           filename: 'product_image_$i.jpg',
//         );

//         request.files.add(multipartFile);
//         print('📷 [ProductService] Added image $i: ${file.path}');
//       }

//       print('📤 [ProductService] Uploading ${images.length} images...');

//       // Send request
//       final streamedResponse = await request.send();
//       final response = await http.Response.fromStream(streamedResponse);

//       print('📥 [ProductService] Response: ${response.statusCode}');
//       print('📥 [ProductService] Body: ${response.body}');

//       if (response.statusCode == 200 || response.statusCode == 201) {
//         return {'success': true, 'message': 'Product created successfully'};
//       } else {
//         try {
//           final errorData = jsonDecode(response.body);
//           return {
//             'success': false,
//             'message': errorData['message'] ?? 'Failed to create product',
//           };
//         } catch (e) {
//           return {
//             'success': false,
//             'message': 'Failed to create product: ${response.statusCode}',
//           };
//         }
//       }
//     } catch (e, stackTrace) {
//       print('❌ [ProductService] Error: $e');
//       print('❌ [ProductService] Stack trace: $stackTrace');
//       return {'success': false, 'message': 'Error: $e'};
//     }
//   }

//   // Update product
//   static Future<Map<String, dynamic>> updateProduct({
//     required int productId,
//     required String name,
//     required String description,
//     required double price,
//     required int stock,
//     required int categoryId,
//     List<File>? newImages,
//   }) async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       final token = prefs.getString('access_token');

//       if (token == null) {
//         return {'success': false, 'message': 'Not authenticated'};
//       }

//       final url = Uri.parse('${ApiConstants.baseUrl}/products/$productId');

//       var request = http.MultipartRequest('POST', url);

//       // Laravel method spoofing for PUT
//       request.fields['_method'] = 'PUT';

//       request.headers.addAll({
//         'Accept': 'application/json',
//         'Authorization': 'Bearer $token',
//       });

//       request.fields['name'] = name;
//       request.fields['description'] = description;
//       request.fields['price'] = price.toString();
//       request.fields['stock'] = stock.toString();
//       request.fields['category_id'] = categoryId.toString();

//       // Add new images if provided
//       if (newImages != null) {
//         for (int i = 0; i < newImages.length; i++) {
//           final file = newImages[i];
//           final stream = http.ByteStream(file.openRead());
//           final length = await file.length();

//           final multipartFile = http.MultipartFile(
//             'images[]',
//             stream,
//             length,
//             filename: 'image_$i.jpg',
//           );

//           request.files.add(multipartFile);
//         }
//       }

//       final streamedResponse = await request.send();
//       final response = await http.Response.fromStream(streamedResponse);

//       if (response.statusCode == 200) {
//         return {'success': true, 'message': 'Product updated successfully'};
//       } else {
//         final errorData = jsonDecode(response.body);
//         return {
//           'success': false,
//           'message': errorData['message'] ?? 'Failed to update product',
//         };
//       }
//     } catch (e) {
//       print('❌ [ProductService] Error: $e');
//       return {'success': false, 'message': e.toString()};
//     }
//   }

//   // Delete product
//   static Future<Map<String, dynamic>> deleteProduct(int productId) async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       final token = prefs.getString('access_token');

//       if (token == null) {
//         return {'success': false, 'message': 'Not authenticated'};
//       }

//       final url = Uri.parse('${ApiConstants.baseUrl}/products/$productId');

//       final response = await http.delete(
//         url,
//         headers: {
//           'Content-Type': 'application/json',
//           'Accept': 'application/json',
//           'Authorization': 'Bearer $token',
//         },
//       );

//       if (response.statusCode == 200) {
//         return {'success': true, 'message': 'Product deleted successfully'};
//       } else {
//         return {'success': false, 'message': 'Failed to delete product'};
//       }
//     } catch (e) {
//       return {'success': false, 'message': e.toString()};
//     }
//   }
// }
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../core/constants/api_constants.dart';
import '../models/product_model.dart';
import '../models/order_model.dart';

class ProductService {
  static Future<Map<String, dynamic>> getVendorProducts() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token');

      if (token == null) {
        return {'success': false, 'message': 'Not authenticated'};
      }

      final url = Uri.parse(
        '${ApiConstants.baseUrl}/vendor/dashboard/products',
      );

      print('🔵 [ProductService] Getting vendor products from: $url');

      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('📥 [ProductService] Response: ${response.statusCode}');
      print('📥 [ProductService] Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Handle pagination format
        List<dynamic> productsJson;

        if (data is Map && data.containsKey('data')) {
          productsJson = data['data'] as List? ?? [];
        } else if (data is List) {
          productsJson = data;
        } else if (data is Map && data.containsKey('products')) {
          productsJson = data['products'] as List? ?? [];
        } else {
          return {'success': false, 'message': 'Invalid response format'};
        }

        final productsList = productsJson
            .map((json) => ProductModel.fromJson(json))
            .toList();

        return {'success': true, 'products': productsList};
      } else {
        return {
          'success': false,
          'message': 'Failed to load products: ${response.statusCode}',
        };
      }
    } catch (e) {
      print('❌ [ProductService] Error: $e');
      return {'success': false, 'message': e.toString()};
    }
  }

  // ⭐ NEW METHOD: Get vendor's orders with customer addresses
  static Future<Map<String, dynamic>> getVendorOrders() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token');

      if (token == null) {
        return {'success': false, 'message': 'Not authenticated'};
      }

      final url = Uri.parse('${ApiConstants.baseUrl}/vendor/dashboard/orders');

      print('🔵 [ProductService] Getting vendor orders from: $url');

      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('📥 [ProductService] Orders response: ${response.statusCode}');
      print('📥 [ProductService] Orders body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Handle Laravel pagination format
        List<dynamic> ordersJson;

        if (data is Map && data.containsKey('data')) {
          // Paginated response: {"current_page": 1, "data": [...], ...}
          ordersJson = data['data'] as List? ?? [];
        } else if (data is List) {
          // Direct array response: [...]
          ordersJson = data;
        } else if (data is Map && data.containsKey('orders')) {
          // Wrapped response: {"orders": [...]}
          ordersJson = data['orders'] as List? ?? [];
        } else {
          print('❌ [ProductService] Unexpected orders response format');
          return {'success': false, 'message': 'Invalid response format'};
        }

        print('📦 [ProductService] Found ${ordersJson.length} orders');

        // Convert to OrderModel list
        final ordersList = ordersJson
            .map((json) => OrderModel.fromJson(json))
            .toList();

        print(
          '✅ [ProductService] Successfully parsed ${ordersList.length} orders',
        );

        return {'success': true, 'orders': ordersList};
      } else if (response.statusCode == 404) {
        // No orders endpoint or no orders yet
        print('⚠️ [ProductService] Orders endpoint not found or no orders');
        return {'success': true, 'orders': []};
      } else if (response.statusCode == 401) {
        return {
          'success': false,
          'message': 'Unauthorized. Please login again.',
        };
      } else {
        return {
          'success': false,
          'message': 'Failed to load orders: ${response.statusCode}',
        };
      }
    } catch (e, stackTrace) {
      print('❌ [ProductService] Error loading orders: $e');
      print('❌ [ProductService] Stack trace: $stackTrace');
      // Return empty orders instead of error so UI doesn't break
      return {'success': true, 'orders': []};
    }
  }

  // Get all categories - FIXED VERSION
  static Future<Map<String, dynamic>> getCategories() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token');

      // Use the baseUrl from ApiConstants
      final url = Uri.parse('${ApiConstants.baseUrl}/categories');

      print('🔵 [ProductService] Getting categories from: $url');

      final headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

      // Add token if available (for authenticated access)
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
        print('🔑 [ProductService] Using auth token');
      }

      print('📤 [ProductService] Request headers: $headers');

      final response = await http.get(url, headers: headers);

      print('📥 [ProductService] Categories status: ${response.statusCode}');
      print('📥 [ProductService] Categories body: ${response.body}');

      if (response.statusCode == 200) {
        final responseBody = response.body;

        // Parse JSON
        dynamic data = jsonDecode(responseBody);

        print('📦 [ProductService] Parsed data type: ${data.runtimeType}');
        print('📦 [ProductService] Parsed data: $data');

        // Handle different response formats from Laravel
        List<dynamic> categoriesData;

        if (data is List) {
          // Direct array: [{"id": 1, "name": "Electronics"}, ...]
          categoriesData = data;
        } else if (data is Map) {
          // Wrapped in object: {"data": [...]}
          if (data['data'] != null) {
            categoriesData = data['data'] as List;
          } else if (data['categories'] != null) {
            categoriesData = data['categories'] as List;
          } else {
            // Maybe it's paginated: {"current_page": 1, "data": [...]}
            categoriesData = data['data'] ?? [];
          }
        } else {
          print('❌ [ProductService] Unexpected data format');
          return {'success': false, 'message': 'Invalid response format'};
        }

        print('✅ [ProductService] Found ${categoriesData.length} categories');

        // Convert to List<Map<String, dynamic>>
        final categories = categoriesData.map((cat) {
          return {
            'id': cat['id'] is int
                ? cat['id']
                : int.parse(cat['id'].toString()),
            'name': cat['name']?.toString() ?? 'Unknown',
            'description': cat['description']?.toString(),
          };
        }).toList();

        print('✅ [ProductService] Processed categories: $categories');

        return {'success': true, 'categories': categories};
      } else if (response.statusCode == 401) {
        return {
          'success': false,
          'message': 'Unauthorized. Please login again.',
        };
      } else if (response.statusCode == 404) {
        return {
          'success': false,
          'message': 'Categories endpoint not found. Check backend routes.',
        };
      } else {
        return {
          'success': false,
          'message': 'Failed to load categories: ${response.statusCode}',
        };
      }
    } catch (e, stackTrace) {
      print('❌ [ProductService] Error loading categories: $e');
      print('❌ [ProductService] Stack trace: $stackTrace');
      return {'success': false, 'message': 'Error: $e'};
    }
  }

  // Create new product with images
  static Future<Map<String, dynamic>> createProduct({
    required String name,
    required String description,
    required double price,
    required int stock,
    required int categoryId,
    required List<File> images,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token');

      if (token == null) {
        return {'success': false, 'message': 'Not authenticated'};
      }

      final url = Uri.parse('${ApiConstants.baseUrl}/products');

      print('🔵 [ProductService] Creating product at: $url');

      // Create multipart request
      var request = http.MultipartRequest('POST', url);

      // Add headers
      request.headers.addAll({
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      });

      // Add text fields
      request.fields['name'] = name;
      request.fields['description'] = description;
      request.fields['price'] = price.toString();
      request.fields['stock'] = stock.toString();
      request.fields['category_id'] = categoryId.toString();

      print('📝 [ProductService] Product data:');
      print('   Name: $name');
      print('   Category ID: $categoryId');
      print('   Price: $price');
      print('   Stock: $stock');

      // Add images
      for (int i = 0; i < images.length; i++) {
        final file = images[i];
        final stream = http.ByteStream(file.openRead());
        final length = await file.length();

        final multipartFile = http.MultipartFile(
          'images[]', // Laravel expects array
          stream,
          length,
          filename: 'product_image_$i.jpg',
        );

        request.files.add(multipartFile);
        print('📷 [ProductService] Added image $i: ${file.path}');
      }

      print('📤 [ProductService] Uploading ${images.length} images...');

      // Send request
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      print('📥 [ProductService] Response: ${response.statusCode}');
      print('📥 [ProductService] Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {'success': true, 'message': 'Product created successfully'};
      } else {
        try {
          final errorData = jsonDecode(response.body);
          return {
            'success': false,
            'message': errorData['message'] ?? 'Failed to create product',
          };
        } catch (e) {
          return {
            'success': false,
            'message': 'Failed to create product: ${response.statusCode}',
          };
        }
      }
    } catch (e, stackTrace) {
      print('❌ [ProductService] Error: $e');
      print('❌ [ProductService] Stack trace: $stackTrace');
      return {'success': false, 'message': 'Error: $e'};
    }
  }

  // Update product
  static Future<Map<String, dynamic>> updateProduct({
    required int productId,
    required String name,
    required String description,
    required double price,
    required int stock,
    required int categoryId,
    List<File>? newImages,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token');

      if (token == null) {
        return {'success': false, 'message': 'Not authenticated'};
      }

      final url = Uri.parse('${ApiConstants.baseUrl}/products/$productId');

      var request = http.MultipartRequest('POST', url);

      // Laravel method spoofing for PUT
      request.fields['_method'] = 'PUT';

      request.headers.addAll({
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      });

      request.fields['name'] = name;
      request.fields['description'] = description;
      request.fields['price'] = price.toString();
      request.fields['stock'] = stock.toString();
      request.fields['category_id'] = categoryId.toString();

      // Add new images if provided
      if (newImages != null) {
        for (int i = 0; i < newImages.length; i++) {
          final file = newImages[i];
          final stream = http.ByteStream(file.openRead());
          final length = await file.length();

          final multipartFile = http.MultipartFile(
            'images[]',
            stream,
            length,
            filename: 'image_$i.jpg',
          );

          request.files.add(multipartFile);
        }
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        return {'success': true, 'message': 'Product updated successfully'};
      } else {
        final errorData = jsonDecode(response.body);
        return {
          'success': false,
          'message': errorData['message'] ?? 'Failed to update product',
        };
      }
    } catch (e) {
      print('❌ [ProductService] Error: $e');
      return {'success': false, 'message': e.toString()};
    }
  }

  // Delete product
  static Future<Map<String, dynamic>> deleteProduct(int productId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token');

      if (token == null) {
        return {'success': false, 'message': 'Not authenticated'};
      }

      final url = Uri.parse('${ApiConstants.baseUrl}/products/$productId');

      final response = await http.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return {'success': true, 'message': 'Product deleted successfully'};
      } else {
        return {'success': false, 'message': 'Failed to delete product'};
      }
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }
}
