import 'package:flutter/foundation.dart';

import '../../core/network/api_client.dart';
import 'auth_models.dart';
import 'auth_service.dart';

enum AuthStatus { unknown, unauthenticated, authenticated }

/// Trạng thái phiên đăng nhập của app.
class AuthProvider extends ChangeNotifier {
  AuthProvider({AuthService? service}) : _service = service ?? AuthService() {
    ApiClient.instance.onSessionExpired = _handleSessionExpired;
  }

  final AuthService _service;

  AuthStatus _status = AuthStatus.unknown;
  AppUser? _user;

  /// Thông báo một lần khi phiên bị kết thúc từ phía server.
  String? sessionMessage;

  AuthStatus get status => _status;
  AppUser? get user => _user;
  AuthService get service => _service;

  /// Khôi phục phiên từ cookie đã lưu khi mở app.
  Future<void> bootstrap() async {
    if (!await ApiClient.instance.hasSessionCookie()) {
      _set(AuthStatus.unauthenticated, null);
      return;
    }
    try {
      final user = await _service.profile();
      _set(AuthStatus.authenticated, user);
    } catch (_) {
      _set(AuthStatus.unauthenticated, null);
    }
  }

  Future<AppUser> login(String identifier, String password) async {
    await _service.login(identifier, password);
    return _loadProfile();
  }

  Future<AppUser> studentLogin(String identifier, String password) async {
    await _service.studentLogin(identifier, password);
    return _loadProfile();
  }

  Future<AppUser> _loadProfile() async {
    final user = await _service.profile();
    _set(AuthStatus.authenticated, user);
    return user;
  }

  Future<void> refreshProfile() async {
    try {
      _user = await _service.profile();
      notifyListeners();
    } catch (_) {}
  }

  Future<void> logout() async {
    await _service.logout();
    _set(AuthStatus.unauthenticated, null);
  }

  /// Xoá phiên phía client mà không gọi API (sau khi đổi mật khẩu).
  Future<void> logoutLocal() async {
    await ApiClient.instance.clearCookies();
    _set(AuthStatus.unauthenticated, null);
  }

  void _handleSessionExpired(String message) {
    if (_status != AuthStatus.authenticated) return;
    sessionMessage = message;
    _set(AuthStatus.unauthenticated, null);
  }

  String? takeSessionMessage() {
    final m = sessionMessage;
    sessionMessage = null;
    return m;
  }

  void _set(AuthStatus status, AppUser? user) {
    _status = status;
    _user = user;
    notifyListeners();
  }
}
