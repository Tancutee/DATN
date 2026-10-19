import 'dart:async';

import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';

import '../theme/tw.dart';
import 'mui.dart';

/// Navigator gốc — dùng để hiển thị thông báo ở bất kỳ màn hình nào.
final rootNavigatorKey = GlobalKey<NavigatorState>();

enum ToastType { success, warning, error, info }

/// Hai cơ chế thông báo của Contests-FE:
/// - [toast]: `contexts/toastContext.tsx` (thẻ màu, thanh tiến trình, góc trên phải).
/// - [notify]: `contexts/NotificationContext.tsx` + `components/Notification` (MUI Snackbar
///   + Alert filled có tiêu đề, góc trên phải).
class AppNotify {
  AppNotify._();

  static final List<_ToastData> _toasts = [];
  static OverlayEntry? _toastEntry;
  static int _seq = 0;

  static OverlayState? get _overlay => rootNavigatorKey.currentState?.overlay;

  // ---------------------------------------------------------------------------
  // Toast
  // ---------------------------------------------------------------------------

  static void toast(String message, [ToastType type = ToastType.success]) {
    final overlay = _overlay;
    if (overlay == null) return;
    final data = _ToastData(++_seq, message, type);
    _toasts.add(data);
    _toastEntry ??= OverlayEntry(builder: (_) => _ToastStack(toasts: List.of(_toasts), onClose: _removeToast));
    if (!_toastEntry!.mounted) {
      overlay.insert(_toastEntry!);
    } else {
      _toastEntry!.markNeedsBuild();
    }
    Timer(const Duration(seconds: 3), () => _removeToast(data.id));
  }

  static void _removeToast(int id) {
    _toasts.removeWhere((t) => t.id == id);
    final entry = _toastEntry;
    if (entry == null) return;
    if (_toasts.isEmpty) {
      if (entry.mounted) entry.remove();
      _toastEntry = null;
    } else {
      entry.markNeedsBuild();
    }
  }

  // ---------------------------------------------------------------------------
  // MUI Snackbar notification
  // ---------------------------------------------------------------------------

  static OverlayEntry? _snackEntry;
  static Timer? _snackTimer;

  static void notify(
    String message, {
    MuiSeverity severity = MuiSeverity.info,
    String? title,
    Duration duration = const Duration(seconds: 3),
  }) {
    final overlay = _overlay;
    if (overlay == null) return;
    hideNotification();
    _snackEntry = OverlayEntry(
      builder: (ctx) => Positioned(
        top: MediaQuery.of(ctx).padding.top + 8,
        left: 8,
        right: 8,
        child: Material(
          color: Colors.transparent,
          child: _SlideIn(
            child: MuiAlert(
              severity: severity,
              filled: true,
              title: title,
              message: message,
              radius: 16,
              onClose: hideNotification,
            ),
          ),
        ),
      ),
    );
    overlay.insert(_snackEntry!);
    if (duration > Duration.zero) _snackTimer = Timer(duration, hideNotification);
  }

  static void success(String message, {String title = 'Thành công', Duration? duration}) =>
      notify(message, severity: MuiSeverity.success, title: title, duration: duration ?? const Duration(seconds: 3));

  static void error(String message, {String title = 'Lỗi', Duration? duration}) =>
      notify(message, severity: MuiSeverity.error, title: title, duration: duration ?? const Duration(seconds: 3));

  static void warning(String message, {String title = 'Cảnh báo', Duration? duration}) =>
      notify(message, severity: MuiSeverity.warning, title: title, duration: duration ?? const Duration(seconds: 3));

  static void info(String message, {String title = 'Thông tin', Duration? duration}) =>
      notify(message, severity: MuiSeverity.info, title: title, duration: duration ?? const Duration(seconds: 3));

  static void hideNotification() {
    _snackTimer?.cancel();
    _snackTimer = null;
    if (_snackEntry?.mounted ?? false) _snackEntry!.remove();
    _snackEntry = null;
  }
}

class _ToastData {
  _ToastData(this.id, this.message, this.type) : createdAt = DateTime.now();

  final int id;
  final String message;
  final ToastType type;
  final DateTime createdAt;
}

class _ToastStack extends StatelessWidget {
  const _ToastStack({required this.toasts, required this.onClose});

  final List<_ToastData> toasts;
  final void Function(int id) onClose;

  @override
  Widget build(BuildContext context) {
    final all = AppNotify._toasts;
    return Positioned(
      // `fixed top-23 right-4 flex flex-col gap-2`
      top: 92,
      right: 16,
      child: Material(
        color: Colors.transparent,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            for (final t in all)
              Padding(padding: const EdgeInsets.only(bottom: 8), child: _ToastCard(key: ValueKey(t.id), data: t, onClose: onClose)),
          ],
        ),
      ),
    );
  }
}

class _ToastCard extends StatefulWidget {
  const _ToastCard({super.key, required this.data, required this.onClose});

  final _ToastData data;
  final void Function(int id) onClose;

  @override
  State<_ToastCard> createState() => _ToastCardState();
}

class _ToastCardState extends State<_ToastCard> with SingleTickerProviderStateMixin {
  // Thanh tiến trình giảm 0.5% mỗi 30ms (giống FE) trong 3 giây hiển thị.
  late final AnimationController _c = AnimationController(vsync: this, duration: const Duration(seconds: 3))..forward();

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final (bg, icon) = switch (widget.data.type) {
      ToastType.success => (Tw.green500, HeroIcons.checkCircle),
      ToastType.warning => (Tw.yellow500, HeroIcons.exclamationCircle),
      ToastType.error => (Tw.red500, HeroIcons.xMark),
      ToastType.info => (Tw.blue500, HeroIcons.informationCircle),
    };
    final width = (MediaQuery.of(context).size.width - 32).clamp(0.0, 320.0);
    return Container(
      width: width,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(8), boxShadow: Tw.shadowXl),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 40, 16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(color: Color(0x33FFFFFF), shape: BoxShape.circle),
                  child: HeroIcon(icon, size: 20, color: Colors.white),
                ),
                const SizedBox(width: 12),
                Expanded(child: Text(widget.data.message, style: Tw.sm(c: Colors.white, w: Tw.medium))),
              ],
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: AnimatedBuilder(
              animation: _c,
              builder: (_, _) => FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: 1 - _c.value * 0.5,
                child: Container(height: 4, color: Colors.white),
              ),
            ),
          ),
          Positioned(
            top: 8,
            right: 8,
            child: GestureDetector(
              onTap: () => widget.onClose(widget.data.id),
              child: const HeroIcon(HeroIcons.xMark, size: 16, color: Color(0xB3FFFFFF)),
            ),
          ),
        ],
      ),
    );
  }
}

class _SlideIn extends StatefulWidget {
  const _SlideIn({required this.child});

  final Widget child;

  @override
  State<_SlideIn> createState() => _SlideInState();
}

class _SlideInState extends State<_SlideIn> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(vsync: this, duration: const Duration(milliseconds: 225))..forward();

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _c,
      child: ScaleTransition(scale: Tween(begin: 0.8, end: 1.0).animate(CurvedAnimation(parent: _c, curve: Curves.easeOut)), child: widget.child),
    );
  }
}
