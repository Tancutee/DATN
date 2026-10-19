import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/widgets/notify.dart';
import 'features/auth/auth_models.dart';
import 'features/auth/auth_provider.dart';
import 'features/auth/screens/admin_login_screen.dart';
import 'features/auth/screens/forgot_password_screen.dart';
import 'features/auth/screens/profile_screen.dart';
import 'features/auth/screens/student_login_screen.dart';
import 'features/judge/screens/judge_contest_list_screen.dart';
import 'features/student/screens/student_dashboard_screen.dart';
import 'features/student/screens/student_register_screen.dart';

/// Điều hướng tương ứng các route của Contests-FE.
class AppRoutes {
  AppRoutes._();

  static NavigatorState get _nav => rootNavigatorKey.currentState!;

  static Future<void> _push(Widget page, {bool replace = false}) {
    final route = MaterialPageRoute<void>(builder: (_) => page);
    return replace ? _nav.pushReplacement(route) : _nav.push(route);
  }

  /// `/` — trang chủ (gốc của app).
  static void home() => _nav.popUntil((r) => r.isFirst);

  /// `/login`
  static Future<void> adminLogin({bool replace = false}) => _push(const AdminLoginScreen(), replace: replace);

  /// `/student/login` — nếu đã đăng nhập thí sinh thì vào thẳng dashboard (giống FE).
  static Future<void> studentLogin({bool replace = false}) {
    final user = rootNavigatorKey.currentContext?.read<AuthProvider>().user;
    if (user?.role == UserRole.student) return studentDashboard(replace: replace);
    return _push(const StudentLoginScreen(), replace: replace);
  }

  /// `/student/register`
  static Future<void> studentRegister({bool replace = false}) => _push(const StudentRegisterScreen(), replace: replace);

  /// `/forgot-password`
  static Future<void> forgotPassword() => _push(const ForgotPasswordScreen());

  /// `/account/profile`
  static Future<void> profile() => _push(const ProfileScreen());

  /// `/student/dashboard`
  static Future<void> studentDashboard({bool replace = false}) => _push(const StudentDashboardScreen(), replace: replace);

  /// `/cuoc-thi`
  static Future<void> judgeContests() => _push(const JudgeContestListScreen());

  /// Đăng xuất như menu người dùng trên header trang chủ.
  static Future<void> logout(BuildContext context, {bool toast = true}) async {
    final auth = context.read<AuthProvider>();
    home();
    await auth.logout();
    if (toast) AppNotify.toast('Đăng xuất thành công');
  }
}
