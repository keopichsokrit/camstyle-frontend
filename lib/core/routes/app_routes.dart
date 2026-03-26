import 'package:flutter/material.dart';
// IMPORTANT: You MUST import these for the compiler to recognize the types
import '../../models/product_model.dart'; 
import '../../views/user/product_detail_screen.dart';
import '../../views/auth/start_screen.dart';
import '../../views/auth/login_screen.dart';
import '../../views/auth/register_screen.dart';
import '../../views/user/home_screen.dart';
import '../../views/user/profile_screen.dart';
import '../../views/admin/admin_dashboard.dart';
import '../../views/cart/cart_screen.dart';
import '../../views/cart/payment_screen.dart';
import '../../views/admin/new_product_screen.dart';
import '../../views/admin/new_category_screen.dart';
import '../../views/admin/update_product_screen.dart';
import '../../views/admin/update_category_screen.dart';
import '../../views/user/change_password_screen.dart';
import '../../views/user/help_screen.dart';

class AppRoutes {
  static const String startUp = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String userHome = '/user-home';
  static const String adminHome = '/admin-dashboard';
  static const String productDetail = '/product-detail';
  static const String cart = '/cart';
  static const String profile = '/profile';
  static const String payment = '/payment';
  static const String newProduct = '/new-product';
  static const String newCategory = '/new-category';
  static const String updateProduct = '/update-product';
  static const String updateCategory = '/update-category';
  static const String changePassword = '/change-password';
  static const String help = '/help';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case startUp:
        return MaterialPageRoute(builder: (_) => const StartUpScreen());
      
      case login:
        return MaterialPageRoute(builder: (_) => LoginScreen());
      
      case register:
        return MaterialPageRoute(builder: (_) => RegisterScreen());
      
      case userHome:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      
      case adminHome:
        return MaterialPageRoute(builder: (_) => const AdminDashboard());
      
      case productDetail:
        // FIX: You must cast 'arguments' to 'ProductModel'
        final args = settings.arguments;
        
        if (args is ProductModel) {
          return MaterialPageRoute(
            builder: (_) => ProductDetailScreen(product: args),
          );
        }
        // Fallback if the arguments are wrong
        return _errorRoute("Invalid Product Data");
        
      case cart:
        return MaterialPageRoute(builder: (_) => const CartScreen());
        
      case profile:
        return MaterialPageRoute(builder: (_) => const ProfileScreen());

      case payment:
        return MaterialPageRoute(builder: (_) => const PaymentScreen());
      
      // 3. ADD THE NEW CASES HERE
      case newProduct:
        return MaterialPageRoute(builder: (_) => const NewProductScreen());
      
      case newCategory:
        return MaterialPageRoute(builder: (_) => const NewCategoryScreen());
      
      case updateProduct:
        return MaterialPageRoute(builder: (_) => const UpdateProductScreen());
      
      case updateCategory:
        return MaterialPageRoute(builder: (_) => const UpdateCategoryScreen());
      case changePassword:
        return MaterialPageRoute(builder: (_) => const ChangePasswordScreen());
      case help:
        return MaterialPageRoute(builder: (_) => const HelpScreen());

      // 4. ONLY ONE DEFAULT AT THE BOTTOM
      default:
        return _errorRoute("No route defined for ${settings.name}");
    }
  }

  // Helper method to show an error screen instead of crashing
  static Route<dynamic> _errorRoute(String message) {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        body: Center(child: Text(message, style: const TextStyle(color: Colors.red))),
      ),
    );
  }
}