import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageHelper {
  // Instance of secure storage
  static final _storage = FlutterSecureStorage();

  // Keys to keep data organized
  static const String _keyToken = 'jwt_token';
  static const String _keyRole = 'user_role';
  static const String _keyUserName = 'user_name';

  // --- SAVE DATA ---
  
  /// Saves the JWT token received from loginUser backend controller
  static Future<void> saveToken(String token) async {
    await _storage.write(key: _keyToken, value: token);
  }

  /// Saves the user role ('admin' or 'user') to handle route logic
  static Future<void> saveRole(String role) async {
    await _storage.write(key: _keyRole, value: role);
  }

  /// Saves the name for display in the Home Drawer
  static Future<void> saveName(String name) async {
    await _storage.write(key: _keyUserName, value: name);
  }

  // --- RETRIEVE DATA ---

  /// Used by ApiConstants.dart to attach to 'Authorization' header
  static Future<String?> getToken() async {
    return await _storage.read(key: _keyToken);
  }

  /// Used by AppRoutes.dart or Controllers to check if user is Admin
  static Future<String?> getRole() async {
    return await _storage.read(key: _keyRole);
  }

  static Future<String?> getName() async {
    return await _storage.read(key: _keyUserName);
  }

  // --- DELETE DATA ---

  /// Clears everything (Used for Logout)
  static Future<void> logout() async {
    await _storage.deleteAll();
  }
}