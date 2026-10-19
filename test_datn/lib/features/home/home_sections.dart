import 'dart:async';

import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../core/theme/tw.dart';
import '../../core/widgets/mui.dart';
import 'home_screen.dart';

void _open(String url) => launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);

/// Lề ngang chung của các section trang chủ.
const _gutter = 20.0;

// -----------------------------------------------------------------------------
// Thành phần dùng chung
// -----------------------------------------------------------------------------

/// Tiêu đề section: nhãn nhỏ (eyebrow) + tiêu đề + mô tả.
class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.eyebrow, required this.title, this.subtitle});

  final String eyebrow;
  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Eyebrow(eyebrow),
        const SizedBox(height: 12),
        Text(title, style: Tw.xl3(c: Tw.gray900, w: FontWeight.w800)),
        if (subtitle != null) ...[
          const SizedBox(height: 8),
          Text(subtitle!, style: Tw.base(c: Tw.gray500)),
        ],
      ],
    );
  }
}

class _Eyebrow extends StatelessWidget {
  const _Eyebrow(this.text, {this.dark = false});

  final String text;
  final bool dark;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: dark ? Colors.white.withValues(alpha: 0.14) : Tw.blue50,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: dark ? Colors.white.withValues(alpha: 0.2) : Tw.blue100),
      ),
      child: Text(
        text.toUpperCase(),
        style: Tw.xs(c: dark ? Colors.white : Tw.blue700, w: Tw.bold).copyWith(letterSpacing: 0.8),
      ),
    );
  }
}

/// Ô icon bo góc nền xanh nhạt.
class _IconTile extends StatelessWidget {
  const _IconTile(this.icon, {this.size = 44});

  final HeroIcons icon;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: Tw.blue50, borderRadius: BorderRadius.circular(size * 0.32)),
      child: Center(child: HeroIcon(icon, size: size * 0.5, color: Tw.blue600)),
    );
  }
}

/// Thẻ trắng bo góc 20 có viền mờ + bóng mềm.
class _Panel extends StatelessWidget {
  const _Panel({required this.child, this.padding = const EdgeInsets.all(20)});

  final Widget child;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0x0F0F2A5C)),
        boxShadow: Tw.shadowMd,
      ),
      child: child,
    );
  }
}

/// Nút bấm gradient / viền dùng trong trang chủ.
class _HomeButton extends StatelessWidget {
  const _HomeButton({required this.label, required this.onTap, this.icon, this.style = _BtnStyle.primary});

  final String label;
  final VoidCallback onTap;
  final IconData? icon;
  final _BtnStyle style;

  @override
  Widget build(BuildContext context) {
    final (bg, gradient, fg, border, shadow) = switch (style) {
      _BtnStyle.primary => (null, Mui.buttonGradient, Colors.white, null, Tw.glow(Mui.accent)),
      _BtnStyle.white => (Colors.white, null, Mui.primary, null, Tw.shadowLg),
      _BtnStyle.glass => (Colors.white.withValues(alpha: 0.12), null, Colors.white, Colors.white.withValues(alpha: 0.3), null),
      _BtnStyle.outline => (Colors.white, null, Mui.secondary, Tw.blue200, null),
    };
    return PressScale(
      child: Container(
        decoration: BoxDecoration(
          color: bg,
          gradient: gradient,
          borderRadius: BorderRadius.circular(14),
          border: border == null ? null : Border.all(color: border, width: 1.4),
          boxShadow: shadow,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: onTap,
            child: Container(
              height: 50,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              alignment: Alignment.center,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(label, maxLines: 1, style: Tw.base(c: fg, w: Tw.semibold)),
                    ),
                  ),
                  if (icon != null) ...[const SizedBox(width: 6), Icon(icon, size: 19, color: fg)],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

enum _BtnStyle { primary, white, glass, outline }

/// Lưới N cột, các ô trong một hàng cao bằng nhau.
class _Grid extends StatelessWidget {
  const _Grid({required this.columns, required this.gap, required this.children});

  final int columns;
  final double gap;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final rows = <Widget>[];
    for (var i = 0; i < children.length; i += columns) {
      final cells = <Widget>[];
      for (var j = 0; j < columns; j++) {
        if (j > 0) cells.add(SizedBox(width: gap));
        cells.add(Expanded(child: i + j < children.length ? children[i + j] : const SizedBox()));
      }
      if (rows.isNotEmpty) rows.add(SizedBox(height: gap));
      rows.add(IntrinsicHeight(child: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: cells)));
    }
    return Column(children: rows);
  }
}

// -----------------------------------------------------------------------------
// BannerSlideshow
// -----------------------------------------------------------------------------

class BannerSlideshow extends StatefulWidget {
  const BannerSlideshow({super.key});

  @override
  State<BannerSlideshow> createState() => _BannerSlideshowState();
}

class _BannerSlideshowState extends State<BannerSlideshow> {
  static const _banners = [
    (
      'Cuộc Thi Lập Trình 2025',
      'Thách thức coding hấp dẫn nhất năm',
      'https://scontent.fsgn2-4.fna.fbcdn.net/v/t39.30808-6/492537042_1238852174906685_7413700368025108558_n.jpg?_nc_cat=101&ccb=1-7&_nc_sid=cc71e4&_nc_eui2=AeGYwuWS2EPq20J7j3jndx6V6ZtZoo9cSQ3pm1mij1xJDS39nR3ecQ_aSUdsd7ngWWHwjrDsmSwkr0NUbkqeRfqy&_nc_ohc=ACy8-bc2_00Q7kNvwG7yCNM&_nc_oc=AdnNan77c1lWy0aZgnc8jFPrsQjSmlHmrtWTQlnRxizBuBszVmSTEkSzdUqweL54hBvYdXd2CqZixXf5-hTs_25h&_nc_zt=23&_nc_ht=scontent.fsgn2-4.fna&_nc_gid=rCNxYXsifdJ1QaIt2U0m0g&oh=00_AfPlwyspMYSMudTMKInjYbFWOllydkeLeII48ikI3hwFVw&oe=68629277',
    ),
    (
      'Giải Thưởng >10 Triệu VNĐ',
      'Cơ hội nhận học bổng và quà tặng giá trị',
      'https://cdn-i2.congthuong.vn/stores/news_dataimages/2025/042025/18/08/in_article/a220250418084500.jpg?rt=20250418172414',
    ),
    (
      'Kết Nối Cộng Đồng Dev',
      'Gặp gỡ và học hỏi từ các lập trình viên hàng đầu',
      'https://scontent.fsgn2-9.fna.fbcdn.net/v/t39.30808-6/498029065_1255968949861674_8110738499065592051_n.jpg?_nc_cat=103&ccb=1-7&_nc_sid=127cfc&_nc_eui2=AeEd_rR098NRaIovUyseB4MkVcqIYsZvxt5Vyohixm_G3rdfoSF53HhP5Ja3-p_M4FM3dgF9XBmlov6EFXcgZXRA&_nc_ohc=zfcUMML86CwQ7kNvwFcDvNN&_nc_oc=Adlr77JOcQyJ8ITEiMiKlE0H_2Gp-NBzINRKZFSgCa76EkXKOnJWopFHQMkqUnE6S0uQiHdgXU9YRt2ufn_qtmIe&_nc_zt=23&_nc_ht=scontent.fsgn2-9.fna&_nc_gid=87UhjXsN8023Trc-az4o7g&oh=00_AfN2Yq2Qeunl_iM_7X3AHUjAz4H_GXuF4ZxqSxLvHGBMFg&oe=6862A143',
    ),
    (
      'Công Nghệ Mới Nhất',
      'Thử thách với các framework và tools hiện đại',
      'https://images.unsplash.com/photo-1461749280684-dccba630e2f6?w=1200&h=400&fit=crop',
    ),
    (
      'Cơ Hội Nghề Nghiệp',
      'Mở ra con đường sự nghiệp lập trình viên chuyên nghiệp',
      'https://images.unsplash.com/photo-1516321318423-f06f85e504b3?w=1200&h=400&fit=crop',
    ),
  ];

  int _current = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _restart();
  }

  void _restart() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 5), (_) => setState(() => _current = (_current + 1) % _banners.length));
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _go(int i) {
    setState(() => _current = (i + _banners.length) % _banners.length);
    _restart();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(_gutter, 16, _gutter, 8),
      child: GestureDetector(
        // Vuốt ngang để chuyển banner.
        onHorizontalDragEnd: (d) {
          final v = d.primaryVelocity ?? 0;
          if (v.abs() > 120) _go(_current + (v < 0 ? 1 : -1));
        },
        child: AspectRatio(
          aspectRatio: 4 / 3,
          child: Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(24), boxShadow: Tw.shadowXl),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  const ColoredBox(color: Mui.primary),
                  for (var i = 0; i < _banners.length; i++)
                    IgnorePointer(
                      ignoring: i != _current,
                      child: AnimatedOpacity(
                        duration: const Duration(milliseconds: 700),
                        curve: Curves.easeInOut,
                        opacity: i == _current ? 1 : 0,
                        child: AnimatedScale(
                          duration: const Duration(milliseconds: 5000),
                          scale: i == _current ? 1.06 : 1,
                          child: Image.network(_banners[i].$3, fit: BoxFit.cover, errorBuilder: (_, _, _) => const SizedBox()),
                        ),
                      ),
                    ),
                  // Phủ tối dần xuống dưới để chữ luôn đọc rõ.
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Color(0x00002550), Color(0x40002550), Color(0xE6001A3D)],
                        stops: [0.25, 0.55, 1],
                      ),
                    ),
                  ),
                  Positioned(
                    left: 20,
                    right: 20,
                    bottom: 20,
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 450),
                      // Chỉ hiện chữ của banner mới, tránh hai đoạn chữ chồng lên nhau.
                      layoutBuilder: (current, _) => current ?? const SizedBox(),
                      transitionBuilder: (child, a) => FadeTransition(
                        opacity: a,
                        child: SlideTransition(
                          position: Tween(begin: const Offset(0, 0.15), end: Offset.zero).animate(a),
                          child: child,
                        ),
                      ),
                      child: Column(
                        key: ValueKey(_current),
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const _Eyebrow('Olympic Tin học 2025', dark: true),
                          const SizedBox(height: 10),
                          Text(_banners[_current].$1, style: Tw.xl2(c: Colors.white, w: FontWeight.w800)),
                          const SizedBox(height: 6),
                          Text(_banners[_current].$2, style: Tw.sm(c: Colors.white.withValues(alpha: 0.85))),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              for (var i = 0; i < _banners.length; i++)
                                GestureDetector(
                                  onTap: () => _go(i),
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 300),
                                    margin: const EdgeInsets.only(right: 6),
                                    width: i == _current ? 24 : 8,
                                    height: 8,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(999),
                                      color: i == _current ? Colors.white : Colors.white.withValues(alpha: 0.4),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// VideoSection
// -----------------------------------------------------------------------------

class VideoSection extends StatefulWidget {
  const VideoSection({super.key});

  @override
  State<VideoSection> createState() => _VideoSectionState();
}

class _VideoSectionState extends State<VideoSection> {
  /// null khi nền tảng không hỗ trợ WebView (vd. khi chạy test).
  late final WebViewController? _web = _createWebView();

  WebViewController? _createWebView() {
    try {
      return _buildWebView();
    } catch (_) {
      return null;
    }
  }

  static const _videoId = 'sF3odX1YNOI';

  /// YouTube bắt buộc player nhúng gửi kèm Referer định danh ứng dụng, nếu không sẽ
  /// báo "Lỗi 153" và chỉ hiện nút "Xem trên YouTube". Với WebView, YouTube khuyến nghị
  /// dùng `https://<application id>` làm origin của trang chứa iframe.
  static const _appOrigin = 'https://com.example.test_datn';

  WebViewController _buildWebView() => WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..setBackgroundColor(Tw.gray900)
    ..setNavigationDelegate(NavigationDelegate(
      // Link bấm trong player (logo, "Xem trên YouTube", video đề xuất) mở bằng app YouTube,
      // không để WebView điều hướng mất player.
      onNavigationRequest: (req) {
        if (!req.isMainFrame || req.url.startsWith(_appOrigin) || req.url == 'about:blank') {
          return NavigationDecision.navigate;
        }
        _open(req.url);
        return NavigationDecision.prevent;
      },
    ))
    ..loadHtmlString(
      '<!DOCTYPE html><html><head><meta name="viewport" content="width=device-width,initial-scale=1">'
      '<meta name="referrer" content="strict-origin-when-cross-origin">'
      '<style>html,body{margin:0;padding:0;background:#0F172A;height:100%;overflow:hidden}'
      'iframe{position:absolute;inset:0;width:100%;height:100%;border:0}</style></head><body>'
      '<iframe src="https://www.youtube.com/embed/$_videoId?playsinline=1&rel=0&origin=$_appOrigin" '
      'title="YouTube video player" referrerpolicy="strict-origin-when-cross-origin" '
      'allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" '
      'allowfullscreen></iframe></body></html>',
      baseUrl: _appOrigin,
    );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(_gutter, 20, _gutter, 8),
      child: _Panel(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(4, 2, 4, 12),
              child: Row(
                children: [
                  const _IconTile(HeroIcons.play, size: 40),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Giới thiệu cuộc thi', style: Tw.base(c: Tw.gray900, w: Tw.bold)),
                        Text('Hướng dẫn tham gia chi tiết', style: Tw.xs(c: Tw.gray500)),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                    decoration: BoxDecoration(color: Tw.red50, borderRadius: BorderRadius.circular(999)),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TwPulse(
                          child: Container(
                            width: 7,
                            height: 7,
                            decoration: const BoxDecoration(color: Tw.red500, shape: BoxShape.circle),
                          ),
                        ),
                        const SizedBox(width: 5),
                        Text('LIVE', style: Tw.xs(c: Tw.red600, w: Tw.bold).copyWith(letterSpacing: 0.6)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: _web != null
                    ? WebViewWidget(controller: _web)
                    : GestureDetector(
                        onTap: () => _open('https://www.youtube.com/watch?v=$_videoId'),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            const ColoredBox(color: Tw.gray900),
                            Image.network('https://img.youtube.com/vi/$_videoId/hqdefault.jpg',
                                fit: BoxFit.cover, errorBuilder: (_, _, _) => const SizedBox()),
                            const Center(child: Icon(Icons.play_circle_fill, size: 64, color: Colors.white)),
                          ],
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 12),
            _HomeButton(
              label: 'Xem thêm video',
              icon: Icons.arrow_outward_rounded,
              style: _BtnStyle.outline,
              onTap: () => _open('https://www.youtube.com/@OlympicTinh%E1%BB%8DcC%C4%90KTCaoTh%E1%BA%AFng'),
            ),
          ],
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// HeroSection
// -----------------------------------------------------------------------------

class HeroSection extends StatelessWidget {
  const HeroSection({super.key, required this.onJoin, required this.onLearnMore});

  final VoidCallback onJoin;
  final VoidCallback onLearnMore;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(_gutter, 28, _gutter, 8),
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          gradient: Mui.pageGradient,
          borderRadius: BorderRadius.circular(28),
          boxShadow: const [BoxShadow(color: Color(0x40003A70), offset: Offset(0, 20), blurRadius: 40, spreadRadius: -12)],
        ),
        child: Stack(
          children: [
            Positioned(
              top: -60,
              right: -60,
              child: Container(
                width: 220,
                height: 220,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(colors: [Color(0x663B8BFF), Color(0x003B8BFF)]),
                ),
              ),
            ),
            const Positioned(
              right: 22,
              top: 26,
              child: TwBounce(distance: 0.12, child: HeroIcon(HeroIcons.trophy, size: 40, color: Color(0x66FFFFFF))),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _Eyebrow('Mùa giải 2025', dark: true),
                  const SizedBox(height: 16),
                  Text('Cuộc thi\nOlympic Tin học', style: Tw.xl3(c: Colors.white, w: FontWeight.w800)),
                  const SizedBox(height: 12),
                  Text(
                    'Nơi những tài năng lập trình hội tụ, thách thức bản thân và chinh phục những đỉnh cao công nghệ.',
                    style: Tw.base(c: Colors.white.withValues(alpha: 0.8)).copyWith(height: 1.6),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: _HomeButton(
                          label: 'Tham gia ngay',
                          icon: Icons.arrow_forward_rounded,
                          style: _BtnStyle.white,
                          onTap: onJoin,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(child: _HomeButton(label: 'Xem thể lệ', style: _BtnStyle.glass, onTap: onLearnMore)),
                    ],
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

// -----------------------------------------------------------------------------
// StatsSection
// -----------------------------------------------------------------------------

class StatsSection extends StatelessWidget {
  const StatsSection({super.key});

  static const _stats = [
    (HeroIcons.users, '1000+', 'Thí sinh tham gia'),
    (HeroIcons.buildingLibrary, '16+', 'Lớp từ các khoa'),
    (HeroIcons.gift, '10M+', 'Tổng giải thưởng'),
    (HeroIcons.faceSmile, '95%', 'Tỷ lệ hài lòng'),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(_gutter, 16, _gutter, 8),
      child: _Grid(
        columns: 2,
        gap: 12,
        children: [
          for (final (icon, n, label) in _stats)
            _Panel(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _IconTile(icon, size: 36),
                  const SizedBox(height: 14),
                  Text(n, style: Tw.xl2(c: Mui.primary, w: FontWeight.w800)),
                  const SizedBox(height: 2),
                  Text(label, style: Tw.sm(c: Tw.gray500)),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// ContestRulesSection
// -----------------------------------------------------------------------------

class ContestRulesSection extends StatelessWidget {
  const ContestRulesSection({super.key});

  @override
  Widget build(BuildContext context) {
    const info = [
      (HeroIcons.users, 'Đối tượng tham gia', 'Tất cả các lớp thuộc khoa CNTT'),
      (
        HeroIcons.calendarDays,
        'Thời gian tổ chức',
        '24/03 - 30/03: Vòng sơ loại • 31/03 - 13/04: Tứ kết & Bán kết • 14/04 - 20/04: Chung kết'
      ),
      (
        HeroIcons.bookOpen,
        '8 Lĩnh vực kiến thức',
        'Lập trình C/C++, CSDL, Phần cứng & Mạng, Ứng dụng CNTT, Thiết kế Website, Công nghệ phần mềm, Tin tức công nghệ, Anh văn chuyên ngành'
      ),
    ];
    const rounds = [
      (HeroIcons.academicCap, 'Vòng sơ loại', 'Thi trực tiếp tại lớp', '30 câu hỏi trắc nghiệm • Chọn 20 thí sinh xuất sắc nhất'),
      (
        HeroIcons.play,
        'Tứ kết & Bán kết',
        'Đấu trường số',
        'Video giới thiệu đội • 13 câu hỏi 4 mức độ • Chọn 60 thí sinh vào chung kết'
      ),
      (
        HeroIcons.trophy,
        'Chung kết',
        'Đấu trường số',
        'Tranh tài quyết liệt • Chọn 3 thí sinh xuất sắc nhất • Cơ hội nhận nút GOLD'
      ),
    ];
    const levels = [
      ('Alpha', 4, '15s', Tw.green50, Tw.green700, Tw.green200),
      ('Beta', 4, '20s', Tw.blue50, Tw.blue700, Tw.blue200),
      ('RC', 4, '30s', Tw.purple50, Tw.purple700, Tw.purple100),
      ('GOLD', 1, '30s', Tw.amber50, Tw.amber700, Tw.amber200),
    ];
    const prizes = [
      ('Giải Nhất', '3.000.000đ', '🥇'),
      ('Giải Nhì', '2.000.000đ', '🥈'),
      ('Giải Ba', '1.000.000đ', '🥉'),
      ('Video ấn tượng', '1.000.000đ', '🎬'),
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(_gutter, 48, _gutter, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const _SectionHeader(
            eyebrow: 'Thể lệ',
            title: 'Thể lệ cuộc thi',
            subtitle: 'Olympic Tin Học 2025 - Đấu Trường Số',
          ),
          const SizedBox(height: 20),
          _Panel(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
            child: Column(
              children: [
                for (var i = 0; i < info.length; i++)
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      border: i == 0 ? null : const Border(top: BorderSide(color: Tw.gray100)),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _IconTile(info[i].$1, size: 40),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(info[i].$2, style: Tw.base(c: Tw.gray900, w: Tw.bold)),
                              const SizedBox(height: 4),
                              Text(info[i].$3, style: Tw.sm(c: Tw.gray500).copyWith(height: 1.55)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 36),
          Text('Các vòng thi', style: Tw.xl(c: Tw.gray900, w: FontWeight.w800)),
          const SizedBox(height: 14),
          for (var i = 0; i < rounds.length; i++) ...[
            _Panel(
              padding: const EdgeInsets.all(18),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      gradient: Mui.buttonGradient,
                      borderRadius: BorderRadius.circular(13),
                      boxShadow: Tw.glow(Mui.accent),
                    ),
                    child: Center(child: HeroIcon(rounds[i].$1, size: 20, color: Colors.white)),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Vòng ${i + 1}', style: Tw.xs(c: Tw.blue600, w: Tw.bold).copyWith(letterSpacing: 0.4)),
                        Text(rounds[i].$2, style: Tw.lg(c: Tw.gray900, w: Tw.bold)),
                        const SizedBox(height: 8),
                        TwPillLite(rounds[i].$3),
                        const SizedBox(height: 10),
                        Text(rounds[i].$4, style: Tw.sm(c: Tw.gray500).copyWith(height: 1.55)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
          ],
          const SizedBox(height: 24),
          Text('Hình thức "Đấu trường số"', style: Tw.xl(c: Tw.gray900, w: FontWeight.w800)),
          const SizedBox(height: 14),
          _Panel(
            child: Column(
              children: [
                _Grid(
                  columns: 2,
                  gap: 10,
                  children: [
                    for (final (name, q, time, bg, fg, border) in levels)
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: bg,
                          border: Border.all(color: border),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(name, style: Tw.lg(c: fg, w: FontWeight.w800)),
                            const SizedBox(height: 6),
                            Text('$q câu hỏi', style: Tw.sm(c: fg)),
                            Text('$time / câu', style: Tw.sm(c: fg, w: Tw.semibold)),
                          ],
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(color: Tw.gray50, borderRadius: BorderRadius.circular(14)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text.rich(
                        TextSpan(
                          style: Tw.sm(c: Tw.gray600).copyWith(height: 1.55),
                          children: const [
                            TextSpan(text: 'Đặc biệt:', style: TextStyle(fontWeight: FontWeight.w700, color: Tw.gray900)),
                            TextSpan(text: ' Có tính năng "Cứu trợ hồi sinh" và "Phao cứu trợ"'),
                          ],
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text.rich(
                        TextSpan(
                          style: Tw.sm(c: Tw.gray600).copyWith(height: 1.55),
                          children: [
                            const TextSpan(text: 'Thí sinh nhận nút '),
                            WidgetSpan(
                              alignment: PlaceholderAlignment.middle,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                                decoration: BoxDecoration(color: Tw.amber200, borderRadius: BorderRadius.circular(6)),
                                child: Text('GOLD', style: Tw.xs(c: Tw.amber700, w: FontWeight.w800)),
                              ),
                            ),
                            const TextSpan(text: ' sẽ được vòng nguyệt quế và phần thưởng đặc biệt'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 36),
          Text('Giải thưởng', style: Tw.xl(c: Tw.gray900, w: FontWeight.w800)),
          const SizedBox(height: 14),
          _Grid(
            columns: 2,
            gap: 12,
            children: [
              for (final (rank, amount, icon) in prizes)
                _Panel(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(color: Tw.amber50, borderRadius: BorderRadius.circular(14)),
                        child: Center(child: Text(icon, style: const TextStyle(fontSize: 24))),
                      ),
                      const SizedBox(height: 12),
                      Text(rank, style: Tw.sm(c: Tw.gray500, w: Tw.semibold)),
                      const SizedBox(height: 2),
                      Text(amount, style: Tw.lg(c: Mui.primary, w: FontWeight.w800)),
                      Text('+ Giấy khen', style: Tw.xs(c: Tw.gray400)),
                    ],
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Nhãn nhỏ nền xanh nhạt.
class TwPillLite extends StatelessWidget {
  const TwPillLite(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: Tw.blue50, borderRadius: BorderRadius.circular(999)),
      child: Text(text, style: Tw.xs(c: Tw.blue700, w: Tw.semibold)),
    );
  }
}

// -----------------------------------------------------------------------------
// TimelineSection
// -----------------------------------------------------------------------------

class TimelineSection extends StatelessWidget {
  const TimelineSection({super.key});

  static const _timeline = [
    ('03/04/2025', 'Tứ kết 1 - Tứ kết 2', '...', HeroIcons.userPlus),
    ('04/04/2025', 'Tứ kết 3 - Tứ kết 4', '...', HeroIcons.clock),
    ('09/04/2025', 'Bán kết 1- Bán kết 2 - bán kết 3', '...', HeroIcons.computerDesktop),
    ('17/04/2025', 'Vòng chung kết', 'Thi đấu trực tiếp tại trường, tranh tài các giải thưởng', HeroIcons.academicCap),
    ('17/04/2025', 'Lễ trao giải', 'Trao giải thưởng và chứng nhận cho các thí sinh xuất sắc', HeroIcons.trophy),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(_gutter, 48, _gutter, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const _SectionHeader(eyebrow: 'Lịch trình', title: 'Lịch trình cuộc thi'),
          const SizedBox(height: 20),
          for (var i = 0; i < _timeline.length; i++) _row(i),
        ],
      ),
    );
  }

  Widget _row(int i) {
    final (date, title, desc, icon) = _timeline[i];
    final last = i == _timeline.length - 1;
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Cột mốc + đường nối dọc
          SizedBox(
            width: 44,
            child: Column(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    gradient: Mui.buttonGradient,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 3),
                    boxShadow: Tw.glow(Mui.accent),
                  ),
                  child: Center(child: HeroIcon(icon, size: 19, color: Colors.white)),
                ),
                if (!last)
                  Expanded(
                    child: Container(
                      width: 2,
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      decoration: BoxDecoration(color: Tw.blue200, borderRadius: BorderRadius.circular(2)),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: last ? 0 : 14),
              child: _Panel(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(child: Text(date, style: Tw.xs(c: Tw.blue600, w: Tw.bold).copyWith(letterSpacing: 0.3))),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(color: Tw.green50, borderRadius: BorderRadius.circular(999)),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const HeroIcon(HeroIcons.checkCircle, size: 12, color: Tw.green700),
                              const SizedBox(width: 4),
                              Text('Hoàn thành', style: Tw.xs(c: Tw.green700, w: Tw.semibold)),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(title, style: Tw.base(c: Tw.gray900, w: Tw.bold)),
                    if (desc != '...') ...[
                      const SizedBox(height: 4),
                      Text(desc, style: Tw.sm(c: Tw.gray500).copyWith(height: 1.55)),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// SponsorsSection
// -----------------------------------------------------------------------------

class SponsorsSection extends StatelessWidget {
  const SponsorsSection({super.key});

  static const _sponsors = [
    (
      'Nvidia',
      'https://th.bing.com/th/id/R.86fd08d25f7cb15216a8de0a5013bbcf?rik=L5x9K9A0pPWa1Q&riu=http%3a%2f%2flogos-download.com%2fwp-content%2fuploads%2f2016%2f10%2fNvidia_logo.png&ehk=Co0aePG6%2f4gh4I1tSSeqEuAQF%2bozxkbbtgm0CUJazrA%3d&risl=&pid=ImgRaw&r=0',
      'gold',
      'https://www.nvidia.com/en-us/drivers/'
    ),
    ('Lexar', 'https://th.bing.com/th/id/OIP.EOs7xmX6kpb872r9Q6mQ8wHaB-?r=0&rs=1&pid=ImgDetMain', 'silver', 'https://www.lexar.com/global/'),
    ('Smnet', 'https://smnet.vn/wp-content/uploads/2024/11/logo-smnet-2024.png', 'silver', 'https://smnet.vn/en/'),
    (
      'Tin học đại dương',
      'https://th.bing.com/th/id/OIP.JQ57f2ePcXF22b9-0hL3kwHaHa?r=0&rs=1&pid=ImgDetMain',
      'silver',
      'https://tinhocdaiduong.vn/'
    ),
    ('Nguyễn Thuận Computer', 'https://thuancomputer.com/wp-content/uploads/2024/07/logo-to-hai.png', 'silver', 'https://thuancomputer.com/'),
    ('Anta6', 'https://anta6.com/wp-content/uploads/2025/03/1-1.png', 'bronze', 'https://anta6.com/'),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(_gutter, 48, _gutter, 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const _SectionHeader(
            eyebrow: 'Đối tác',
            title: 'Nhà tài trợ',
            subtitle: 'Chân thành cảm ơn các đối tác đã đồng hành cùng cuộc thi lập trình',
          ),
          const SizedBox(height: 20),
          _tier('gold', 'Nhà tài trợ Vàng', Tw.amber500, 1),
          const SizedBox(height: 20),
          _tier('silver', 'Nhà tài trợ Bạc', Tw.gray400, 2),
          const SizedBox(height: 20),
          _tier('bronze', 'Nhà tài trợ Đồng', Tw.orange400, 2),
          const SizedBox(height: 28),
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(gradient: Mui.pageGradient, borderRadius: BorderRadius.circular(24)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const HeroIcon(HeroIcons.sparkles, size: 28, color: Tw.blue200),
                const SizedBox(height: 12),
                Text('Trở thành nhà tài trợ', style: Tw.xl(c: Colors.white, w: FontWeight.w800)),
                const SizedBox(height: 8),
                Text(
                  'Tham gia cùng chúng tôi để hỗ trợ cộng đồng lập trình viên Việt Nam và quảng bá thương hiệu của bạn',
                  style: Tw.sm(c: Colors.white.withValues(alpha: 0.78)).copyWith(height: 1.55),
                ),
                const SizedBox(height: 18),
                _HomeButton(
                  label: 'Liên hệ tài trợ',
                  icon: Icons.arrow_forward_rounded,
                  style: _BtnStyle.white,
                  onTap: () => _open('https://cntt.caothang.edu.vn'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _tier(String tier, String title, Color medal, int columns) {
    final list = _sponsors.where((s) => s.$3 == tier).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Container(width: 10, height: 10, decoration: BoxDecoration(color: medal, shape: BoxShape.circle)),
            const SizedBox(width: 8),
            Text(title, style: Tw.sm(c: Tw.gray700, w: Tw.bold)),
          ],
        ),
        const SizedBox(height: 10),
        _Grid(
          columns: columns,
          gap: 10,
          children: [
            for (final s in list)
              PressScale(
                child: GestureDetector(
                  onTap: () => _open(s.$4),
                  child: Container(
                    height: columns == 1 ? 96 : 76,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Tw.gray200),
                    ),
                    child: Image.network(
                      s.$2,
                      fit: BoxFit.contain,
                      errorBuilder: (_, _, _) => Center(
                        child: Text(s.$1, textAlign: TextAlign.center, style: Tw.sm(c: Tw.gray500, w: Tw.semibold)),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}

// -----------------------------------------------------------------------------
// Footer
// -----------------------------------------------------------------------------

class HomeFooter extends StatelessWidget {
  const HomeFooter({super.key});

  @override
  Widget build(BuildContext context) {
    const url = 'https://cntt.caothang.edu.vn';
    final muted = Colors.white.withValues(alpha: 0.6);
    Widget heading(String t) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Text(t, style: Tw.sm(c: Colors.white, w: Tw.bold)),
        );
    Widget link(String t, String href) => Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: GestureDetector(onTap: () => _open(href), child: Text(t, style: Tw.sm(c: muted))),
        );

    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF071A33),
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: EdgeInsets.fromLTRB(24, 36, 24, 28 + MediaQuery.of(context).padding.bottom),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                child: const CaoThangLogo(width: 26, height: 34),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Olympic Tin học 2025', style: Tw.base(c: Colors.white, w: FontWeight.w800)),
                  Text('Khoa Công nghệ Thông tin', style: Tw.xs(c: muted)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 18),
          Text(
            'Cuộc thi Olympic Tin học 2025 do Khoa Công nghệ Thông tin, Trường Cao đẳng Kỹ Thuật Cao Thắng tổ chức nhằm tạo sân chơi bổ ích cho sinh viên đam mê công nghệ thông tin.',
            style: Tw.sm(c: muted).copyWith(height: 1.6),
          ),
          const SizedBox(height: 28),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    heading('Liên kết nhanh'),
                    for (final t in ['Trang chủ', 'Giới thiệu', 'Đào tạo', 'Tuyển sinh']) link(t, url),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    heading('Chương trình'),
                    for (final t in ['Công nghệ Phần mềm', 'Quản trị mạng', 'Mạng máy tính', 'Sửa chữa máy tính']) link(t, url),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          heading('Theo dõi chúng tôi'),
          Row(
            children: [
              for (final icon in [Icons.facebook_rounded, Icons.language_rounded, Icons.smart_display_rounded]) ...[
                PressScale(
                  child: GestureDetector(
                    onTap: () => _open('https://www.facebook.com/cntt.caothang.edu.vn'),
                    child: Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
                      ),
                      child: Icon(icon, size: 20, color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
              ],
            ],
          ),
          const SizedBox(height: 28),
          Container(
            padding: const EdgeInsets.only(top: 20),
            width: double.infinity,
            decoration: BoxDecoration(border: Border(top: BorderSide(color: Colors.white.withValues(alpha: 0.1)))),
            child: Text(
              '© 2025 Olympic Tin Học - Khoa Công nghệ Thông tin.',
              textAlign: TextAlign.center,
              style: Tw.xs(c: Colors.white.withValues(alpha: 0.45)),
            ),
          ),
        ],
      ),
    );
  }
}
