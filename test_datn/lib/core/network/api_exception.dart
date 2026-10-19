import 'package:dio/dio.dart';

/// Lỗi chuẩn hoá từ response của Contests-BE.
///
/// BE trả lỗi dạng:
/// `{ success: false, message, error?: { type: 'VALIDATION_ERROR', details: [{ field, message }] } }`
class ApiException implements Exception {
  ApiException(this.message, {this.statusCode, this.code, this.fieldErrors = const {}});

  final String message;
  final int? statusCode;
  final String? code;

  /// Lỗi theo từng trường (field -> message) khi BE trả VALIDATION_ERROR.
  final Map<String, String> fieldErrors;

  factory ApiException.fromDio(DioException e) {
    final data = e.response?.data;
    final status = e.response?.statusCode;

    if (data is Map) {
      final fieldErrors = <String, String>{};
      final error = data['error'];
      if (error is Map && error['details'] is List) {
        for (final d in error['details'] as List) {
          if (d is Map && d['field'] != null) {
            fieldErrors[d['field'].toString()] = d['message']?.toString() ?? '';
          }
        }
      }
      var message = data['message']?.toString() ?? 'Có lỗi xảy ra';
      if (message == 'Validation failed' && fieldErrors.isNotEmpty) {
        message = fieldErrors.values.first;
      }
      return ApiException(
        message,
        statusCode: status,
        code: data['code']?.toString() ?? (error is String ? error : null),
        fieldErrors: fieldErrors,
      );
    }

    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        return ApiException('Kết nối tới máy chủ quá thời gian chờ', statusCode: status);
      case DioExceptionType.connectionError:
        return ApiException(
          'Không thể kết nối tới máy chủ. Kiểm tra lại địa chỉ server và mạng.',
          statusCode: status,
        );
      default:
        return ApiException(e.message ?? 'Có lỗi xảy ra', statusCode: status);
    }
  }

  static String messageOf(Object error) {
    if (error is ApiException) return error.message;
    if (error is DioException) return ApiException.fromDio(error).message;
    return error.toString();
  }

  @override
  String toString() => message;
}
