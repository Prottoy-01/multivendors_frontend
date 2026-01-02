// import '../../core/constants/api_constants.dart';
// import 'api_service.dart';

// class AdminService {
//   // Get dashboard overview
//   static Future<Map<String, dynamic>> getDashboardOverview() async {
//     try {
//       final response = await ApiService.get(
//         ApiConstants.adminDashboardOverview,
//         requiresAuth: true,
//       );
//       return {'success': true, 'data': response};
//     } catch (e) {
//       return {'success': false, 'message': e.toString()};
//     }
//   }

//   // Get all vendors with optional status filter
//   static Future<Map<String, dynamic>> getVendors({String? status}) async {
//     try {
//       String url = ApiConstants.adminVendors;
//       if (status != null) {
//         url += '?status=$status';
//       }

//       final response = await ApiService.get(url, requiresAuth: true);
//       return {'success': true, 'data': response};
//     } catch (e) {
//       return {'success': false, 'message': e.toString()};
//     }
//   }

//   // Approve or reject vendor
//   static Future<Map<String, dynamic>> approveVendor({
//     required int vendorId,
//     required String status, // 'approved' or 'rejected'
//   }) async {
//     try {
//       final response = await ApiService.post(
//         '${ApiConstants.adminApproveVendor}/$vendorId/approve',
//         {'status': status},
//         requiresAuth: true,
//       );
//       return {'success': true, 'data': response};
//     } catch (e) {
//       return {'success': false, 'message': e.toString()};
//     }
//   }

//   // Get all users
//   static Future<Map<String, dynamic>> getUsers({String? role}) async {
//     try {
//       String url = ApiConstants.adminUsers;
//       if (role != null) {
//         url += '?role=$role';
//       }

//       final response = await ApiService.get(url, requiresAuth: true);
//       return {'success': true, 'data': response};
//     } catch (e) {
//       return {'success': false, 'message': e.toString()};
//     }
//   }

//   // Get all orders
//   static Future<Map<String, dynamic>> getOrders({
//     String? status,
//     int? vendorId,
//   }) async {
//     try {
//       String url = ApiConstants.adminOrders;
//       List<String> params = [];

//       if (status != null) {
//         params.add('status=$status');
//       }
//       if (vendorId != null) {
//         params.add('vendor_id=$vendorId');
//       }

//       if (params.isNotEmpty) {
//         url += '?${params.join('&')}';
//       }

//       final response = await ApiService.get(url, requiresAuth: true);
//       return {'success': true, 'data': response};
//     } catch (e) {
//       return {'success': false, 'message': e.toString()};
//     }
//   }
// }
import '../../core/constants/api_constants.dart';
import 'api_service.dart';

class AdminService {
  // Get dashboard overview
  static Future<Map<String, dynamic>> getDashboardOverview() async {
    try {
      final response = await ApiService.get(
        ApiConstants.adminDashboardOverview,
        requiresAuth: true,
      );
      return {'success': true, 'data': response};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  // Get all vendors with optional status filter
  static Future<Map<String, dynamic>> getVendors({String? status}) async {
    try {
      String url = ApiConstants.adminVendors;
      if (status != null) {
        url += '?status=$status';
      }

      print('🔍 AdminService: Getting vendors from: $url'); // DEBUG

      final response = await ApiService.get(url, requiresAuth: true);

      print('✅ AdminService: Got response: $response'); // DEBUG

      return {'success': true, 'data': response};
    } catch (e) {
      print('❌ AdminService Error: $e'); // DEBUG
      return {'success': false, 'message': e.toString()};
    }
  }

  // Approve or reject vendor
  static Future<Map<String, dynamic>> approveVendor({
    required int vendorId,
    required String status, // 'approved' or 'rejected'
  }) async {
    try {
      final response = await ApiService.post(
        '${ApiConstants.adminApproveVendor}/$vendorId/approve',
        {'status': status},
        requiresAuth: true,
      );
      return {'success': true, 'data': response};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  // Get all users
  static Future<Map<String, dynamic>> getUsers({String? role}) async {
    try {
      String url = ApiConstants.adminUsers;
      if (role != null) {
        url += '?role=$role';
      }

      final response = await ApiService.get(url, requiresAuth: true);
      return {'success': true, 'data': response};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  // Get all orders
  static Future<Map<String, dynamic>> getOrders({
    String? status,
    int? vendorId,
  }) async {
    try {
      String url = ApiConstants.adminOrders;
      List<String> params = [];

      if (status != null) {
        params.add('status=$status');
      }
      if (vendorId != null) {
        params.add('vendor_id=$vendorId');
      }

      if (params.isNotEmpty) {
        url += '?${params.join('&')}';
      }

      final response = await ApiService.get(url, requiresAuth: true);
      return {'success': true, 'data': response};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }
}
