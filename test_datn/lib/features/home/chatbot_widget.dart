import 'dart:async';

import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';

import '../../core/theme/tw.dart';
import '../../core/widgets/mui.dart';

/// `features/chatbot` — chatbot tư vấn trả lời theo từ khoá (không gọi API).
class OlympicChatbotWidget extends StatefulWidget {
  const OlympicChatbotWidget({super.key});

  @override
  State<OlympicChatbotWidget> createState() => _OlympicChatbotWidgetState();
}

class _Message {
  _Message(this.text, this.isBot) : timestamp = DateTime.now();

  final String text;
  final bool isBot;
  final DateTime timestamp;
}

class _OlympicChatbotWidgetState extends State<OlympicChatbotWidget> {
  static const _quickQuestions = [
    (HeroIcons.calendarDays, 'Thời gian', 'Cuộc thi diễn ra khi nào?'),
    (HeroIcons.bookOpen, 'Nội dung', 'Các môn thi là gì?'),
    (HeroIcons.trophy, 'Giải thưởng', 'Giải thưởng của cuộc thi'),
    (HeroIcons.users, 'Đối tượng', 'Ai được tham gia cuộc thi?'),
  ];

  final _messages = <_Message>[];
  final _input = TextEditingController();
  final _scroll = ScrollController();
  bool _open = false;
  bool _typing = false;
  bool _hasNew = false;

  @override
  void dispose() {
    _input.dispose();
    _scroll.dispose();
    super.dispose();
  }

  void _send([String? text]) {
    final msg = (text ?? _input.text);
    if (msg.trim().isEmpty) return;
    setState(() {
      _messages.add(_Message(msg, false));
      _input.clear();
      _typing = true;
    });
    _scrollToBottom();
    Timer(const Duration(seconds: 1), () {
      if (!mounted) return;
      setState(() {
        _messages.add(_Message(_botResponse(msg), true));
        _typing = false;
        if (!_open && _messages.length > 1) _hasNew = true;
      });
      _scrollToBottom();
    });
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scroll.hasClients) {
        _scroll.animateTo(_scroll.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
      }
    });
  }

  String _fmt(DateTime d) => '${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    if (_open) return Positioned.fill(child: _fullScreen());
    return Positioned(
      bottom: 24 + MediaQuery.of(context).padding.bottom,
      right: 16,
      child: GestureDetector(
        onTap: () => setState(() {
          _open = true;
          _hasNew = false;
        }),
        child: TwPulse(
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: Mui.buttonGradient,
                  border: Border.all(color: Colors.white, width: 3),
                  boxShadow: Tw.glow(Mui.accent),
                ),
                child: const Center(child: HeroIcon(HeroIcons.chatBubbleLeftRight, size: 24, color: Colors.white)),
              ),
              if (_hasNew)
                Positioned(
                  top: -4,
                  right: -4,
                  child: Container(
                    width: 18,
                    height: 18,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Tw.red500,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: Text('1', style: Tw.xs(c: Colors.white, w: Tw.bold).copyWith(fontSize: 9, height: 1)),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _fullScreen() {
    return Material(
      color: Colors.white,
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.zero,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.fromLTRB(16, 14, 8, 14),
                decoration: const BoxDecoration(gradient: Mui.pageGradient),
                child: Row(
                  children: [
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.16),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Center(child: HeroIcon(HeroIcons.sparkles, size: 22, color: Colors.white)),
                        ),
                        Positioned(
                          right: -2,
                          bottom: -2,
                          child: Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              color: Tw.green400,
                              shape: BoxShape.circle,
                              border: Border.all(color: Mui.primary, width: 2),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Trợ lý Olympic 2025', style: Tw.base(c: Colors.white, w: FontWeight.w800)),
                          Text('Đang trực tuyến · Trả lời ngay', style: Tw.xs(c: Colors.white.withValues(alpha: 0.75))),
                        ],
                      ),
                    ),
                    InkResponse(
                      onTap: () => setState(() => _open = false),
                      child: const Padding(
                        padding: EdgeInsets.all(8),
                        child: HeroIcon(HeroIcons.xMark, size: 24, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
                decoration: const BoxDecoration(color: Colors.white, border: Border(bottom: BorderSide(color: Tw.gray100))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('CÂU HỎI THƯỜNG GẶP', style: Tw.xs(c: Tw.gray400, w: Tw.bold).copyWith(letterSpacing: 0.8)),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        for (final (icon, text, question) in _quickQuestions)
                          PressScale(
                            child: GestureDetector(
                              onTap: () => _send(question),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                decoration: BoxDecoration(
                                  color: Tw.blue50,
                                  borderRadius: BorderRadius.circular(999),
                                  border: Border.all(color: Tw.blue100),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    HeroIcon(icon, size: 15, color: Tw.blue600),
                                    const SizedBox(width: 6),
                                    Text(text, style: Tw.sm(c: Tw.blue700, w: Tw.semibold)),
                                  ],
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ColoredBox(
                  color: Mui.background,
                  child: ListView(
                    controller: _scroll,
                    padding: const EdgeInsets.all(16),
                    children: [
                      for (final m in _messages) ...[_bubble(m), const SizedBox(height: 16)],
                      if (_typing) _typingBubble(),
                    ],
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(16, 12, 12, 12),
                decoration: const BoxDecoration(color: Colors.white, border: Border(top: BorderSide(color: Tw.gray100))),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _input,
                        onChanged: (_) => setState(() {}),
                        onSubmitted: (_) => _send(),
                        style: Tw.sm(c: Tw.gray900, w: Tw.medium),
                        decoration: InputDecoration(
                          hintText: 'Nhập câu hỏi...',
                          hintStyle: Tw.sm(c: Tw.gray400),
                          isDense: true,
                          filled: true,
                          fillColor: Tw.gray100,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(999), borderSide: BorderSide.none),
                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(999), borderSide: BorderSide.none),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(999), borderSide: const BorderSide(color: Tw.blue400, width: 1.5)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    AnimatedOpacity(
                      duration: const Duration(milliseconds: 150),
                      opacity: _input.text.trim().isEmpty ? 0.45 : 1,
                      child: GestureDetector(
                        onTap: _input.text.trim().isEmpty ? null : _send,
                        child: Container(
                          width: 48,
                          height: 48,
                          decoration: const BoxDecoration(shape: BoxShape.circle, gradient: Mui.buttonGradient),
                          child: const Center(child: HeroIcon(HeroIcons.paperAirplane, size: 20, color: Colors.white)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _botIcon(double pad) => Container(
        padding: EdgeInsets.all(pad),
        decoration: const BoxDecoration(color: Tw.blue50, shape: BoxShape.circle),
        child: const HeroIcon(HeroIcons.sparkles, size: 13, color: Tw.blue600),
      );

  Widget _bubble(_Message m) {
    return Align(
      alignment: m.isBot ? Alignment.centerLeft : Alignment.centerRight,
      child: FractionallySizedBox(
        widthFactor: 0.85,
        alignment: m.isBot ? Alignment.centerLeft : Alignment.centerRight,
        child: Align(
          alignment: m.isBot ? Alignment.centerLeft : Alignment.centerRight,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: m.isBot ? Colors.white : null,
              gradient: m.isBot ? null : Mui.buttonGradient,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(20),
                topRight: const Radius.circular(20),
                bottomLeft: Radius.circular(m.isBot ? 6 : 20),
                bottomRight: Radius.circular(m.isBot ? 20 : 6),
              ),
              border: m.isBot ? Border.all(color: Tw.gray100) : null,
              boxShadow: Tw.shadowSm,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (m.isBot) ...[
                  Padding(padding: const EdgeInsets.only(top: 4), child: _botIcon(6)),
                  const SizedBox(width: 12),
                ],
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(m.text, style: Tw.sm(c: m.isBot ? Tw.gray700 : Colors.white).copyWith(height: 1.6)),
                      const SizedBox(height: 6),
                      Text(_fmt(m.timestamp),
                          style: Tw.xs(c: m.isBot ? Tw.gray400 : Colors.white.withValues(alpha: 0.7))),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _typingBubble() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
            bottomLeft: Radius.circular(6),
            bottomRight: Radius.circular(20),
          ),
          border: Border.all(color: Tw.gray100),
          boxShadow: Tw.shadowSm,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _botIcon(6),
            const SizedBox(width: 12),
            for (var i = 0; i < 3; i++) ...[
              TwBounce(
                delay: Duration(milliseconds: 100 * i),
                child: Container(
                    width: 7, height: 7, decoration: const BoxDecoration(color: Tw.blue300, shape: BoxShape.circle)),
              ),
              const SizedBox(width: 4),
            ],
          ],
        ),
      ),
    );
  }
}

/// `features/chatbot/utils/getBotResponse`.
String _botResponse(String userMessage) {
  final message = userMessage.toLowerCase();
  bool has(List<String> keys) => keys.any(message.contains);

  if (has(['thời gian', 'lịch thi', 'khi nào'])) {
    return '📅 **Lịch thi Olympic Tin Học 2025:**\n\n• **Vòng sơ loại:** 24/03/2025 – 30/03/2025\n• **Vòng tứ kết & bán kết:** 31/03/2025 – 13/04/2025\n• **Vòng chung kết:** 14/04/2025 – 20/04/2025\n\nVòng sơ loại thi trực tiếp tại lớp học, các vòng còn lại thi trực tiếp trên sân khấu.';
  }
  if (has(['môn thi', 'nội dung', 'lĩnh vực'])) {
    return '📚 **8 lĩnh vực kiến thức thi:**\n\n1. **Lập trình (C/C++)** - Thuật toán, cấu trúc dữ liệu, OOP\n2. **Tin tức - Công nghệ** - Thông tin công nghệ 2025\n3. **Cơ sở dữ liệu** - CSDL, mô hình quan hệ, T-SQL\n4. **Phần cứng và mạng** - Cấu tạo máy tính, mạng LAN/WAN\n5. **Ứng dụng CNTT** - MS Office 2016 (Word, Excel, PowerPoint)\n6. **Thiết kế website** - HTML, CSS, JavaScript\n7. **Công nghệ phần mềm** - Mô hình phát triển, công cụ quản lý\n8. **Anh văn chuyên ngành** - Tiếng Anh IT';
  }
  if (has(['giải thưởng', 'phần thưởng', 'tiền thưởng'])) {
    return '🏆 **Cơ cấu giải thưởng:**\n\n• **Giải Nhất:** 3.000.000 đồng + giấy khen\n• **Giải Nhì:** 2.000.000 đồng + giấy khen\n• **Giải Ba:** 1.000.000 đồng + giấy khen\n• **Giải Video ấn tượng:** 1.000.000 đồng + giấy khen\n• **Giải GOLD:** Phần quà + giấy khen\n• **Giấy chứng nhận** cho thí sinh vào được chung kết';
  }
  if (has(['đối tượng', 'ai được thi', 'tham gia'])) {
    return '👥 **Đối tượng tham gia:**\n\nTất cả các lớp thuộc khoa CNTT đều có thể tham gia cuộc thi Olympic Tin Học 2025 - Đấu Trường Số.';
  }
  if (has(['vòng sơ loại', 'sơ loại'])) {
    return '📝 **Vòng sơ loại:**\n\n• **Hình thức:** Thi trắc nghiệm trực tiếp tại lớp học\n• **Thời gian:** 24/03/2025 – 30/03/2025\n• **Nội dung:** 30 câu hỏi theo đề cương cuộc thi\n• **Kết quả:** Chọn 20 thí sinh xuất sắc nhất (15 chính thức + 5 dự bị) vào vòng tứ kết\n• **Đặc biệt:** 3 đội từ khóa 22 được đặc cách vào bán kết';
  }
  if (has(['tứ kết', 'video'])) {
    return '🎬 **Vòng tứ kết:**\n\n• **Video giới thiệu:** Mỗi đội làm video 1.5-3 phút giới thiệu đội\n• **Nội dung video:** Tên đội, slogan, thành viên, mục tiêu\n• **Thi đấu:** Hình thức "Đấu trường số" với 13 câu hỏi\n• **Kết quả:** 20 thí sinh xuất sắc nhất vào bán kết\n• **Đặc biệt:** Thí sinh nhấn nút GOLD được vòng nguyệt quế + giấy khen + phần thưởng';
  }
  if (has(['đấu trường số', 'cách thi'])) {
    return '⚔️ **Hình thức "Đấu trường số":**\n\n• **13 câu hỏi** chia 4 mức độ:\n  - **Alpha:** 4 câu (15s/câu)\n  - **Beta:** 4 câu (20s/câu) \n  - **Release Candidate:** 4 câu (30s/câu)\n  - **GOLD:** 1 câu quyết định (30s)\n\n• **Cứu trợ "hồi sinh":** Có thể cứu thí sinh bị loại\n• **"Phao cứu trợ":** Hỗ trợ đặc biệt khi chỉ còn 1 thí sinh\n• **Câu GOLD:** Giành quyền trả lời bằng cách đưa tay';
  }
  if (has(['fanpage', 'facebook', 'theo dõi'])) {
    return '📱 **Thông tin theo dõi:**\n\nFanpage chính thức: https://www.facebook.com/olympicit.caothang/\n\nHãy theo dõi fanpage để cập nhật thông tin mới nhất về cuộc thi!';
  }
  if (has(['bán kết'])) {
    return '🏟️ **Vòng bán kết:**\n\n• **Hình thức:** "Đấu trường số"\n• **Kết quả:** 20 thí sinh xuất sắc nhất vào chung kết\n• **Cấu trúc:** 3 trận đấu cho các khóa 2022, 2023, 2024\n• **Tổng cộng:** 60 thí sinh được chọn vào vòng chung kết';
  }
  if (has(['chung kết'])) {
    return '👑 **Vòng chung kết:**\n\n• **Thời gian:** 14/04/2025 – 20/04/2025\n• **Hình thức:** "Đấu trường số"\n• **Kết quả:** Chọn 3 thí sinh xuất sắc nhất\n• **Tiêu chí:** Thí sinh nhấn GOLD, thứ tự câu hỏi, số câu trả lời đúng\n• **Đặc biệt:** Thí sinh nhấn GOLD được thêm giấy khen + 1 phần thưởng chiến thắng';
  }
  if (has(['xin chào', 'hello', 'hi'])) {
    return 'Xin chào! Tôi rất vui được hỗ trợ bạn về cuộc thi Olympic Tin Học 2025 - Đấu Trường Số. Bạn muốn biết thông tin gì về cuộc thi?';
  }
  return 'Tôi chưa hiểu rõ câu hỏi của bạn. Bạn có thể hỏi về:\n\n• Thời gian thi\n• Nội dung môn thi\n• Giải thưởng\n• Quy trình các vòng thi\n• Hình thức thi đấu\n• Đối tượng tham gia\n\nHoặc bạn có thể đặt câu hỏi cụ thể hơn!';
}
