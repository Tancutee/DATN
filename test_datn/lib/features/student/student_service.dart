import '../../core/network/api_client.dart';
import '../../core/network/api_exception.dart';
import 'student_models.dart';

/// API dành cho thí sinh (tương ứng `features/student/services` của Contests-FE).
class StudentService {
  StudentService([ApiClient? client]) : _api = client ?? ApiClient.instance;

  final ApiClient _api;

  /// `GET /auth/profile-student`
  Future<ContestantInfo> getProfile() async {
    final data = await _api.get('/auth/profile-student');
    return ContestantInfo.fromJson(Map<String, dynamic>.from(data as Map));
  }

  /// Số báo danh trong trận — dùng để nhận sự kiện cứu trợ `student:rescued`.
  Future<int?> getRegistrationNumber(int contestantId, int matchId) async {
    try {
      final data = await _api.get('/auth/registration-number',
          query: {'contestantId': contestantId, 'matchId': matchId});
      final n = (data as Map?)?['registrationNumber'];
      return n is num ? n.toInt() : null;
    } catch (_) {
      return null;
    }
  }

  /// `POST /results/submit-answer`
  Future<AnswerResult> submitAnswer({
    required int matchId,
    required int questionOrder,
    required String answer,
    List<int>? selectedOptions,
  }) async {
    final body = await _api.postRaw('/results/submit-answer', data: {
      'matchId': matchId,
      'questionOrder': questionOrder,
      'answer': answer,
      'selectedOptions': ?selectedOptions,
    });
    if (body['success'] != true) {
      throw ApiException(body['message']?.toString() ?? 'Không thể gửi đáp án');
    }
    final data = Map<String, dynamic>.from(body['data'] as Map? ?? {});
    final result = Map<String, dynamic>.from(data['result'] as Map? ?? {});
    return AnswerResult.fromJson(result, questionOrder);
  }

  /// `POST /results/ban-contestant` — tự cấm khi vi phạm chống gian lận quá số lần cho phép.
  Future<String> banContestant({
    required int matchId,
    required int violationCount,
    required String reason,
  }) async {
    final body = await _api.postRaw('/results/ban-contestant', data: {
      'matchId': matchId,
      'violationType': 'anti_cheat_multiple_violations',
      'violationCount': violationCount,
      'reason': reason,
      'bannedBy': 'ANTI_CHEAT_SYSTEM',
    });
    return body['message']?.toString() ?? 'Bạn đã bị cấm thi do vi phạm quy chế nhiều lần.';
  }

  /// `GET /class/list-with-school`
  Future<List<SchoolClass>> getClasses() async {
    final data = await _api.get('/class/list-with-school');
    return (data as List? ?? [])
        .map((e) => SchoolClass.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList();
  }

  /// `POST /auth/register-student`
  Future<void> register({
    required String username,
    required String fullName,
    required String email,
    required String password,
    required String confirmPassword,
    required int classId,
  }) =>
      _api.post('/auth/register-student', data: {
        'username': username.trim(),
        'fullName': fullName.trim(),
        'email': email.trim(),
        'password': password,
        'confirmPassword': confirmPassword,
        'classId': classId,
      });
}
