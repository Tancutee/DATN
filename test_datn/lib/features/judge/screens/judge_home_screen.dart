import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

import '../../../app_routes.dart';
import '../../../core/network/socket_client.dart';
import '../../../core/theme/tw.dart';
import '../../../core/widgets/mui.dart';
import '../../../core/widgets/notify.dart';
import '../../auth/auth_provider.dart';
import '../judge_service.dart';

enum _Tab { inProgress, confirmed1, confirmed2, logout }

extension on _Tab {
  String get label => switch (this) {
        _Tab.inProgress => 'Đang thi',
        _Tab.confirmed1 => 'Xác nhận 1',
        _Tab.confirmed2 => 'Xác nhận 2',
        _Tab.logout => 'Đăng xuất',
      };

  String get icon => switch (this) {
        _Tab.inProgress => '📝',
        _Tab.confirmed1 => '⚠️',
        _Tab.confirmed2 => '❌',
        _Tab.logout => '�',
      };

  String? get status => switch (this) {
        _Tab.inProgress => 'in_progress',
        _Tab.confirmed1 => 'confirmed1',
        _Tab.confirmed2 => 'confirmed2',
        _Tab.logout => null,
      };

  /// (gradient active, bg inactive, text inactive, border inactive)
  (List<Color>, Color, Color, Color) get colors => switch (this) {
        _Tab.inProgress => (const [Tw.blue500, Tw.blue600], Tw.blue50, Tw.blue700, Tw.blue200),
        _Tab.confirmed1 => (const [Tw.amber500, Tw.amber600], Tw.amber50, Tw.amber700, Tw.amber200),
        _Tab.confirmed2 => (const [Tw.red500, Tw.red600], Tw.red50, Tw.red700, Tw.red200),
        _Tab.logout => (const [Tw.gray500, Tw.gray600], Tw.gray50, Tw.gray700, Tw.gray200),
      };
}

/// Theo dõi trận đấu — `features/judge/pages/JudgeHomePage.tsx`.
class JudgeHomeScreen extends StatefulWidget {
  const JudgeHomeScreen({super.key, required this.matchSlug});

  final String matchSlug;

  @override
  State<JudgeHomeScreen> createState() => _JudgeHomeScreenState();
}

class _JudgeHomeScreenState extends State<JudgeHomeScreen> {
  final _service = JudgeService();
  final _scroll = ScrollController();

  bool _loading = true;
  bool _error = false;
  JudgeMatchInfo? _match;
  List<JudgeContestant> _contestants = [];
  JudgeGroup? _group;
  io.Socket? _socket;

  _Tab _tab = _Tab.inProgress;
  final List<int> _selected = [];
  bool _scrolled = false;

  int? get _userId => context.read<AuthProvider>().user?.id;

  @override
  void initState() {
    super.initState();
    _scroll.addListener(() {
      final s = _scroll.offset > 100;
      if (s != _scrolled) setState(() => _scrolled = s);
    });
    _load();
    _connect();
  }

  @override
  void dispose() {
    _scroll.dispose();
    _socket?.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    try {
      final r = await Future.wait([
        _service.matchInfo(widget.matchSlug),
        _service.contestants(widget.matchSlug),
        _service.group(widget.matchSlug),
      ]);
      if (!mounted) return;
      setState(() {
        _match = r[0] as JudgeMatchInfo;
        _contestants = r[1] as List<JudgeContestant>;
        _group = r[2] as JudgeGroup?;
        _error = false;
      });
    } catch (_) {
      if (mounted) setState(() => _error = true);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _connect() async {
    final socket = await SocketClient.connect('/match-control');
    if (!mounted) {
      socket.dispose();
      return;
    }
    _socket = socket;
    socket
      ..onConnect((_) => socket.emit('joinMatchRoom', widget.matchSlug))
      ..on('currentQuestion:get', (data) {
        final info = data is Map ? data['matchInfo'] : null;
        if (info is Map && mounted) setState(() => _match = JudgeMatchInfo.fromJson(info));
      })
      ..on('contestant:status-update-judge', (data) {
        final list = data is Map ? data['data'] : null;
        if (list is List && mounted) {
          setState(() => _contestants = list.map((e) => JudgeContestant.fromJson(e as Map)).toList());
        }
      })
      ..on('group:confirmCurrentQuestion-update', (data) {
        final g = data is Map ? data['updatedGroup'] : null;
        if (g is Map && mounted) setState(() => _group = JudgeGroup.fromJson(g));
      });
  }

  bool get _disabled {
    final q = _match?.currentQuestion ?? 0;
    if (q == 0) return false;
    return (_group?.confirmCurrentQuestion ?? 0) >= q;
  }

  int _count(String status) => _contestants.where((c) => c.status == status).length;

  Future<void> _emitStatus({
    required String from,
    required String to,
    required String warn,
    required String ok,
    required String fail,
    required _Tab next,
  }) async {
    final hasFrom = _selected.any((id) => _contestants.any((c) => c.registrationNumber == id && c.status == from));
    if (_selected.isEmpty || !hasFrom) {
      AppNotify.toast(warn, ToastType.warning);
      return;
    }
    final s = _socket;
    if (s == null) return;
    final ack = await SocketClient.emitAck(s, 'contestant:status-update-judge', {
      'match': widget.matchSlug,
      'userId': _userId,
      'status': to,
      'ids': List.of(_selected),
    });
    if (!mounted) return;
    if (ack.success) {
      AppNotify.toast(ok, ToastType.success);
      setState(() {
        _selected.clear();
        _tab = next;
      });
    } else {
      AppNotify.toast(ack.message.isNotEmpty ? ack.message : fail, ToastType.error);
    }
  }

  Future<void> _chot() async {
    if (_contestants.any((c) => c.status == 'confirmed1')) {
      AppNotify.toast('Vẫn còn thí sinh ở trạng thái xác nhận 1!', ToastType.error);
      return;
    }
    final s = _socket;
    if (s == null) return;
    final ack = await SocketClient.emitAck(s, 'group:confirmCurrentQuestion-update', {
      'match': widget.matchSlug,
      'userId': _userId,
      'groupId': _group?.id,
      'confirmCurrentQuestion': _match?.currentQuestion ?? 0,
    });
    if (!mounted) return;
    ack.success
        ? AppNotify.toast('Chốt thành công!', ToastType.success)
        : AppNotify.toast(ack.message.isNotEmpty ? ack.message : 'Chốt thất bại!', ToastType.error);
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(backgroundColor: Colors.white, body: Center(child: CircularProgressIndicator(color: Mui.primary)));
    }
    if (_error) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(child: Text('Lỗi khi tải dữ liệu. Vui lòng thử lại.', style: Tw.base(c: Tw.red500))),
      );
    }
    final user = context.watch<AuthProvider>().user;
    final top = MediaQuery.of(context).padding.top;

    return Scaffold(
      body: Stack(
        children: [
          const Positioned.fill(child: _AnimatedBackground()),
          RefreshIndicator(
            onRefresh: _load,
            edgeOffset: top + 64,
            child: ListView(
              controller: _scroll,
              padding: EdgeInsets.fromLTRB(12, top + 12 + 64, 12, 12),
              children: [
                _header(user?.username ?? 'Giám khảo'),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                    boxShadow: Tw.shadow2xl,
                  ),
                  child: _tab == _Tab.logout ? _logoutSection() : _contestantList(),
                ),
                const SizedBox(height: 16),
                Text('Cuộc thi - Hệ thống quản lý trọng tài © 2025',
                    textAlign: TextAlign.center, style: Tw.xs(c: Colors.white.withValues(alpha: 0.5))),
              ],
            ),
          ),
          Positioned(top: top + 16, left: 0, right: 0, child: Center(child: _tabs())),
        ],
      ),
    );
  }

  Widget _header(String username) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Tw.blue200, width: 2),
        boxShadow: Tw.shadowXl,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 40,
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Tw.blue500, Tw.blue700]),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: Tw.shadowLg,
                ),
                child: Text('👨‍⚖️', style: Tw.xl()),
              ),
              const SizedBox(width: 12),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('$username - Câu ${_match?.currentQuestion ?? 0}', style: Tw.lg(c: Tw.blue800, w: Tw.bold)),
                    Text(_match?.name ?? 'Trận đấu', style: Tw.xs(c: Tw.blue600, w: Tw.medium)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Tw.blue50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Tw.blue200),
            ),
            child: Column(
              children: [
                Text('Tổng thí sinh', style: Tw.xs(c: Tw.blue700, w: Tw.semibold)),
                Text('${_contestants.length}', style: Tw.lg(c: Tw.blue900, w: Tw.bold)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _tabs() {
    final w = MediaQuery.of(context).size.width;
    return AnimatedScale(
      duration: const Duration(milliseconds: 300),
      scale: _scrolled ? 0.9 : 1,
      child: Container(
        constraints: BoxConstraints(maxWidth: w - 16),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.95),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
          boxShadow: Tw.shadowXl,
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          clipBehavior: Clip.none,
          child: Row(
            children: [
              for (final t in _Tab.values) ...[
                if (t != _Tab.inProgress) const SizedBox(width: 16),
                _tabButton(t),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _tabButton(_Tab t) {
    final active = _tab == t;
    final (grad, bg, fg, border) = t.colors;
    final count = t.status == null ? 0 : _count(t.status!);
    return GestureDetector(
      onTap: () => setState(() => _tab = t),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              gradient: active ? LinearGradient(colors: grad) : null,
              color: active ? null : bg,
              borderRadius: BorderRadius.circular(12),
              border: active ? null : Border.all(color: border),
              boxShadow: active ? Tw.shadowLg : Tw.shadowSm,
            ),
            child: Row(
              children: [
                Text(t.icon, style: Tw.base()),
                const SizedBox(width: 6),
                Text(t.label, style: Tw.sm(c: active ? Colors.white : fg, w: Tw.medium)),
                if (t.status != null) ...[
                  const SizedBox(width: 6),
                  TwPulse(
                    enabled: count > 0,
                    child: Container(
                      constraints: const BoxConstraints(minWidth: 20),
                      height: 20,
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: active ? Colors.white.withValues(alpha: 0.25) : Colors.white,
                        borderRadius: BorderRadius.circular(999),
                        boxShadow: active ? null : Tw.shadowSm,
                      ),
                      child: Text('$count', style: Tw.xs(c: active ? Colors.white : Tw.gray700, w: Tw.bold)),
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (active)
            Positioned(
              bottom: -4,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle, boxShadow: Tw.shadowSm),
                ),
              ),
            ),
          if (t.status != null && count > 5)
            Positioned(
              top: -4,
              right: -4,
              child: TwBounce(
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: Tw.orange500,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _contestantList() {
    final q = _match?.currentQuestion ?? 0;
    final (emoji, title, subtitle) = switch (_tab) {
      _Tab.inProgress => ('📝', 'Danh sách thí sinh đang thi', 'Chọn thí sinh để chuyển sang xác nhận'),
      _Tab.confirmed1 => ('⚠️', 'Thí sinh đã chọn - Câu $q', 'Chọn để thu hồi hoặc loại thí sinh'),
      _ => ('❌', 'Thí sinh bị loại - Câu $q', 'Danh sách thí sinh đã bị loại'),
    };
    final cols = min(_contestants.isNotEmpty ? max(1, _contestants.first.columns) : 10, 12);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Tw.blue50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Tw.blue200),
          ),
          child: Column(
            children: [
              Text('$emoji $title', textAlign: TextAlign.center, style: Tw.lg(c: Tw.blue900, w: Tw.bold)),
              const SizedBox(height: 4),
              Text(subtitle, textAlign: TextAlign.center, style: Tw.xs(c: Tw.blue700, w: Tw.medium)),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _grid(cols),
        if (_tab == _Tab.confirmed2) ...[
          const SizedBox(height: 16),
          Center(
            child: _actionButton(
              '⚠️ Xác nhận danh sách',
              enabled: !_disabled,
              fg: Tw.red700,
              border: Tw.red300,
              onTap: _chot,
            ),
          ),
          const SizedBox(height: 24),
        ] else ...[
          const SizedBox(height: 24),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 12,
            runSpacing: 12,
            children: [
              _actionButton('🟢 Chọn hết', fg: Tw.green700, border: Tw.green300, onTap: () {
                final ids = _contestants.where((c) => c.status == _tab.status).map((c) => c.registrationNumber);
                final merged = {..._selected, ...ids};
                setState(() => _selected
                  ..clear()
                  ..addAll(merged));
              }),
              _actionButton('⚪ Bỏ chọn', fg: Tw.blue700, border: Tw.blue300, onTap: () {
                final ids = _contestants.where((c) => c.status == _tab.status).map((c) => c.registrationNumber).toSet();
                setState(() => _selected.removeWhere(ids.contains));
              }),
              if (_tab == _Tab.inProgress)
                _actionButton(
                  '⚠️ Xác nhận 1',
                  enabled: !_disabled,
                  fg: Tw.red700,
                  border: Tw.red300,
                  onTap: () => _emitStatus(
                    from: 'in_progress',
                    to: 'confirmed1',
                    warn: 'Vui lòng chọn ít nhất một thí sinh đang thi',
                    ok: 'Xác nhận 1 thành công!',
                    fail: 'Xác nhận 1 thất bại!',
                    next: _Tab.confirmed1,
                  ),
                ),
              if (_tab == _Tab.confirmed1) ...[
                _actionButton(
                  '↩️ Thu hồi',
                  fg: Tw.yellow700,
                  border: Tw.yellow300,
                  onTap: () => _emitStatus(
                    from: 'confirmed1',
                    to: 'in_progress',
                    warn: 'Vui lòng chọn ít nhất một thí sinh ở Xác nhận 1!',
                    ok: 'Hủy xác nhận 1 thành công!',
                    fail: 'Hủy xác nhận 1 thất bại!',
                    next: _Tab.inProgress,
                  ),
                ),
                _actionButton(
                  '❌ Xác nhận 2',
                  enabled: !_disabled,
                  fg: Tw.red700,
                  border: Tw.red300,
                  onTap: () => _emitStatus(
                    from: 'confirmed1',
                    to: 'confirmed2',
                    warn: 'Vui lòng chọn ít nhất một thí sinh ở Xác nhận 1',
                    ok: 'Xác nhận 2 thành công!',
                    fail: 'Xác nhận 2 thất bại!',
                    next: _Tab.confirmed2,
                  ),
                ),
              ],
            ],
          ),
        ],
      ],
    );
  }

  Widget _grid(int cols) {
    const gap = 12.0;
    final (selBg, selFg, selBorder, bg, fg, border) = switch (_tab) {
      _Tab.inProgress => (Tw.blue700, Colors.white, Tw.blue800, Colors.white, Tw.blue700, Tw.blue300),
      _Tab.confirmed1 => (Tw.yellow500, Colors.white, Tw.yellow600, Tw.yellow100, Tw.yellow800, Tw.yellow300),
      _ => (Tw.red600, Colors.white, Tw.red700, Tw.red100, Tw.red800, Tw.red300),
    };
    return LayoutBuilder(builder: (context, c) {
      final cell = (c.maxWidth - gap * (cols - 1)) / cols;
      return Wrap(
        spacing: gap,
        runSpacing: gap,
        children: [
          for (final ct in _contestants)
            SizedBox(
              width: cell,
              height: 40,
              child: Visibility(
                visible: ct.status == _tab.status,
                maintainSize: true,
                maintainAnimation: true,
                maintainState: true,
                child: _numberButton(ct.registrationNumber, selBg, selFg, selBorder, bg, fg, border),
              ),
            ),
        ],
      );
    });
  }

  Widget _numberButton(int number, Color selBg, Color selFg, Color selBorder, Color bg, Color fg, Color border) {
    final selected = _selected.contains(number);
    return GestureDetector(
      onTap: () => setState(() => selected ? _selected.remove(number) : _selected.add(number)),
      child: AnimatedScale(
        duration: const Duration(milliseconds: 300),
        scale: selected ? 1.05 : 1,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned.fill(
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: selected ? selBg : bg,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: selected ? selBorder : border, width: 2),
                  boxShadow: selected ? Tw.shadowLg : Tw.shadowMd,
                ),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    child: Text('$number', style: Tw.sm(c: selected ? selFg : fg, w: Tw.semibold)),
                  ),
                ),
              ),
            ),
            if (selected)
              Positioned(
                top: -4,
                right: -4,
                child: Container(
                  width: 16,
                  height: 16,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(color: Tw.green500, shape: BoxShape.circle),
                  child: Text('✓', style: Tw.xs(c: Colors.white).copyWith(fontSize: 10, height: 1)),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _actionButton(String label, {required Color fg, required Color border, required VoidCallback onTap, bool enabled = true}) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Container(
        constraints: const BoxConstraints(minWidth: 80),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: enabled ? Colors.white : Tw.gray200,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: enabled ? border : Tw.gray300, width: 2),
          boxShadow: Tw.shadowLg,
        ),
        child: Text(label, textAlign: TextAlign.center, style: Tw.xs(c: enabled ? fg : Tw.gray500, w: Tw.semibold).copyWith(fontSize: 11)),
      ),
    );
  }

  Widget _logoutSection() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Tw.red50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Tw.red200, width: 2),
      ),
      child: Column(
        children: [
          TwPulse(
            child: Container(
              width: 64,
              height: 64,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Tw.red500, Tw.red700]),
                boxShadow: Tw.shadowLg,
              ),
              child: Text('🚪', style: Tw.xl2()),
            ),
          ),
          const SizedBox(height: 16),
          Text('Đăng xuất trọng tài', style: Tw.lg(c: Tw.red800, w: Tw.bold)),
          Text('Bạn có chắc chắn muốn đăng xuất khỏi hệ thống?',
              textAlign: TextAlign.center, style: Tw.xs(c: Tw.red700, w: Tw.medium)),
          const SizedBox(height: 24),
          GestureDetector(
            onTap: () => AppRoutes.logout(context),
            child: Container(
              constraints: const BoxConstraints(minWidth: 120),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Tw.red300, width: 2),
                boxShadow: Tw.shadowLg,
              ),
              child: Text('🚪 Đăng xuất', textAlign: TextAlign.center, style: Tw.xs(c: Tw.red700, w: Tw.bold).copyWith(fontSize: 11)),
            ),
          ),
        ],
      ),
    );
  }
}

/// `components/home/AnimatedBackground.tsx`.
class _AnimatedBackground extends StatelessWidget {
  const _AnimatedBackground();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, c) {
      final w = c.maxWidth;
      final h = c.maxHeight;
      Widget circle(double size, Color color) => TwPulse(
            child: Container(width: size, height: size, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
          );
      return Stack(
        children: [
          const Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Tw.blue50, Colors.white, Tw.blue100],
                ),
              ),
            ),
          ),
          Positioned(top: h / 4, left: w / 6, child: circle(256, Tw.blue400.withValues(alpha: 0.10))),
          Positioned(bottom: h / 3, right: w / 6, child: circle(320, Tw.blue600.withValues(alpha: 0.08))),
          Positioned(top: h * 2 / 3, left: w / 3, child: circle(192, Tw.blue300.withValues(alpha: 0.12))),
          Positioned(
            top: -80,
            right: -80,
            child: Container(
              width: 384,
              height: 384,
              decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Tw.blue200.withValues(alpha: 0.2))),
            ),
          ),
          Positioned(
            bottom: -80,
            left: -80,
            child: Container(
              width: 320,
              height: 320,
              decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Tw.blue300.withValues(alpha: 0.25))),
            ),
          ),
        ],
      );
    });
  }
}
