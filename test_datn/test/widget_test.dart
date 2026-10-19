import 'package:flutter_test/flutter_test.dart';

import 'package:test_datn/features/audience/rescue_service.dart';
import 'package:test_datn/features/student/student_models.dart';

void main() {
  group('AudienceLink.parse', () {
    test('đọc được liên kết QR của màn hình trình chiếu', () {
      final link = AudienceLink.parse('https://olympic.example.com/khan-gia/tro-giup/tran-1-vong-loai/12');
      expect(link, isNotNull);
      expect(link!.matchSlug, 'tran-1-vong-loai');
      expect(link.rescueId, 12);
    });

    test('trả về null với nội dung không hợp lệ', () {
      expect(AudienceLink.parse('https://example.com/abc'), isNull);
    });
  });

  group('ExamQuestion.fromEvent', () {
    test('parse payload match:questionShown', () {
      final q = ExamQuestion.fromEvent({
        'order': 3,
        'question': {
          'id': 10,
          'content': '<p>1 + 1 = ?</p>',
          'questionType': 'multiple_choice',
          'difficulty': 'Alpha',
          'defaultTime': 20,
          'score': 1,
          'options': ['1', '2', '3'],
          'media': [
            {'type': 'image', 'url': '/uploads/q.png'},
          ],
        },
      });
      expect(q.order, 3);
      expect(q.options, ['1', '2', '3']);
      expect(q.isEssay, isFalse);
      expect(q.media.single.url, '/uploads/q.png');
    });
  });

  test('ContestantInfo sắp xếp trận đấu mới nhất lên đầu', () {
    final info = ContestantInfo.fromJson({
      'contestant': {'id': 1, 'fullName': 'A', 'studentCode': 'S1', 'class': null, 'contestId': 2},
      'contest': {'id': 2, 'name': 'Olympic', 'slug': 'olympic'},
      'matches': [
        {'id': 1, 'name': 'Trận 1', 'slug': 't1', 'status': 'finished', 'currentQuestion': 0},
        {'id': 5, 'name': 'Trận 5', 'slug': 't5', 'status': 'upcoming', 'currentQuestion': 0},
      ],
    });
    expect(info.matches.first.id, 5);
  });
}
