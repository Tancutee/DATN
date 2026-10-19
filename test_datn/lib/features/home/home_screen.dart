import 'dart:math';
import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../app_routes.dart';
import '../../core/theme/tw.dart';
import '../../core/widgets/mui.dart';
import '../../core/widgets/notify.dart';
import '../audience/screens/audience_entry_screen.dart';
import '../auth/auth_models.dart';
import '../auth/auth_provider.dart';
import 'chatbot_widget.dart';
import 'home_sections.dart';
import 'server_settings_screen.dart';

/// Logo Cao Thắng (`assets/image/logo/logo-caothang.svg` của FE).
class CaoThangLogo extends StatelessWidget {
  const CaoThangLogo({super.key, required this.width, required this.height});

  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ClipRect(child: SvgPicture.asset('assets/images/logo-caothang.svg', fit: BoxFit.cover)),
    );
  }
}

/// Trang chủ — `features/home/pages/HomePage.tsx` + `layouts/HomeLayout`.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _NavItem {
  const _NavItem(this.name, this.id);

  final String name;
  final String id;
}

class _HomeScreenState extends State<HomeScreen> {
  final _scroll = ScrollController();
  final _keys = {
    for (final id in ['home', 'contest', 'rules', 'timeline', 'sponsors']) id: GlobalKey(),
  };

  static const _navItems = [
    _NavItem('Trang chủ', 'home'),
    _NavItem('Cuộc thi', 'contest'),
    _NavItem('Thể lệ thi', 'rules'),
    _NavItem('Lịch trình', 'timeline'),
    _NavItem('Nhà tài trợ', 'sponsors'),
  ];

  bool _scrolled = false;
  bool _mobileMenu = false;
  bool _userMenu = false;
  bool _loginMenu = false;
  String _active = 'home';

  @override
  void initState() {
    super.initState();
    _scroll.addListener(() {
      final s = _scroll.offset > 20;
      if (s != _scrolled) setState(() => _scrolled = s);
    });
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  void _closeMenus() => setState(() {
    _userMenu = false;
    _loginMenu = false;
    _mobileMenu = false;
  });

  void _navClick(_NavItem item) {
    setState(() {
      _active = item.id;
      _mobileMenu = false;
    });
    final ctx = _keys[item.id]?.currentContext;
    if (ctx != null) {
      Scrollable.ensureVisible(ctx, duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final top = MediaQuery.of(context).padding.top;
    const headerH = 64.0;

    return Scaffold(
      body: Stack(
        children: [
          const Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFFEAF2FF), Mui.background, Mui.background],
                  stops: [0, 0.35, 1],
                ),
              ),
            ),
          ),
          const Positioned.fill(child: IgnorePointer(child: BackgroundDots())),
          SingleChildScrollView(
            controller: _scroll,
            child: DefaultTextStyle.merge(
              style: Tw.base(c: Tw.gray800),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: headerH + top),
                  KeyedSubtree(
                    key: _keys['home'],
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [BannerSlideshow(), VideoSection()],
                    ),
                  ),
                  KeyedSubtree(
                    key: _keys['contest'],
                    child: HeroSection(
                      onJoin: () =>
                          auth.user?.role == UserRole.judge ? AppRoutes.judgeContests() : AppRoutes.studentLogin(),
                      onLearnMore: () => _navClick(_navItems[2]),
                    ),
                  ),
                  const StatsSection(),
                  KeyedSubtree(key: _keys['rules'], child: const ContestRulesSection()),
                  KeyedSubtree(key: _keys['timeline'], child: const TimelineSection()),
                  KeyedSubtree(key: _keys['sponsors'], child: const SponsorsSection()),
                  const HomeFooter(),
                ],
              ),
            ),
          ),
          // Header cố định
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: _Header(
              scrolled: _scrolled,
              height: headerH,
              topInset: top,
              auth: auth,
              userMenuOpen: _userMenu,
              loginMenuOpen: _loginMenu,
              mobileMenuOpen: _mobileMenu,
              onUserMenu: () => setState(() {
                _userMenu = !_userMenu;
                _loginMenu = false;
              }),
              onLoginMenu: () => setState(() {
                _loginMenu = !_loginMenu;
                _userMenu = false;
              }),
              onMobileMenu: () => setState(() {
                _mobileMenu = !_mobileMenu;
                _userMenu = false;
                _loginMenu = false;
              }),
            ),
          ),
          if (_userMenu || _loginMenu)
            Positioned.fill(
              child: GestureDetector(behavior: HitTestBehavior.opaque, onTap: _closeMenus),
            ),
          if (_userMenu && auth.user != null)
            Positioned(
              top: top + headerH + 4,
              right: 16,
              child: _UserDropdown(user: auth.user!, onClose: _closeMenus),
            ),
          if (_loginMenu && auth.user == null)
            Positioned(
              top: top + headerH + 4,
              right: 16,
              child: _LoginDropdown(onClose: _closeMenus),
            ),
          // Menu mobile
          _MobileMenu(
            open: _mobileMenu,
            items: _navItems,
            active: _active,
            showLogin: auth.status == AuthStatus.unauthenticated,
            onClose: () => setState(() => _mobileMenu = false),
            onNav: _navClick,
          ),
          if (!_mobileMenu) const OlympicChatbotWidget(),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// Header
// -----------------------------------------------------------------------------

class _Header extends StatelessWidget {
  const _Header({
    required this.scrolled,
    required this.height,
    required this.topInset,
    required this.auth,
    required this.userMenuOpen,
    required this.loginMenuOpen,
    required this.mobileMenuOpen,
    required this.onUserMenu,
    required this.onLoginMenu,
    required this.onMobileMenu,
  });

  final bool scrolled;
  final double height;
  final double topInset;
  final AuthProvider auth;
  final bool userMenuOpen;
  final bool loginMenuOpen;
  final bool mobileMenuOpen;
  final VoidCallback onUserMenu;
  final VoidCallback onLoginMenu;
  final VoidCallback onMobileMenu;

  @override
  Widget build(BuildContext context) {
    final user = auth.user;
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: scrolled ? 0.86 : 0.6),
            border: Border(bottom: BorderSide(color: scrolled ? Tw.gray200 : Colors.transparent)),
          ),
          padding: EdgeInsets.only(top: topInset),
          child: SizedBox(
            height: height,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Tw.gray200),
                    ),
                    child: const CaoThangLogo(width: 30, height: 30),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Olympic Tin học',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Tw.base(c: Mui.primary, w: FontWeight.w800).copyWith(letterSpacing: -0.3),
                        ),
                        Text(
                          'Khoa CNTT · 2025',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Tw.xs(c: Tw.gray500, w: Tw.medium),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  if (auth.status != AuthStatus.unknown)
                    user != null
                        ? _UserButton(user: user, open: userMenuOpen, onTap: onUserMenu)
                        : _LoginButton(open: loginMenuOpen, onTap: onLoginMenu),
                  const SizedBox(width: 8),
                  _Hamburger(open: mobileMenuOpen, onTap: onMobileMenu),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Chevron extends StatelessWidget {
  const _Chevron({required this.open, required this.size, required this.color});

  final bool open;
  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return AnimatedRotation(
      turns: open ? 0.5 : 0,
      duration: const Duration(milliseconds: 200),
      child: Icon(Icons.keyboard_arrow_down_rounded, size: size + 4, color: color),
    );
  }
}

class _UserButton extends StatelessWidget {
  const _UserButton({required this.user, required this.open, required this.onTap});

  final AppUser user;
  final bool open;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return PressScale(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 40,
          padding: const EdgeInsets.only(left: 4, right: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: open ? Tw.blue300 : Tw.gray200),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 32,
                height: 32,
                alignment: Alignment.center,
                decoration: const BoxDecoration(shape: BoxShape.circle, gradient: Mui.buttonGradient),
                child: Text(
                  user.username.isEmpty ? '' : user.username[0].toUpperCase(),
                  style: Tw.sm(c: Colors.white, w: Tw.bold),
                ),
              ),
              const SizedBox(width: 4),
              _Chevron(open: open, size: 14, color: Tw.gray500),
            ],
          ),
        ),
      ),
    );
  }
}

class _LoginButton extends StatelessWidget {
  const _LoginButton({required this.open, required this.onTap});

  final bool open;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return PressScale(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 40,
          padding: const EdgeInsets.only(left: 14, right: 8),
          decoration: BoxDecoration(
            gradient: Mui.buttonGradient,
            borderRadius: BorderRadius.circular(12),
            boxShadow: Tw.glow(Mui.accent),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Đăng nhập',
                style: Tw.sm(c: Colors.white, w: Tw.semibold),
              ),
              const SizedBox(width: 2),
              _Chevron(open: open, size: 14, color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }
}

class _Hamburger extends StatelessWidget {
  const _Hamburger({required this.open, required this.onTap});

  final bool open;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    Widget line({double angle = 0, double dy = 0, double opacity = 1}) => AnimatedOpacity(
      duration: const Duration(milliseconds: 300),
      opacity: opacity,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        transform: Matrix4.translationValues(0, dy, 0)..rotateZ(angle),
        transformAlignment: Alignment.center,
        width: 18,
        height: 2,
        decoration: BoxDecoration(color: Mui.primary, borderRadius: BorderRadius.circular(2)),
      ),
    );
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        padding: const EdgeInsets.all(11),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Tw.gray200),
        ),
        child: SizedBox(
          width: 18,
          height: 18,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              line(angle: open ? pi / 4 : 0, dy: open ? 5 : 0),
              const SizedBox(height: 3),
              line(opacity: open ? 0 : 1),
              const SizedBox(height: 3),
              line(angle: open ? -pi / 4 : 0, dy: open ? -5 : 0),
            ],
          ),
        ),
      ),
    );
  }
}

class _DropdownCard extends StatelessWidget {
  const _DropdownCard({required this.width, required this.children});

  final double width;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        width: width,
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: Tw.shadowXl,
          border: Border.all(color: Tw.gray100),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: children,
        ),
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  const _MenuItem({required this.label, required this.onTap, this.icon, this.danger = false});

  final String label;
  final IconData? icon;
  final bool danger;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = danger ? Tw.red600 : Tw.gray700;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      hoverColor: danger ? Tw.red50 : Tw.blue50,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
        child: Row(
          children: [
            if (icon != null) ...[
              Icon(icon, size: 19, color: danger ? Tw.red500 : Tw.gray500),
              const SizedBox(width: 10),
            ],
            Flexible(
              child: Text(
                label,
                style: Tw.sm(c: color, w: Tw.medium),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _UserDropdown extends StatelessWidget {
  const _UserDropdown({required this.user, required this.onClose});

  final AppUser user;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final pageLabel = switch (user.role) {
      UserRole.admin => 'Trang quản lý',
      UserRole.judge => 'Trang giám khảo',
      _ => 'Trang thí sinh',
    };
    return _DropdownCard(
      width: 220,
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 4),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: Tw.blue50, borderRadius: BorderRadius.circular(12)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Đăng nhập với tư cách', style: Tw.xs(c: Tw.gray500)),
              const SizedBox(height: 2),
              Text(
                user.username.isEmpty ? 'Người dùng' : user.username,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Tw.sm(c: Tw.gray900, w: Tw.bold),
              ),
              Text(
                user.role.value,
                style: Tw.xs(c: Tw.blue600, w: Tw.semibold),
              ),
            ],
          ),
        ),
        _MenuItem(
          label: 'Hồ sơ',
          icon: Icons.person_outline,
          onTap: () {
            onClose();
            AppRoutes.profile();
          },
        ),
        _MenuItem(
          label: pageLabel,
          icon: Icons.home_outlined,
          onTap: () {
            onClose();
            switch (user.role) {
              case UserRole.judge:
                AppRoutes.judgeContests();
              case UserRole.student:
                AppRoutes.studentDashboard();
              default:
                AppNotify.toast('Trang quản lý chỉ hỗ trợ trên phiên bản web', ToastType.info);
            }
          },
        ),
        _MenuItem(
          label: 'Đăng xuất',
          icon: Icons.logout,
          danger: true,
          onTap: () {
            onClose();
            AppRoutes.logout(context);
          },
        ),
      ],
    );
  }
}

class _LoginDropdown extends StatelessWidget {
  const _LoginDropdown({required this.onClose});

  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return _DropdownCard(
      width: 210,
      children: [
        _MenuItem(
          label: 'Đăng nhập Admin',
          icon: Icons.admin_panel_settings_outlined,
          onTap: () {
            onClose();
            AppRoutes.adminLogin();
          },
        ),
        _MenuItem(
          label: 'Đăng nhập Thí sinh',
          icon: Icons.school_outlined,
          onTap: () {
            onClose();
            AppRoutes.studentLogin();
          },
        ),
      ],
    );
  }
}

// -----------------------------------------------------------------------------
// Mobile menu (drawer bên phải)
// -----------------------------------------------------------------------------

class _MobileMenu extends StatelessWidget {
  const _MobileMenu({
    required this.open,
    required this.items,
    required this.active,
    required this.showLogin,
    required this.onClose,
    required this.onNav,
  });

  final bool open;
  final List<_NavItem> items;
  final String active;
  final bool showLogin;
  final VoidCallback onClose;
  final void Function(_NavItem) onNav;

  static const _icons = {
    'home': Icons.home_rounded,
    'contest': Icons.emoji_events_rounded,
    'rules': Icons.menu_book_rounded,
    'timeline': Icons.event_note_rounded,
    'sponsors': Icons.handshake_rounded,
  };

  @override
  Widget build(BuildContext context) {
    final w = min(320.0, MediaQuery.of(context).size.width * 0.85);
    return Stack(
      children: [
        IgnorePointer(
          ignoring: !open,
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 250),
            opacity: open ? 1 : 0,
            child: GestureDetector(
              onTap: onClose,
              child: const ColoredBox(color: Color(0x660B1A33), child: SizedBox.expand()),
            ),
          ),
        ),
        AnimatedPositioned(
          duration: const Duration(milliseconds: 320),
          curve: Curves.easeOutCubic,
          top: 0,
          bottom: 0,
          right: open ? 0 : -w - 30,
          width: w,
          child: AnnotatedRegion<SystemUiOverlayStyle>(
            value: open ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.horizontal(left: Radius.circular(28)),
                boxShadow: Tw.shadow2xl,
              ),
              clipBehavior: Clip.antiAlias,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: EdgeInsets.fromLTRB(20, MediaQuery.of(context).padding.top + 20, 12, 24),
                    decoration: const BoxDecoration(gradient: Mui.pageGradient),
                    child: Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14)),
                          child: const CaoThangLogo(width: 36, height: 36),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Olympic Tin học',
                                style: Tw.lg(c: Colors.white, w: FontWeight.w800),
                              ),
                              Text('Khoa CNTT · 2025', style: Tw.xs(c: Colors.white.withValues(alpha: 0.7))),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: onClose,
                          icon: const Icon(Icons.close_rounded, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.fromLTRB(12, 16, 12, 16),
                      children: [
                        _label('Điều hướng'),
                        for (final item in items)
                          _drawerItem(_icons[item.id] ?? Icons.circle, item.name, active == item.id, () => onNav(item)),
                        const SizedBox(height: 12),
                        _label('Tiện ích'),
                        _drawerItem(Icons.qr_code_scanner_rounded, 'Khán giả trợ giúp (quét QR)', false, () {
                          onClose();
                          Navigator.of(context).push(MaterialPageRoute(builder: (_) => const AudienceEntryScreen()));
                        }),
                        _drawerItem(Icons.dns_rounded, 'Cài đặt máy chủ', false, () {
                          onClose();
                          Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ServerSettingsScreen()));
                        }),
                      ],
                    ),
                  ),
                  if (showLogin)
                    Padding(
                      padding: EdgeInsets.fromLTRB(16, 8, 16, 16 + MediaQuery.of(context).padding.bottom),
                      child: PressScale(
                        child: GestureDetector(
                          onTap: () {
                            onClose();
                            AppRoutes.adminLogin();
                          },
                          child: Container(
                            height: 50,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              gradient: Mui.buttonGradient,
                              borderRadius: BorderRadius.circular(14),
                              boxShadow: Tw.glow(Mui.accent),
                            ),
                            child: Text(
                              'Đăng nhập',
                              style: Tw.base(c: Colors.white, w: Tw.semibold),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _label(String t) => Padding(
    padding: const EdgeInsets.fromLTRB(12, 4, 12, 8),
    child: Text(
      t.toUpperCase(),
      style: Tw.xs(c: Tw.gray400, w: Tw.bold).copyWith(letterSpacing: 0.8),
    ),
  );

  Widget _drawerItem(IconData icon, String name, bool isActive, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Material(
        color: isActive ? Tw.blue50 : Colors.transparent,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            child: Row(
              children: [
                Icon(icon, size: 21, color: isActive ? Tw.blue600 : Tw.gray400),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    name,
                    style: Tw.sm(c: isActive ? Mui.primary : Tw.gray700, w: isActive ? Tw.bold : Tw.medium),
                  ),
                ),
                if (isActive)
                  Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(color: Tw.blue600, shape: BoxShape.circle),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// 50 chấm `w-1 h-1 bg-blue-400 rounded-full animate-pulse` ở vị trí ngẫu nhiên (BackgroundEffects).
class BackgroundDots extends StatefulWidget {
  const BackgroundDots({super.key});

  @override
  State<BackgroundDots> createState() => _BackgroundDotsState();
}

class _BackgroundDotsState extends State<BackgroundDots> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(vsync: this, duration: const Duration(seconds: 60))..repeat();
  final _rand = Random();
  late final List<(double, double, double, double)> _dots = List.generate(
    22,
    (_) => (_rand.nextDouble(), _rand.nextDouble(), _rand.nextDouble() * 3, 2 + _rand.nextDouble() * 3),
  );

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _c,
      builder: (_, _) => CustomPaint(painter: _DotsPainter(_dots, _c.value * 60)),
    );
  }
}

class _DotsPainter extends CustomPainter {
  _DotsPainter(this.dots, this.seconds);

  final List<(double, double, double, double)> dots;
  final double seconds;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    for (final (x, y, delay, duration) in dots) {
      final t = ((seconds - delay) % duration) / duration;
      // animate-pulse: 0%,100% opacity 1 → 50% opacity 0.5
      final opacity = 1 - 0.5 * (1 - (2 * t - 1).abs());
      paint.color = Tw.blue300.withValues(alpha: opacity * 0.35);
      canvas.drawCircle(Offset(x * size.width, y * size.height), 2, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _DotsPainter old) => true;
}
