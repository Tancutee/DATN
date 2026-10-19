import '../../core/network/api_client.dart';

int _int(dynamic v) => v is num ? v.toInt() : int.tryParse(v?.toString() ?? '') ?? 0;

class JudgeContest {
  const JudgeContest({required this.id, required this.name, required this.slug});

  final int id;
  final String name;
  final String slug;

  factory JudgeContest.fromJson(Map j) =>
      JudgeContest(id: _int(j['id']), name: '${j['name'] ?? ''}', slug: '${j['slug'] ?? ''}');
}

class JudgeMatch {
  const JudgeMatch({required this.id, required this.name, required this.slug});

  final int id;
  final String name;
  final String slug;

  factory JudgeMatch.fromJson(Map j) =>
      JudgeMatch(id: _int(j['id']), name: '${j['name'] ?? ''}', slug: '${j['slug'] ?? ''}');
}

/// `GET /match/:slug/matchInfo` (MatchService.MatchControl).
class JudgeMatchInfo {
  const JudgeMatchInfo({
    required this.id,
    required this.slug,
    required this.name,
    required this.currentQuestion,
    required this.status,
    this.roundName,
  });

  final int id;
  final String slug;
  final String name;
  final int currentQuestion;
  final String status;
  final String? roundName;

  factory JudgeMatchInfo.fromJson(Map j) => JudgeMatchInfo(
        id: _int(j['id']),
        slug: '${j['slug'] ?? ''}',
        name: '${j['name'] ?? ''}',
        currentQuestion: _int(j['currentQuestion']),
        status: '${j['status'] ?? ''}',
        roundName: j['roundName']?.toString(),
      );
}

/// Thí sinh trong nhóm của trọng tài (`contestantMatch`).
class JudgeContestant {
  const JudgeContestant({required this.registrationNumber, required this.status, required this.columns});

  final int registrationNumber;

  /// `in_progress` | `confirmed1` | `confirmed2` | ...
  final String status;
  final int columns;

  factory JudgeContestant.fromJson(Map j) => JudgeContestant(
        registrationNumber: _int(j['registrationNumber']),
        status: '${j['status'] ?? ''}',
        columns: _int((j['match'] as Map?)?['maxContestantColumn']),
      );
}

/// Nhóm mà trọng tài phụ trách (`GET /group/match/:slug`).
class JudgeGroup {
  const JudgeGroup({required this.id, required this.name, required this.confirmCurrentQuestion});

  final int id;
  final String name;
  final int confirmCurrentQuestion;

  factory JudgeGroup.fromJson(Map j) => JudgeGroup(
        id: _int(j['id']),
        name: '${j['name'] ?? ''}',
        confirmCurrentQuestion: _int(j['confirmCurrentQuestion']),
      );
}

/// API trọng tài (tương ứng `features/judge/services/selector/api.ts`).
class JudgeService {
  JudgeService([ApiClient? client]) : _api = client ?? ApiClient.instance;

  final ApiClient _api;

  Future<List<JudgeContest>> contests() async {
    final data = await _api.get('/contest/list-contest/judge');
    return (data as List? ?? []).map((e) => JudgeContest.fromJson(e as Map)).toList();
  }

  Future<List<JudgeMatch>> matches(int contestId) async {
    final data = await _api.get('/match/judge/$contestId');
    return (data as List? ?? []).map((e) => JudgeMatch.fromJson(e as Map)).toList();
  }

  Future<JudgeMatchInfo> matchInfo(String slug) async {
    final data = await _api.get('/match/$slug/matchInfo');
    return JudgeMatchInfo.fromJson(data as Map);
  }

  Future<List<JudgeContestant>> contestants(String slug) async {
    final data = await _api.get('/group-divisions/contestant/judge/$slug');
    return (data as List? ?? []).map((e) => JudgeContestant.fromJson(e as Map)).toList();
  }

  Future<JudgeGroup?> group(String slug) async {
    final data = await _api.get('/group/match/$slug');
    return data is Map ? JudgeGroup.fromJson(data) : null;
  }
}
