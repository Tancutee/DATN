import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:heroicons/heroicons.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

import '../../../app_routes.dart';
import '../../../core/network/socket_client.dart';
import '../../../core/theme/tw.dart';
import '../../../core/widgets/mui.dart';
import '../../../core/widgets/notify.dart';
import '../../../core/widgets/tw_widgets.dart';
import '../../auth/auth_provider.dart';
import '../student_models.dart';
import '../student_service.dart';
import 'student_exam_screen.dart';

/// Dashboard thí sinh — `features/student/pages/StudentDashboard.tsx` (layout mobile).
class StudentDashboardScreen extends StatefulWidget {
  const StudentDashboardScreen({super.key});

  @override
  State<StudentDashboardScreen> createState() => _StudentDashboardScreenState();
}

class _StudentDashboardScreenState extends State<StudentDashboardScreen> {
  static const _itemsPerPage = 5;
  final _service = StudentService();

  ContestantInfo? _info;
  bool _loading = true;
  int _page = 1;

  io.Socket? _socket;
  bool _connected = false;
  bool _inExam = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _disconnect();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() => _loading = _info == null);
    try {
      final info = await _service.getProfile();
      if (!mounted) return;
      setState(() {
        _info = info;
        _page = 1;
      });
      await _connect();
    } catch (_) {
      if (mounted) setState(() => _info = null);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _connect() async {
    if (_socket != null || _info == null) return;
    final socket = await SocketClient.connect('/student');
    if (!mounted) {
      socket.dispose();
      return;
    }
    _socket = socket;
    socket
      ..onConnect((_) async {
        if (mounted) setState(() => _connected = true);
        // BE đăng ký handler `/student` sau một truy vấn DB → thử lại vài lần.
        for (final m in _info?.matches ?? const <StudentMatch>[]) {
          var ack = SocketAck(false, '');
          for (var i = 0; i < 4 && !ack.success && socket.connected; i++) {
            await Future<void>.delayed(Duration(milliseconds: 400 + i * 600));
            ack = await SocketClient.emitAck(socket, 'joinMatchRoom', m.id, timeout: const Duration(seconds: 3));
          }
        }
      })
      ..onDisconnect((_) {
        if (mounted) setState(() => _connected = false);
      })
      ..onConnectError((_) {
        if (mounted) setState(() => _connected = false);
      })
      ..on('match:started', _onMatchStarted)
      ..on('match:globalStarted', _onMatchStarted)
      ..on('timer:update', (data) {
        final t = data is Map ? data['timeRemaining'] : null;
        if (t is num && mounted && _info != null) {
          setState(() {
            _info = _info!.withMatches([
              for (final m in _info!.matches)
                m.status == 'active'
                    ? StudentMatch(
                        id: m.id,
                        name: m.name,
                        slug: m.slug,
                        status: m.status,
                        currentQuestion: m.currentQuestion,
                        remainingTime: t.toInt())
                    : m,
            ]);
          });
        }
      });
  }

  void _disconnect() {
    _socket?.dispose();
    _socket = null;
    _connected = false;
  }

  void _onMatchStarted(dynamic data) {
    if (data is! Map || _info == null || _inExam || !mounted) return;
    final matchId = data['matchId'];
    final match = _info!.matches.where((m) => m.id.toString() == matchId?.toString()).firstOrNull;
    _socket?.emit('student:confirmStart', {'contestantId': _info!.contestantId, 'matchId': matchId});
    AppNotify.success('Trận đấu ${data['matchName'] ?? ''} đã bắt đầu! Đang chuyển vào phòng thi...');
    if (match == null) return;
    Timer(const Duration(milliseconds: 1500), () {
      if (mounted && !_inExam) _openExam(match.copyWith(status: 'ongoing'));
    });
  }

  Future<void> _openExam(StudentMatch match) async {
    if (_inExam || _info == null) return;
    _inExam = true;
    _disconnect();
    await Navigator.of(context).push(MaterialPageRoute(builder: (_) => StudentExamScreen(info: _info!, match: match)));
    _inExam = false;
    if (mounted) await _load();
  }

  /// FE: logout → `/student/login`.
  Future<void> _logout() async {
    final auth = context.read<AuthProvider>();
    _disconnect();
    AppRoutes.home();
    await auth.logout();
    AppRoutes.studentLogin();
  }

  // FE: getMatchStatusColor / getStatusText
  (Color, Color) _statusColors(String s) => switch (s) {
        'upcoming' => (Tw.yellow600, Tw.yellow100),
        'ongoing' => (Tw.green600, Tw.green100),
        _ => (Tw.gray600, Tw.gray100),
      };

  String _statusText(String s) => switch (s) {
        'upcoming' => 'Sắp diễn ra',
        'ongoing' => 'Đang diễn ra',
        'completed' => 'Đã kết thúc',
        _ => 'Không xác định',
      };


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Mui.background,
      body: _loading
          ? const Center(child: TwSpinner(size: 44, color: Tw.blue600, width: 3, track: Tw.blue100))
          : _info == null
              ? _notInContest()
              : RefreshIndicator(
                  onRefresh: _load,
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      _header(),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
                        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: _content()),
                      ),
                    ],
                  ),
                ),
    );
  }

  Widget _notInContest() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: TwCard(
          width: 400,
          padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(color: Tw.blue50, borderRadius: BorderRadius.circular(24)),
                child: const Center(child: HeroIcon(HeroIcons.userGroup, size: 36, color: Tw.blue600)),
              ),
              const SizedBox(height: 20),
              Text('Bạn chưa được thêm vào cuộc thi',
                  textAlign: TextAlign.center, style: Tw.xl(c: Tw.gray900, w: FontWeight.w800)),
              const SizedBox(height: 8),
              Text('Vui lòng liên hệ Admin để được thêm vào cuộc thi',
                  textAlign: TextAlign.center, style: Tw.sm(c: Tw.gray500)),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: TwPrimaryButton(label: 'Về trang chủ', onPressed: AppRoutes.home, icon: Icons.home_rounded),
              ),
              const SizedBox(height: 8),
              TextButton(onPressed: _logout, child: const Text('Đăng xuất')),
            ],
          ),
        ),
      ),
    );
  }

  void _openMenu() {
    showModalBottomSheet<void>(
      context: context,
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ListTile(
                leading: Icon(_connected ? Icons.wifi_rounded : Icons.wifi_off_rounded,
                    color: _connected ? Tw.green600 : Tw.red600),
                title: Text('Kết nối: ${_connected ? 'Ổn định' : 'Mất kết nối'}', style: Tw.sm(c: Tw.gray700, w: Tw.semibold)),
              ),
              ListTile(
                leading: const Icon(Icons.refresh_rounded),
                title: Text('Tải lại', style: Tw.sm(c: Tw.gray700, w: Tw.semibold)),
                onTap: () {
                  Navigator.pop(ctx);
                  _load();
                },
              ),
              ListTile(
                leading: const Icon(Icons.logout_rounded, color: Tw.red600),
                title: Text('Đăng xuất', style: Tw.sm(c: Tw.red600, w: Tw.semibold)),
                onTap: () {
                  Navigator.pop(ctx);
                  _logout();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _header() {
    final info = _info!;
    final initial = info.fullName.trim().isEmpty ? '?' : info.fullName.trim()[0].toUpperCase();
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Container(
        decoration: const BoxDecoration(
          gradient: Mui.pageGradient,
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
        ),
        child: SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 12, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Text(initial, style: Tw.lg(c: Mui.primary, w: FontWeight.w800)),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Xin chào,', style: Tw.xs(c: Colors.white.withValues(alpha: 0.7))),
                          Text(info.fullName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Tw.base(c: Colors.white, w: FontWeight.w800)),
                        ],
                      ),
                    ),
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
                            enabled: _connected,
                            child: Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: _connected ? Tw.green400 : Tw.red400,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(_connected ? 'Trực tuyến' : 'Ngoại tuyến', style: Tw.xs(c: Colors.white, w: Tw.semibold)),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: _openMenu,
                      icon: const Icon(Icons.more_vert_rounded, color: Colors.white),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.14)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(colors: [Tw.amber200, Tw.amber500]),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Center(child: HeroIcon(HeroIcons.trophy, size: 24, color: Colors.white)),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('CUỘC THI',
                                style: Tw.xs(c: Colors.white.withValues(alpha: 0.6), w: Tw.bold).copyWith(letterSpacing: 0.8)),
                            const SizedBox(height: 2),
                            Text(info.contestName, style: Tw.base(c: Colors.white, w: Tw.bold).copyWith(height: 1.3)),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.14),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text('Mã thí sinh: ${info.studentCode}',
                                  style: Tw.xs(c: Colors.white, w: Tw.semibold)),
                            ),
                          ],
                        ),
                      ),
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

  List<Widget> _content() {
    final info = _info!;
    final sorted = [...info.matches]..sort((a, b) => b.id.compareTo(a.id));
    final totalPages = (sorted.length / _itemsPerPage).ceil();
    final start = (_page - 1) * _itemsPerPage;
    final pageItems = sorted.skip(start).take(_itemsPerPage).toList();

    return [
      Row(
        children: [
          Expanded(child: Text('Trận đấu của bạn', style: Tw.lg(c: Tw.gray900, w: FontWeight.w800))),
          TwPill('${info.matches.length} trận', fg: Tw.blue700, bg: Tw.blue100, small: true),
        ],
      ),
      const SizedBox(height: 12),
      if (info.matches.isEmpty)
        TwCard(
          padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 24),
          shadow: Tw.shadowMd,
          child: Column(
            children: [
              const HeroIcon(HeroIcons.calendar, size: 44, color: Tw.gray300),
              const SizedBox(height: 12),
              Text('Không có trận đấu nào', style: Tw.base(c: Tw.gray800, w: Tw.bold)),
              const SizedBox(height: 4),
              Text('Hiện tại không có trận đấu nào đang diễn ra.',
                  textAlign: TextAlign.center, style: Tw.sm(c: Tw.gray500)),
            ],
          ),
        )
      else ...[
        for (final m in pageItems) ...[_matchTile(m), const SizedBox(height: 10)],
        if (totalPages > 1) _pagination(sorted.length, totalPages),
      ],
      const SizedBox(height: 24),
      Text('Hướng dẫn nhanh', style: Tw.lg(c: Tw.gray900, w: FontWeight.w800)),
      const SizedBox(height: 12),
      TwCard(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 6),
        shadow: Tw.shadowMd,
        child: Column(
          children: [
            for (final (i, t) in const [
              'Vi phạm 3 lần sẽ bị loại khỏi cuộc thi',
              'Chờ trận đấu bắt đầu và vào phòng thi',
              'Trả lời câu hỏi trong thời gian quy định',
              'Xem kết quả ngay sau khi hết thời gian',
              'Khi bị loại vẫn có thể hồi sinh ( nên đừng rời phòng thi )',
            ].indexed)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 26,
                      height: 26,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: i == 0 ? Tw.red50 : Tw.blue50,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text('${i + 1}', style: Tw.xs(c: i == 0 ? Tw.red600 : Tw.blue700, w: FontWeight.w800)),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 3),
                        child: Text(t, style: Tw.sm(c: Tw.gray600).copyWith(height: 1.5)),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    ];
  }

  Widget _matchTile(StudentMatch m) {
    final (fg, bg) = _statusColors(m.status);
    final live = m.status == 'ongoing' || m.status == 'active';
    return PressScale(
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          // Chạm vào thẻ trận để vào phòng chờ.
          onTap: () => _openExam(m),
          borderRadius: BorderRadius.circular(18),
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: live ? Tw.green200 : Tw.gray200),
            ),
            child: Row(
              children: [
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    gradient: live ? const LinearGradient(colors: [Tw.green400, Tw.green600]) : null,
                    color: live ? null : Tw.blue50,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Center(
                    child: HeroIcon(live ? HeroIcons.play : HeroIcons.clock,
                        size: 22, color: live ? Colors.white : Tw.blue600),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(m.name, style: Tw.base(c: Tw.gray900, w: Tw.bold)),
                      const SizedBox(height: 6),
                      TwPill(_statusText(m.status), fg: fg, bg: bg, small: true),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right_rounded, color: Tw.gray400),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _pagination(int total, int totalPages) {
    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: Row(
        children: [
          Expanded(
            child: Text(
              '${(_page - 1) * _itemsPerPage + 1}–${min(_page * _itemsPerPage, total)} / $total trận',
              style: Tw.sm(c: Tw.gray500),
            ),
          ),
          _pageIcon(Icons.chevron_left_rounded, _page > 1 ? () => setState(() => _page--) : null),
          for (var p = 1; p <= totalPages; p++)
            GestureDetector(
              onTap: () => setState(() => _page = p),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                margin: const EdgeInsets.symmetric(horizontal: 3),
                width: 36,
                height: 36,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: _page == p ? Mui.secondary : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: _page == p ? Mui.secondary : Tw.gray200),
                ),
                child: Text('$p', style: Tw.sm(c: _page == p ? Colors.white : Tw.gray600, w: Tw.bold)),
              ),
            ),
          _pageIcon(Icons.chevron_right_rounded, _page < totalPages ? () => setState(() => _page++) : null),
        ],
      ),
    );
  }

  Widget _pageIcon(IconData icon, VoidCallback? onTap) => IconButton(
        onPressed: onTap,
        visualDensity: VisualDensity.compact,
        icon: Icon(icon, color: onTap == null ? Tw.gray300 : Tw.gray600),
      );
}
