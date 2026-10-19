import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Cấu hình địa chỉ server Contests-BE.
///
/// Mặc định:
/// - Android emulator: http://10.0.2.2:3000 (trỏ về localhost của máy tính)
/// - Các nền tảng khác: http://localhost:3000
///
/// Có thể ghi đè lúc build: `flutter run --dart-define=API_BASE_URL=http://192.168.1.10:3000`
/// hoặc đổi trực tiếp trong màn hình "Cài đặt máy chủ" của app.
class AppConfig {
  AppConfig._();

  static const _kBaseUrl = 'server_base_url';
  static const _envBaseUrl = String.fromEnvironment('API_BASE_URL');

  static late SharedPreferences _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static String get defaultBaseUrl {
    if (_envBaseUrl.isNotEmpty) return _envBaseUrl;
    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      return 'http://10.0.2.2:3000';
    }
    return 'http://localhost:3000';
  }

  /// Gốc server, ví dụ `http://10.0.2.2:3000` (không có dấu `/` cuối).
  static String get baseUrl => _prefs.getString(_kBaseUrl) ?? defaultBaseUrl;

  /// Tiền tố REST API: `<baseUrl>/api`.
  static String get apiUrl => '$baseUrl/api';

  static Future<void> setBaseUrl(String url) async {
    var value = url.trim();
    while (value.endsWith('/')) {
      value = value.substring(0, value.length - 1);
    }
    if (value.endsWith('/api')) value = value.substring(0, value.length - 4);
    await _prefs.setString(_kBaseUrl, value);
  }

  static Future<void> resetBaseUrl() => _prefs.remove(_kBaseUrl);

  /// Chuyển đường dẫn media tương đối (vd: `/uploads/abc.png`) thành URL đầy đủ.
  static String mediaUrl(String? path) {
    if (path == null || path.isEmpty) return '';
    if (path.startsWith('http://') || path.startsWith('https://')) return path;
    return path.startsWith('/') ? '$baseUrl$path' : '$baseUrl/$path';
  }
}
