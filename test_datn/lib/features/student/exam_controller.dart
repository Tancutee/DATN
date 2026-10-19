import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

import '../../core/network/api_exception.dart';
import '../../core/network/socket_client.dart';
import '../../core/widgets/mui.dart';
import 'student_models.dart';
import 'student_service.dart';

/// Thông báo MUI (NotificationContext) mà màn hình cần hiển thị.
class ExamNotice {
  const ExamNotice(this.severity, this.message, this.title, [this.duration = const Duration(seconds: 3)]);

  final MuiSeverity severity;
  final String message;
  final String title;
  final Duration duration;
}

/// Vi phạm chống gian lận (`AntiCheatViolation` của FE).
class Violation {
  Violation(this.type, this.description) : timestamp = DateTime.now();

  /// `tab_switch` | `fullscreen_exit`
  final String type;
  final String description;
  final DateTime timestamp;
}

/// Đáp án gửi đi khi hết giờ mà thí sinh chưa chọn.
const kNoAnswer = '[KHÔNG CHỌN ĐÁP ÁN]';

/// Điều khiển phòng thi trực tuyến của thí sinh — gộp logic của `useStudentRealTime`,
/// `useStudentSocket`, `useAntiCheat` và `QuestionAnswerRefactored` trong Contests-FE.
class ExamController extends ChangeNotifier with WidgetsBindingObserver {
  ExamController({required this.info, required this.match, StudentService? service})
      : _service = service ?? StudentService(),
        matchStarted = match.status == 'ongoing';

  final ContestantInfo info;
  final StudentMatch match;
  final StudentService _service;

  static const maxViolations = 3;

  io.Socket? _socket;
  final _notices = StreamController<ExamNotice>.broadcast();
  final _violationEvents = StreamController<Violation>.broadcast();
  final _ended = StreamController<void>.broadcast();

  Stream<ExamNotice> get notices => _notices.stream;
  Stream<Violation> get violationEvents => _violationEvents.stream;
  Stream<void> get ended => _ended.stream;

  int? registrationNumber;
  bool connected = false;
  bool matchStarted;
  bool matchEnded = false;

  CurrentQuestion? current;
  int remainingTime = 0;

  String selectedAnswer = '';
  bool isSubmitted = false;
  bool isApiSubmitting = false;
  bool canShowResult = false;
  AnswerResult? pendingResult;
  AnswerResult? answerResult;

  bool isEliminated = false;
  bool isBanned = false;
  String banMessage = '';

  /// Đang chạy hiệu ứng cứu trợ (5 giây) — `isInRescueMode` của FE.
  bool isInRescueMode = false;

  /// Vừa được cứu trợ — chặn tự nộp khi hết giờ (giống FE).
  bool justRescued = false;
  DateTime? _lastRescueAt;

  final List<Violation> violations = [];
  int get warningCount => violations.length;
  bool _away = false;
  DateTime? _lastViolationAt;
  bool _disposed = false;

  ExamQuestion? get question => current?.question;

  bool get isMonitoring => current != null && !isEliminated && !(isBanned) && !matchEnded;

  /// `shouldDisableInteraction` của QuestionOptions.
  bool get interactionDisabled => isSubmitted || isEliminated || isBanned || isInRescueMode;

  // ---------------------------------------------------------------------------
  // Vòng đời
  // ---------------------------------------------------------------------------

  Future<void> start() async {
    WidgetsBinding.instance.addObserver(this);
    registrationNumber = await _service.getRegistrationNumber(info.contestantId, match.id);
    if (_disposed) return;

    final socket = await SocketClient.connect('/student');
    if (_disposed) {
      socket.dispose();
      return;
    }
    _socket = socket;
    socket
      ..onConnect((_) => _onConnected())
      ..onDisconnect((_) => _setConnected(false))
      ..onConnectError((_) => _setConnected(false))
      ..on('match:started', _onMatchStarted)
      ..on('match:globalStarted', _onMatchStarted)
      ..on('match:questionShown', _onQuestionShown)
      ..on('timer:update', _onTimerUpdate)
      ..on('timer:ended', (_) => _setRemaining(0))
      ..on('match:ended', _onMatchEnded)
      ..on('student:rescued', _onRescued);
  }

  @override
  void dispose() {
    _disposed = true;
    WidgetsBinding.instance.removeObserver(this);
    final s = _socket;
    if (s != null) {
      if (s.connected) s.emit('leaveMatchRoom', match.slug);
      s.dispose();
    }
    _notices.close();
    _violationEvents.close();
    _ended.close();
    super.dispose();
  }

  // ---------------------------------------------------------------------------
  // Socket
  // ---------------------------------------------------------------------------

  Future<void> _onConnected() async {
    _setConnected(true);
    final s = _socket!;
    // BE chỉ đăng ký handler của namespace `/student` sau một truy vấn DB bất đồng bộ
    // khi kết nối → sự kiện gửi quá sớm có thể bị bỏ qua, nên thử lại vài lần.
    var join = SocketAck(false, '');
    for (var attempt = 0; attempt < 4 && !join.success && s.connected; attempt++) {
      await Future<void>.delayed(Duration(milliseconds: 400 + attempt * 600));
      join = await SocketClient.emitAck(s, 'student:joinMatch', {'matchSlug': match.slug},
          timeout: const Duration(seconds: 3));
    }
    if (!join.success) return;
    await SocketClient.emitAck(s, 'joinMatchRoom', match.id);
    await _syncStatus();
  }

  Future<void> _syncStatus() async {
    final s = _socket;
    if (s == null) return;
    final ack = await SocketClient.emitAck(s, 'student:getMatchStatus', null);
    if (!ack.success || ack.data is! Map) return;
    final data = ack.data as Map;
    final matchData = data['matchData'];
    if (matchData is Map && matchData['status']?.toString() == 'ongoing') matchStarted = true;
    switch (data['contestantStatus']?.toString()) {
      case 'eliminated':
        isEliminated = true;
      case 'banned':
        isBanned = true;
    }
    _notify();
  }

  bool _isThisMatch(dynamic data) {
    if (data is! Map) return false;
    return data['matchSlug']?.toString() == match.slug || data['matchId']?.toString() == match.id.toString();
  }

  void _onMatchStarted(dynamic data) {
    if (!_isThisMatch(data)) return;
    matchStarted = true;
    _socket?.emit('student:confirmStart', {'contestantId': info.contestantId, 'matchId': match.id});
    _notify();
  }

  void _onQuestionShown(dynamic data) {
    if (!_isThisMatch(data)) return;
    final raw = (data as Map)['currentQuestionData'];
    if (raw is! Map) return;
    final next = CurrentQuestion.fromEvent(Map<String, dynamic>.from(raw));
    final time = data['remainingTime'];
    matchStarted = true;

    // Sự kiện trùng (gửi tới 2 phòng) → không reset đáp án.
    if (current != null && current!.order == next.order && current!.question.id == next.question.id) {
      _notify();
      return;
    }

    current = next;
    remainingTime = time is num ? time.toInt() : next.question.defaultTime;
    selectedAnswer = '';
    isSubmitted = false;
    answerResult = null;
    pendingResult = null;
    canShowResult = false;
    justRescued = false;
    _notify();
  }

  void _onTimerUpdate(dynamic data) {
    if (data is! Map) return;
    final t = data['timeRemaining'];
    if (t is num) _setRemaining(t.toInt());
  }

  void _setRemaining(int value) {
    remainingTime = value < 0 ? 0 : value;
    if (remainingTime < 1 && !canShowResult) {
      canShowResult = true;
      _revealResult();
    }
    // Hết giờ mà chưa gửi → tự gửi (FE: remainingTime === 0 && !isSubmitted ...).
    if (remainingTime == 0 &&
        !isSubmitted &&
        !isEliminated &&
        !isBanned &&
        !isInRescueMode &&
        !justRescued &&
        !isApiSubmitting &&
        current != null) {
      submit(selectedAnswer.isEmpty ? kNoAnswer : selectedAnswer);
    }
    _notify();
  }

  void _onMatchEnded(dynamic data) {
    if (!_isThisMatch(data)) return;
    matchEnded = true;
    matchStarted = false;
    remainingTime = 0;
    _notify();
    if (!_ended.isClosed) _ended.add(null);
  }

  void _onRescued(dynamic data) {
    if (data is! Map) return;
    final ids = (data['rescuedContestantIds'] as List? ?? []).map((e) => e.toString()).toList();
    if (registrationNumber == null || !ids.contains(registrationNumber.toString())) return;

    final now = DateTime.now();
    if (_lastRescueAt != null && now.difference(_lastRescueAt!) < const Duration(seconds: 6)) return;
    _lastRescueAt = now;

    isEliminated = false;
    isBanned = false;
    banMessage = '';
    violations.clear();
    isInRescueMode = true;
    _emitNotice(MuiSeverity.success, '🎉 Bạn đã được cứu trợ thành công!', 'Cứu trợ');
    _notify();

    // RescueAnimation tự hoàn tất sau 5 giây.
    Timer(const Duration(seconds: 5), () {
      if (_disposed) return;
      isInRescueMode = false;
      justRescued = true;
      selectedAnswer = '';
      isSubmitted = false;
      answerResult = null;
      pendingResult = null;
      isEliminated = false;
      _notify();
    });
  }

  // ---------------------------------------------------------------------------
  // Trả lời
  // ---------------------------------------------------------------------------

  void selectAnswer(String answer) {
    if (isBanned || isEliminated || isSubmitted) return;
    selectedAnswer = answer;
    _notify();
  }

  Future<void> submit([String? answerOverride]) async {
    final q = current;
    if (q == null || isBanned || isEliminated) return;

    final answer = (answerOverride ?? selectedAnswer).isEmpty ? kNoAnswer : (answerOverride ?? selectedAnswer);
    final index = answer == kNoAnswer ? -1 : q.question.options.indexOf(answer);

    isSubmitted = true;
    isApiSubmitting = true;
    _notify();

    try {
      final result = await _service.submitAnswer(
        matchId: match.id,
        questionOrder: q.order,
        answer: answer,
        selectedOptions: index >= 0 ? [index] : const [],
      );
      if (current?.order != q.order) return;
      pendingResult = result;
      _emitNotice(
        MuiSeverity.success,
        answer == kNoAnswer ? 'Đã bỏ qua câu hỏi này!' : 'Đã gửi đáp án: "$answer"',
        'Gửi thành công',
      );
      _revealResult();
    } on ApiException catch (e) {
      if (e.statusCode == null) {
        isSubmitted = false;
        _emitNotice(MuiSeverity.error, 'Lỗi kết nối khi gửi đáp án. Vui lòng thử lại!', 'Lỗi kết nối',
            const Duration(seconds: 5));
      } else {
        _emitNotice(MuiSeverity.error, 'Không thể gửi đáp án: ${e.message}', 'Gửi thất bại', const Duration(seconds: 5));
      }
    } finally {
      isApiSubmitting = false;
      _notify();
    }
  }

  void _revealResult() {
    final r = pendingResult;
    if (r == null || !canShowResult || answerResult != null) return;
    answerResult = r;
    pendingResult = null;
    if (r.eliminated) isEliminated = true;
    if (r.isCorrect) {
      _emitNotice(MuiSeverity.success, '🎉 Chính xác! Bạn được +${r.score} điểm', 'Câu trả lời đúng!',
          const Duration(seconds: 4));
    } else {
      _emitNotice(MuiSeverity.error, '❌ Câu trả lời chưa đúng. Đáp án đúng: "${r.correctAnswer}"', 'Câu trả lời sai',
          const Duration(seconds: 4));
    }
  }

  // ---------------------------------------------------------------------------
  // Chống gian lận
  // ---------------------------------------------------------------------------

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.hidden:
      case AppLifecycleState.paused:
        if (!_away) {
          _away = true;
          _addViolation('tab_switch', 'Thí sinh đã chuyển tab hoặc minimize cửa sổ', emit: false);
        }
      case AppLifecycleState.resumed:
        if (_away) {
          _away = false;
          if (violations.isNotEmpty && !isBanned && _lastViolationAt != null &&
              DateTime.now().difference(_lastViolationAt!) < const Duration(minutes: 30)) {
            final last = violations.last;
            if (!_violationEvents.isClosed) _violationEvents.add(last);
          }
          if (warningCount >= maxViolations) _ban();
        }
        if (_socket != null && !_socket!.connected) _socket!.connect();
      default:
        break;
    }
  }

  /// Gọi khi thí sinh thoát chế độ toàn màn hình (thanh hệ thống hiện lại).
  void reportFullscreenExit() {
    _addViolation('fullscreen_exit', 'Thí sinh đã thoát khỏi chế độ toàn màn hình');
  }

  void _addViolation(String type, String description, {bool emit = true}) {
    if (!isMonitoring) return;
    final now = DateTime.now();
    // Rời app thường kéo theo thoát toàn màn hình → chỉ tính 1 lần.
    if (_lastViolationAt != null && now.difference(_lastViolationAt!) < const Duration(seconds: 2)) return;
    _lastViolationAt = now;
    final v = Violation(type, description);
    violations.add(v);
    if (emit && !_violationEvents.isClosed) _violationEvents.add(v);
    if (warningCount >= maxViolations) _ban();
    _notify();
  }

  void resetViolations() {
    violations.clear();
    _notify();
  }

  bool _banning = false;

  Future<void> _ban() async {
    if (isBanned || _banning) return;
    _banning = true;
    try {
      final types = violations.map((v) => v.type).join(', ');
      final msg = await _service.banContestant(
        matchId: match.id,
        violationCount: warningCount,
        reason: 'Vi phạm $warningCount lần: $types. Hệ thống tự động cấm tham gia.',
      );
      isBanned = true;
      banMessage = msg;
    } on ApiException catch (e) {
      if (e.statusCode == null) {
        _emitNotice(MuiSeverity.error, 'Lỗi kết nối khi xử lý cấm tham gia!', 'Lỗi kết nối', Duration.zero);
      } else {
        _emitNotice(MuiSeverity.error, 'Bạn đã bị cấm trước đó!', 'Cấm', Duration.zero);
      }
    } finally {
      _banning = false;
      _notify();
    }
  }

  /// Nút "Kết thúc" trong cảnh báo chống gian lận.
  void terminateByUser() {
    _emitNotice(MuiSeverity.error, 'Bài thi đã bị kết thúc do vi phạm quy định chống gian lận!', 'Kết thúc bài thi',
        Duration.zero);
  }

  // ---------------------------------------------------------------------------

  void _setConnected(bool value) {
    connected = value;
    _notify();
  }

  void _emitNotice(MuiSeverity s, String message, String title, [Duration d = const Duration(seconds: 3)]) {
    if (!_notices.isClosed) _notices.add(ExamNotice(s, message, title, d));
  }

  void _notify() {
    if (!_disposed) notifyListeners();
  }
}
