import 'package:flutter/material.dart';

/// Bảng màu dựng theo tên class Tailwind (`bg-*`, `text-*`, `border-*`) của Contests-FE.
///
/// Để toàn app chỉ có một tông xanh: `gray` dùng xám lạnh (slate), còn `indigo`,
/// `cyan`, `purple` được ánh xạ sang các sắc độ của họ xanh thương hiệu.
class Tw {
  Tw._();

  static const white = Color(0xFFFFFFFF);
  static const black = Color(0xFF000000);

  // gray
  static const gray50 = Color(0xFFF8FAFC);
  static const gray100 = Color(0xFFF1F5F9);
  static const gray200 = Color(0xFFE2E8F0);
  static const gray300 = Color(0xFFCBD5E1);
  static const gray400 = Color(0xFF94A3B8);
  static const gray500 = Color(0xFF64748B);
  static const gray600 = Color(0xFF475569);
  static const gray700 = Color(0xFF334155);
  static const gray800 = Color(0xFF1E293B);
  static const gray900 = Color(0xFF0F172A);

  // slate
  static const slate50 = Color(0xFFF8FAFC);
  static const slate100 = Color(0xFFF1F5F9);
  static const slate200 = Color(0xFFE2E8F0);
  static const slate500 = Color(0xFF64748B);
  static const slate600 = Color(0xFF475569);
  static const slate800 = Color(0xFF1E293B);

  // red
  static const red50 = Color(0xFFFEF2F2);
  static const red100 = Color(0xFFFEE2E2);
  static const red200 = Color(0xFFFECACA);
  static const red300 = Color(0xFFFCA5A5);
  static const red400 = Color(0xFFF87171);
  static const red500 = Color(0xFFEF4444);
  static const red600 = Color(0xFFDC2626);
  static const red700 = Color(0xFFB91C1C);
  static const red800 = Color(0xFF991B1B);

  // orange
  static const orange50 = Color(0xFFFFF7ED);
  static const orange100 = Color(0xFFFFEDD5);
  static const orange200 = Color(0xFFFED7AA);
  static const orange300 = Color(0xFFFDBA74);
  static const orange400 = Color(0xFFFB923C);
  static const orange500 = Color(0xFFF97316);
  static const orange600 = Color(0xFFEA580C);
  static const orange800 = Color(0xFF9A3412);

  // amber
  static const amber50 = Color(0xFFFFFBEB);
  static const amber200 = Color(0xFFFDE68A);
  static const amber500 = Color(0xFFF59E0B);
  static const amber600 = Color(0xFFD97706);
  static const amber700 = Color(0xFFB45309);

  // yellow
  static const yellow50 = Color(0xFFFEFCE8);
  static const yellow100 = Color(0xFFFEF9C3);
  static const yellow200 = Color(0xFFFEF08A);
  static const yellow300 = Color(0xFFFDE047);
  static const yellow400 = Color(0xFFFACC15);
  static const yellow500 = Color(0xFFEAB308);
  static const yellow600 = Color(0xFFCA8A04);
  static const yellow700 = Color(0xFFA16207);
  static const yellow800 = Color(0xFF854D0E);

  // green
  static const green50 = Color(0xFFF0FDF4);
  static const green100 = Color(0xFFDCFCE7);
  static const green200 = Color(0xFFBBF7D0);
  static const green300 = Color(0xFF86EFAC);
  static const green400 = Color(0xFF4ADE80);
  static const green500 = Color(0xFF22C55E);
  static const green600 = Color(0xFF16A34A);
  static const green700 = Color(0xFF15803D);
  static const green800 = Color(0xFF166534);

  // cyan
  static const cyan50 = Color(0xFFF0F9FF);
  static const cyan100 = Color(0xFFE0F2FE);
  static const cyan200 = Color(0xFFBAE6FD);
  static const cyan300 = Color(0xFF7DD3FC);
  static const cyan400 = Color(0xFF38BDF8);
  static const cyan500 = Color(0xFF0EA5E9);
  static const cyan600 = Color(0xFF0284C7);
  static const cyan700 = Color(0xFF0369A1);

  // blue
  static const blue50 = Color(0xFFEFF6FF);
  static const blue100 = Color(0xFFDBEAFE);
  static const blue200 = Color(0xFFBFDBFE);
  static const blue300 = Color(0xFF93C5FD);
  static const blue400 = Color(0xFF5B9DF9);
  static const blue500 = Color(0xFF2F7BF0);
  static const blue600 = Color(0xFF1E63DB);
  static const blue700 = Color(0xFF1A4FB8);
  static const blue800 = Color(0xFF1A4294);
  static const blue900 = Color(0xFF14326E);

  // indigo
  static const indigo50 = Color(0xFFEEF4FF);
  static const indigo100 = Color(0xFFDCE8FF);
  static const indigo300 = Color(0xFF9DBDFB);
  static const indigo500 = Color(0xFF3B6FE8);
  static const indigo600 = Color(0xFF2456D3);
  static const indigo700 = Color(0xFF1C43AA);

  // purple
  static const purple50 = Color(0xFFF3F6FF);
  static const purple100 = Color(0xFFE5EBFF);
  static const purple300 = Color(0xFFAFC0FA);
  static const purple400 = Color(0xFF86A0F5);
  static const purple500 = Color(0xFF5E7FEE);
  static const purple600 = Color(0xFF4766DE);
  static const purple700 = Color(0xFF3750BD);
  static const purple800 = Color(0xFF2C4096);

  // pink
  static const pink100 = Color(0xFFFCE7F3);

  // ---------------------------------------------------------------------------
  // Shadows (Tailwind v4)
  // ---------------------------------------------------------------------------
  // Bóng mềm ánh xanh navy (0x0F2A5C) thay cho bóng đen thuần.
  static const shadowSm = [
    BoxShadow(color: Color(0x0F0F2A5C), offset: Offset(0, 1), blurRadius: 3),
    BoxShadow(color: Color(0x0A0F2A5C), offset: Offset(0, 1), blurRadius: 2),
  ];
  static const shadowMd = [
    BoxShadow(color: Color(0x140F2A5C), offset: Offset(0, 6), blurRadius: 16, spreadRadius: -4),
    BoxShadow(color: Color(0x0A0F2A5C), offset: Offset(0, 2), blurRadius: 4, spreadRadius: -2),
  ];
  static const shadowLg = [
    BoxShadow(color: Color(0x170F2A5C), offset: Offset(0, 12), blurRadius: 32, spreadRadius: -8),
    BoxShadow(color: Color(0x0A0F2A5C), offset: Offset(0, 4), blurRadius: 8, spreadRadius: -4),
  ];
  static const shadowXl = [
    BoxShadow(color: Color(0x1F0F2A5C), offset: Offset(0, 20), blurRadius: 44, spreadRadius: -10),
    BoxShadow(color: Color(0x0D0F2A5C), offset: Offset(0, 6), blurRadius: 12, spreadRadius: -6),
  ];
  static const shadow2xl = [
    BoxShadow(color: Color(0x330F2A5C), offset: Offset(0, 28), blurRadius: 60, spreadRadius: -12),
  ];

  /// Bóng "phát sáng" màu xanh cho nút chính.
  static List<BoxShadow> glow(Color c) => [
        BoxShadow(color: c.withValues(alpha: 0.32), offset: const Offset(0, 8), blurRadius: 20, spreadRadius: -6),
      ];

  // ---------------------------------------------------------------------------
  // Text styles: text-xs ... text-5xl (font-size / line-height)
  // ---------------------------------------------------------------------------
  static TextStyle xs({Color? c, FontWeight? w}) => _t(12, 16, c, w);
  static TextStyle sm({Color? c, FontWeight? w}) => _t(14, 20, c, w);
  static TextStyle base({Color? c, FontWeight? w}) => _t(16, 24, c, w);
  static TextStyle lg({Color? c, FontWeight? w}) => _t(18, 28, c, w);
  static TextStyle xl({Color? c, FontWeight? w}) => _t(20, 28, c, w);
  static TextStyle xl2({Color? c, FontWeight? w}) => _t(24, 32, c, w);
  static TextStyle xl3({Color? c, FontWeight? w}) => _t(30, 36, c, w);
  static TextStyle xl4({Color? c, FontWeight? w}) => _t(36, 40, c, w);
  static TextStyle xl5({Color? c, FontWeight? w}) => _t(48, 48, c, w);

  // Chữ lớn kéo khoảng cách ký tự lại một chút cho gọn, kiểu tiêu đề hiện đại.
  static TextStyle _t(double size, double lh, Color? c, FontWeight? w) => TextStyle(
        fontSize: size,
        height: lh / size,
        color: c,
        fontWeight: w,
        letterSpacing: size >= 24 ? -0.02 * size : (size >= 18 ? -0.2 : null),
      );

  static const medium = FontWeight.w500;
  static const semibold = FontWeight.w600;
  static const bold = FontWeight.w700;
}

/// Text có màu gradient (`bg-gradient-to-r ... bg-clip-text text-transparent`).
class GradientText extends StatelessWidget {
  const GradientText(this.text, {super.key, required this.colors, required this.style, this.textAlign});

  final String text;
  final List<Color> colors;
  final TextStyle style;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (rect) => LinearGradient(colors: colors).createShader(rect),
      child: Text(text, style: style.copyWith(color: Colors.white), textAlign: textAlign),
    );
  }
}

/// Spinner `animate-spin rounded-full border-b-2` của Tailwind.
class TwSpinner extends StatefulWidget {
  const TwSpinner({super.key, this.size = 48, this.color = Tw.indigo600, this.width = 2, this.track});

  final double size;
  final Color color;
  final double width;

  /// Màu viền nền (vd `border-slate-200 border-t-blue-600`). Null = chỉ vẽ cạnh dưới.
  final Color? track;

  @override
  State<TwSpinner> createState() => _TwSpinnerState();
}

class _TwSpinnerState extends State<TwSpinner> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(vsync: this, duration: const Duration(seconds: 1))
    ..repeat();

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: _c,
      child: CustomPaint(
        size: Size.square(widget.size),
        painter: _SpinnerPainter(widget.color, widget.width, widget.track),
      ),
    );
  }
}

class _SpinnerPainter extends CustomPainter {
  _SpinnerPainter(this.color, this.width, this.track);

  final Color color;
  final double width;
  final Color? track;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset(width / 2, width / 2) & Size(size.width - width, size.height - width);
    final p = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = width;
    if (track != null) {
      canvas.drawArc(rect, 0, 6.2832, false, p..color = track!);
      canvas.drawArc(rect, -2.356, 1.571, false, p..color = color);
    } else {
      canvas.drawArc(rect, 0.785, 1.571, false, p..color = color);
    }
  }

  @override
  bool shouldRepaint(covariant _SpinnerPainter old) => false;
}

/// Lặp vô hạn animation `animate-pulse` (opacity 1 → 0.5).
class TwPulse extends StatefulWidget {
  const TwPulse({super.key, required this.child, this.enabled = true});

  final Widget child;
  final bool enabled;

  @override
  State<TwPulse> createState() => _TwPulseState();
}

class _TwPulseState extends State<TwPulse> with SingleTickerProviderStateMixin {
  late final AnimationController _c =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 1000))..repeat(reverse: true);

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.enabled) return widget.child;
    return FadeTransition(opacity: Tween(begin: 1.0, end: 0.5).animate(_c), child: widget.child);
  }
}

/// `animate-bounce` của Tailwind.
class TwBounce extends StatefulWidget {
  const TwBounce({super.key, required this.child, this.delay = Duration.zero, this.distance = 0.25});

  final Widget child;
  final Duration delay;

  /// Tỷ lệ theo chiều cao (Tailwind: translateY(-25%)).
  final double distance;

  @override
  State<TwBounce> createState() => _TwBounceState();
}

class _TwBounceState extends State<TwBounce> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(vsync: this, duration: const Duration(seconds: 1));

  @override
  void initState() {
    super.initState();
    Future.delayed(widget.delay, () {
      if (mounted) _c.repeat();
    });
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _c,
      builder: (context, child) {
        final t = _c.value;
        // 0%,100%: -25% (ease-out), 50%: 0 (ease-in)
        final y = t < 0.5
            ? -widget.distance * (1 - Curves.easeIn.transform(t * 2))
            : -widget.distance * Curves.easeOut.transform((t - 0.5) * 2);
        return FractionalTranslation(translation: Offset(0, y), child: child);
      },
      child: widget.child,
    );
  }
}

/// Thu nhỏ nhẹ (97%) khi nhấn giữ — phản hồi chạm cho nút và thẻ bấm được.
class PressScale extends StatefulWidget {
  const PressScale({super.key, required this.child, this.enabled = true, this.scale = 0.97});

  final Widget child;
  final bool enabled;
  final double scale;

  @override
  State<PressScale> createState() => _PressScaleState();
}

class _PressScaleState extends State<PressScale> {
  bool _down = false;

  void _set(bool v) {
    if (widget.enabled && v != _down) setState(() => _down = v);
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (_) => _set(true),
      onPointerUp: (_) => _set(false),
      onPointerCancel: (_) => _set(false),
      child: AnimatedScale(
        scale: _down ? widget.scale : 1,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        child: widget.child,
      ),
    );
  }
}
