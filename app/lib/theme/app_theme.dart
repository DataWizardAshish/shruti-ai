import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const parchment = Color(0xFFF5E6C8);
  static const saffron = Color(0xFFE8821A);
  static const templeRed = Color(0xFF8B1A1A);
  static const sandalwood = Color(0xFFA0785A);
  static const deepForest = Color(0xFF2C4A2E);
  static const gold = Color(0xFFC9A84C);
  static const charcoal = Color(0xFF1C1C1E);
  static const white = Color(0xFFFFFFFF);
  static const correctGlow = Color(0xFFC9A84C);
  static const wrongMuted = Color(0xFF9E9E9E);
}

class AppTheme {
  static ThemeData get light => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.saffron,
          primary: AppColors.saffron,
          secondary: AppColors.templeRed,
          tertiary: AppColors.gold,
          surface: AppColors.parchment,
          onSurface: AppColors.charcoal,
        ),
        scaffoldBackgroundColor: AppColors.parchment,
        textTheme: _textTheme,
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.parchment,
          foregroundColor: AppColors.templeRed,
          elevation: 0,
          titleTextStyle: GoogleFonts.cinzel(
            color: AppColors.templeRed,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.saffron,
            foregroundColor: AppColors.white,
            textStyle: GoogleFonts.inter(fontWeight: FontWeight.w600),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          ),
        ),
        cardTheme: CardThemeData(
          color: AppColors.white,
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: AppColors.parchment,
          selectedItemColor: AppColors.saffron,
          unselectedItemColor: AppColors.sandalwood,
          type: BottomNavigationBarType.fixed,
        ),
      );

  static ThemeData get dark => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.saffron,
          brightness: Brightness.dark,
          primary: AppColors.saffron,
          secondary: AppColors.gold,
          surface: AppColors.deepForest,
          onSurface: AppColors.parchment,
        ),
        scaffoldBackgroundColor: AppColors.deepForest,
        textTheme: _darkTextTheme,
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.deepForest,
          foregroundColor: AppColors.parchment,
          elevation: 0,
          titleTextStyle: GoogleFonts.cinzel(
            color: AppColors.gold,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: AppColors.deepForest,
          selectedItemColor: AppColors.gold,
          unselectedItemColor: AppColors.sandalwood,
          type: BottomNavigationBarType.fixed,
        ),
      );

  static TextTheme get _textTheme => TextTheme(
        displayLarge: GoogleFonts.cinzel(color: AppColors.templeRed, fontWeight: FontWeight.bold),
        displayMedium: GoogleFonts.cinzel(color: AppColors.templeRed, fontWeight: FontWeight.w600),
        headlineLarge: GoogleFonts.cinzel(color: AppColors.templeRed, fontWeight: FontWeight.w600),
        headlineMedium: GoogleFonts.cinzel(color: AppColors.charcoal, fontWeight: FontWeight.w500),
        titleLarge: GoogleFonts.cinzel(color: AppColors.charcoal, fontWeight: FontWeight.w600),
        titleMedium: GoogleFonts.inter(color: AppColors.charcoal, fontWeight: FontWeight.w500),
        bodyLarge: GoogleFonts.inter(color: AppColors.charcoal, fontSize: 16),
        bodyMedium: GoogleFonts.inter(color: AppColors.charcoal, fontSize: 14),
        bodySmall: GoogleFonts.inter(color: AppColors.sandalwood, fontSize: 12),
        labelLarge: GoogleFonts.inter(color: AppColors.white, fontWeight: FontWeight.w600),
      );

  static TextTheme get _darkTextTheme => TextTheme(
        displayLarge: GoogleFonts.cinzel(color: AppColors.gold, fontWeight: FontWeight.bold),
        displayMedium: GoogleFonts.cinzel(color: AppColors.gold, fontWeight: FontWeight.w600),
        headlineLarge: GoogleFonts.cinzel(color: AppColors.gold, fontWeight: FontWeight.w600),
        headlineMedium: GoogleFonts.cinzel(color: AppColors.parchment, fontWeight: FontWeight.w500),
        titleLarge: GoogleFonts.cinzel(color: AppColors.parchment, fontWeight: FontWeight.w600),
        titleMedium: GoogleFonts.inter(color: AppColors.parchment, fontWeight: FontWeight.w500),
        bodyLarge: GoogleFonts.inter(color: AppColors.parchment, fontSize: 16),
        bodyMedium: GoogleFonts.inter(color: AppColors.parchment, fontSize: 14),
        bodySmall: GoogleFonts.inter(color: AppColors.sandalwood, fontSize: 12),
        labelLarge: GoogleFonts.inter(color: AppColors.charcoal, fontWeight: FontWeight.w600),
      );
}

class EpicTheme {
  final String epicId;
  final Color background;
  final Color surface;
  final Color primary;
  final Color secondary;
  final Color accent;
  final Color textPrimary;
  final Color textSecondary;
  final Color correct;
  final Color wrong;
  final Color cardBorder;

  const EpicTheme({
    required this.epicId,
    required this.background,
    required this.surface,
    required this.primary,
    required this.secondary,
    required this.accent,
    required this.textPrimary,
    required this.textSecondary,
    required this.correct,
    required this.wrong,
    required this.cardBorder,
  });

  static const EpicTheme ramayana = EpicTheme(
    epicId: 'ramayana',
    background:    Color(0xFFF5E6C8),
    surface:       Color(0xFFFDF3E3),
    primary:       Color(0xFFE8821A),
    secondary:     Color(0xFFC9A84C),
    accent:        Color(0xFF8B1A1A),
    textPrimary:   Color(0xFF2C1A0E),
    textSecondary: Color(0xFFA0785A),
    correct:       Color(0xFFC9A84C),
    wrong:         Color(0xFFA0785A),
    cardBorder:    Color(0xFFD4B896),
  );

  static const EpicTheme mahabharata = EpicTheme(
    epicId: 'mahabharata',
    background:    Color(0xFF1A1A2E),
    surface:       Color(0xFF16213E),
    primary:       Color(0xFFD4AF37),
    secondary:     Color(0xFF4A7C9E),
    accent:        Color(0xFF8B0000),
    textPrimary:   Color(0xFFE8E0D0),
    textSecondary: Color(0xFF9A8C7A),
    correct:       Color(0xFFD4AF37),
    wrong:         Color(0xFF8B0000),
    cardBorder:    Color(0xFF2A3A5C),
  );
}
