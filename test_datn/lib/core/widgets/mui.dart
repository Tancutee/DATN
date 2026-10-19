import 'package:flutter/material.dart';

import '../theme/tw.dart';
import 'brand.dart';

/// Màu theme MUI của Contests-FE (`common/theme/colors.ts` + `theme.ts`).
class Mui {
  Mui._();

  static const primary = Color(0xFF003A70);
  static const secondary = Color(0xFF0B5CB5);
  static const accent = Color(0xFF1E63DB);
  static const light = Color(0xFF5B9DF9);
  static const background = Color(0xFFF4F7FC);
  static const surfaceTint = Color(0xFFF8FAFD);
  static const outline = Color(0xFFE2E8F0);
  static const textPrimary = Color(0xFF0F172A);
  static const textSecondary = Color(0xFF52637A);
  static const textDisabled = Color(0x61000000);
  static const divider = Color(0xFFE6EBF2);
  static const success = Color(0xFF15803D);
  static const error = Color(0xFFDC2626);
  static const warning = Color(0xFFD97706);
  static const info = Color(0xFF0284C7);

  /// Nền trang đăng nhập / tài khoản: navy đậm → xanh thương hiệu.
  static const pageGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF002550), primary, secondary],
    stops: [0, 0.45, 1],
  );

  /// Nút contained primary.
  static const buttonGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [secondary, accent],
  );

  static const cardShadow = [
    BoxShadow(color: Color(0x120F2A5C), offset: Offset(0, 10), blurRadius: 30, spreadRadius: -6),
    BoxShadow(color: Color(0x080F2A5C), offset: Offset(0, 2), blurRadius: 6),
  ];

  // Typography
  static const h2 = TextStyle(fontSize: 44, fontWeight: FontWeight.w800, height: 1.15, letterSpacing: -1.2);
  static const h4 = TextStyle(fontSize: 28, fontWeight: FontWeight.w700, height: 1.25, letterSpacing: -0.6);
  static const h6 = TextStyle(fontSize: 19, fontWeight: FontWeight.w700, height: 1.4, letterSpacing: -0.2);
  static const subtitle1 = TextStyle(fontSize: 16, height: 1.75);
  static const body1 = TextStyle(fontSize: 16, height: 1.5);
  static const body2 = TextStyle(fontSize: 14, height: 1.43);
  static const caption = TextStyle(fontSize: 12, height: 1.66);
}

enum MuiSeverity { success, info, warning, error }

extension MuiSeverityColors on MuiSeverity {
  Color get main => switch (this) {
        MuiSeverity.success => Mui.success,
        MuiSeverity.info => Mui.info,
        MuiSeverity.warning => Mui.warning,
        MuiSeverity.error => Mui.error,
      };

  Color get standardBg => switch (this) {
        MuiSeverity.success => const Color(0xFFEDF7ED),
        MuiSeverity.info => const Color(0xFFE5F6FD),
        MuiSeverity.warning => const Color(0xFFFFF4E5),
        MuiSeverity.error => const Color(0xFFFDEDED),
      };

  Color get standardText => switch (this) {
        MuiSeverity.success => const Color(0xFF1E4620),
        MuiSeverity.info => const Color(0xFF014361),
        MuiSeverity.warning => const Color(0xFF663C00),
        MuiSeverity.error => const Color(0xFF5F2120),
      };

  Color get lightBorder => switch (this) {
        MuiSeverity.success => const Color(0xFF4CAF50),
        MuiSeverity.info => const Color(0xFF03A9F4),
        MuiSeverity.warning => const Color(0xFFFF9800),
        MuiSeverity.error => const Color(0xFFEF5350),
      };

  IconData get icon => switch (this) {
        MuiSeverity.success => Icons.check_circle_outline,
        MuiSeverity.info => Icons.info_outline,
        MuiSeverity.warning => Icons.report_problem_outlined,
        MuiSeverity.error => Icons.error_outline,
      };
}

/// `<Alert>` của MUI (variant standard / filled).
class MuiAlert extends StatelessWidget {
  const MuiAlert({
    super.key,
    required this.severity,
    this.title,
    this.message,
    this.child,
    this.filled = false,
    this.icon,
    this.border,
    this.radius = 14,
    this.onClose,
    this.padding = const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
  });

  final MuiSeverity severity;
  final String? title;
  final String? message;
  final Widget? child;
  final bool filled;
  final IconData? icon;
  final BoxBorder? border;
  final double radius;
  final VoidCallback? onClose;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    final fg = filled ? Colors.white : severity.standardText;
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: filled ? severity.main : severity.standardBg,
        borderRadius: BorderRadius.circular(radius),
        border: border ?? (filled ? null : Border.all(color: severity.lightBorder.withValues(alpha: 0.28))),
      ),
      child: DefaultTextStyle(
        style: Mui.body2.copyWith(color: fg, fontWeight: filled ? FontWeight.w500 : FontWeight.w400),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 7, bottom: 7, right: 12),
              child: Icon(icon ?? severity.icon, size: 22, color: (filled ? Colors.white : severity.main).withValues(alpha: 0.9)),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (title != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 5.6),
                        child: Text(title!, style: Mui.body1.copyWith(fontWeight: FontWeight.w500, color: fg)),
                      ),
                    if (message != null) Text(message!),
                    ?child,
                  ],
                ),
              ),
            ),
            if (onClose != null)
              Padding(
                padding: const EdgeInsets.only(left: 16, top: 4),
                child: InkResponse(
                  onTap: onClose,
                  radius: 16,
                  child: Padding(
                    padding: const EdgeInsets.all(5),
                    child: Icon(Icons.close, size: 20, color: fg),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

enum MuiButtonVariant { contained, outlined, text }

/// `<Button>` của MUI với override trong theme Contests-FE
/// (contained primary = gradient 45deg primary → accent, textTransform none, fontWeight 600).
class MuiButton extends StatelessWidget {
  const MuiButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = MuiButtonVariant.contained,
    this.large = false,
    this.fullWidth = false,
    this.radius = 14,
    this.fontSize,
    this.padding,
    this.icon,
    this.color = Mui.primary,
    this.minWidth,
    this.shadow,
    this.gradient = Mui.buttonGradient,
  });

  final String label;
  final VoidCallback? onPressed;
  final MuiButtonVariant variant;
  final bool large;
  final bool fullWidth;
  final double radius;
  final double? fontSize;
  final EdgeInsets? padding;
  final Widget? icon;
  final Color color;
  final double? minWidth;
  final List<BoxShadow>? shadow;
  final Gradient? gradient;

  @override
  Widget build(BuildContext context) {
    final disabled = onPressed == null;
    final pad = padding ??
        (variant == MuiButtonVariant.text
            ? EdgeInsets.symmetric(horizontal: large ? 16 : 12, vertical: large ? 10 : 6)
            : EdgeInsets.symmetric(horizontal: large ? 24 : 18, vertical: large ? 13 : 9));
    final size = fontSize ?? (large ? 15.5 : 14.0);

    Color fg;
    BoxDecoration deco;
    switch (variant) {
      case MuiButtonVariant.contained:
        fg = disabled ? const Color(0xFF94A3B8) : Colors.white;
        deco = BoxDecoration(
          gradient: disabled ? null : gradient,
          color: disabled ? const Color(0xFFE2E8F0) : (gradient == null ? color : null),
          borderRadius: BorderRadius.circular(radius),
          boxShadow: disabled ? null : (shadow ?? Tw.glow(gradient?.colors.last ?? color)),
        );
      case MuiButtonVariant.outlined:
        fg = disabled ? const Color(0xFF94A3B8) : color;
        deco = BoxDecoration(
          color: disabled ? null : color.withValues(alpha: 0.04),
          borderRadius: BorderRadius.circular(radius),
          border: Border.all(color: disabled ? const Color(0xFFE2E8F0) : color.withValues(alpha: 0.35), width: 1.4),
        );
      case MuiButtonVariant.text:
        fg = disabled ? const Color(0xFF94A3B8) : color;
        deco = BoxDecoration(borderRadius: BorderRadius.circular(radius));
    }

    final content = Row(
      mainAxisSize: fullWidth ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (icon != null) ...[
          IconTheme(data: IconThemeData(color: fg, size: 20), child: icon!),
          const SizedBox(width: 8),
        ],
        Flexible(
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(color: fg, fontSize: size, fontWeight: FontWeight.w600, height: 1.5, letterSpacing: 0.1),
          ),
        ),
      ],
    );

    return PressScale(
      enabled: !disabled,
      child: ConstrainedBox(
        constraints: BoxConstraints(minWidth: minWidth ?? 64),
        child: DecoratedBox(
          decoration: deco,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(radius),
              onTap: onPressed,
              child: Padding(padding: pad, child: content),
            ),
          ),
        ),
      ),
    );
  }
}

/// `<TextField variant="outlined">` với override theme (radius 10, focus màu secondary).
class MuiTextField extends StatelessWidget {
  const MuiTextField({
    super.key,
    required this.label,
    this.controller,
    this.required = false,
    this.errorText,
    this.helperText,
    this.hintText,
    this.startIcon,
    this.endIcon,
    this.obscureText = false,
    this.readOnly = false,
    this.keyboardType,
    this.textInputAction,
    this.onChanged,
    this.onSubmitted,
    this.autofocus = false,
    this.radius = 14,
  });

  final String label;
  final TextEditingController? controller;
  final bool required;
  final String? errorText;
  final String? helperText;
  final String? hintText;
  final Widget? startIcon;
  final Widget? endIcon;
  final bool obscureText;
  final bool readOnly;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final bool autofocus;
  final double radius;

  @override
  Widget build(BuildContext context) {
    OutlineInputBorder b(Color c, [double w = 1]) =>
        OutlineInputBorder(borderRadius: BorderRadius.circular(radius), borderSide: BorderSide(color: c, width: w));
    final hasError = errorText != null && errorText!.isNotEmpty;
    return TextField(
      controller: controller,
      obscureText: obscureText,
      readOnly: readOnly,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      autofocus: autofocus,
      style: const TextStyle(fontSize: 15.5, color: Mui.textPrimary, height: 1.4, fontWeight: FontWeight.w500),
      cursorColor: Mui.secondary,
      decoration: InputDecoration(
        isDense: false,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 17),
        label: Text.rich(TextSpan(text: label, children: [
          if (required) const TextSpan(text: ' *', style: TextStyle(color: Mui.error)),
        ])),
        labelStyle: const TextStyle(color: Color(0xFF64748B), fontSize: 15, fontWeight: FontWeight.w400),
        floatingLabelStyle: WidgetStateTextStyle.resolveWith((s) {
          if (hasError) return const TextStyle(color: Mui.error, fontWeight: FontWeight.w600);
          if (s.contains(WidgetState.focused)) return const TextStyle(color: Mui.secondary, fontWeight: FontWeight.w600);
          return const TextStyle(color: Color(0xFF64748B), fontWeight: FontWeight.w500);
        }),
        hintText: hintText,
        hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontWeight: FontWeight.w400),
        prefixIcon: startIcon == null
            ? null
            : Padding(
                padding: const EdgeInsets.only(left: 16, right: 10),
                child: IconTheme.merge(data: const IconThemeData(color: Color(0xFF64748B), size: 21), child: startIcon!),
              ),
        prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
        suffixIcon: endIcon,
        errorText: hasError ? errorText : null,
        helperText: helperText,
        errorMaxLines: 3,
        errorStyle: const TextStyle(fontSize: 12.5, color: Mui.error, fontWeight: FontWeight.w500),
        filled: true,
        fillColor: readOnly ? const Color(0xFFF1F5F9) : Mui.surfaceTint,
        border: b(Mui.outline),
        enabledBorder: b(Mui.outline),
        focusedBorder: b(Mui.secondary, 1.8),
        errorBorder: b(const Color(0xFFFCA5A5)),
        focusedErrorBorder: b(Mui.error, 1.8),
      ),
    );
  }
}

/// Helper text đỏ (`<FormHelperText error sx={{ ml: 2 }}>`).
class MuiHelperText extends StatelessWidget {
  const MuiHelperText(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, top: 3, bottom: 16),
      child: Text(text, style: Mui.caption.copyWith(color: Mui.error)),
    );
  }
}

/// `<Card>` (radius 16, shadow theme).
class MuiCard extends StatelessWidget {
  const MuiCard({super.key, required this.child, this.padding = const EdgeInsets.all(16), this.color = Colors.white, this.leftBorder, this.gradient});

  final Widget child;
  final EdgeInsets padding;
  final Color color;
  final Color? leftBorder;
  final Gradient? gradient;

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: gradient == null ? color : null,
        gradient: gradient,
        borderRadius: BorderRadius.circular(20),
        boxShadow: Mui.cardShadow,
        border: Border.all(color: const Color(0x0F0F2A5C)),
      ),
      child: Container(
        decoration: leftBorder == null ? null : BoxDecoration(border: Border(left: BorderSide(color: leftBorder!, width: 4))),
        padding: padding,
        child: child,
      ),
    );
  }
}

enum MuiChipVariant { filled, outlined }

/// `<Chip size="small">`.
class MuiChip extends StatelessWidget {
  const MuiChip({super.key, required this.label, this.color, this.variant = MuiChipVariant.filled, this.icon});

  final String label;

  /// null = màu mặc định (xám).
  final Color? color;
  final MuiChipVariant variant;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final outlined = variant == MuiChipVariant.outlined;
    final bg = outlined ? (color ?? const Color(0xFF64748B)).withValues(alpha: 0.06) : (color ?? const Color(0xFFF1F5F9));
    final fg = outlined ? (color ?? const Color(0xFF334155)) : (color == null ? const Color(0xFF334155) : Colors.white);
    return Container(
      height: 26,
      padding: EdgeInsets.only(left: icon != null ? 6 : 0),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
        border: outlined ? Border.all(color: (color ?? const Color(0xFFCBD5E1)).withValues(alpha: 0.6)) : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) Icon(icon, size: 15, color: fg),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: outlined ? 8 : 10),
            child: Text(label, style: TextStyle(fontSize: 12.5, color: fg, height: 1, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }
}

/// `<LinearProgress variant="determinate">`.
class MuiLinearProgress extends StatelessWidget {
  const MuiLinearProgress({super.key, required this.value, required this.color, this.height = 4, this.radius = 0});

  final double value;
  final Color color;
  final double height;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final track = Color.lerp(color, Colors.white, 0.62)!;
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: SizedBox(
        height: height,
        child: Stack(
          children: [
            Positioned.fill(child: ColoredBox(color: track)),
            FractionallySizedBox(
              widthFactor: value.clamp(0.0, 1.0),
              child: ColoredBox(color: color, child: SizedBox(height: height)),
            ),
          ],
        ),
      ),
    );
  }
}

/// `<Dialog>` MUI: Paper radius 16, elevation 24, margin 32.
Future<T?> showMuiDialog<T>(
  BuildContext context, {
  required WidgetBuilder builder,
  bool barrierDismissible = true,
  EdgeInsets padding = EdgeInsets.zero,
  double maxWidth = 600,
}) {
  return showGeneralDialog<T>(
    context: context,
    barrierDismissible: barrierDismissible,
    barrierLabel: 'dialog',
    barrierColor: const Color(0x8C0B1A33),
    transitionDuration: const Duration(milliseconds: 260),
    transitionBuilder: (ctx, anim, _, child) {
      final curved = CurvedAnimation(parent: anim, curve: Curves.easeOutCubic);
      return FadeTransition(
        opacity: curved,
        child: ScaleTransition(scale: Tween(begin: 0.94, end: 1.0).animate(curved), child: child),
      );
    },
    pageBuilder: (ctx, _, _) => SafeArea(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxWidth),
            child: Container(
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: Tw.shadow2xl,
              ),
              child: Material(
                color: Colors.transparent,
                child: Padding(padding: padding, child: builder(ctx)),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

/// Trang nền thương hiệu (login, quên mật khẩu, tài khoản): logo + tiêu đề trên nền gradient,
/// nội dung trong thẻ trắng.
class MuiGradientPage extends StatelessWidget {
  const MuiGradientPage({super.key, required this.child, this.title, this.subtitle});

  final Widget child;
  final String? title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return BrandBackdrop(
      child: Column(
        children: [
          if (title != null) BrandHeader(title: title!, subtitle: subtitle),
          BrandFormCard(child: child),
        ],
      ),
    );
  }
}

/// Icon "mắt" bật/tắt mật khẩu của MUI (`<IconButton edge="end">`).
class MuiVisibilityToggle extends StatelessWidget {
  const MuiVisibilityToggle({super.key, required this.visible, required this.onTap});

  final bool visible;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onTap,
      icon: Icon(visible ? Icons.visibility_off_outlined : Icons.visibility_outlined, color: const Color(0xFF64748B), size: 21),
    );
  }
}

/// Màu tiêu đề trang MUI (`variant="h4"` + gradient bị ghi đè bởi màu chữ).
const muiPageTitleStyle =
    TextStyle(fontSize: 26, fontWeight: FontWeight.w800, height: 1.25, letterSpacing: -0.5, color: Mui.textPrimary);

/// Divider "Hoặc" của form Tailwind.
class TwOrDivider extends StatelessWidget {
  const TwOrDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider(color: Tw.gray200, height: 1)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text('hoặc', style: Tw.sm(c: Tw.gray400, w: Tw.medium)),
        ),
        const Expanded(child: Divider(color: Tw.gray200, height: 1)),
      ],
    );
  }
}
