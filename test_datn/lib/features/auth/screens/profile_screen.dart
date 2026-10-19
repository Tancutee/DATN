import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../app_routes.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/widgets/mui.dart';
import '../../../core/widgets/notify.dart';
import '../auth_models.dart';
import '../auth_provider.dart';

/// Thông tin tài khoản — `features/account/pages/ProfilePage.tsx` + `ProfileLayout`.
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _fetching = true;

  @override
  void initState() {
    super.initState();
    context.read<AuthProvider>().refreshProfile().whenComplete(() {
      if (mounted) setState(() => _fetching = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final user = auth.user;
    return Stack(
      children: [
        MuiGradientPage(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Padding(
                padding: EdgeInsets.only(bottom: 32),
                child: Text('TÀI KHOẢN', textAlign: TextAlign.center, style: muiPageTitleStyle),
              ),
              if (_fetching && user == null)
                const _Skeleton()
              else if (user == null)
                const MuiAlert(
                  severity: MuiSeverity.error,
                  padding: EdgeInsets.all(24),
                  icon: Icons.error_outline,
                  title: 'Không thể tải thông tin tài khoản',
                  message: 'Vui lòng đăng nhập lại để tiếp tục sử dụng dịch vụ.',
                )
              else ...[
                _AccountInfo(user: user),
                Wrap(
                  children: [
                    _OutlinedAction(icon: Icons.vpn_key, label: 'Đổi mật khẩu', onTap: () => _changePassword(context)),
                    _OutlinedAction(icon: Icons.person, label: 'Đổi thông tin', onTap: () => _changeInfo(context, user)),
                  ],
                ),
              ],
            ],
          ),
        ),
        // Nút "Về trang chủ" cố định góc phải trên.
        Positioned(
          top: MediaQuery.of(context).padding.top + 16,
          right: 16,
          child: Tooltip(
            message: 'Về trang chủ',
            child: Material(
              color: Mui.primary,
              shape: const CircleBorder(),
              elevation: 2,
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: AppRoutes.home,
                child: const Padding(padding: EdgeInsets.all(8), child: Icon(Icons.home, color: Colors.white)),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _changePassword(BuildContext context) async {
    final auth = context.read<AuthProvider>();
    await showMuiDialog<void>(
      context,
      padding: const EdgeInsets.all(16),
      builder: (_) => _ChangePasswordDialog(
        onSubmit: (current, next, confirm) async {
          await auth.service.changePassword(currentPassword: current, newPassword: next, confirmNewPassword: confirm);
          AppNotify.toast('Đổi mật khẩu thành công! Vui lòng đăng nhập lại.');
          Timer(const Duration(milliseconds: 1500), () async {
            await auth.logoutLocal();
            AppRoutes.home();
            AppRoutes.adminLogin();
          });
        },
      ),
    );
  }

  Future<void> _changeInfo(BuildContext context, AppUser user) async {
    final auth = context.read<AuthProvider>();
    await showMuiDialog<void>(
      context,
      padding: const EdgeInsets.all(16),
      builder: (_) => _ChangeInfoDialog(
        initialEmail: user.email,
        onSubmit: (email) async {
          await auth.service.changeInfo(username: user.username, email: email);
          AppNotify.toast('Cập nhật thông tin thành công!', ToastType.success);
          await auth.refreshProfile();
        },
      ),
    );
  }
}

class _Skeleton extends StatelessWidget {
  const _Skeleton();

  @override
  Widget build(BuildContext context) {
    Widget bar(double h, {double? w, double r = 4}) => Container(
          width: w,
          height: h,
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(color: const Color(0x17000000), borderRadius: BorderRadius.circular(r)),
        );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(width: 64, height: 64, decoration: const BoxDecoration(color: Color(0x17000000), shape: BoxShape.circle)),
        const SizedBox(height: 16),
        bar(24, w: 180),
        bar(56, r: 16),
        bar(56, r: 16),
        bar(56, r: 16),
        bar(48, r: 16),
      ],
    );
  }
}

class _AccountInfo extends StatelessWidget {
  const _AccountInfo({required this.user});

  final AppUser user;

  @override
  Widget build(BuildContext context) {
    Widget field(String label, String value, IconData icon) => MuiTextField(
          label: label,
          controller: TextEditingController(text: value),
          readOnly: true,
          startIcon: Icon(icon, color: Mui.secondary),
        );
    return Padding(
      padding: const EdgeInsets.only(bottom: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Thông tin tài khoản', style: Mui.h6.copyWith(color: Mui.textPrimary)),
          const SizedBox(height: 7),
          field('Tên người dùng', user.username, Icons.person),
          const SizedBox(height: 16),
          field('Email', user.email, Icons.email),
          const SizedBox(height: 16),
          field('Vai trò', user.role.value, Icons.badge),
          const SizedBox(height: 16),
          field('Trạng thái', user.isActive ? 'Hoạt động' : 'Không hoạt động', user.isActive ? Icons.check_circle : Icons.cancel),
        ],
      ),
    );
  }
}

class _OutlinedAction extends StatelessWidget {
  const _OutlinedAction({required this.icon, required this.label, required this.onTap});

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return MuiButton(
      label: label,
      variant: MuiButtonVariant.outlined,
      color: Mui.secondary,
      icon: Icon(icon),
      onPressed: onTap,
      radius: 10,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    );
  }
}

/// Tiêu đề dialog: icon màu secondary + h6.
class _DialogTitle extends StatelessWidget {
  const _DialogTitle(this.icon, this.title);

  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
      child: Row(
        children: [
          Icon(icon, color: Mui.secondary),
          const SizedBox(width: 8),
          Expanded(child: Text(title, style: Mui.h6.copyWith(color: Mui.textPrimary))),
        ],
      ),
    );
  }
}

class _ChangePasswordDialog extends StatefulWidget {
  const _ChangePasswordDialog({required this.onSubmit});

  final Future<void> Function(String current, String next, String confirm) onSubmit;

  @override
  State<_ChangePasswordDialog> createState() => _ChangePasswordDialogState();
}

class _ChangePasswordDialogState extends State<_ChangePasswordDialog> {
  final _current = TextEditingController();
  final _next = TextEditingController();
  final _confirm = TextEditingController();
  bool _show = false;
  bool _showConfirm = false;
  bool _pending = false;
  String _error = '';
  String? _pwError;
  String? _confirmError;

  static final _rule = RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]');

  @override
  void dispose() {
    _current.dispose();
    _next.dispose();
    _confirm.dispose();
    super.dispose();
  }

  bool _validate() {
    String? pw;
    String? cf;
    if (_next.text.length < 8) {
      pw = 'Mật khẩu phải có ít nhất 8 ký tự';
    } else if (!_rule.hasMatch(_next.text)) {
      pw = 'Mật khẩu phải chứa ít nhất 1 chữ hoa, 1 chữ thường, 1 số và 1 ký tự đặc biệt';
    }
    if (_confirm.text.length < 8) {
      cf = 'Xác nhận mật khẩu phải có ít nhất 8 ký tự';
    } else if (!_rule.hasMatch(_confirm.text)) {
      cf = 'Xác nhận mật khẩu phải chứa ít nhất 1 chữ hoa, 1 chữ thường, 1 số và 1 ký tự đặc biệt';
    }
    if (_next.text != _confirm.text) cf = 'Xác nhận mật khẩu không khớp';
    setState(() {
      _pwError = pw;
      _confirmError = cf;
    });
    return pw == null && cf == null;
  }

  Future<void> _submit() async {
    if (_current.text.isEmpty) {
      setState(() => _pwError = 'Vui lòng nhập mật khẩu hiện tại');
      return;
    }
    if (!_validate()) return;
    setState(() {
      _pending = true;
      _error = '';
    });
    try {
      await widget.onSubmit(_current.text, _next.text, _confirm.text);
      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      final msg = e is ApiException && e.statusCode != null ? e.message : 'Đổi mật khẩu thất bại! Vui lòng thử lại.';
      AppNotify.toast(msg, ToastType.error);
      if (mounted) setState(() => _error = msg);
    } finally {
      if (mounted) setState(() => _pending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const _DialogTitle(Icons.vpn_key, 'Đổi mật khẩu'),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (_error.isNotEmpty) ...[
                  MuiAlert(
                    severity: MuiSeverity.error,
                    message: _error,
                    radius: 8,
                    border: Border.all(color: MuiSeverity.error.lightBorder),
                  ),
                  const SizedBox(height: 24),
                ],
                const SizedBox(height: 6),
                MuiTextField(
                  label: 'Mật khẩu hiện tại',
                  required: true,
                  controller: _current,
                  obscureText: !_show,
                  startIcon: const Icon(Icons.lock, color: Mui.secondary),
                  endIcon: MuiVisibilityToggle(visible: _show, onTap: () => setState(() => _show = !_show)),
                ),
                const SizedBox(height: 24),
                MuiTextField(
                  label: 'Mật khẩu mới',
                  required: true,
                  controller: _next,
                  obscureText: !_show,
                  errorText: _pwError == null ? null : '',
                  startIcon: const Icon(Icons.lock, color: Mui.secondary),
                  endIcon: MuiVisibilityToggle(visible: _show, onTap: () => setState(() => _show = !_show)),
                  onChanged: (_) => setState(() => _pwError = null),
                ),
                if (_pwError != null) MuiHelperText(_pwError!) else const SizedBox(height: 24),
                MuiTextField(
                  label: 'Xác nhận mật khẩu mới',
                  required: true,
                  controller: _confirm,
                  obscureText: !_showConfirm,
                  errorText: _confirmError == null ? null : '',
                  startIcon: const Icon(Icons.lock, color: Mui.secondary),
                  endIcon: MuiVisibilityToggle(visible: _showConfirm, onTap: () => setState(() => _showConfirm = !_showConfirm)),
                  onChanged: (_) => setState(() => _confirmError = null),
                ),
                if (_confirmError != null) MuiHelperText(_confirmError!) else const SizedBox(height: 16),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                MuiButton(
                  label: 'Hủy',
                  variant: MuiButtonVariant.outlined,
                  radius: 10,
                  padding: const EdgeInsets.symmetric(horizontal: 23, vertical: 5),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                const SizedBox(width: 16),
                MuiButton(
                  label: _pending ? 'Đang xử lý...' : 'Đổi mật khẩu',
                  radius: 10,
                  minWidth: 140,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 6),
                  onPressed: _pending ? null : _submit,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ChangeInfoDialog extends StatefulWidget {
  const _ChangeInfoDialog({required this.initialEmail, required this.onSubmit});

  final String initialEmail;
  final Future<void> Function(String email) onSubmit;

  @override
  State<_ChangeInfoDialog> createState() => _ChangeInfoDialogState();
}

class _ChangeInfoDialogState extends State<_ChangeInfoDialog> {
  late final _email = TextEditingController(text: widget.initialEmail);
  bool _pending = false;
  String _error = '';
  String? _emailError;

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(_email.text)) {
      setState(() => _emailError = 'Email không hợp lệ');
      return;
    }
    setState(() {
      _pending = true;
      _error = '';
    });
    try {
      await widget.onSubmit(_email.text.trim());
      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      final msg = e is ApiException && e.statusCode != null ? e.message : 'Cập nhật thông tin thất bại! Vui lòng thử lại.';
      AppNotify.toast(msg, ToastType.error);
      if (mounted) setState(() => _error = msg);
    } finally {
      if (mounted) setState(() => _pending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const _DialogTitle(Icons.person, 'Đổi thông tin tài khoản'),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (_error.isNotEmpty) ...[
                  MuiAlert(
                    severity: MuiSeverity.error,
                    message: _error,
                    radius: 8,
                    border: Border.all(color: MuiSeverity.error.lightBorder),
                  ),
                  const SizedBox(height: 24),
                ],
                const SizedBox(height: 16),
                MuiTextField(
                  label: 'Email',
                  required: true,
                  controller: _email,
                  keyboardType: TextInputType.emailAddress,
                  errorText: _emailError == null ? null : '',
                  startIcon: const Icon(Icons.email, color: Mui.secondary),
                  onChanged: (_) => setState(() => _emailError = null),
                ),
                if (_emailError != null) MuiHelperText(_emailError!) else const SizedBox(height: 16),
                const SizedBox(height: 16),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                MuiButton(
                  label: 'Hủy',
                  variant: MuiButtonVariant.outlined,
                  radius: 10,
                  padding: const EdgeInsets.symmetric(horizontal: 23, vertical: 5),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                const SizedBox(width: 16),
                MuiButton(
                  label: _pending ? 'Đang xử lý...' : 'Cập nhật',
                  radius: 10,
                  minWidth: 140,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 6),
                  onPressed: _pending ? null : _submit,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
