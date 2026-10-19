import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../widgets/mui.dart';
import 'tw.dart';

/// Theme toàn app: font Be Vietnam Pro, một họ màu xanh, bo góc lớn, bóng mềm.
ThemeData buildAppTheme() {
  final scheme = ColorScheme.fromSeed(
    seedColor: Mui.secondary,
    primary: Mui.primary,
    secondary: Mui.secondary,
    tertiary: Tw.cyan600,
    error: Mui.error,
    surface: Colors.white,
  ).copyWith(
    onSurface: Mui.textPrimary,
    onSurfaceVariant: Mui.textSecondary,
    outline: Tw.gray300,
    outlineVariant: Tw.gray200,
    surfaceTint: Colors.transparent,
  );

  final base = ThemeData(useMaterial3: true, colorScheme: scheme, fontFamily: 'BeVietnamPro');
  final text = base.textTheme.apply(bodyColor: Mui.textPrimary, displayColor: Mui.textPrimary);
  OutlineInputBorder border(Color c, [double w = 1]) =>
      OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: c, width: w));
  final rounded = RoundedRectangleBorder(borderRadius: BorderRadius.circular(14));
  const btnText = TextStyle(fontFamily: 'BeVietnamPro', fontSize: 15, fontWeight: FontWeight.w600);

  return base.copyWith(
    textTheme: text,
    scaffoldBackgroundColor: Mui.background,
    splashFactory: InkSparkle.splashFactory,
    visualDensity: VisualDensity.standard,
    dividerTheme: const DividerThemeData(color: Mui.divider, thickness: 1, space: 1),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: Mui.textPrimary,
      elevation: 0,
      scrolledUnderElevation: 0.5,
      shadowColor: Color(0x330F2A5C),
      surfaceTintColor: Colors.transparent,
      centerTitle: false,
      titleTextStyle: TextStyle(
        fontFamily: 'BeVietnamPro',
        fontSize: 18,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.2,
        color: Mui.textPrimary,
      ),
      systemOverlayStyle: SystemUiOverlayStyle.dark,
    ),
    cardTheme: CardThemeData(
      color: Colors.white,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: Color(0x0F0F2A5C)),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Mui.surfaceTint,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
      hintStyle: const TextStyle(color: Tw.gray400),
      border: border(Mui.outline),
      enabledBorder: border(Mui.outline),
      focusedBorder: border(Mui.secondary, 1.8),
      errorBorder: border(Tw.red300),
      focusedErrorBorder: border(Mui.error, 1.8),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Mui.secondary,
        foregroundColor: Colors.white,
        elevation: 0,
        minimumSize: const Size(64, 48),
        shape: rounded,
        textStyle: btnText,
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: Mui.secondary,
        minimumSize: const Size(64, 48),
        shape: rounded,
        textStyle: btnText,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: Mui.secondary,
        minimumSize: const Size(64, 48),
        side: BorderSide(color: Mui.secondary.withValues(alpha: 0.35), width: 1.4),
        shape: rounded,
        textStyle: btnText,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(foregroundColor: Mui.secondary, shape: rounded, textStyle: btnText),
    ),
    checkboxTheme: CheckboxThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      side: const BorderSide(color: Tw.gray300, width: 1.5),
      fillColor: WidgetStateProperty.resolveWith((s) => s.contains(WidgetState.selected) ? Mui.secondary : Colors.white),
    ),
    radioTheme: RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith((s) => s.contains(WidgetState.selected) ? Mui.secondary : Tw.gray400),
    ),
    switchTheme: SwitchThemeData(
      trackColor: WidgetStateProperty.resolveWith((s) => s.contains(WidgetState.selected) ? Mui.secondary : Tw.gray200),
      thumbColor: const WidgetStatePropertyAll(Colors.white),
      trackOutlineColor: const WidgetStatePropertyAll(Colors.transparent),
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: Mui.secondary,
      linearTrackColor: Tw.blue100,
      circularTrackColor: Tw.blue100,
    ),
    tabBarTheme: const TabBarThemeData(
      labelColor: Mui.secondary,
      unselectedLabelColor: Tw.gray500,
      indicatorColor: Mui.secondary,
      dividerColor: Mui.divider,
      labelStyle: TextStyle(fontFamily: 'BeVietnamPro', fontWeight: FontWeight.w600, fontSize: 14),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      showDragHandle: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
    ),
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      backgroundColor: Tw.gray900,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
    ),
    listTileTheme: ListTileThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      iconColor: Mui.secondary,
    ),
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: {
        TargetPlatform.android: FadeForwardsPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
      },
    ),
  );
}
