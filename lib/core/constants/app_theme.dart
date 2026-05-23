import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  // Primary palette — violet/indigo profond
  static const primary = Color(0xFF6759FF);
  static const primaryDark = Color(0xFF4638D8);
  static const primaryLight = Color(0xFFA8A0FF);

  // Accent
  static const accent = Color(0xFF20D6B5);
  static const accentDark = Color(0xFF0E9F88);
  static const coral = Color(0xFFFF8A7A);
  static const gold = Color(0xFFF6C85F);

  // Backgrounds dark
  static const bgDark = Color(0xFF11131F);
  static const bgCard = Color(0xFF1A1D2E);
  static const bgCardLight = Color(0xFF24283B);
  static const bgSurface = Color(0xFF151827);

  // Backgrounds light
  static const bgLight = Color(0xFFFAF8F3);
  static const bgLightCard = Color(0xFFFFFFFF);
  static const bgLightSurface = Color(0xFFFFF7ED);

  // Status
  static const success = Color(0xFF10B981);
  static const error = Color(0xFFEF4444);
  static const warning = Color(0xFFF59E0B);
  static const info = Color(0xFF3B82F6);

  // Text dark
  static const textPrimary = Color(0xFFF9FAFB);
  static const textSecondary = Color(0xFF9CA3AF);
  static const textMuted = Color(0xFF6B7280);

  // Text light
  static const textPrimaryLight = Color(0xFF111827);
  static const textSecondaryLight = Color(0xFF6B7280);

  // Gradients
  static const gradientPrimary = LinearGradient(
    colors: [Color(0xFF6759FF), Color(0xFF20D6B5)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  static const gradientAccent = LinearGradient(
    colors: [Color(0xFF20D6B5), Color(0xFFFF8A7A)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  static const gradientBackground = LinearGradient(
    colors: [Color(0xFF11131F), Color(0xFF171A2B), Color(0xFF1A2333)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}

class AppTheme {
  static ThemeData get darkTheme => ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.bgDark,
        primaryColor: AppColors.primary,
        colorScheme: const ColorScheme.dark(
          primary: AppColors.primary,
          secondary: AppColors.accent,
          surface: AppColors.bgCard,
          error: AppColors.error,
        ),
        textTheme: GoogleFonts.outfitTextTheme(
          const TextTheme(
            displayLarge: TextStyle(
                color: AppColors.textPrimary, fontWeight: FontWeight.w700),
            displayMedium: TextStyle(
                color: AppColors.textPrimary, fontWeight: FontWeight.w600),
            headlineLarge: TextStyle(
                color: AppColors.textPrimary, fontWeight: FontWeight.w700),
            headlineMedium: TextStyle(
                color: AppColors.textPrimary, fontWeight: FontWeight.w600),
            titleLarge: TextStyle(
                color: AppColors.textPrimary, fontWeight: FontWeight.w600),
            titleMedium: TextStyle(
                color: AppColors.textPrimary, fontWeight: FontWeight.w500),
            bodyLarge: TextStyle(color: AppColors.textPrimary),
            bodyMedium: TextStyle(color: AppColors.textSecondary),
            bodySmall: TextStyle(color: AppColors.textMuted),
          ),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.bgDark,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: GoogleFonts.outfit(
            color: AppColors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
          iconTheme: const IconThemeData(color: AppColors.textPrimary),
        ),
        cardTheme: CardThemeData(
          color: AppColors.bgCard,
          elevation: 0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.bgCardLight,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFF32364C), width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: AppColors.primary, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: AppColors.error, width: 1),
          ),
          labelStyle: const TextStyle(color: AppColors.textSecondary),
          hintStyle: const TextStyle(color: AppColors.textMuted),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 15),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            textStyle:
                GoogleFonts.outfit(fontWeight: FontWeight.w600, fontSize: 16),
          ),
        ),
        snackBarTheme: SnackBarThemeData(
          backgroundColor: AppColors.bgCardLight,
          contentTextStyle: GoogleFonts.outfit(color: AppColors.textPrimary),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          behavior: SnackBarBehavior.floating,
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: AppColors.bgCard,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: AppColors.textMuted,
          type: BottomNavigationBarType.fixed,
          elevation: 0,
        ),
      );

  static ThemeData get lightTheme => ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: AppColors.bgLight,
        primaryColor: AppColors.primary,
        colorScheme: const ColorScheme.light(
          primary: AppColors.primary,
          secondary: AppColors.accent,
          surface: AppColors.bgLightCard,
          error: AppColors.error,
        ),
        textTheme: GoogleFonts.outfitTextTheme(
          const TextTheme(
            displayLarge: TextStyle(
                color: AppColors.textPrimaryLight, fontWeight: FontWeight.w700),
            headlineLarge: TextStyle(
                color: AppColors.textPrimaryLight, fontWeight: FontWeight.w700),
            titleLarge: TextStyle(
                color: AppColors.textPrimaryLight, fontWeight: FontWeight.w600),
            bodyMedium: TextStyle(color: AppColors.textSecondaryLight),
          ),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.bgLight,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: GoogleFonts.outfit(
            color: AppColors.textPrimaryLight,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
          iconTheme: const IconThemeData(color: AppColors.textPrimaryLight),
        ),
        cardTheme: CardThemeData(
          color: AppColors.bgLightCard,
          elevation: 2,
          shadowColor: Colors.black12,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 15),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            textStyle:
                GoogleFonts.outfit(fontWeight: FontWeight.w600, fontSize: 16),
          ),
        ),
      );
}

class AppStrings {
  static const appName = 'DELTASIGNE';
  static const tagline = 'La langue des signes, traduite pour tous';
  static const author = 'Joseph Mukubu Kapoya';
}
