import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:heroicons/heroicons.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';

import '../../../core/config/app_config.dart';
import '../../../core/theme/tw.dart';
import '../../../core/widgets/mui.dart';
import '../exam_controller.dart';
import '../student_models.dart';

/// Nội dung HTML (TinyMCE) — `dangerouslySetInnerHTML`.
class HtmlContent extends StatelessWidget {
  const HtmlContent(this.html, {super.key, required this.style});

  final String html;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    return Html(
      data: html,
      style: {
        'body': Style.fromTextStyle(style).copyWith(margin: Margins.zero, padding: HtmlPaddings.zero),
        'p': Style(margin: Margins.zero),
        'img': Style(width: Width(100, Unit.percent)),
      },
      onLinkTap: (url, _, _) {
        if (url != null) launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
      },
    );
  }
}

// -----------------------------------------------------------------------------
// AntiCheatStatus
// -----------------------------------------------------------------------------

class AntiCheatStatusCard extends StatelessWidget {
  const AntiCheatStatusCard({super.key, required this.isMonitoring, required this.warningCount});

  final bool isMonitoring;
  final int warningCount;

  @override
  Widget build(BuildContext context) {
    return MuiCard(
      leftBorder: Tw.orange500,
      gradient: const LinearGradient(colors: [Tw.orange50, Tw.red50]),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      child: Row(
        children: [
          Text('🛡️ chống gian lận', style: Mui.subtitle1.copyWith(color: Tw.orange800)),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: isMonitoring ? Tw.green100 : Tw.red100,
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(isMonitoring ? '🟢' : '🔴 ', style: Tw.xs(c: isMonitoring ? Tw.green600 : Tw.red600, w: Tw.medium)),
          ),
          const Spacer(),
          if (warningCount > 0)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(color: Tw.red100, borderRadius: BorderRadius.circular(999)),
              child: Text('⚠️ Vi phạm: $warningCount/${ExamController.maxViolations}',
                  style: Tw.xs(c: Tw.red600, w: Tw.medium)),
            ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// QuestionHeader
// -----------------------------------------------------------------------------

class QuestionHeaderCard extends StatelessWidget {
  const QuestionHeaderCard({super.key, required this.current, required this.remainingTime});

  final CurrentQuestion current;
  final int remainingTime;

  Color get _timerColor {
    if (remainingTime <= 10) return Mui.error;
    if (remainingTime <= 30) return Mui.warning;
    return Mui.primary;
  }

  Color? _difficultyColor(String d) => switch (d.toLowerCase()) {
        'alpha' => Mui.success,
        'beta' => Mui.warning,
        'gamma' => Mui.error,
        _ => null,
      };

  String _format(int s) => '${s ~/ 60}:${(s % 60).toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    final q = current.question;
    final chip = MuiChip(label: _format(remainingTime), color: _timerColor, icon: Icons.timer);
    return MuiCard(
      leftBorder: Tw.blue500,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(Icons.quiz, color: Tw.blue500),
              const SizedBox(width: 8),
              Expanded(child: Text('Câu hỏi số ${current.order}', style: Mui.h6.copyWith(color: Tw.gray800))),
              if (remainingTime <= 10) TwPulse(child: chip) else chip,
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              MuiChip(label: 'Độ khó: ${q.difficulty}', color: _difficultyColor(q.difficulty)),
              MuiChip(
                label: q.questionType == 'multiple_choice' ? 'Trắc nghiệm' : 'Đúng/Sai',
                variant: MuiChipVariant.outlined,
              ),
            ],
          ),
          const SizedBox(height: 12),
          MuiLinearProgress(
            value: q.defaultTime > 0 ? max(0, remainingTime / q.defaultTime) : 0,
            color: _timerColor,
            radius: 4,
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// QuestionContent
// -----------------------------------------------------------------------------

class QuestionContentCard extends StatelessWidget {
  const QuestionContentCard({super.key, required this.question, required this.child});

  final ExamQuestion question;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MuiCard(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (question.intro != null) ...[
            Text('📝 ${question.intro}', style: Mui.body2.copyWith(color: Tw.gray600, fontStyle: FontStyle.italic)),
            const SizedBox(height: 12),
          ],
          HtmlContent(question.content, style: Tw.lg(c: Tw.gray800, w: Tw.semibold)),
          const SizedBox(height: 16),
          const Divider(height: 1, thickness: 1, color: Mui.divider),
          if (question.media.isNotEmpty)
            Container(
              margin: const EdgeInsets.only(bottom: 24),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Tw.gray50,
                border: Border.all(color: Tw.gray200),
                borderRadius: BorderRadius.circular(8),
              ),
              child: MediaGridView(media: question.media),
            ),
          child,
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// QuestionOptions
// -----------------------------------------------------------------------------

class QuestionOptionsView extends StatelessWidget {
  const QuestionOptionsView({super.key, required this.c});

  final ExamController c;

  @override
  Widget build(BuildContext context) {
    final q = c.question!;
    final result = c.answerResult;
    final shouldShowOptions = !c.isBanned && (!c.isEliminated || (c.isEliminated && c.canShowResult && result != null));
    final disabled = c.interactionDisabled;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (shouldShowOptions)
          for (var i = 0; i < q.options.length; i++) ...[
            if (i > 0) const SizedBox(height: 12),
            _option(i, q.options[i], result, disabled),
          ],
        if (c.isBanned) ...[
          const SizedBox(height: 16),
          _bannedAlert(),
        ],
        if (c.isEliminated && !c.canShowResult && result == null) ...[
          const SizedBox(height: 16),
          _eliminatedAlert(),
        ],
        if (c.isInRescueMode) ...[
          const SizedBox(height: 16),
          MuiAlert(
            severity: MuiSeverity.info,
            border: Border.all(color: Tw.blue500, width: 2),
            title: '🎉 Đang trong chế độ cứu trợ',
            child: Text('Bạn đang được cứu trợ. Vui lòng chờ câu hỏi tiếp theo...', style: Mui.body2.copyWith(color: Tw.blue700)),
          ),
        ],
        if (!c.isSubmitted && !c.isEliminated && !c.isBanned && !c.isInRescueMode) ...[
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.centerRight,
            child: MuiButton(
              label: c.isApiSubmitting ? 'Đang xử lý...' : 'Xác nhận',
              icon: const Icon(Icons.send),
              large: true,
              onPressed: c.selectedAnswer.isEmpty || c.isApiSubmitting ? null : () => c.submit(),
            ),
          ),
        ],
      ],
    );
  }

  Widget _option(int index, String option, AnswerResult? result, bool disabled) {
    Color bg = Tw.gray50;
    Color border = Tw.gray200;
    Color? fg;
    List<BoxShadow>? shadow;
    double opacity = 1;
    Widget? resultIcon;

    if (c.isInRescueMode) {
      bg = Tw.gray100;
      border = Tw.gray300;
      fg = Tw.gray500;
      opacity = 0.6;
    } else if (!c.canShowResult) {
      if (c.selectedAnswer == option) {
        bg = Tw.blue100;
        border = Tw.blue500;
        fg = Tw.blue800;
        shadow = Tw.shadowMd;
      }
    } else {
      final isCorrect = result != null && option == result.correctAnswer;
      final isUser = option == c.selectedAnswer;
      if (isCorrect) {
        bg = Tw.green100;
        border = Tw.green500;
        fg = Tw.green800;
        shadow = Tw.shadowLg;
      } else if (isUser && !(result?.isCorrect ?? false)) {
        bg = Tw.red100;
        border = Tw.red500;
        fg = Tw.red800;
        shadow = Tw.shadowLg;
      } else {
        fg = Tw.gray500;
        opacity = 0.6;
      }
      if (result != null && isCorrect) {
        resultIcon = const _ResultTag('ĐÚNG', Icons.check_circle, Tw.green600);
      } else if (result != null && isUser && !result.isCorrect) {
        resultIcon = const _ResultTag('SAI', Icons.cancel, Tw.red600);
      }
    }

    final selected = c.selectedAnswer == option;
    return Opacity(
      opacity: opacity,
      child: GestureDetector(
        onTap: disabled ? null : () => c.selectAnswer(option),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: border, width: 2),
            boxShadow: shadow,
          ),
          child: Row(
            children: [
              Transform.translate(
                offset: const Offset(-11, 0),
                child: SizedBox(
                  width: 42,
                  height: 42,
                  child: Icon(
                    selected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                    color: disabled ? const Color(0x42000000) : (selected ? Mui.primary : const Color(0x99000000)),
                  ),
                ),
              ),
              Expanded(
                child: Transform.translate(
                  offset: const Offset(-11, 0),
                  child: Text('${String.fromCharCode(65 + index)}. $option',
                      style: Mui.body1.copyWith(color: disabled ? const Color(0x61000000) : (fg ?? Mui.textPrimary))),
                ),
              ),
              ?resultIcon,
            ],
          ),
        ),
      ),
    );
  }
}

Widget _bannedAlert() => MuiAlert(
      severity: MuiSeverity.error,
      icon: Icons.cancel,
      border: Border.all(color: Tw.red500, width: 2),
      title: 'Bị cấm tham gia',
      child: Text('Bạn đã bị cấm tham gia vì vi phạm quy chế!', style: Mui.h6.copyWith(color: Tw.red800)),
    );

Widget _eliminatedAlert() => MuiAlert(
      severity: MuiSeverity.warning,
      icon: Icons.cancel,
      border: Border.all(color: Tw.orange500, width: 2),
      title: 'Đã bị loại',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Bạn có thể được hồi sinh!', style: Mui.h6.copyWith(color: Tw.blue800)),
          const SizedBox(height: 12),
          Text('💡 Đừng rời đi nhé', style: Mui.body2.copyWith(color: Tw.blue800)),
        ],
      ),
    );

class _ResultTag extends StatelessWidget {
  const _ResultTag(this.label, this.icon, this.color);

  final String label;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    // Chip MUI giữ màu mặc định (class Tailwind bg-* bị style của MUI ghi đè).
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(width: 8),
        MuiChip(label: label),
      ],
    );
  }
}

// -----------------------------------------------------------------------------
// EssayInput
// -----------------------------------------------------------------------------

class EssayInputView extends StatefulWidget {
  const EssayInputView({super.key, required this.c});

  final ExamController c;

  @override
  State<EssayInputView> createState() => _EssayInputViewState();
}

class _EssayInputViewState extends State<EssayInputView> {
  late final TextEditingController _text = TextEditingController(text: widget.c.selectedAnswer);
  int? _order;

  @override
  void dispose() {
    _text.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.c;
    if (_order != c.current?.order) {
      _order = c.current?.order;
      _text.text = c.selectedAnswer;
    }
    final disabled = c.isSubmitted || c.isEliminated || c.isBanned || c.isApiSubmitting || c.isInRescueMode;
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (c.isBanned) ...[_bannedAlert(), const SizedBox(height: 16)],
          if (c.isEliminated && !c.canShowResult) ...[_eliminatedAlert(), const SizedBox(height: 16)],
          if (!c.isEliminated && !c.isBanned) ...[
            TextField(
              controller: _text,
              enabled: !disabled,
              minLines: 6,
              maxLines: 10,
              onChanged: c.selectAnswer,
              style: const TextStyle(fontSize: 16, fontFamily: 'Arial', color: Colors.black),
              decoration: InputDecoration(
                hintText: 'Nhập câu trả lời của bạn...',
                filled: true,
                fillColor: disabled ? const Color(0xFFF5F5F5) : Colors.white,
                contentPadding: const EdgeInsets.all(12),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFFBDBDBD), width: 1.5)),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFFBDBDBD), width: 1.5)),
                disabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFFBDBDBD), width: 1.5)),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFFBDBDBD), width: 1.5)),
              ),
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerRight,
              child: MuiButton(label: 'xác nhận', onPressed: disabled ? null : () => c.submit()),
            ),
          ],
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// QuestionResult
// -----------------------------------------------------------------------------

class QuestionResultView extends StatelessWidget {
  const QuestionResultView({super.key, required this.c});

  final ExamController c;

  @override
  Widget build(BuildContext context) {
    final r = c.canShowResult ? c.answerResult : null;
    final noAnswer = c.selectedAnswer.isEmpty || c.selectedAnswer == kNoAnswer;
    final children = <Widget>[];

    if (c.isSubmitted && c.pendingResult != null && c.answerResult == null && !c.canShowResult) {
      children.add(Padding(
        padding: const EdgeInsets.only(top: 12),
        child: MuiAlert(
          severity: MuiSeverity.info,
          border: Border.all(color: Tw.blue200, width: 2),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Đã gửi ${noAnswer ? 'yêu cầu bỏ qua câu hỏi' : 'đáp án'} thành công!',
                  style: Mui.body1.copyWith(color: Tw.blue800)),
              const SizedBox(height: 4),
              Text('Kết quả sẽ được hiển thị khi hết thời gian...', style: Mui.body2.copyWith(color: Tw.blue600)),
            ],
          ),
        ),
      ));
    }

    if (r != null) {
      final sev = r.isCorrect ? MuiSeverity.success : MuiSeverity.error;
      children.add(Padding(
        padding: const EdgeInsets.only(top: 24),
        child: MuiAlert(
          severity: sev,
          icon: r.isCorrect ? Icons.check_circle : Icons.cancel,
          border: Border.all(color: sev.standardText, width: 2),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                r.isCorrect ? '🎉 Chính xác!' : (noAnswer ? ' Bạn không chọn đáp án nào!' : ' Bạn đã bị loại khỏi trận đấu'),
                style: Mui.h6.copyWith(color: sev.standardText),
              ),
              const SizedBox(height: 8),
              Text.rich(TextSpan(
                style: Mui.body1,
                children: [
                  const TextSpan(text: 'Đáp án của bạn: ', style: TextStyle(color: Tw.gray700)),
                  TextSpan(
                    text: noAnswer ? '❌ Không chọn đáp án nào' : c.selectedAnswer,
                    style: TextStyle(color: r.isCorrect ? Tw.green700 : Tw.red700),
                  ),
                ],
              )),
              if (!r.isCorrect) ...[
                const SizedBox(height: 8),
                Text.rich(TextSpan(
                  style: Mui.body1,
                  children: [
                    const TextSpan(text: 'Đáp án đúng: ', style: TextStyle(color: Tw.gray700)),
                    TextSpan(text: r.correctAnswer, style: const TextStyle(color: Tw.green700, fontWeight: FontWeight.bold)),
                  ],
                )),
              ],
            ],
          ),
        ),
      ));
      if (r.explanation.isNotEmpty) {
        children.add(Container(
          margin: const EdgeInsets.only(top: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Tw.blue50,
            border: Border.all(color: Tw.blue200, width: 2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('💡 Giải thích chi tiết:', style: Mui.subtitle1.copyWith(color: Tw.blue800)),
              const SizedBox(height: 8),
              Text(r.explanation, style: Mui.body1.copyWith(color: Tw.blue700, height: 1.625)),
            ],
          ),
        ));
      }
    }
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: children);
  }
}

// -----------------------------------------------------------------------------
// MediaGrid + MediaModal
// -----------------------------------------------------------------------------

class MediaGridView extends StatelessWidget {
  const MediaGridView({super.key, required this.media});

  final List<MediaItem> media;

  @override
  Widget build(BuildContext context) {
    final shown = media.take(4).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < shown.length; i++) ...[
          if (i > 0) const SizedBox(height: 12),
          _item(context, shown[i], i),
        ],
        if (media.length > 4) ...[
          const SizedBox(height: 12),
          Text('* Hiển thị 4/${media.length} media đầu tiên',
              style: Mui.caption.copyWith(color: Tw.gray500, fontStyle: FontStyle.italic)),
        ],
      ],
    );
  }

  Widget _item(BuildContext context, MediaItem m, int index) {
    final url = AppConfig.mediaUrl(m.url);
    Widget content;
    switch (m.type) {
      case 'video':
        content = SizedBox(
          height: 128,
          child: Stack(
            fit: StackFit.expand,
            children: [
              m.thumbnail != null && m.thumbnail != m.url
                  ? Image.network(AppConfig.mediaUrl(m.thumbnail), fit: BoxFit.cover, errorBuilder: (_, _, _) => const ColoredBox(color: Colors.black))
                  : const ColoredBox(color: Colors.black),
              Center(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: const BoxDecoration(color: Colors.black, shape: BoxShape.circle),
                  child: const Icon(Icons.play_arrow, color: Colors.white),
                ),
              ),
            ],
          ),
        );
      case 'audio':
        content = Container(
          height: 128,
          decoration: const BoxDecoration(
            gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Tw.purple400, Tw.purple600]),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.volume_up, color: Colors.white),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(m.title ?? 'File âm thanh', textAlign: TextAlign.center, style: Mui.body2.copyWith(color: Colors.white)),
              ),
            ],
          ),
        );
      default:
        content = Container(
          height: 256,
          color: Colors.white,
          child: Stack(
            fit: StackFit.expand,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(url, fit: BoxFit.contain, errorBuilder: (_, _, _) => const Center(child: Icon(Icons.broken_image, color: Tw.gray400))),
              ),
              Positioned(top: 12, right: 12, child: _pill(const HeroIcon(HeroIcons.photo, size: 16, color: Tw.gray600))),
              if (media.length > 1)
                Positioned(top: 12, left: 12, child: _pill(Text('${index + 1}/${media.length}', style: Tw.xs(c: Tw.gray700, w: Tw.medium)))),
            ],
          ),
        );
    }
    return GestureDetector(
      onTap: () => Navigator.of(context).push(MaterialPageRoute(fullscreenDialog: true, builder: (_) => MediaModal(media: m))),
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), border: Border.all(color: Tw.gray200, width: 2)),
        child: content,
      ),
    );
  }

  Widget _pill(Widget child) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.9), borderRadius: BorderRadius.circular(999)),
        child: child,
      );
}

/// `MediaModal.tsx` — dialog toàn màn hình xem ảnh / phát video / audio.
class MediaModal extends StatefulWidget {
  const MediaModal({super.key, required this.media});

  final MediaItem media;

  @override
  State<MediaModal> createState() => _MediaModalState();
}

class _MediaModalState extends State<MediaModal> {
  VideoPlayerController? _player;

  @override
  void initState() {
    super.initState();
    if (widget.media.type == 'video' || widget.media.type == 'audio') {
      _player = VideoPlayerController.networkUrl(Uri.parse(AppConfig.mediaUrl(widget.media.url)))
        ..initialize().then((_) {
          if (mounted) setState(() {});
          _player?.play();
        });
      _player!.addListener(() {
        if (mounted) setState(() {});
      });
    }
  }

  @override
  void dispose() {
    _player?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final m = widget.media;
    final url = AppConfig.mediaUrl(m.url);
    Widget body;
    if (m.type == 'image') {
      body = ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: InteractiveViewer(maxScale: 5, child: Image.network(url, fit: BoxFit.contain)),
      );
    } else if (m.type == 'video') {
      final p = _player;
      body = p == null || !p.value.isInitialized
          ? const CircularProgressIndicator(color: Mui.primary)
          : Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ClipRRect(borderRadius: BorderRadius.circular(8), child: AspectRatio(aspectRatio: p.value.aspectRatio, child: VideoPlayer(p))),
                _controls(p),
              ],
            );
    } else {
      body = Container(
        width: 448,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          gradient: const LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Tw.purple400, Tw.purple600]),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.volume_up, color: Colors.white),
            const SizedBox(height: 16),
            Text(m.title ?? 'File âm thanh', textAlign: TextAlign.center, style: Mui.h6.copyWith(color: Colors.white)),
            const SizedBox(height: 16),
            if (_player != null) _controls(_player!, light: true),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Stack(
            children: [
              Column(
                children: [
                  Expanded(child: Center(child: Padding(padding: const EdgeInsets.all(16), child: body))),
                  if (m.title != null || m.description != null)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: const BoxDecoration(
                        color: Tw.gray50,
                        borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (m.title != null) Text(m.title!, style: Mui.h6.copyWith(color: Tw.gray800)),
                          if (m.description != null) ...[
                            const SizedBox(height: 8),
                            Text(m.description!, style: Mui.body2.copyWith(color: Tw.gray600)),
                          ],
                        ],
                      ),
                    ),
                ],
              ),
              Positioned(
                top: 8,
                right: 8,
                child: IconButton(
                  iconSize: 28,
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close, color: Color(0x8A000000)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _controls(VideoPlayerController p, {bool light = false}) {
    final color = light ? Colors.white : Tw.gray800;
    final pos = p.value.position;
    final dur = p.value.duration;
    String f(Duration d) => '${d.inMinutes}:${(d.inSeconds % 60).toString().padLeft(2, '0')}';
    return Row(
      children: [
        IconButton(
          onPressed: () => p.value.isPlaying ? p.pause() : p.play(),
          icon: Icon(p.value.isPlaying ? Icons.pause : Icons.play_arrow, color: color),
        ),
        Text(f(pos), style: Tw.xs(c: color)),
        Expanded(
          child: Slider(
            value: dur.inMilliseconds == 0 ? 0 : pos.inMilliseconds.clamp(0, dur.inMilliseconds).toDouble(),
            max: max(1, dur.inMilliseconds.toDouble()),
            activeColor: light ? Colors.white : Mui.primary,
            onChanged: (v) => p.seekTo(Duration(milliseconds: v.toInt())),
          ),
        ),
        Text(f(dur), style: Tw.xs(c: color)),
      ],
    );
  }
}

// -----------------------------------------------------------------------------
// AntiCheatWarning
// -----------------------------------------------------------------------------

class AntiCheatWarningModal extends StatelessWidget {
  const AntiCheatWarningModal({
    super.key,
    required this.violation,
    required this.warningCount,
    required this.onContinue,
    required this.onTerminate,
  });

  final Violation violation;
  final int warningCount;
  final VoidCallback onContinue;
  final VoidCallback onTerminate;

  static const _messages = {
    'tab_switch': 'Bạn đã chuyển tab hoặc minimize cửa sổ',
    'escape_key': 'Bạn đã nhấn phím ESC',
    'minimize': 'Cửa sổ đã mất focus',
    'fullscreen_exit': 'Bạn đã thoát khỏi chế độ toàn màn hình',
    'copy_paste': 'Bạn đã thử sao chép/dán nội dung',
    'context_menu': 'Bạn đã thử mở menu chuột phải',
    'dev_tools': 'Bạn đã thử mở Developer Tools',
  };

  @override
  Widget build(BuildContext context) {
    final remaining = ExamController.maxViolations - warningCount;
    final last = remaining <= 1;
    final t = violation.timestamp;
    String two(int v) => v.toString().padLeft(2, '0');

    return Positioned.fill(
      child: ColoredBox(
        color: Colors.black,
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 448),
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), boxShadow: Tw.shadow2xl),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(color: last ? Tw.red100 : Tw.yellow100, shape: BoxShape.circle),
                    child: Icon(Icons.warning_amber_rounded, size: 32, color: last ? Tw.red600 : Tw.yellow600),
                  ),
                  const SizedBox(height: 16),
                  Text(last ? '⚠️ CẢNH BÁO CUỐI CÙNG!' : '⚠️ VI PHẠM QUY ĐỊNH!',
                      textAlign: TextAlign.center, style: Tw.xl(c: last ? Tw.red800 : Tw.yellow800, w: Tw.bold)),
                  const SizedBox(height: 16),
                  Text(_messages[violation.type] ?? violation.description,
                      textAlign: TextAlign.center, style: Tw.base(c: Tw.gray700)),
                  const SizedBox(height: 8),
                  Text('Thời gian: ${two(t.hour)}:${two(t.minute)}:${two(t.second)}', style: Tw.sm(c: Tw.gray500)),
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(color: last ? Tw.red100 : Tw.yellow100, borderRadius: BorderRadius.circular(999)),
                    child: Text('Lần vi phạm: $warningCount/${ExamController.maxViolations}',
                        style: Tw.sm(c: last ? Tw.red800 : Tw.yellow800, w: Tw.medium)),
                  ),
                  const SizedBox(height: 8),
                  if (remaining > 0)
                    Text.rich(
                      TextSpan(style: Tw.sm(c: Tw.gray600), children: [
                        const TextSpan(text: 'Còn lại '),
                        TextSpan(text: '$remaining', style: const TextStyle(fontWeight: FontWeight.bold)),
                        const TextSpan(text: ' cơ hội'),
                      ]),
                    )
                  else
                    Text('Bài thi sẽ bị kết thúc!', style: Tw.sm(c: Tw.red600, w: Tw.bold)),
                  const SizedBox(height: 24),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(color: Tw.gray50, borderRadius: BorderRadius.circular(8)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('📋 Quy định bài thi:', style: Tw.base(c: Tw.gray800, w: Tw.semibold)),
                        const SizedBox(height: 8),
                        for (final rule in const [
                          '• Không được chuyển tab hoặc minimize cửa sổ',
                          '• Không được thoát khỏi chế độ toàn màn hình',
                          '• Không được sao chép/dán nội dung',
                          '• Không được mở menu chuột phải',
                          '• Không được sử dụng Developer Tools',
                        ])
                          Padding(padding: const EdgeInsets.only(bottom: 4), child: Text(rule, style: Tw.sm(c: Tw.gray600))),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  if (remaining > 0)
                    Row(
                      children: [
                        Expanded(child: _btn('Tiếp tục thi', Tw.blue600, onContinue)),
                        const SizedBox(width: 12),
                        Expanded(child: _btn('Kết thúc', Tw.gray500, onTerminate)),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _btn(String label, Color color, VoidCallback onTap) => Material(
        color: color,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Text(label, textAlign: TextAlign.center, style: Tw.base(c: Colors.white, w: Tw.medium)),
          ),
        ),
      );
}

// -----------------------------------------------------------------------------
// RescueAnimation
// -----------------------------------------------------------------------------

class RescueAnimationOverlay extends StatefulWidget {
  const RescueAnimationOverlay({super.key});

  @override
  State<RescueAnimationOverlay> createState() => _RescueAnimationOverlayState();
}

class _RescueAnimationOverlayState extends State<RescueAnimationOverlay> with TickerProviderStateMixin {
  late final AnimationController _loop = AnimationController(vsync: this, duration: const Duration(seconds: 6))..repeat();
  late final AnimationController _intro = AnimationController(vsync: this, duration: const Duration(seconds: 1));
  final _rand = Random();
  late final _fireworks = List.generate(15, (_) => (_rand.nextDouble(), _rand.nextDouble(), _rand.nextDouble() * 2));
  late final _sparkles = List.generate(
    30,
    (_) => (
      _rand.nextDouble(),
      _rand.nextDouble(),
      _rand.nextDouble() * 3,
      const [Color(0xFFFF0080), Color(0xFF00FF80), Color(0xFF8000FF), Color(0xFFFF8000), Color(0xFF00FFFF), Color(0xFFFFFF00)][_rand.nextInt(6)],
    ),
  );

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) _intro.forward();
    });
  }

  @override
  void dispose() {
    _loop.dispose();
    _intro.dispose();
    super.dispose();
  }

  static const _rainbow = [
    Color(0xFFFF0000),
    Color(0xFFFF8000),
    Color(0xFFFFFF00),
    Color(0xFF00FF00),
    Color(0xFF00FFFF),
    Color(0xFF8000FF),
    Color(0xFFFF0000),
  ];

  Color _rainbowAt(double t) {
    final seg = t * (_rainbow.length - 1);
    final i = seg.floor().clamp(0, _rainbow.length - 2);
    return Color.lerp(_rainbow[i], _rainbow[i + 1], seg - i)!;
  }

  /// bounce keyframes: 0,20,50,80,100% → 0; 40% → -30px; 60% → -15px.
  double _bounce(double t) {
    if (t < 0.2) return 0;
    if (t < 0.4) return -30 * Curves.easeOut.transform((t - 0.2) / 0.2);
    if (t < 0.5) return -30 * (1 - Curves.easeIn.transform((t - 0.4) / 0.1));
    if (t < 0.6) return -15 * Curves.easeOut.transform((t - 0.5) / 0.1);
    if (t < 0.8) return -15 * (1 - Curves.easeIn.transform((t - 0.6) / 0.2));
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Material(
        color: Colors.transparent,
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Color(0xFF667EEA), Color(0xFF764BA2)]),
          ),
          child: AnimatedBuilder(
            animation: Listenable.merge([_loop, _intro]),
            builder: (context, _) {
              final secs = _loop.value * 6;
              return Stack(
                children: [
                  Positioned.fill(child: CustomPaint(painter: _FireworkPainter(_fireworks, _sparkles, secs))),
                  Center(
                    child: Opacity(
                      opacity: _intro.value,
                      child: Transform.scale(
                        scale: _intro.value,
                        child: Transform.translate(
                          offset: Offset(0, _bounce((secs % 2) / 2)),
                          child: Text(
                            'CỨU TRỢ\n🎉',
                            textAlign: TextAlign.center,
                            style: Mui.h2.copyWith(
                              color: _rainbowAt((secs % 3) / 3),
                              shadows: const [
                                Shadow(color: Colors.white, blurRadius: 5),
                                Shadow(color: Colors.white, blurRadius: 10),
                                Shadow(color: Colors.white, blurRadius: 15),
                                Shadow(color: Color(0xFFFF00DE), blurRadius: 20),
                                Shadow(color: Color(0xFFFF00DE), blurRadius: 35),
                                Shadow(color: Color(0xFFFF00DE), blurRadius: 40),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _FireworkPainter extends CustomPainter {
  _FireworkPainter(this.fireworks, this.sparkles, this.secs);

  final List<(double, double, double)> fireworks;
  final List<(double, double, double, Color)> sparkles;
  final double secs;

  @override
  void paint(Canvas canvas, Size size) {
    // fireworkExplode: 2s — scale 0→1→1.5, opacity 1→1→0
    for (final (x, y, delay) in fireworks) {
      if (secs < delay) continue;
      final t = ((secs - delay) % 2) / 2;
      final scale = t < 0.5 ? t * 2 : 1 + (t - 0.5);
      final opacity = t < 0.5 ? 1.0 : 1 - (t - 0.5) * 2;
      final c = Offset(x * size.width, y * size.height);
      canvas.drawCircle(c, 2 * scale, Paint()..color = Colors.white.withValues(alpha: opacity));
      canvas.drawCircle(
        c,
        20 * scale,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2
          ..color = Colors.white.withValues(alpha: opacity),
      );
    }
    // sparkle: 1.5s — scale 0→1→0
    for (final (x, y, delay, color) in sparkles) {
      if (secs < delay) continue;
      final t = ((secs - delay) % 1.5) / 1.5;
      final scale = t < 0.5 ? t * 2 : 2 - t * 2;
      final c = Offset(x * size.width, y * size.height);
      canvas.drawCircle(c, 4 * scale, Paint()..color = color..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2));
      canvas.drawCircle(c, 4 * scale, Paint()..color = color);
    }
  }

  @override
  bool shouldRepaint(covariant _FireworkPainter old) => true;
}
