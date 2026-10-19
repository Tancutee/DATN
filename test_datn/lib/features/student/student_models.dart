int _int(dynamic v, [int fallback = 0]) =>
    v is num ? v.toInt() : int.tryParse(v?.toString() ?? '') ?? fallback;

String _str(dynamic v) => v?.toString() ?? '';

/// Trận đấu của thí sinh (từ `GET /auth/profile-student`).
class StudentMatch {
  const StudentMatch({
    required this.id,
    required this.name,
    required this.slug,
    required this.status,
    required this.currentQuestion,
    this.remainingTime,
  });

  final int id;
  final String name;
  final String slug;

  /// `upcoming` | `ongoing` | `finished`
  final String status;
  final int currentQuestion;
  final int? remainingTime;

  factory StudentMatch.fromJson(Map<String, dynamic> j) => StudentMatch(
        id: _int(j['id']),
        name: _str(j['name']),
        slug: _str(j['slug']),
        status: _str(j['status']),
        currentQuestion: _int(j['currentQuestion']),
        remainingTime: j['remainingTime'] == null ? null : _int(j['remainingTime']),
      );

  StudentMatch copyWith({String? status}) => StudentMatch(
        id: id,
        name: name,
        slug: slug,
        status: status ?? this.status,
        currentQuestion: currentQuestion,
        remainingTime: remainingTime,
      );
}

/// Thông tin thí sinh + cuộc thi + danh sách trận.
class ContestantInfo {
  const ContestantInfo({
    required this.contestantId,
    required this.fullName,
    required this.studentCode,
    required this.className,
    required this.contestId,
    required this.contestName,
    required this.contestSlug,
    required this.matches,
  });

  final int contestantId;
  final String fullName;
  final String studentCode;
  final String? className;
  final int contestId;
  final String contestName;
  final String contestSlug;
  final List<StudentMatch> matches;

  factory ContestantInfo.fromJson(Map<String, dynamic> j) {
    final c = Map<String, dynamic>.from(j['contestant'] as Map? ?? {});
    final contest = Map<String, dynamic>.from(j['contest'] as Map? ?? {});
    final matches = (j['matches'] as List? ?? [])
        .map((m) => StudentMatch.fromJson(Map<String, dynamic>.from(m as Map)))
        .toList()
      ..sort((a, b) => b.id.compareTo(a.id));
    return ContestantInfo(
      contestantId: _int(c['id']),
      fullName: _str(c['fullName']),
      studentCode: _str(c['studentCode']),
      className: c['class']?.toString(),
      contestId: _int(contest['id']),
      contestName: _str(contest['name']),
      contestSlug: _str(contest['slug']),
      matches: matches,
    );
  }

  ContestantInfo withMatches(List<StudentMatch> list) => ContestantInfo(
        contestantId: contestantId,
        fullName: fullName,
        studentCode: studentCode,
        className: className,
        contestId: contestId,
        contestName: contestName,
        contestSlug: contestSlug,
        matches: list,
      );
}

/// Media đính kèm câu hỏi (kết quả `transformQuestionMedia` của BE).
class MediaItem {
  const MediaItem({required this.type, required this.url, this.thumbnail, this.title, this.description});

  /// `image` | `video` | `audio`
  final String type;
  final String url;
  final String? thumbnail;
  final String? title;
  final String? description;

  static List<MediaItem> listFrom(dynamic raw) {
    if (raw is! List) return const [];
    return raw.whereType<Map>().map((m) {
      final mime = m['mimetype']?.toString() ?? m['mimeType']?.toString() ?? '';
      var type = m['type']?.toString() ?? '';
      if (type.isEmpty) {
        type = mime.startsWith('video/')
            ? 'video'
            : mime.startsWith('audio/')
                ? 'audio'
                : 'image';
      }
      return MediaItem(
        type: type,
        url: m['url']?.toString() ?? m['path']?.toString() ?? '',
        thumbnail: m['thumbnail']?.toString(),
        title: (m['title']?.toString().isNotEmpty ?? false) ? m['title'].toString() : null,
        description: (m['description']?.toString().isNotEmpty ?? false) ? m['description'].toString() : null,
      );
    }).where((m) => m.url.isNotEmpty).toList();
  }
}

/// Câu hỏi đang hiển thị (payload `match:questionShown` → `currentQuestionData.question`).
class ExamQuestion {
  const ExamQuestion({
    required this.id,
    required this.order,
    required this.content,
    required this.questionType,
    required this.difficulty,
    required this.defaultTime,
    required this.score,
    required this.options,
    required this.media,
    this.intro,
  });

  final int id;
  final int order;
  final String? intro;
  final String content;

  /// `multiple_choice` | `essay` | ...
  final String questionType;
  final String difficulty;
  final int defaultTime;
  final int score;
  final List<String> options;
  final List<MediaItem> media;

  bool get isEssay => questionType.toLowerCase() == 'essay';

  factory ExamQuestion.fromEvent(Map<String, dynamic> currentQuestionData) {
    final q = Map<String, dynamic>.from(currentQuestionData['question'] as Map? ?? {});
    final rawOptions = q['options'];
    final options = rawOptions is List
        ? rawOptions
            .map((o) => o is Map ? (o['text'] ?? o['content'] ?? '').toString() : o.toString())
            .toList()
        : <String>[];
    return ExamQuestion(
      id: _int(q['id']),
      order: _int(currentQuestionData['order']),
      intro: (q['intro']?.toString().trim().isEmpty ?? true) ? null : q['intro'].toString(),
      content: _str(q['content']),
      questionType: _str(q['questionType']),
      difficulty: _str(q['difficulty']),
      defaultTime: _int(q['defaultTime'], 30),
      score: _int(q['score']),
      options: options,
      media: MediaItem.listFrom(q['media'] ?? q['questionMedia']),
    );
  }
}

/// `currentQuestionData` của sự kiện `match:questionShown`.
class CurrentQuestion {
  const CurrentQuestion(this.order, this.question);

  final int order;
  final ExamQuestion question;

  factory CurrentQuestion.fromEvent(Map<String, dynamic> data) {
    final q = ExamQuestion.fromEvent(data);
    return CurrentQuestion(q.order, q);
  }
}

/// Kết quả chấm của `POST /results/submit-answer`.
class AnswerResult {
  const AnswerResult({
    required this.isCorrect,
    required this.correctAnswer,
    required this.explanation,
    required this.score,
    required this.eliminated,
    required this.questionOrder,
  });

  final bool isCorrect;
  final String correctAnswer;
  final String explanation;
  final int score;
  final bool eliminated;
  final int questionOrder;

  factory AnswerResult.fromJson(Map<String, dynamic> j, int questionOrder) {
    final ca = j['correctAnswer'];
    return AnswerResult(
      isCorrect: j['isCorrect'] == true,
      correctAnswer: ca is List ? ca.join(', ') : _str(ca),
      explanation: _str(j['explanation']),
      score: _int(j['score']),
      eliminated: j['eliminated'] == true,
      questionOrder: questionOrder,
    );
  }
}

/// Lớp học (cho form đăng ký) — `GET /class/list-with-school`.
class SchoolClass {
  const SchoolClass({required this.id, required this.name, required this.schoolName});

  final int id;
  final String name;
  final String schoolName;

  factory SchoolClass.fromJson(Map<String, dynamic> j) => SchoolClass(
        id: _int(j['id']),
        name: _str(j['name']),
        schoolName: _str((j['school'] as Map?)?['name']),
      );
}

String matchStatusText(String status) => switch (status) {
      'upcoming' => 'Sắp diễn ra',
      'ongoing' || 'active' => 'Đang diễn ra',
      'finished' || 'completed' => 'Đã kết thúc',
      _ => 'Không xác định',
    };
