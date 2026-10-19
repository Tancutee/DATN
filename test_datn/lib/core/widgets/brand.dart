import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../theme/tw.dart';
import 'mui.dart';

/// Nền thương hiệu dùng chung cho các trang đăng nhập / đăng ký / tài khoản:
/// gradient navy → xanh, vài quầng sáng mờ và lưới chấm rất nhạt.
class BrandBackdrop extends StatelessWidget {
  const BrandBackdrop({super.key, required this.child, this.showBack = true});

  final Widget child;
  final bool showBack;

  @override
  Widget build(BuildContext context) {
    final canPop = showBack && Navigator.of(context).canPop();
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: _scaffold(context, canPop),
    );
  }

  Widget _scaffold(BuildContext context, bool canPop) {
    return Scaffold(
      backgroundColor: Mui.primary,
      body: DecoratedBox(
        decoration: const BoxDecoration(gradient: Mui.pageGradient),
        child: Stack(
          children: [
            const Positioned(top: -140, right: -120, child: _Glow(size: 380, color: Color(0xFF3B8BFF), opacity: 0.35)),
            const Positioned(bottom: -160, left: -140, child: _Glow(size: 420, color: Color(0xFF38BDF8), opacity: 0.22)),
            const Positioned.fill(child: IgnorePointer(child: CustomPaint(painter: _GridDotsPainter()))),
            SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(20, canPop ? 56 : 28, 20, 32),
                  child: ConstrainedBox(constraints: const BoxConstraints(maxWidth: 480), child: child),
                ),
              ),
            ),
            if (canPop)
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: GlassIconButton(icon: Icons.arrow_back_rounded, onTap: () => Navigator.of(context).maybePop()),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Nút tròn kính mờ trên nền xanh đậm.
class GlassIconButton extends StatelessWidget {
  const GlassIconButton({super.key, required this.icon, required this.onTap, this.size = 44});

  final IconData icon;
  final VoidCallback onTap;
  final double size;

  @override
  Widget build(BuildContext context) {
    return PressScale(
      child: Material(
        color: Colors.white.withValues(alpha: 0.12),
        shape: CircleBorder(side: BorderSide(color: Colors.white.withValues(alpha: 0.18))),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onTap,
          child: SizedBox.square(dimension: size, child: Icon(icon, color: Colors.white, size: 22)),
        ),
      ),
    );
  }
}

/// Huy hiệu logo Cao Thắng: ô trắng bo tròn có bóng.
class BrandLogoBadge extends StatelessWidget {
  const BrandLogoBadge({super.key, this.size = 76});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      padding: EdgeInsets.all(size * 0.16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(size * 0.3),
        boxShadow: const [BoxShadow(color: Color(0x40001A3D), offset: Offset(0, 12), blurRadius: 28, spreadRadius: -6)],
      ),
      child: SvgPicture.asset('assets/images/logo-caothang.svg', fit: BoxFit.contain),
    );
  }
}

/// Logo + tiêu đề + mô tả, chữ trắng, đặt trên [BrandBackdrop].
class BrandHeader extends StatelessWidget {
  const BrandHeader({super.key, required this.title, this.subtitle});

  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 28),
      child: Column(
        children: [
          const BrandLogoBadge(),
          const SizedBox(height: 20),
          Text(title, textAlign: TextAlign.center, style: Tw.xl3(c: Colors.white, w: FontWeight.w800)),
          if (subtitle != null) ...[
            const SizedBox(height: 8),
            Text(subtitle!, textAlign: TextAlign.center, style: Tw.base(c: Colors.white.withValues(alpha: 0.78))),
          ],
        ],
      ),
    );
  }
}

/// Thẻ trắng chứa form, đặt trên [BrandBackdrop].
class BrandFormCard extends StatelessWidget {
  const BrandFormCard({super.key, required this.child, this.padding = const EdgeInsets.fromLTRB(24, 28, 24, 24)});

  final Widget child;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: const [BoxShadow(color: Color(0x4D00122B), offset: Offset(0, 24), blurRadius: 60, spreadRadius: -16)],
      ),
      child: child,
    );
  }
}

class _Glow extends StatelessWidget {
  const _Glow({required this.size, required this.color, required this.opacity});

  final double size;
  final Color color;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(colors: [color.withValues(alpha: opacity), color.withValues(alpha: 0)]),
        ),
      ),
    );
  }
}

class _GridDotsPainter extends CustomPainter {
  const _GridDotsPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()..color = Colors.white.withValues(alpha: 0.06);
    const step = 26.0;
    for (var y = step / 2; y < size.height; y += step) {
      for (var x = step / 2; x < size.width; x += step) {
        canvas.drawCircle(Offset(x, y), 1.1, p);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
