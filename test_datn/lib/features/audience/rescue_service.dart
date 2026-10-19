import '../../core/network/api_client.dart';
import '../student/student_models.dart';

/// Câu hỏi cứu trợ hiển thị cho khán giả — `GET /rescue/match/:slug/:rescueId`.
class RescueQuestion {
  const RescueQuestion({
    required this.id,
    required this.content,
    required this.options,
    required this.questionType,
    required this.media,
    required this.correctAnswer,
    this.topic,
  });

  final int id;
  final String content;
  final List<String> options;
  final String questionType;
  final String? topic;
  final List<MediaItem> media;

  /// Dùng để tạo các ô chữ cái cho câu tự luận (OpenEndedInput).
  final String correctAnswer;

  bool get isMultipleChoice => questionType == 'multiple_choice';

  factory RescueQuestion.fromJson(Map j) {
    final raw = j['options'];
    return RescueQuestion(
      id: (j['id'] as num?)?.toInt() ?? 0,
      content: j['content']?.toString() ?? '',
      options: raw is List ? raw.map((e) => e is Map ? '${e['text'] ?? ''}' : '$e').toList() : const [],
      questionType: j['questionType']?.toString() ?? '',
      topic: j['questionTopic']?.toString(),
      media: MediaItem.listFrom(j['questionMedia']),
      correctAnswer: j['correctAnswer']?.toString() ?? '',
    );
  }
}

class ChartItem {
  const ChartItem(this.label, this.value);

  final String label;
  final int value;
}

/// Liên kết khán giả: `/khan-gia/tro-giup/:matchSlug/:rescueId` (mã QR trên màn hình trình chiếu).
class AudienceLink {
  const AudienceLink(this.matchSlug, this.rescueId);

  final String matchSlug;
  final int rescueId;

  static final _pattern = RegExp(r'khan-gia/tro-giup/([^/?#]+)/(\d+)');

  static AudienceLink? parse(String raw) {
    final m = _pattern.firstMatch(raw.trim());
    if (m == null) return null;
    return AudienceLink(Uri.decodeComponent(m.group(1)!), int.parse(m.group(2)!));
  }
}

/// API cứu trợ khán giả (`features/audience/services/rescueService.ts`) — không cần đăng nhập.
class RescueService {
  RescueService([ApiClient? client]) : _api = client ?? ApiClient.instance;

  final ApiClient _api;

  Future<RescueQuestion> question(String matchSlug, int rescueId) async {
    final data = await _api.get('/rescue/match/$matchSlug/$rescueId');
    return RescueQuestion.fromJson(data as Map);
  }

  Future<void> submit(int rescueId, String answer) =>
      _api.post('/rescue/supportAnswer/$rescueId', data: {'supportAnswers': answer});

  Future<List<ChartItem>> chart(int rescueId) async {
    final data = await _api.get('/rescue/chart/$rescueId');
    return (data as List? ?? [])
        .whereType<Map>()
        .map((e) => ChartItem('${e['label']}', (e['value'] as num?)?.toInt() ?? 0))
        .toList();
  }
}
