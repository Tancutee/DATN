import 'dart:async';

import 'package:socket_io_client/socket_io_client.dart' as io;

import '../config/app_config.dart';
import 'api_client.dart';

/// Kết quả ack chuẩn hoá từ server Socket.IO.
class SocketAck {
  SocketAck(this.success, this.message, [this.data]);

  final bool success;
  final String message;
  final dynamic data;
}

/// Tạo kết nối Socket.IO tới Contests-BE.
///
/// Namespace:
/// - `/student`: thí sinh thi online
/// - `/match-control`: trọng tài / admin
///
/// BE xác thực socket bằng cookie `accessToken`, nên cookie trong
/// [ApiClient] được gửi qua header `Cookie` khi bắt tay.
class SocketClient {
  SocketClient._();

  static Future<io.Socket> connect(String namespace) async {
    final cookie = await ApiClient.instance.cookieHeader();
    final socket = io.io(
      '${AppConfig.baseUrl}$namespace',
      io.OptionBuilder()
          .setTransports(['websocket'])
          .setExtraHeaders({'Cookie': cookie})
          .disableAutoConnect()
          .enableForceNew()
          .enableReconnection()
          .setReconnectionAttempts(10)
          .setReconnectionDelay(1000)
          .build(),
    );
    socket.connect();
    return socket;
  }

  /// Emit kèm ack và chuẩn hoá các kiểu callback mà BE dùng:
  /// - `callback({ success, message })`
  /// - `callback(null, { success, message })`
  /// - `callback(new Error(...))`
  static Future<SocketAck> emitAck(
    io.Socket socket,
    String event,
    dynamic data, {
    Duration timeout = const Duration(seconds: 10),
  }) {
    final completer = Completer<SocketAck>();

    socket.emitWithAck(event, data, ack: (dynamic res) {
      if (completer.isCompleted) return;
      dynamic payload = res;
      if (res is List) {
        final err = res.isNotEmpty ? res[0] : null;
        if (err != null) {
          final msg = err is Map ? err['message']?.toString() : null;
          completer.complete(SocketAck(false, msg ?? 'Thao tác thất bại'));
          return;
        }
        payload = res.length > 1 ? res[1] : null;
      }
      if (payload is Map) {
        completer.complete(SocketAck(
          payload['success'] == true,
          payload['message']?.toString() ?? '',
          payload['data'] ?? payload,
        ));
      } else {
        completer.complete(SocketAck(false, 'Phản hồi không hợp lệ từ máy chủ'));
      }
    });

    return completer.future.timeout(
      timeout,
      onTimeout: () => SocketAck(false, 'Máy chủ không phản hồi'),
    );
  }
}
