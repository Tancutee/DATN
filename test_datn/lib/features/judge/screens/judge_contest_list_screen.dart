import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import '../../../core/widgets/brand.dart';
import '../../../core/widgets/mui.dart';
import 'package:flutter/services.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/theme/tw.dart';
import '../judge_service.dart';
import 'judge_home_screen.dart';

const _mono = 'monospace';

/// Danh sách cuộc thi của trọng tài — `features/judge/components/selector/ContestList.tsx`.
class JudgeContestListScreen extends StatefulWidget {
  const JudgeContestListScreen({super.key});

  @override
  State<JudgeContestListScreen> createState() => _JudgeContestListScreenState();
}

class _JudgeContestListScreenState extends State<JudgeContestListScreen> {
  final _service = JudgeService();
  List<JudgeContest> _contests = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final list = await _service.contests();
      if (mounted) setState(() => _contests = list);
    } on ApiException catch (e) {
      if (mounted) {
        setState(
          () => _error = e.statusCode == 401
              ? 'Phiên đăng nhập đã hết hạn. Vui lòng đăng nhập lại.'
              : 'Không thể tải danh sách cuộc thi.',
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Mui.background,
      body: RefreshIndicator(
        onRefresh: _load,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const JudgePageHeader(
              icon: HeroIcons.trophy,
              title: 'Danh sách cuộc thi',
              subtitle: 'Chọn cuộc thi để xem danh sách trận đấu',
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (_loading) const JudgeLoading('Đang tải danh sách cuộc thi...'),
                  if (_error != null) JudgeErrorBox(_error!),
                  if (!_loading && _error == null && _contests.isNotEmpty)
                    for (final c in _contests) ...[_ContestCard(contest: c), const SizedBox(height: 16)],
                  if (!_loading && _error == null && _contests.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 64, horizontal: 16),
                      child: Column(
                        children: [
                          Text('📋', style: Tw.xl4()),
                          const SizedBox(height: 16),
                          Text(
                            'Chưa có cuộc thi nào',
                            style: Tw.lg(c: Tw.slate800, w: Tw.semibold),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Hiện tại chưa có cuộc thi nào được tạo.',
                            textAlign: TextAlign.center,
                            style: Tw.sm(c: Tw.slate600).copyWith(height: 1.625),
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
    );
  }
}

/// Header navy dùng chung cho các trang danh sách của giám khảo.
class JudgePageHeader extends StatelessWidget {
  const JudgePageHeader({super.key, required this.icon, required this.title, this.subtitle, this.trailing});

  final HeroIcons icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final canPop = Navigator.of(context).canPop();
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
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (canPop) ...[
                  GlassIconButton(
                    icon: Icons.arrow_back_rounded,
                    size: 40,
                    onTap: () => Navigator.of(context).maybePop(),
                  ),
                  const SizedBox(height: 16),
                ] else
                  const SizedBox(height: 12),
                Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.14),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Center(child: HeroIcon(icon, size: 24, color: Colors.white)),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: Tw.xl2(c: Colors.white, w: FontWeight.w800),
                          ),
                          if (subtitle != null) Text(subtitle!, style: Tw.sm(c: Colors.white.withValues(alpha: 0.75))),
                        ],
                      ),
                    ),
                  ],
                ),
                if (trailing != null) ...[const SizedBox(height: 14), trailing!],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ContestCard extends StatelessWidget {
  const _ContestCard({required this.contest});

  final JudgeContest contest;

  @override
  Widget build(BuildContext context) {
    return PressScale(
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () =>
              Navigator.of(context).push(MaterialPageRoute(builder: (_) => JudgeMatchListScreen(contest: contest))),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Tw.gray200),
            ),
            child: Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    gradient: Mui.buttonGradient,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: Tw.glow(Mui.accent),
                  ),
                  child: const Center(child: HeroIcon(HeroIcons.trophy, size: 24, color: Colors.white)),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        contest.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Tw.base(c: Tw.gray900, w: Tw.bold).copyWith(height: 1.3),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        contest.slug,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Tw.xs(c: Tw.gray400).copyWith(fontFamily: _mono),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.chevron_right_rounded, color: Tw.gray400),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Danh sách trận đấu — `features/judge/components/selector/MatchList.tsx`.
class JudgeMatchListScreen extends StatefulWidget {
  const JudgeMatchListScreen({super.key, required this.contest});

  final JudgeContest contest;

  @override
  State<JudgeMatchListScreen> createState() => _JudgeMatchListScreenState();
}

class _JudgeMatchListScreenState extends State<JudgeMatchListScreen> {
  final _service = JudgeService();
  List<JudgeMatch> _matches = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final list = await _service.matches(widget.contest.id);
      if (mounted) setState(() => _matches = list);
    } on ApiException catch (e) {
      if (mounted) {
        setState(
          () => _error = e.statusCode == 401
              ? 'Phiên đăng nhập đã hết hạn. Vui lòng đăng nhập lại.'
              : 'Không thể tải danh sách trận đấu.',
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Mui.background,
      body: Column(
        children: [
          JudgePageHeader(
            icon: HeroIcons.squares2x2,
            title: 'Danh sách trận đấu',
            subtitle: widget.contest.name,
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.14),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                'Cuộc thi ID: ${widget.contest.id}',
                style: Tw.xs(c: Colors.white, w: Tw.semibold),
              ),
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _load,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  if (_loading) const JudgeLoading('Đang tải danh sách trận đấu...'),
                  if (_error != null) JudgeErrorBox(_error!),
                  if (!_loading && _error == null && _matches.isNotEmpty) ...[
                    Text(
                      '${_matches.length} trận đấu',
                      style: Tw.lg(c: Tw.slate800, w: Tw.semibold),
                    ),
                    const SizedBox(height: 24),
                    for (var i = 0; i < _matches.length; i++) ...[
                      _SlideUp(
                        delay: Duration(milliseconds: 100 * i),
                        child: _MatchCard(match: _matches[i], index: i),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ],
                  if (!_loading && _error == null && _matches.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 64, horizontal: 16),
                      child: Column(
                        children: [
                          Opacity(opacity: 0.7, child: Text('🏟️', style: Tw.xl5())),
                          const SizedBox(height: 20),
                          Text(
                            'Chưa có trận đấu nào',
                            style: Tw.xl(c: Tw.slate800, w: Tw.semibold),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Cuộc thi này chưa có trận đấu nào được tạo.',
                            textAlign: TextAlign.center,
                            style: Tw.sm(c: Tw.slate600).copyWith(height: 1.625),
                          ),
                          const SizedBox(height: 24),
                          _BlueButton(label: 'Chọn cuộc thi khác', onTap: () => Navigator.of(context).maybePop()),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MatchCard extends StatelessWidget {
  const _MatchCard({required this.match, required this.index});

  final JudgeMatch match;
  final int index;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: match.slug.isEmpty
          ? null
          : () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => JudgeHomeScreen(matchSlug: match.slug))),
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Tw.slate200),
          boxShadow: Tw.shadowSm,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
                color: Tw.slate50,
                border: Border(bottom: BorderSide(color: Tw.slate100)),
              ),
              child: Row(
                children: [
                  Container(
                    constraints: const BoxConstraints(minWidth: 32),
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(gradient: Mui.buttonGradient, borderRadius: BorderRadius.circular(8)),
                    child: Text(
                      '#${index + 1}',
                      textAlign: TextAlign.center,
                      style: Tw.xs(c: Colors.white, w: Tw.bold),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    'ID: ${match.id}',
                    style: Tw.xs(c: Tw.slate500, w: Tw.medium).copyWith(fontFamily: _mono),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    match.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Tw.sm(c: Tw.slate800, w: Tw.semibold).copyWith(height: 1.25),
                  ),
                  const SizedBox(height: 8),
                  Opacity(
                    opacity: 0.8,
                    child: Text(
                      'Slug: ${match.slug}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Tw.xs(c: Tw.slate500).copyWith(fontFamily: _mono),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
                color: Tw.slate50,
                border: Border(top: BorderSide(color: Tw.slate200)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(color: Tw.green500, shape: BoxShape.circle),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Sẵn sàng',
                    style: Tw.xs(c: Tw.green600, w: Tw.medium),
                  ),
                  const Spacer(),
                  Opacity(
                    opacity: 0.8,
                    child: Text(
                      'Click để xem chi tiết →',
                      style: Tw.xs(c: Tw.blue600, w: Tw.medium),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BlueButton extends StatelessWidget {
  const _BlueButton({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return MuiButton(label: label, onPressed: onTap);
  }
}

class _SlideUp extends StatefulWidget {
  const _SlideUp({required this.child, required this.delay});

  final Widget child;
  final Duration delay;

  @override
  State<_SlideUp> createState() => _SlideUpState();
}

class _SlideUpState extends State<_SlideUp> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));

  @override
  void initState() {
    super.initState();
    Future.delayed(widget.delay, () {
      if (mounted) _c.forward();
    });
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final curved = CurvedAnimation(parent: _c, curve: Curves.ease);
    return AnimatedBuilder(
      animation: curved,
      builder: (_, child) => Opacity(
        opacity: curved.value,
        child: Transform.translate(offset: Offset(0, 20 * (1 - curved.value)), child: child),
      ),
      child: widget.child,
    );
  }
}

/// Spinner `w-10 h-10 border-4 border-slate-200 border-t-blue-600`.
class JudgeLoading extends StatelessWidget {
  const JudgeLoading(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 64),
      child: Column(
        children: [
          const TwSpinner(size: 40, width: 4, color: Tw.blue600, track: Tw.slate200),
          const SizedBox(height: 16),
          Text(text, style: Tw.base(c: Tw.slate600)),
        ],
      ),
    );
  }
}

class JudgeErrorBox extends StatelessWidget {
  const JudgeErrorBox(this.message, {super.key});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Tw.red50,
        border: Border.all(color: Tw.red200),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Text('⚠️', style: Tw.xl2()),
          const SizedBox(width: 12),
          Expanded(
            child: Text(message, style: Tw.sm(c: Tw.red600).copyWith(height: 1.625)),
          ),
        ],
      ),
    );
  }
}
