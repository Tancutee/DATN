import 'dart:math';

import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';

import '../../../core/config/app_config.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/theme/tw.dart';
import '../../../core/widgets/notify.dart';
import '../../../core/widgets/tw_widgets.dart';
import '../../student/student_models.dart';
import '../../student/widgets/exam_widgets.dart';
import '../rescue_service.dart';

/// Trợ giúp của khán giả — `features/audience/pages/AudienceOpinionPage.tsx`.
class AudienceOpinionScreen extends StatefulWidget {
  const AudienceOpinionScreen({super.key, required this.matchSlug, required this.rescueId});

  final String matchSlug;
  final int rescueId;

  @override
  State<AudienceOpinionScreen> createState() => _AudienceOpinionScreenState();
}

class _AudienceOpinionScreenState extends State<AudienceOpinionScreen> {
  final _service = RescueService();
  RescueQuestion? _question;
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
      final q = await _service.question(widget.matchSlug, widget.rescueId);
      if (mounted) setState(() => _question = q);
    } catch (e) {
      if (mounted) setState(() => _error = ApiException.messageOf(e));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Scaffold(backgroundColor: Colors.white, body: Center(child: Text('Đang tải...', style: Tw.base(c: Tw.gray500))));
    }
    if (_error != null) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              alignment: WrapAlignment.center,
              children: [
                GestureDetector(onTap: _load, child: Text('Thử lại', style: Tw.base())),
                Text('Lỗi khi tải câu hỏi: $_error', textAlign: TextAlign.center, style: Tw.base(c: Tw.red500)),
              ],
            ),
          ),
        ),
      );
    }
    final q = _question!;
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Tw.blue50, Tw.indigo50, Tw.purple50],
          ),
        ),
        child: Column(
          children: [
            Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: Tw.shadowSm,
                border: Border(bottom: BorderSide(color: Tw.gray200)),
              ),
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(color: Tw.blue100, borderRadius: BorderRadius.circular(999)),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const HeroIcon(HeroIcons.userGroup, size: 20, color: Tw.blue600),
                            const SizedBox(width: 8),
                            Text('Trợ giúp khán giả', style: Tw.sm(c: Tw.blue800, w: Tw.medium)),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text('ID: ${q.id}', style: Tw.sm(c: Tw.gray500)),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 32, 16, 32),
                children: [
                  Container(
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Tw.gray100),
                      boxShadow: Tw.shadowXl,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: const BoxDecoration(gradient: LinearGradient(colors: [Tw.blue600, Tw.indigo600])),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              HtmlContent(q.content, style: Tw.xl2(c: Colors.white, w: Tw.bold).copyWith(height: 1.25)),
                              const SizedBox(height: 32),
                              Wrap(
                                spacing: 12,
                                runSpacing: 12,
                                children: [
                                  if (q.topic != null) _headerPill(HeroIcons.academicCap, q.topic!),
                                  _headerPill(HeroIcons.trophy, 'Trợ giúp khán giả'),
                                ],
                              ),
                            ],
                          ),
                        ),
                        if (q.media.isNotEmpty) _mediaGrid(q.media),
                        Padding(
                          padding: const EdgeInsets.all(24),
                          child: q.isMultipleChoice
                              ? _MultipleChoiceInput(options: q.options, rescueId: widget.rescueId, service: _service)
                              : _OpenEndedInput(correctAnswer: q.correctAnswer, rescueId: widget.rescueId, service: _service),
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

  Widget _headerPill(HeroIcons icon, String label) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(999)),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            HeroIcon(icon, size: 16, color: Colors.white),
            const SizedBox(width: 8),
            Text(label, style: Tw.sm(c: Colors.white, w: Tw.medium)),
          ],
        ),
      );

  Widget _mediaGrid(List<MediaItem> media) {
    final cols = media.length == 1 ? 1 : 2;
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
      child: LayoutBuilder(builder: (context, c) {
        final cell = (c.maxWidth - 16 * (cols - 1)) / cols;
        return Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            for (var i = 0; i < media.length; i++)
              SizedBox(width: media[i].type == 'audio' ? c.maxWidth : cell, child: _mediaItem(context, media, i)),
          ],
        );
      }),
    );
  }

  Widget _mediaItem(BuildContext context, List<MediaItem> media, int index) {
    final m = media[index];
    final icon = switch (m.type) {
      'video' => HeroIcons.videoCamera,
      'audio' => HeroIcons.speakerWave,
      _ => HeroIcons.photo,
    };
    Widget content;
    if (m.type == 'audio') {
      content = Container(
        height: 256,
        decoration: const BoxDecoration(
          gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Tw.blue50, Tw.indigo50]),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const HeroIcon(HeroIcons.speakerWave, size: 64, color: Tw.blue400),
            const SizedBox(height: 16),
            Text('Tập tin âm thanh', style: Tw.base(c: Tw.gray600)),
            const SizedBox(height: 16),
            TextButton.icon(
              onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => MediaModal(media: m))),
              icon: const Icon(Icons.play_arrow),
              label: const Text('Phát'),
            ),
          ],
        ),
      );
    } else if (m.type == 'video') {
      content = GestureDetector(
        onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => MediaModal(media: m))),
        child: Container(
          height: 256,
          color: Colors.black,
          child: const Center(child: Icon(Icons.play_circle_fill, size: 56, color: Colors.white)),
        ),
      );
    } else {
      content = GestureDetector(
        onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => MediaModal(media: m))),
        child: SizedBox(
          height: 256,
          child: Image.network(AppConfig.mediaUrl(m.url), fit: BoxFit.contain, errorBuilder: (_, _, _) => const SizedBox()),
        ),
      );
    }
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Tw.gray50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Tw.gray200),
      ),
      child: Stack(
        children: [
          content,
          Positioned(top: 12, right: 12, child: _pill(HeroIcon(icon, size: 16, color: Tw.gray600))),
          if (media.length > 1)
            Positioned(top: 12, left: 12, child: _pill(Text('${index + 1}/${media.length}', style: Tw.xs(c: Tw.gray700, w: Tw.medium)))),
        ],
      ),
    );
  }

  Widget _pill(Widget child) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.9), borderRadius: BorderRadius.circular(999)),
        child: child,
      );
}

/// Nút "Cứu trợ" dùng chung.
Widget _rescueButton({required bool enabled, required bool submitted, required VoidCallback onTap, required List<Color> activeGradient}) {
  final gradient = enabled
      ? activeGradient
      : submitted
          ? const [Tw.gray400, Tw.gray500]
          : const [Tw.gray300, Tw.gray400];
  return GestureDetector(
    onTap: enabled ? onTap : null,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: gradient),
        borderRadius: BorderRadius.circular(12),
        boxShadow: enabled ? Tw.shadowLg : null,
      ),
      child: Text('Cứu trợ', style: Tw.lg(c: enabled || submitted ? Colors.white : Tw.gray500, w: Tw.semibold)),
    ),
  );
}

/// `components/MultipleChoiceInput.tsx` — gửi chữ cái A/B/C/D.
class _MultipleChoiceInput extends StatefulWidget {
  const _MultipleChoiceInput({required this.options, required this.rescueId, required this.service});

  final List<String> options;
  final int rescueId;
  final RescueService service;

  @override
  State<_MultipleChoiceInput> createState() => _MultipleChoiceInputState();
}

class _MultipleChoiceInputState extends State<_MultipleChoiceInput> {
  String? _selected;
  bool _submitted = false;

  String _letter(int i) => String.fromCharCode(65 + i);

  Future<void> _submit() async {
    final sel = _selected;
    if (sel == null) return;
    setState(() => _submitted = true);
    try {
      await widget.service.submit(widget.rescueId, sel);
      AppNotify.toast('Cứu trợ thành công', ToastType.success);
      if (mounted) setState(() => _selected = null);
    } catch (e) {
      AppNotify.toast(e is ApiException && e.statusCode != null ? e.message : 'Lỗi khi gửi cứu trợ', ToastType.error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Tw.slate50, Tw.blue50]),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Tw.gray100),
        boxShadow: Tw.shadowXl,
      ),
      child: Column(
        children: [
          for (var i = 0; i < widget.options.length; i++) ...[
            if (i > 0) const SizedBox(height: 16),
            _option(i),
          ],
          const SizedBox(height: 32),
          _rescueButton(
            enabled: _selected != null && !_submitted,
            submitted: false,
            onTap: _submit,
            activeGradient: const [Tw.blue600, Tw.indigo600],
          ),
        ],
      ),
    );
  }

  Widget _option(int i) {
    final letter = _letter(i);
    final selected = _selected == letter;
    return GestureDetector(
      onTap: _submitted ? null : () => setState(() => _selected = letter),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: selected ? null : Colors.white,
          gradient: selected ? const LinearGradient(colors: [Tw.blue50, Tw.indigo50]) : null,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: selected ? Tw.blue500 : Tw.gray200, width: 2),
          boxShadow: selected ? [...Tw.shadowMd, const BoxShadow(color: Tw.blue200, spreadRadius: 2)] : null,
        ),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              alignment: Alignment.center,
              decoration: BoxDecoration(color: selected ? Tw.blue500 : Tw.gray200, shape: BoxShape.circle),
              child: Text(letter, style: Tw.sm(c: selected ? Colors.white : Tw.gray600, w: Tw.bold)),
            ),
            const SizedBox(width: 16),
            Expanded(child: Text(widget.options[i], style: Tw.base(c: selected ? Tw.blue700 : Tw.gray700, w: Tw.medium))),
          ],
        ),
      ),
    );
  }
}

/// `components/OpenEndedInput.tsx` — ghép các chữ cái của đáp án.
class _OpenEndedInput extends StatefulWidget {
  const _OpenEndedInput({required this.correctAnswer, required this.rescueId, required this.service});

  final String correctAnswer;
  final int rescueId;
  final RescueService service;

  @override
  State<_OpenEndedInput> createState() => _OpenEndedInputState();
}

class _OpenEndedInputState extends State<_OpenEndedInput> {
  late List<String?> _slots;
  late List<String> _available;
  bool _submitted = false;

  @override
  void initState() {
    super.initState();
    final chars = widget.correctAnswer.split('');
    _available = chars.where((c) => c != ' ').toList()..shuffle(Random());
    _slots = chars.map((c) => c == ' ' ? ' ' : null).toList();
  }

  int get _filled => _slots.where((s) => s != null && s != ' ').length;
  int get _total => widget.correctAnswer.replaceAll(' ', '').length;
  bool get _complete => _slots.every((s) => s == ' ' || s != null);

  void _add(int index) {
    if (_submitted) return;
    final i = _slots.indexWhere((s) => s == null);
    if (i < 0) return;
    setState(() {
      _slots[i] = _available.removeAt(index);
    });
  }

  void _remove(int index) {
    final s = _slots[index];
    if (s == null || s == ' ') return;
    setState(() {
      _slots[index] = null;
      _available.add(s);
    });
  }

  void _clearAll() {
    setState(() {
      _available.addAll(_slots.where((s) => s != null && s != ' ').cast<String>());
      _slots = _slots.map((s) => s == ' ' ? ' ' : null).toList();
    });
  }

  Future<void> _submit() async {
    setState(() => _submitted = true);
    try {
      await widget.service.submit(widget.rescueId, _slots.join());
      AppNotify.toast('Cứu trợ thành công', ToastType.success);
    } catch (e) {
      AppNotify.toast(e is ApiException && e.statusCode != null ? e.message : 'Lỗi khi gửi cứu trợ', ToastType.error);
    }
  }

  @override
  Widget build(BuildContext context) {
    final canClear = !_submitted && _slots.any((s) => s != null && s != ' ');
    final words = widget.correctAnswer.split(' ');
    var cursor = 0;
    final wordWidgets = <Widget>[];
    for (var w = 0; w < words.length; w++) {
      final start = cursor;
      cursor += words[w].length + 1;
      wordWidgets.add(Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var k = 0; k < words[w].length; k++) ...[
            if (k > 0) const SizedBox(width: 8),
            _slot(start + k),
          ],
          if (w < words.length - 1) ...[
            const SizedBox(width: 8),
            SizedBox(width: 16, child: Center(child: Text('_', style: Tw.sm(c: Tw.gray400)))),
          ],
        ],
      ));
    }

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Tw.purple50, Tw.indigo50]),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Tw.gray100),
        boxShadow: Tw.shadowXl,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Đáp án của bạn:', style: Tw.sm(c: Tw.gray600, w: Tw.medium)),
              const SizedBox(width: 16),
              Opacity(
                opacity: canClear ? 1 : 0.5,
                child: GestureDetector(
                  onTap: canClear ? _clearAll : null,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(color: Tw.gray100, borderRadius: BorderRadius.circular(999)),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const HeroIcon(HeroIcons.backspace, size: 12, color: Tw.gray800),
                        const SizedBox(width: 4),
                        Text('Xóa tất cả', style: Tw.xs(c: Tw.gray800)),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(alignment: WrapAlignment.center, crossAxisAlignment: WrapCrossAlignment.center, spacing: 16, runSpacing: 16, children: wordWidgets),
          const SizedBox(height: 32),
          Text('Chữ cái khả dụng:', style: Tw.sm(c: Tw.gray600, w: Tw.medium)),
          const SizedBox(height: 16),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 8,
            runSpacing: 8,
            children: [
              for (var i = 0; i < _available.length; i++)
                GestureDetector(
                  onTap: _submitted ? null : () => _add(i),
                  child: Container(
                    width: 48,
                    height: 48,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: _submitted ? Tw.gray100 : null,
                      gradient: _submitted
                          ? null
                          : const LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Tw.gray100, Tw.gray200]),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: _submitted ? Tw.gray200 : Tw.gray300, width: 2),
                    ),
                    child: Text(_available[i], style: Tw.lg(c: _submitted ? Tw.gray400 : Tw.gray700, w: Tw.bold)),
                  ),
                ),
            ],
          ),
          if (_available.isEmpty && !_submitted) ...[
            const SizedBox(height: 16),
            Text('🎉 Tất cả chữ cái đã được sử dụng!', style: Tw.sm(c: Tw.gray500)),
          ],
          const SizedBox(height: 32),
          _rescueButton(
            enabled: _complete && !_submitted,
            submitted: _submitted,
            onTap: _submit,
            activeGradient: const [Tw.purple600, Tw.indigo600],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Text('Tiến độ:', style: Tw.sm(c: Tw.gray600)),
              const Spacer(),
              Text('$_filled/$_total', style: Tw.sm(c: Tw.gray700, w: Tw.medium)),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: Container(
              height: 8,
              color: Tw.gray200,
              alignment: Alignment.centerLeft,
              child: FractionallySizedBox(
                widthFactor: _total == 0 ? 0 : _filled / _total,
                child: const DecoratedBox(decoration: BoxDecoration(gradient: LinearGradient(colors: [Tw.purple500, Tw.indigo500]))),
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _slot(int index) {
    final letter = _slots[index];
    final filled = letter != null && letter != ' ';
    var number = 0;
    for (var i = 0; i <= index; i++) {
      if (_slots[i] != ' ') number++;
    }
    return GestureDetector(
      onTap: _submitted ? null : () => _remove(index),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          filled
              ? Container(
                  width: 48,
                  height: 48,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Tw.purple100, Tw.indigo100]),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Tw.purple400, width: 2),
                    boxShadow: Tw.shadowMd,
                  ),
                  child: Text(letter, style: Tw.lg(c: Tw.purple700, w: Tw.bold)),
                )
              : CustomPaint(
                  painter: DashedBorderPainter(color: Tw.gray300),
                  child: Container(
                    width: 48,
                    height: 48,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                    child: Container(width: 24, height: 2, decoration: BoxDecoration(color: Tw.gray400, borderRadius: BorderRadius.circular(999))),
                  ),
                ),
          Positioned(
            top: -8,
            right: -8,
            child: Container(
              width: 20,
              height: 20,
              alignment: Alignment.center,
              decoration: const BoxDecoration(color: Tw.gray500, shape: BoxShape.circle),
              child: Text('$number', style: Tw.xs(c: Colors.white).copyWith(height: 1)),
            ),
          ),
        ],
      ),
    );
  }
}
