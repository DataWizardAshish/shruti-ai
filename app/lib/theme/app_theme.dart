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
