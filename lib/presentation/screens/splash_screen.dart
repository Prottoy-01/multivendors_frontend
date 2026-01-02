// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../../core/constants/app_colors.dart';
// import '../../providers/auth_provider.dart';
// import 'auth/login_screen.dart';
// import 'home/home_screen.dart';

// class SplashScreen extends StatefulWidget {
//   const SplashScreen({Key? key}) : super(key: key);

//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen> {
//   @override
//   void initState() {
//     super.initState();
//     _checkLoginStatus();
//   }

//   Future<void> _checkLoginStatus() async {
//     final authProvider = Provider.of<AuthProvider>(context, listen: false);
//     await authProvider.checkLoginStatus();

//     // Wait for 2 seconds to show splash screen
//     await Future.delayed(const Duration(seconds: 2));

//     if (mounted) {
//       Navigator.of(context).pushReplacement(
//         MaterialPageRoute(
//           builder: (_) => authProvider.isLoggedIn
//               ? const HomeScreen()
//               : const LoginScreen(),
//         ),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
//         child: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               // App Logo
//               Container(
//                 height: 120,
//                 width: 120,
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   shape: BoxShape.circle,
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withOpacity(0.2),
//                       blurRadius: 20,
//                       spreadRadius: 5,
//                     ),
//                   ],
//                 ),
//                 child: const Icon(
//                   Icons.shopping_bag,
//                   size: 60,
//                   color: AppColors.primary,
//                 ),
//               ),
//               const SizedBox(height: 32),

//               // App Name
//               const Text(
//                 'Multivendor Store',
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 32,
//                   fontWeight: FontWeight.bold,
//                   letterSpacing: 1.2,
//                 ),
//               ),
//               const SizedBox(height: 8),

//               // Tagline
//               const Text(
//                 'Shop from Multiple Vendors',
//                 style: TextStyle(color: Colors.white70, fontSize: 16),
//               ),
//               const SizedBox(height: 60),

//               // Loading Indicator
//               const CircularProgressIndicator(
//                 valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
//                 strokeWidth: 3,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import 'auth/login_screen.dart';
import 'home/home_screen.dart';
import 'admin/admin_dashboard_screen.dart';
import 'vendor/vendor_dashboard_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    print('🔍 [Splash] Checking login status...');

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      await authProvider.checkLoginStatus();

      // Wait for 2 seconds to show splash screen
      await Future.delayed(const Duration(seconds: 2));

      if (!mounted) return;

      print('🔍 [Splash] Is logged in: ${authProvider.isLoggedIn}');
      print('🔍 [Splash] User role: ${authProvider.user?.role}');

      // Navigate based on login status and role
      if (authProvider.isLoggedIn && authProvider.user != null) {
        final userRole = authProvider.user!.role;

        Widget destinationScreen;

        if (userRole == 'admin') {
          print('✅ [Splash] Routing to Admin Dashboard');
          destinationScreen = const AdminDashboardScreen();
        } else if (userRole == 'vendor') {
          print('✅ [Splash] Routing to Vendor Dashboard');
          destinationScreen = const VendorDashboardScreen();
        } else {
          print('✅ [Splash] Routing to Customer Home');
          destinationScreen = const HomeScreen();
        }

        Navigator.of(
          context,
        ).pushReplacement(MaterialPageRoute(builder: (_) => destinationScreen));
      } else {
        print('✅ [Splash] Not logged in, routing to Login');
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const LoginScreen()),
        );
      }
    } catch (e, stackTrace) {
      print('❌ [Splash] Error: $e');
      print('❌ [Splash] Stack trace: $stackTrace');

      // On error, go to login screen
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const LoginScreen()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF6C63FF), Color(0xFF5A52D5)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // App Logo
              Container(
                height: 120,
                width: 120,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.shopping_bag,
                  size: 60,
                  color: Color(0xFF6C63FF),
                ),
              ),
              const SizedBox(height: 32),

              // App Name
              const Text(
                'Multivendor Store',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 8),

              // Tagline
              const Text(
                'Shop from Multiple Vendors',
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
              const SizedBox(height: 60),

              // Loading Indicator
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                strokeWidth: 3,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
