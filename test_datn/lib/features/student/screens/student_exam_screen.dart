import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:heroicons/heroicons.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/tw.dart';
import '../../../core/widgets/mui.dart';
import '../../../core/widgets/notify.dart';
import '../../../core/widgets/tw_widgets.dart';
import '../exam_controller.dart';
import '../student_models.dart';
import '../widgets/exam_widgets.dart';

/// Phòng chờ / phòng thi trực tuyến — `features/student/pages/StudentWaitingRoom.tsx`.
class StudentExamScreen extends StatelessWidget {
  const StudentExamScreen({super.key, required this.info, required this.match});

  final ContestantInfo info;
  final StudentMatch match;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ExamController(info: info, match: match)..start(),
      child: const _WaitingRoom(),
    );
  }
}

class _WaitingRoom extends StatefulWidget {
  const _WaitingRoom();

  @override
  State<_WaitingRoom> createState() => _WaitingRoomState();
}

class _WaitingRoomState extends State<_WaitingRoom> {
  final _subs = <StreamSubscription<dynamic>>[];
  bool _isFullscreen = false;
  Violation? _warning;
  Timer? _warningTimer;

  @override
  void initState() {
    super.initState();
    final c = context.read<ExamController>();
    _subs
      ..add(c.notices.listen((n) => AppNotify.notify(n.message, severity: n.severity, title: n.title, duration: n.duration)))
      ..add(c.violationEvents.listen(_onViolation))
      ..add(c.ended.listen((_) {
        // FE: setTimeout(() => navigate("/student/dashboard"), 3000)
        Timer(const Duration(seconds: 3), () {
          if (mounted) Navigator.of(context).maybePop();
        });
      }));

    // Thanh hệ thống hiện lại = thoát toàn màn hình.
    SystemChrome.setSystemUIChangeCallback((overlaysVisible) async {
      if (!mounted) return;
      final full = !overlaysVisible;
      if (_isFullscreen && !full) context.read<ExamController>().reportFullscreenExit();
      setState(() => _isFullscreen = full);
    });
  }

  @override
  void dispose() {
    for (final s in _subs) {
      s.cancel();
    }
    _warningTimer?.cancel();
    SystemChrome.setSystemUIChangeCallback(null);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  void _onViolation(Violation v) {
    if (!mounted) return;
    setState(() => _warning = v);
    AppNotify.warning('⚠️ Phát hiện vi phạm: ${v.description}',
        title: 'Cảnh báo chống gian lận', duration: const Duration(seconds: 4));
    _warningTimer?.cancel();
    _warningTimer = Timer(const Duration(seconds: 5), () {
      if (mounted) setState(() => _warning = null);
    });
  }

  Future<void> _enterFullscreen() async {
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    if (mounted) setState(() => _isFullscreen = true);
  }

  @override
  Widget build(BuildContext context) {
    final c = context.watch<ExamController>();
    final started = c.matchStarted;
    final inQuestion = started && c.current != null;

    return Scaffold(
      backgroundColor: Mui.background,
      body: Container(
        color: Mui.background,
        child: Stack(
          children: [
            Column(
              children: [
                _header(c, inQuestion),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
                    children: inQuestion ? _questionLayout(c) : _waitingLayout(c),
                  ),
                ),
              ],
            ),
            if (_warning != null && c.current != null)
              AntiCheatWarningModal(
                violation: _warning!,
                warningCount: c.warningCount,
                onContinue: () => setState(() => _warning = null),
                onTerminate: () {
                  c.terminateByUser();
                  setState(() => _warning = null);
                },
              ),
            if (c.isInRescueMode) const RescueAnimationOverlay(),
            if (!_isFullscreen) _fullscreenDialog(),
          ],
        ),
      ),
    );
  }

  Widget _header(ExamController c, bool inQuestion) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Container(
        decoration: const BoxDecoration(
          gradient: Mui.pageGradient,
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
        ),
        child: SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 18),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Center(
                    child: HeroIcon(inQuestion ? HeroIcons.pencilSquare : HeroIcons.trophy, size: 22, color: Colors.white),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(inQuestion ? 'Phòng thi trực tuyến' : 'Phòng chờ thi đấu',
                          style: Tw.lg(c: Colors.white, w: FontWeight.w800)),
                      Text(c.info.fullName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Tw.xs(c: Colors.white.withValues(alpha: 0.72))),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TwPulse(
                        enabled: c.connected,
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: c.connected ? Tw.green400 : Tw.red400,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(c.connected ? 'Đã kết nối' : 'Mất kết nối', style: Tw.xs(c: Colors.white, w: Tw.semibold)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _infoBox(String label, Widget value) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(color: Tw.gray50, borderRadius: BorderRadius.circular(14)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [Text(label, style: Tw.sm(c: Tw.gray500)), const SizedBox(height: 2), value],
        ),
      );

  Widget _statusPill() => const TwPill('Đang diễn ra', fg: Tw.green600, bg: Tw.green100);

  Widget _contestCard(ExamController c, {required bool withStudent}) {
    return TwCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [Tw.amber200, Tw.amber500]),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: const Center(child: HeroIcon(HeroIcons.trophy, size: 20, color: Colors.white)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('THÔNG TIN CUỘC THI', style: Tw.xs(c: Tw.gray400, w: Tw.bold).copyWith(letterSpacing: 0.8)),
                    Text(c.info.contestName, style: Tw.base(c: Mui.primary, w: FontWeight.w800).copyWith(height: 1.3)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _infoBox('Trạng thái cuộc thi', Align(alignment: Alignment.centerLeft, child: _statusPill())),
          const SizedBox(height: 10),
          _infoBox('Vòng thi', Text('Vòng thi', style: Tw.base(c: Tw.gray800, w: Tw.semibold))),
          if (withStudent) ...[
            const SizedBox(height: 10),
            _infoBox(
              'Thông tin thí sinh',
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(c.info.fullName, style: Tw.base(c: Tw.gray800, w: Tw.semibold)),
                  Text(c.info.studentCode, style: Tw.sm(c: Tw.gray600)),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  List<Widget> _questionLayout(ExamController c) {
    final current = c.current!;
    final q = current.question;
    return [
      _contestCard(c, withStudent: true),
      const SizedBox(height: 24),
      AntiCheatStatusCard(isMonitoring: c.isMonitoring, warningCount: c.warningCount),
      const SizedBox(height: 16),
      QuestionHeaderCard(current: current, remainingTime: c.remainingTime),
      const SizedBox(height: 16),
      QuestionContentCard(
        question: q,
        child: q.isEssay ? EssayInputView(c: c) : QuestionOptionsView(c: c),
      ),
      QuestionResultView(c: c),
      const SizedBox(height: 32),
    ];
  }

  List<Widget> _waitingLayout(ExamController c) {
    final started = c.matchStarted;
    return [
      _contestCard(c, withStudent: false),
      const SizedBox(height: 24),
      Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Tw.orange50,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Tw.orange200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('🛡️ Quy định chống gian lận', style: Tw.lg(c: Tw.orange800, w: Tw.bold)),
            const SizedBox(height: 16),
            _rule(['Bắt buộc vào chế độ ', 'toàn màn hình', ' khi làm bài']),
            _rule(['Không được ', 'chuyển tab', ' hoặc minimize cửa sổ']),
            _rule(['Không được sử dụng ', 'Copy/Paste', ' (Ctrl+C/V/X)']),
            _rule(['Không được mở ', 'menu chuột phải', '']),
            _rule(['Không được mở ', 'Developer Tools', ' (F12)']),
            const SizedBox(height: 4),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Tw.orange100,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Tw.orange200),
              ),
              child: Text.rich(
                TextSpan(
                  style: Tw.sm(c: Tw.orange800, w: Tw.medium),
                  children: const [
                    TextSpan(text: '⚠️ Vi phạm quá '),
                    TextSpan(text: '3 lần', style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(text: ' sẽ bị kết thúc bài thi!'),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
      if (started && c.current == null) ...[
        const SizedBox(height: 24),
        TwCard(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 32),
            child: Column(
              children: [
                const HeroIcon(HeroIcons.questionMarkCircle, size: 64, color: Tw.blue400),
                const SizedBox(height: 16),
                Text('Đang chờ câu hỏi', style: Tw.lg(c: Tw.gray800, w: Tw.bold)),
                const SizedBox(height: 8),
                Text('Giáo viên sẽ bắt đầu câu hỏi đầu tiên trong giây lát...',
                    textAlign: TextAlign.center, style: Tw.base(c: Tw.gray600)),
                const SizedBox(height: 16),
                TwPulse(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(color: Tw.blue100, borderRadius: BorderRadius.circular(8)),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(width: 8, height: 8, decoration: const BoxDecoration(color: Tw.blue500, shape: BoxShape.circle)),
                        const SizedBox(width: 8),
                        Text('Sẵn sàng thi đấu', style: Tw.base(c: Tw.blue700, w: Tw.medium)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
      const SizedBox(height: 32),
      TwCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const HeroIcon(HeroIcons.userGroup, size: 20, color: Tw.green500),
                const SizedBox(width: 8),
                Text('Thông tin thí sinh', style: Tw.lg(c: Tw.gray800, w: Tw.bold)),
              ],
            ),
            const SizedBox(height: 16),
            _kv('Họ tên', c.info.fullName),
            _kv('Mã thí sinh', c.info.studentCode),
            if (c.info.className != null) _kv('Lớp', c.info.className!),
            Text('Trạng thái', style: Tw.sm(c: Tw.gray500)),
            const SizedBox(height: 2),
            const TwPill('Đang thi đấu', fg: Tw.green600, bg: Tw.green100),
          ],
        ),
      ),
      const SizedBox(height: 32),
    ];
  }

  Widget _kv(String k, String v) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [Text(k, style: Tw.sm(c: Tw.gray500)), Text(v, style: Tw.base(c: Tw.gray800, w: Tw.semibold))],
        ),
      );

  Widget _rule(List<String> parts) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('•', style: Tw.sm(c: Tw.orange500, w: Tw.bold)),
            const SizedBox(width: 8),
            Expanded(
              child: Text.rich(
                TextSpan(
                  style: Tw.sm(c: Tw.gray700),
                  children: [
                    TextSpan(text: parts[0]),
                    TextSpan(text: parts[1], style: const TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(text: parts[2]),
                  ],
                ),
              ),
            ),
          ],
        ),
      );

  /// `<Dialog open fullWidth maxWidth="xs">` "Cho phép chế độ toàn màn hình".
  Widget _fullscreenDialog() {
    return Positioned.fill(
      child: ColoredBox(
        color: const Color(0x80000000),
        child: Center(
          child: Container(
            margin: const EdgeInsets.all(32),
            constraints: const BoxConstraints(maxWidth: 444),
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [BoxShadow(color: Color(0x33000000), blurRadius: 38, offset: Offset(0, 11))],
            ),
            child: Material(
              color: Colors.transparent,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Cho phép chế độ toàn màn hình', textAlign: TextAlign.center, style: Mui.h6.copyWith(color: Mui.textPrimary)),
                  const SizedBox(height: 7 + 16),
                  MuiButton(
                    label: 'Xác nhận',
                    large: true,
                    gradient: null,
                    color: Mui.error,
                    onPressed: _enterFullscreen,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
