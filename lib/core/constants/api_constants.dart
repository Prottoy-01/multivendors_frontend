class ApiConstants {
  // ⚠️ REPLACE WITH YOUR ACTUAL API URL
  static const String baseUrl = 'http://127.0.0.1:8000/api';
  //static const String baseUrl = 'http://192.168.1.X:8000/api';
  static const String storageUrl = 'http://127.0.0.1:8000/storage';

  // Auth Endpoints
  static const String register = '$baseUrl/register';
  static const String login = '$baseUrl/login';
  static const String logout = '$baseUrl/logout';
  static const String googleAuth = '$baseUrl/auth/google';
  static const String registerVendor = '$baseUrl/vendor/register';
  static const String forgotPassword = '$baseUrl/forgot-password';
  static const String resetPassword = '$baseUrl/reset-password';
  static const String changePassword = '$baseUrl/change-password';

  // Profile
  static const String profile = '$baseUrl/profile';
  static const String vendorProfile = '$baseUrl/vendor/profile';

  // Products
  static const String products = '$baseUrl/products';

  // Categories (Admin)
  static const String categories = '$baseUrl/categories';

  // Cart
  static const String cart = '$baseUrl/cart';
  static const String addToCart = '$baseUrl/cart/add';
  static String updateCartItem(int id) => '$baseUrl/cart/item/$id';
  static String removeCartItem(int id) => '$baseUrl/cart/item/$id';

  // Orders
  static const String checkout = '$baseUrl/checkout';
  static const String myOrders = '$baseUrl/orders';
  static String updateOrderStatus(int id) => '$baseUrl/orders/$id/status';

  // Addresses
  static const String addresses = '$baseUrl/addresses';
  static String updateAddress(int id) => '$baseUrl/addresses/$id';
  static String deleteAddress(int id) => '$baseUrl/addresses/$id';
  static String setDefaultAddress(int id) => '$baseUrl/addresses/$id/default';

  // Admin User Management
  static const String adminDashboardOverview = '/admin/dashboard/overview';
  static const String adminVendors = '/admin/vendors';
  static const String adminUsers = '/admin/users';
  static const String adminOrders = '/admin/orders';
  static const String adminApproveVendor = '/vendor';
}
