import 'dart:async';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:path_provider/path_provider.dart';

import '../config/app_config.dart';
import 'api_exception.dart';

/// HTTP client dùng chung cho toàn app.
///
/// Contests-BE xác thực bằng cookie httpOnly `accessToken` / `refreshToken`
/// (không đọc header Authorization), nên app lưu cookie bằng [PersistCookieJar]
/// để giữ phiên đăng nhập giữa các lần mở app — tương đương `withCredentials: true`
/// trong axios của Contests-FE.
class ApiClient {
  ApiClient._();

  static final ApiClient instance = ApiClient._();

  late final Dio dio;

  /// Dio không có interceptor xác thực — dùng để refresh token và gửi lại request.
  late final Dio _plain;
  late final CookieJar _cookieJar;

  /// Được gọi khi phiên đăng nhập hết hạn hẳn (refresh thất bại,
  /// tài khoản bị khoá hoặc đăng nhập ở thiết bị khác).
  void Function(String message)? onSessionExpired;

  Completer<bool>? _refreshing;

  Future<void> init() async {
    final dir = await getApplicationSupportDirectory();
    _cookieJar = PersistCookieJar(
      ignoreExpires: false,
      storage: FileStorage('${dir.path}/.cookies/'),
    );

    BaseOptions options() => BaseOptions(
          baseUrl: AppConfig.apiUrl,
          connectTimeout: const Duration(seconds: 15),
          receiveTimeout: const Duration(seconds: 20),
          contentType: Headers.jsonContentType,
          responseType: ResponseType.json,
        );

    _plain = Dio(options())..interceptors.add(CookieManager(_cookieJar));
    dio = Dio(options())
      ..interceptors.add(CookieManager(_cookieJar))
      ..interceptors.add(InterceptorsWrapper(onError: _onError));
  }

  /// Cập nhật baseUrl sau khi người dùng đổi địa chỉ server.
  void reloadBaseUrl() {
    dio.options.baseUrl = AppConfig.apiUrl;
    _plain.options.baseUrl = AppConfig.apiUrl;
  }

  /// Chuỗi header `Cookie` để gửi kèm khi bắt tay Socket.IO
  /// (BE đọc `socket.handshake.headers.cookie`).
  Future<String> cookieHeader() async {
    final cookies = await _cookieJar.loadForRequest(Uri.parse(AppConfig.apiUrl));
    return cookies.map((c) => '${c.name}=${c.value}').join('; ');
  }

  Future<bool> hasSessionCookie() async {
    final cookies = await _cookieJar.loadForRequest(Uri.parse(AppConfig.apiUrl));
    return cookies.any((c) => c.name == 'accessToken' || c.name == 'refreshToken');
  }

  Future<void> clearCookies() => _cookieJar.deleteAll();

  // ---------------------------------------------------------------------------
  // Helpers: trả về phần `data` của response chuẩn `{ success, message, data }`.
  // ---------------------------------------------------------------------------

  Future<dynamic> get(String path, {Map<String, dynamic>? query}) =>
      _wrap(() => dio.get(path, queryParameters: query));

  Future<dynamic> post(String path, {Object? data}) => _wrap(() => dio.post(path, data: data));

  /// Trả về toàn bộ body (khi cần cả `message`).
  Future<Map<String, dynamic>> postRaw(String path, {Object? data}) async {
    try {
      final res = await dio.post(path, data: data);
      return _asMap(res.data);
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  Future<dynamic> _wrap(Future<Response> Function() call) async {
    try {
      final res = await call();
      final body = res.data;
      if (body is Map && body.containsKey('success')) {
        if (body['success'] == false) {
          throw ApiException(body['message']?.toString() ?? 'Có lỗi xảy ra',
              statusCode: res.statusCode);
        }
        return body['data'];
      }
      return body;
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  static Map<String, dynamic> _asMap(dynamic v) =>
      v is Map ? Map<String, dynamic>.from(v) : <String, dynamic>{};

  // ---------------------------------------------------------------------------
  // Tự refresh access token khi gặp 401 (giống interceptor của axiosInstance FE).
  // ---------------------------------------------------------------------------

  static const _noRefreshPaths = [
    '/auth/login',
    '/auth/student-login',
    '/auth/refresh-token',
    '/auth/logout',
  ];

  Future<void> _onError(DioException err, ErrorInterceptorHandler handler) async {
    final res = err.response;
    final req = err.requestOptions;
    final skip = _noRefreshPaths.any(req.path.contains) || req.extra['retried'] == true;

    if (res?.statusCode != 401 || skip) {
      return handler.next(err);
    }

    final data = res?.data;
    final code = data is Map ? data['code']?.toString() : null;
    if (code == 'USER_NOT_FOUND_OR_INACTIVE') {
      await _expire('Tài khoản đã bị khoá');
      return handler.next(err);
    }
    if (code == 'INVALID_OR_EXPIRED_TOKEN') {
      await _expire('Tài khoản đã đăng nhập trên thiết bị khác');
      return handler.next(err);
    }

    final ok = await _refreshToken();
    if (!ok) {
      await _expire('Phiên đăng nhập đã hết hạn, vui lòng đăng nhập lại');
      return handler.next(err);
    }

    try {
      req.extra['retried'] = true;
      final retry = await _plain.fetch(req);
      return handler.resolve(retry);
    } on DioException catch (e) {
      return handler.next(e);
    }
  }

  /// Gộp các lời gọi refresh đồng thời thành một.
  Future<bool> _refreshToken() async {
    if (_refreshing != null) return _refreshing!.future;
    final completer = Completer<bool>();
    _refreshing = completer;
    try {
      final res = await _plain.get('/auth/refresh-token');
      completer.complete(res.data is Map && res.data['success'] == true);
    } catch (_) {
      completer.complete(false);
    } finally {
      _refreshing = null;
    }
    return completer.future;
  }

  Future<void> _expire(String message) async {
    await clearCookies();
    onSessionExpired?.call(message);
  }
}
