import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../app_routes.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/widgets/mui.dart';
import '../../../core/widgets/notify.dart';
import '../auth_provider.dart';

/// Đăng nhập Admin / Trọng tài — `features/auth/pages/login.tsx` + `components/LoginForm.tsx`.
class AdminLoginScreen extends StatefulWidget {
  const AdminLoginScreen({super.key});

  @override
  State<AdminLoginScreen> createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<AdminLoginScreen> {
  final _identifier = TextEditingController();
  final _password = TextEditingController();
  bool _showPassword = false;
  bool _loading = false;
  bool _touchedId = false;
  bool _touchedPw = false;
  String? _serverIdError;
  String? _serverPwError;

  @override
  void dispose() {
    _identifier.dispose();
    _password.dispose();
    super.dispose();
  }

  // LoginSchema (features/auth/types/auth.shema.ts), mode "onTouched".
  String? get _idError {
    if (_serverIdError != null) return _serverIdError;
    if (!_touchedId) return null;
    final v = _identifier.text;
    if (v.isEmpty) return 'Vui lòng nhập tên đăng nhập';
    if (v.length > 20) return 'Tên đăng nhập không được quá 20 kí tự';
    return null;
  }

  String? get _pwError {
    if (_serverPwError != null) return _serverPwError;
    if (!_touchedPw) return null;
    return _password.text.isEmpty ? 'Vui lòng nhập mật khẩu' : null;
  }

  Future<void> _submit() async {
    setState(() {
      _touchedId = true;
      _touchedPw = true;
      _serverIdError = null;
      _serverPwError = null;
    });
    if (_idError != null || _pwError != null) return;
    FocusScope.of(context).unfocus();
    setState(() => _loading = true);
    try {
      await context.read<AuthProvider>().login(_identifier.text, _password.text);
      AppNotify.toast('Đăng nhập thành công', ToastType.success);
      // FE: Admin → /admin/dashboard, còn lại → "/".
      AppRoutes.home();
    } on ApiException catch (e) {
      if (e.fieldErrors.isNotEmpty) {
        setState(() {
          _serverIdError = e.fieldErrors['identifier'];
          _serverPwError = e.fieldErrors['password'];
        });
        AppNotify.toast('Đăng nhập thất bại:', ToastType.error);
      } else {
        AppNotify.toast(e.statusCode == null ? 'Đăng nhập thất bại, vui lòng thử lại sau.' : e.message, ToastType.error);
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MuiGradientPage(
      title: 'Đăng nhập quản trị',
      subtitle: 'Dành cho Admin và Giám khảo',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Focus(
            onFocusChange: (f) {
              if (!f) setState(() => _touchedId = true);
            },
            child: MuiTextField(
              label: 'Tên đăng nhập',
              required: true,
              controller: _identifier,
              autofocus: true,
              hintText: 'Nhập email hoặc tên đăng nhập',
              errorText: _idError,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              startIcon: const Icon(Icons.person_outline_rounded),
              onChanged: (_) => setState(() => _serverIdError = null),
            ),
          ),
          const SizedBox(height: 18),
          Focus(
            onFocusChange: (f) {
              if (!f) setState(() => _touchedPw = true);
            },
            child: MuiTextField(
              label: 'Mật khẩu',
              required: true,
              controller: _password,
              obscureText: !_showPassword,
              hintText: 'Nhập mật khẩu',
              errorText: _pwError,
              textInputAction: TextInputAction.done,
              startIcon: const Icon(Icons.lock_outline_rounded),
              endIcon: MuiVisibilityToggle(visible: _showPassword, onTap: () => setState(() => _showPassword = !_showPassword)),
              onChanged: (_) => setState(() => _serverPwError = null),
              onSubmitted: (_) => _submit(),
            ),
          ),
          const SizedBox(height: 14),
          Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: AppRoutes.forgotPassword,
              child: Text('Quên mật khẩu?', style: Mui.body2.copyWith(color: Mui.secondary, fontWeight: FontWeight.w600)),
            ),
          ),
          const SizedBox(height: 24),
          MuiButton(
            label: _loading ? 'Đang đăng nhập...' : 'Đăng nhập',
            onPressed: _loading ? null : _submit,
            large: true,
            fullWidth: true,
            fontSize: 16,
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 22),
          ),
        ],
      ),
    );
  }
}
