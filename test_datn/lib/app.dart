import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'core/theme/app_theme.dart';
import 'core/widgets/notify.dart';
import 'features/auth/auth_provider.dart';
import 'features/home/home_screen.dart';

class ContestsApp extends StatelessWidget {
  const ContestsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AuthProvider()..bootstrap(),
      child: MaterialApp(
        title: 'Cuộc thi - Olympic Tin học',
        debugShowCheckedModeBanner: false,
        navigatorKey: rootNavigatorKey,
        theme: buildAppTheme(),
        // Mặc định chữ tối trên thanh trạng thái; trang nền xanh đậm tự đặt lại thành chữ sáng.
        builder: (context, child) => AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.dark.copyWith(statusBarColor: Colors.transparent),
          child: child!,
        ),
        home: const _SessionWatcher(child: HomeScreen()),
      ),
    );
  }
}

/// Khi phiên bị kết thúc từ server (401, đăng nhập nơi khác…) → về trang chủ + thông báo,
/// giống interceptor của `axiosInstance` trên FE.
class _SessionWatcher extends StatefulWidget {
  const _SessionWatcher({required this.child});

  final Widget child;

  @override
  State<_SessionWatcher> createState() => _SessionWatcherState();
}

class _SessionWatcherState extends State<_SessionWatcher> {
  AuthStatus? _last;

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    if (_last == AuthStatus.authenticated && auth.status == AuthStatus.unauthenticated) {
      final msg = auth.takeSessionMessage();
      if (msg != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          rootNavigatorKey.currentState?.popUntil((r) => r.isFirst);
          AppNotify.toast(msg, ToastType.error);
        });
      }
    }
    _last = auth.status;
    return widget.child;
  }
}
