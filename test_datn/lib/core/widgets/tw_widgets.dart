import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';

import '../theme/tw.dart';

/// Thẻ `bg-white rounded-xl shadow-lg p-6`.
class TwCard extends StatelessWidget {
  const TwCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(24),
    this.radius = 20,
    this.shadow = Tw.shadowLg,
    this.color = Colors.white,
    this.border,
    this.gradient,
    this.width,
  });

  final Widget child;
  final EdgeInsets padding;
  final double radius;
  final List<BoxShadow>? shadow;
  final Color color;
  final BoxBorder? border;
  final Gradient? gradient;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: padding,
      decoration: BoxDecoration(
        color: gradient == null ? color : null,
        gradient: gradient,
        borderRadius: BorderRadius.circular(radius),
        boxShadow: shadow,
        border: border ?? (gradient == null && color == Colors.white ? Border.all(color: const Color(0x0F0F2A5C)) : null),
      ),
      child: child,
    );
  }
}

/// Pill `px-3 py-1 rounded-full text-sm font-medium`.
class TwPill extends StatelessWidget {
  const TwPill(this.text, {super.key, required this.fg, required this.bg, this.small = false, this.border});

  final String text;
  final Color fg;
  final Color bg;
  final bool small;
  final Color? border;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: small ? 9 : 12, vertical: small ? 3 : 5),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
        border: border == null ? null : Border.all(color: border!),
      ),
      child: Text(text, style: (small ? Tw.xs : Tw.sm)(c: fg, w: Tw.semibold)),
    );
  }
}

/// Ô nhập của form Tailwind (`pl-10 pr-3 py-3 border rounded-lg shadow-sm focus:ring-2`).
class TwInput extends StatefulWidget {
  const TwInput({
    super.key,
    required this.label,
    required this.icon,
    required this.controller,
    this.placeholder,
    this.error,
    this.obscure = false,
    this.onToggleObscure,
    this.keyboardType,
    this.textInputAction,
    this.onChanged,
    this.onSubmitted,
  });

  final String label;
  final HeroIcons icon;
  final TextEditingController controller;
  final String? placeholder;
  final String? error;

  /// Trường mật khẩu: hiển thị nút mắt khi [onToggleObscure] khác null.
  final bool obscure;
  final VoidCallback? onToggleObscure;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;

  @override
  State<TwInput> createState() => _TwInputState();
}

class _TwInputState extends State<TwInput> {
  final _focus = FocusNode();

  @override
  void initState() {
    super.initState();
    _focus.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hasError = widget.error != null && widget.error!.isNotEmpty;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.label, style: Tw.sm(c: Tw.gray700, w: Tw.semibold)),
        const SizedBox(height: 8),
        TwFieldBox(
          focused: _focus.hasFocus,
          error: hasError,
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 10),
                child: HeroIcon(widget.icon, size: 20, color: _focus.hasFocus ? Tw.blue600 : Tw.gray400),
              ),
              Expanded(
                child: TextField(
                  controller: widget.controller,
                  focusNode: _focus,
                  obscureText: widget.obscure,
                  keyboardType: widget.keyboardType,
                  textInputAction: widget.textInputAction,
                  onChanged: widget.onChanged,
                  onSubmitted: widget.onSubmitted,
                  autocorrect: false,
                  style: Tw.base(c: Tw.gray900, w: Tw.medium),
                  cursorColor: Tw.blue600,
                  decoration: InputDecoration(
                    isCollapsed: true,
                    filled: false,
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    focusedErrorBorder: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 15),
                    hintText: widget.placeholder,
                    hintStyle: Tw.base(c: Tw.gray400, w: FontWeight.w400),
                  ),
                ),
              ),
              if (widget.onToggleObscure != null)
                GestureDetector(
                  onTap: widget.onToggleObscure,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8, right: 16),
                    child: HeroIcon(widget.obscure ? HeroIcons.eye : HeroIcons.eyeSlash, size: 20, color: Tw.gray400),
                  ),
                )
              else
                const SizedBox(width: 16),
            ],
          ),
        ),
        if (hasError) ...[
          const SizedBox(height: 6),
          Text(widget.error!, style: Tw.sm(c: Tw.red600, w: Tw.medium)),
        ],
      ],
    );
  }
}

/// Khung viền của ô nhập Tailwind (border + ring khi focus).
class TwFieldBox extends StatelessWidget {
  const TwFieldBox({super.key, required this.child, this.focused = false, this.error = false, this.disabled = false});

  final Widget child;
  final bool focused;
  final bool error;
  final bool disabled;

  @override
  Widget build(BuildContext context) {
    final ring = error ? Tw.red500 : Tw.blue600;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      decoration: BoxDecoration(
        color: disabled ? Tw.gray100 : (focused ? Colors.white : Tw.gray50),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: focused ? ring : (error ? Tw.red300 : Tw.gray200), width: focused ? 1.6 : 1),
        boxShadow: [if (focused) BoxShadow(color: ring.withValues(alpha: 0.14), spreadRadius: 4)],
      ),
      child: child,
    );
  }
}

/// Nút chính: gradient xanh, bo góc 14, bóng phát sáng; xám + spinner khi loading.
class TwPrimaryButton extends StatelessWidget {
  const TwPrimaryButton({super.key, required this.label, required this.onPressed, this.loading = false, this.loadingLabel, this.icon});

  final String label;
  final VoidCallback? onPressed;
  final bool loading;
  final String? loadingLabel;
  final IconData? icon;

  static const gradient = LinearGradient(colors: [Tw.blue600, Tw.indigo600]);

  @override
  Widget build(BuildContext context) {
    final disabled = loading || onPressed == null;
    return PressScale(
      enabled: !disabled,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          gradient: disabled ? null : gradient,
          color: disabled ? Tw.gray300 : null,
          borderRadius: BorderRadius.circular(14),
          boxShadow: disabled ? null : Tw.glow(Tw.blue600),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: disabled ? null : onPressed,
            child: Container(
              height: 52,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              alignment: Alignment.center,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (loading) ...[
                    const TwSpinner(size: 18, color: Colors.white, width: 2.4),
                    const SizedBox(width: 10),
                  ],
                  Text(loading ? (loadingLabel ?? label) : label, style: Tw.base(c: Colors.white, w: Tw.semibold)),
                  if (!loading && icon != null) ...[
                    const SizedBox(width: 8),
                    Icon(icon, size: 20, color: Colors.white),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Khung lỗi `bg-red-50 border border-red-200 rounded-lg p-4`.
class TwErrorBox extends StatelessWidget {
  const TwErrorBox(this.message, {super.key});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Tw.red50,
        border: Border.all(color: Tw.red200),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 1, right: 10),
            child: Icon(Icons.error_outline_rounded, size: 18, color: Tw.red600),
          ),
          Expanded(child: Text(message, style: Tw.sm(c: Tw.red700, w: Tw.medium))),
        ],
      ),
    );
  }
}

/// Viền nét đứt bo góc (`border-dashed`).
class DashedBorderPainter extends CustomPainter {
  DashedBorderPainter({required this.color, this.radius = 12, this.width = 2, this.dash = 6, this.gap = 4});

  final Color color;
  final double radius;
  final double width;
  final double dash;
  final double gap;

  @override
  void paint(Canvas canvas, Size size) {
    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(width / 2, width / 2, size.width - width, size.height - width),
      Radius.circular(radius),
    );
    final path = Path()..addRRect(rrect);
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = width;
    for (final metric in path.computeMetrics()) {
      var d = 0.0;
      while (d < metric.length) {
        canvas.drawPath(metric.extractPath(d, d + dash), paint);
        d += dash + gap;
      }
    }
  }

  @override
  bool shouldRepaint(covariant DashedBorderPainter old) => old.color != color;
}
