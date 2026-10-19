import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../app_routes.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/widgets/mui.dart';
import '../../../core/widgets/notify.dart';
import '../auth_service.dart';

/// Quên mật khẩu — `features/auth/pages/forgot-password.tsx` (+ EmailStep/OtpStep/ResetPasswordStep/SuccessStep).
class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  static const _steps = ['Nhập email', 'Xác thực OTP', 'Đặt lại mật khẩu', 'Hoàn tất'];
  final _service = AuthService();

  int _step = 0;
  String _email = '';
  String _otp = '';

  Future<bool> _sendEmail(String email) async {
    try {
      await _service.forgotPassword(email);
      setState(() {
        _email = email;
        _step = 1;
      });
      AppNotify.toast('Đã gửi email xác thực OTP!', ToastType.success);
      return true;
    } catch (e) {
      AppNotify.toast(ApiException.messageOf(e).isEmpty ? 'Gửi email thất bại!' : ApiException.messageOf(e), ToastType.error);
      return false;
    }
  }

  Future<void> _verify(String otp) async {
    try {
      await _service.verifyOtp(_email, otp);
      setState(() {
        _otp = otp;
        _step = 2;
      });
      AppNotify.toast('Xác thực OTP thành công!', ToastType.success);
    } catch (e) {
      AppNotify.toast(ApiException.messageOf(e), ToastType.error);
    }
  }

  Future<void> _reset(String password, String confirm) async {
    try {
      await _service.resetPassword(email: _email, otp: _otp, newPassword: password, confirmNewPassword: confirm);
      setState(() => _step = 3);
      AppNotify.toast('Đặt lại mật khẩu thành công!', ToastType.success);
    } catch (e) {
      AppNotify.toast(ApiException.messageOf(e));
    }
  }

  @override
  Widget build(BuildContext context) {
    return MuiGradientPage(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _Stepper(steps: _steps, active: _step),
          const SizedBox(height: 32),
          switch (_step) {
            0 => _EmailStep(onSubmit: _sendEmail),
            1 => _OtpStep(email: _email, onSubmit: _verify, onBack: () => setState(() => _step = 0), onResend: _service.forgotPassword),
            2 => _ResetStep(onSubmit: _reset, onBack: () => setState(() => _step = 1)),
            _ => const _SuccessStep(),
          },
        ],
      ),
    );
  }
}

/// `<Stepper activeStep alternativeLabel>` của MUI.
class _Stepper extends StatelessWidget {
  const _Stepper({required this.steps, required this.active});

  final List<String> steps;
  final int active;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < steps.length; i++)
          Expanded(
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: i == 0
                          ? const SizedBox()
                          : const Padding(
                              padding: EdgeInsets.only(right: 8),
                              child: Divider(color: Color(0xFFBDBDBD), height: 24),
                            ),
                    ),
                    _circle(i),
                    Expanded(
                      child: i == steps.length - 1
                          ? const SizedBox()
                          : const Padding(
                              padding: EdgeInsets.only(left: 8),
                              child: Divider(color: Color(0xFFBDBDBD), height: 24),
                            ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  steps[i],
                  textAlign: TextAlign.center,
                  style: Mui.body2.copyWith(
                    color: i <= active ? Mui.primary : const Color(0x99000000),
                    fontWeight: i <= active ? FontWeight.w500 : FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _circle(int i) {
    final done = i < active;
    final current = i == active;
    if (done) return const Icon(Icons.check_circle, size: 24, color: Mui.primary);
    return Container(
      width: 24,
      height: 24,
      alignment: Alignment.center,
      decoration: BoxDecoration(shape: BoxShape.circle, color: current ? Mui.primary : const Color(0x61000000)),
      child: Text('${i + 1}', style: const TextStyle(color: Colors.white, fontSize: 12)),
    );
  }
}

class _StepTitle extends StatelessWidget {
  const _StepTitle(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(title, textAlign: TextAlign.center, style: muiPageTitleStyle),
    );
  }
}

class _EmailStep extends StatefulWidget {
  const _EmailStep({required this.onSubmit});

  final Future<bool> Function(String) onSubmit;

  @override
  State<_EmailStep> createState() => _EmailStepState();
}

class _EmailStepState extends State<_EmailStep> {
  final _email = TextEditingController();
  bool _loading = false;
  String? _emailError;

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final ok = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(_email.text);
    setState(() => _emailError = ok ? null : 'Vui lòng nhập địa chỉ email hợp lệ');
    if (!ok) return;
    setState(() => _loading = true);
    await Future<void>.delayed(const Duration(seconds: 1));
    await widget.onSubmit(_email.text.trim());
    if (mounted) setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _StepTitle('QUÊN MẬT KHẨU'),
        Text('Vui lòng nhập địa chỉ email đã đăng ký để nhận mã xác thực',
            textAlign: TextAlign.center, style: Mui.body1.copyWith(color: Mui.textSecondary)),
        const SizedBox(height: 32 + 16),
        MuiTextField(
          label: 'Địa chỉ email',
          required: true,
          autofocus: true,
          controller: _email,
          keyboardType: TextInputType.emailAddress,
          errorText: _emailError,
          startIcon: const Icon(Icons.email, color: Mui.secondary),
          onSubmitted: (_) => _submit(),
        ),
        const SizedBox(height: 24 + 8),
        MuiButton(
          label: _loading ? 'Đang xử lý...' : 'Gửi mã xác thực',
          onPressed: _loading ? null : _submit,
          large: true,
          fullWidth: true,
          radius: 10,
          fontSize: 16,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 22),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

class _OtpStep extends StatefulWidget {
  const _OtpStep({required this.email, required this.onSubmit, required this.onBack, required this.onResend});

  final String email;
  final Future<void> Function(String) onSubmit;
  final VoidCallback onBack;
  final Future<void> Function(String) onResend;

  @override
  State<_OtpStep> createState() => _OtpStepState();
}

class _OtpStepState extends State<_OtpStep> {
  final _otp = TextEditingController();
  bool _loading = false;
  String? _error;
  int _countdown = 120;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_countdown <= 1) {
        t.cancel();
        setState(() => _countdown = 0);
      } else {
        setState(() => _countdown--);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _otp.dispose();
    super.dispose();
  }

  Future<void> _resend() async {
    try {
      await widget.onResend(widget.email);
      AppNotify.success('Mã xác thực đã được gửi');
      setState(() => _countdown = 120);
      _startTimer();
    } catch (_) {
      AppNotify.error('Không thể gửi mã xác thực. Vui lòng thử lại sau.', title: 'Lỗi');
    }
  }

  Future<void> _submit() async {
    if (_otp.text.length != 6) {
      setState(() => _error = 'Vui lòng nhập đầy đủ mã xác thực');
      return;
    }
    setState(() {
      _loading = true;
      _error = null;
    });
    await Future<void>.delayed(const Duration(seconds: 1));
    await widget.onSubmit(_otp.text);
    if (mounted) setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _StepTitle('XÁC THỰC MÃ OTP'),
        Text('Mã xác thực đã được gửi đến', textAlign: TextAlign.center, style: Mui.body1.copyWith(color: Mui.textSecondary)),
        const SizedBox(height: 8),
        Text(widget.email, textAlign: TextAlign.center, style: Mui.body1.copyWith(fontWeight: FontWeight.w600, color: Mui.primary)),
        const SizedBox(height: 24),
        if (_error != null) ...[MuiAlert(severity: MuiSeverity.error, message: _error), const SizedBox(height: 24)],
        Center(
          child: SizedBox(
            width: 256 + 28,
            child: TextField(
              controller: _otp,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              maxLength: 6,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: 8),
              decoration: InputDecoration(
                counterText: '',
                hintText: '●' * 6,
                hintStyle: const TextStyle(color: Color(0x6B000000), letterSpacing: 8),
                contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Color(0x3B000000))),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Mui.secondary, width: 2)),
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),
        Center(
          child: Text.rich(
            TextSpan(
              style: Mui.body2.copyWith(color: Mui.textPrimary),
              children: [
                const TextSpan(text: 'Chưa nhận được mã? '),
                WidgetSpan(
                  alignment: PlaceholderAlignment.baseline,
                  baseline: TextBaseline.alphabetic,
                  child: GestureDetector(
                    onTap: _countdown <= 0 ? _resend : null,
                    child: Text(
                      _countdown > 0 ? 'Gửi lại sau ${_countdown}s' : 'Gửi lại mã',
                      style: Mui.body2.copyWith(
                        color: _countdown > 0 ? Mui.textDisabled : Mui.secondary,
                        decoration: _countdown > 0 ? null : TextDecoration.underline,
                        decorationColor: Mui.secondary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(
              child: MuiButton(
                label: 'Quay lại',
                variant: MuiButtonVariant.outlined,
                onPressed: widget.onBack,
                fullWidth: true,
                radius: 16,
                padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 15),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: MuiButton(
                label: _loading ? 'Đang xử lý...' : 'Xác thực',
                onPressed: _loading ? null : _submit,
                fullWidth: true,
                radius: 16,
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _ResetStep extends StatefulWidget {
  const _ResetStep({required this.onSubmit, required this.onBack});

  final Future<void> Function(String, String) onSubmit;
  final VoidCallback onBack;

  @override
  State<_ResetStep> createState() => _ResetStepState();
}

class _ResetStepState extends State<_ResetStep> {
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  bool _show = false;
  bool _showConfirm = false;
  bool _loading = false;
  String? _pwError;
  String? _confirmError;

  @override
  void dispose() {
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  bool _validate() {
    var ok = true;
    String? pw;
    String? cf;
    if (_password.text.length < 8) {
      pw = 'Mật khẩu phải có ít nhất 8 ký tự';
      ok = false;
    } else if (!RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]').hasMatch(_password.text)) {
      pw = 'Mật khẩu phải chứa ít nhất 1 chữ hoa, 1 chữ thường, 1 số và 1 ký tự đặc biệt';
      ok = false;
    }
    if (_password.text != _confirm.text) {
      cf = 'Xác nhận mật khẩu không khớp';
      ok = false;
    }
    setState(() {
      _pwError = pw;
      _confirmError = cf;
    });
    return ok;
  }

  Future<void> _submit() async {
    if (!_validate()) return;
    setState(() => _loading = true);
    await widget.onSubmit(_password.text, _confirm.text);
    if (mounted) setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _StepTitle('ĐẶT LẠI MẬT KHẨU'),
        Text('Vui lòng nhập mật khẩu mới cho tài khoản của bạn',
            textAlign: TextAlign.center, style: Mui.body1.copyWith(color: Mui.textSecondary)),
        const SizedBox(height: 32),
        MuiTextField(
          label: 'Mật khẩu mới',
          required: true,
          controller: _password,
          obscureText: !_show,
          errorText: _pwError == null ? null : '',
          startIcon: const Icon(Icons.lock, color: Mui.secondary),
          endIcon: MuiVisibilityToggle(visible: _show, onTap: () => setState(() => _show = !_show)),
          onChanged: (_) => setState(() => _pwError = null),
        ),
        if (_pwError != null) MuiHelperText(_pwError!) else const SizedBox(height: 24),
        const SizedBox(height: 24),
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
        if (_confirmError != null) MuiHelperText(_confirmError!) else const SizedBox(height: 24),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(
              child: MuiButton(
                label: 'Quay lại',
                variant: MuiButtonVariant.outlined,
                onPressed: widget.onBack,
                fullWidth: true,
                radius: 10,
                fontSize: 16,
                padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 15),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: MuiButton(
                label: _loading ? 'Đang xử lý...' : 'Đặt lại mật khẩu',
                onPressed: _loading ? null : _submit,
                fullWidth: true,
                large: true,
                radius: 10,
                fontSize: 16,
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _SuccessStep extends StatelessWidget {
  const _SuccessStep();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: const BoxDecoration(
              color: Mui.success,
              shape: BoxShape.circle,
              boxShadow: [BoxShadow(color: Color(0x1A000000), offset: Offset(0, 4), blurRadius: 20)],
            ),
            child: const Icon(Icons.check_circle, size: 35, color: Colors.white),
          ),
          const SizedBox(height: 24),
          const Text('Thành công!', style: muiPageTitleStyle, textAlign: TextAlign.center),
          const SizedBox(height: 16),
          Text(
            'Mật khẩu của bạn đã được đặt lại thành công. Vui lòng đăng nhập bằng mật khẩu mới.',
            textAlign: TextAlign.center,
            style: Mui.body1.copyWith(color: Mui.textSecondary),
          ),
          const SizedBox(height: 32),
          MuiButton(
            label: 'Đăng nhập',
            onPressed: () => AppRoutes.adminLogin(replace: true),
            large: true,
            radius: 10,
            fontSize: 16,
            minWidth: 200,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 22),
          ),
        ],
      ),
    );
  }
}
