import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

export 'package:hive_flutter/hive_flutter.dart';
export 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  final SharedPreferences _prefs;
  final FlutterSecureStorage _secureStorage;

  StorageService(this._prefs, this._secureStorage);

  static Future<StorageService> init() async {
    await Hive.initFlutter();
    
    
    await Hive.openBox('profile_box');
    await Hive.openBox('requests_box');
    await Hive.openBox('hospitals_box');
    await Hive.openBox('notifications_box');
    
    final prefs = await SharedPreferences.getInstance();
    const secureStorage = FlutterSecureStorage(
      aOptions: AndroidOptions(encryptedSharedPreferences: true),
    );
    return StorageService(prefs, secureStorage);
  }

  
  static const String _authTokenKey = 'auth_token';
  static const String _userRoleKey = 'user_role';
  static const String _themeModeKey = 'theme_mode';

  
  Future<void> saveAuthToken(String token) async {
    await _secureStorage.write(key: _authTokenKey, value: token);
  }

  Future<String?> getAuthToken() async {
    return await _secureStorage.read(key: _authTokenKey);
  }

  Future<void> deleteAuthToken() async {
    await _secureStorage.delete(key: _authTokenKey);
  }

  
  Future<void> saveUserRole(String role) async {
    await _prefs.setString(_userRoleKey, role);
  }

  String? getUserRole() {
    return _prefs.getString(_userRoleKey);
  }

  
  Future<void> saveThemeMode(bool isDarkMode) async {
    await _prefs.setBool(_themeModeKey, isDarkMode);
  }

  bool getThemeMode() {
    return _prefs.getBool(_themeModeKey) ?? false;
  }

  
  Box get profileBox => Hive.box('profile_box');
  Box get requestsBox => Hive.box('requests_box');
  Box get hospitalsBox => Hive.box('hospitals_box');
  Box get notificationsBox => Hive.box('notifications_box');

  
  Future<void> clearAll() async {
    await _secureStorage.deleteAll();
    await _prefs.clear();
    await profileBox.clear();
    await requestsBox.clear();
    await hospitalsBox.clear();
    await notificationsBox.clear();
  }
}
