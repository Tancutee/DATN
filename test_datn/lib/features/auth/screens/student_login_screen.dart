import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:provider/provider.dart';

import '../../../app_routes.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/theme/tw.dart';
import '../../../core/widgets/notify.dart';
import '../../../core/widgets/tw_widgets.dart';
import '../../../core/widgets/brand.dart';
import '../../../core/widgets/mui.dart';
import '../auth_provider.dart';

/// Nền của trang đăng nhập/đăng ký thí sinh (dùng chung nền thương hiệu).
class StudentAuthBackground extends StatelessWidget {
  const StudentAuthBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => BrandBackdrop(child: child);
}

/// Logo + tiêu đề trên form thí sinh.
class StudentAuthHeader extends StatelessWidget {
  const StudentAuthHeader(this.title, {super.key, this.subtitle});

  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) => BrandHeader(title: title, subtitle: subtitle);
}

/// Đăng nhập thí sinh — `features/student/pages/StudentLogin.tsx`.
class StudentLoginScreen extends StatefulWidget {
  const StudentLoginScreen({super.key});

  @override
  State<StudentLoginScreen> createState() => _StudentLoginScreenState();
}

class _StudentLoginScreenState extends State<StudentLoginScreen> {
  final _identifier = TextEditingController();
  final _password = TextEditingController();
  bool _showPassword = false;
  bool _remember = false;
  bool _loading = false;
  Map<String, String> _errors = {};

  @override
  void dispose() {
    _identifier.dispose();
    _password.dispose();
    super.dispose();
  }

  void _clearErrors() {
    if (_errors.isNotEmpty) setState(() => _errors = {});
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    setState(() {
      _loading = true;
      _errors = {};
    });
    try {
      // LoginSchema (zod) — lỗi validate phía client rơi vào nhánh toast mặc định của FE.
      if (_identifier.text.trim().isEmpty || _password.text.isEmpty) {
        AppNotify.toast('Tài khoản hoặc mật khẩu không đúng', ToastType.error);
        return;
      }
      await context.read<AuthProvider>().studentLogin(_identifier.text.trim(), _password.text);
      AppNotify.toast('Đăng nhập thành công', ToastType.success);
      if (mounted) AppRoutes.studentDashboard(replace: true);
    } on ApiException catch (e) {
      if (e.fieldErrors.isNotEmpty) {
        setState(() {
          _errors = {
            for (final entry in e.fieldErrors.entries)
              if (entry.key == 'identifier' || entry.key == 'password') entry.key: entry.value,
          };
        });
        AppNotify.toast('Đăng nhập thất bại', ToastType.error);
      } else {
        AppNotify.toast(e.message, ToastType.error);
      }
    } catch (_) {
      AppNotify.toast('Tài khoản hoặc mật khẩu không đúng', ToastType.error);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return StudentAuthBackground(
      child: Column(
        children: [
          const StudentAuthHeader('Đăng nhập Thí sinh', subtitle: 'Olympic Tin học · Khoa CNTT Cao Thắng'),
          BrandFormCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (_errors['general'] != null) ...[TwErrorBox(_errors['general']!), const SizedBox(height: 24)],
                TwInput(
                  label: 'Tên đăng nhập hoặc Email',
                  icon: HeroIcons.user,
                  controller: _identifier,
                  placeholder: 'Nhập tên đăng nhập hoặc email',
                  error: _errors['identifier'],
                  textInputAction: TextInputAction.next,
                  onChanged: (_) => _clearErrors(),
                ),
                const SizedBox(height: 18),
                TwInput(
                  label: 'Mật khẩu',
                  icon: HeroIcons.lockClosed,
                  controller: _password,
                  placeholder: 'Nhập mật khẩu của bạn',
                  error: _errors['password'],
                  obscure: !_showPassword,
                  onToggleObscure: () => setState(() => _showPassword = !_showPassword),
                  textInputAction: TextInputAction.done,
                  onChanged: (_) => _clearErrors(),
                  onSubmitted: (_) => _submit(),
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: Checkbox(
                        value: _remember,
                        onChanged: (v) => setState(() => _remember = v ?? false),
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        visualDensity: VisualDensity.compact,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(child: Text('Ghi nhớ đăng nhập', style: Tw.sm(c: Tw.gray600))),
                    GestureDetector(
                      onTap: AppRoutes.forgotPassword,
                      child: Text('Quên mật khẩu?', style: Tw.sm(c: Tw.blue600, w: Tw.semibold)),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                TwPrimaryButton(
                  label: 'Đăng nhập',
                  loadingLabel: 'Đang đăng nhập...',
                  loading: _loading,
                  onPressed: _submit,
                  icon: Icons.arrow_forward_rounded,
                ),
                const SizedBox(height: 22),
                const TwOrDivider(),
                const SizedBox(height: 18),
                Center(
                  child: Text.rich(
                    TextSpan(
                      style: Tw.sm(c: Tw.gray600),
                      children: [
                        const TextSpan(text: 'Chưa có tài khoản? '),
                        WidgetSpan(
                          alignment: PlaceholderAlignment.baseline,
                          baseline: TextBaseline.alphabetic,
                          child: GestureDetector(
                            onTap: () => AppRoutes.studentRegister(replace: true),
                            child: Text('Đăng ký ngay', style: Tw.sm(c: Tw.blue600, w: Tw.bold)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
