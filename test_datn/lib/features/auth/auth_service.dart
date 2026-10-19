import '../../core/network/api_client.dart';
import 'auth_models.dart';

/// Các API trong `/api/auth` của Contests-BE.
class AuthService {
  AuthService([ApiClient? client]) : _api = client ?? ApiClient.instance;

  final ApiClient _api;

  /// Đăng nhập Admin / Trọng tài — `POST /auth/login`.
  Future<void> login(String identifier, String password) =>
      _api.post('/auth/login', data: {'identifier': identifier.trim(), 'password': password});

  /// Đăng nhập thí sinh — `POST /auth/student-login`.
  Future<void> studentLogin(String identifier, String password) => _api
      .post('/auth/student-login', data: {'identifier': identifier.trim(), 'password': password});

  Future<AppUser> profile() async {
    final data = await _api.get('/auth/profile');
    return AppUser.fromJson(Map<String, dynamic>.from(data as Map));
  }

  Future<void> logout() async {
    try {
      await _api.post('/auth/logout');
    } catch (_) {
      // Bỏ qua — vẫn xoá cookie phía client.
    } finally {
      await _api.clearCookies();
    }
  }

  // ----- Quên mật khẩu (email -> OTP -> mật khẩu mới) -----

  Future<void> forgotPassword(String email) =>
      _api.post('/auth/forgot-password', data: {'email': email.trim()});

  Future<void> verifyOtp(String email, String otp) =>
      _api.post('/auth/verify-otp', data: {'email': email.trim(), 'otp': otp.trim()});

  Future<void> resetPassword({
    required String email,
    required String otp,
    required String newPassword,
    required String confirmNewPassword,
  }) =>
      _api.post('/auth/reset-password', data: {
        'email': email.trim(),
        'otp': otp.trim(),
        'newPassword': newPassword,
        'confirmNewPassword': confirmNewPassword,
      });

  // ----- Tài khoản -----

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmNewPassword,
  }) =>
      _api.post('/auth/change-password', data: {
        'currentPassword': currentPassword,
        'newPassword': newPassword,
        'confirmNewPassword': confirmNewPassword,
      });

  /// `POST /auth/change-info` — FE gửi cả `username` và `email` (BE chỉ dùng email).
  Future<void> changeInfo({required String username, required String email}) =>
      _api.post('/auth/change-info', data: {'username': username, 'email': email.trim()});
}
