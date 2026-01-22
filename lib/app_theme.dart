import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// App-wide theme configuration adapted to the provided Figma screens
class AppTheme {
  // Palette inspired by Figma
  static const Color primaryColor = Color(0xFF4B3862); // deep purple
  static const Color primaryVariant = Color(0xFF35243E);
  static const Color primaryLight = Color(0xFF6E5488);
  static const Color primaryDark = primaryVariant;
  static const Color accentColor = Color(0xFFFF8A4B); // warm orange accent
  static const Color sosColor = Color(0xFFE53935); // SOS red
  static const Color successColor = Color(0xFF4CAF50);
  static const Color errorColor = Color(0xFFB00020);
  static const Color backgroundBeige = Color(0xFFF6EEE9);
  static const Color surfaceRose = Color(0xFFF9ECE8);
  static const Color white = Color(0xFFFFFFFF);
  static const Color surfaceColor = surfaceRose;
  static const Color backgroundColor = backgroundBeige;
  static const Color textPrimary = Color(0xFF231F20);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textHint = Color(0xFFBDBDBD);
  static const Color dividerColor = Color(0xFFE0E0E0);
  static const Color sosBackground = Color(0xFFFFEBEE);

  // Typography
  static const String headingFont = 'PlayfairDisplay';
  static const String bodyFont = 'Inter';

  static TextStyle get heading1 => GoogleFonts.playfairDisplay(
    fontSize: 36,
    fontWeight: FontWeight.w700,
    color: textPrimary,
    letterSpacing: -0.6,
  );

  static TextStyle get heading2 => GoogleFonts.playfairDisplay(
    fontSize: 26,
    fontWeight: FontWeight.w700,
    color: textPrimary,
    letterSpacing: -0.25,
  );

  static TextStyle get heading3 => GoogleFonts.playfairDisplay(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: textPrimary,
  );

  static TextStyle get bodyLarge => GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: textPrimary,
    height: 1.5,
  );

  static TextStyle get bodyMedium => GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: textPrimary,
    height: 1.4,
  );

  static TextStyle get bodySmall => GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: textSecondary,
    height: 1.3,
  );

  static TextStyle get buttonText => GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: white,
    letterSpacing: 0.6,
  );

  static TextStyle get linkText => GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: primaryColor,
  );

  // Spacing
  static const double spacingXS = 4.0;
  static const double spacingS = 8.0;
  static const double spacingM = 16.0;
  static const double spacingL = 24.0;
  static const double spacingXL = 32.0;
  static const double spacingXXL = 48.0;

  // Border Radius
  static const double radiusS = 6.0;
  static const double radiusM = 12.0;
  static const double radiusL = 20.0;
  static const double radiusXL = 28.0;

  // Shadows
  static List<BoxShadow> get cardShadow => [
    BoxShadow(
      color: Colors.black.withOpacity(0.06),
      blurRadius: 18,
      offset: const Offset(0, 8),
    ),
  ];

  static List<BoxShadow> get buttonShadow => [
    BoxShadow(
      color: primaryColor.withOpacity(0.18),
      blurRadius: 12,
      offset: const Offset(0, 6),
    ),
  ];

  // App Theme Data
  static ThemeData get lightTheme {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: primaryColor,
      primary: primaryColor,
      secondary: accentColor,
      surface: surfaceRose,
      background: backgroundBeige,
      error: errorColor,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: backgroundBeige,

      // ✅ FIXED: removed fontFamily override
      // fontFamily: bodyFont,

      // Instead, override textTheme safely with Google Fonts
      textTheme: GoogleFonts.interTextTheme(ThemeData.light().textTheme)
          .copyWith(
            displayLarge: heading1,
            displayMedium: heading2,
            headlineSmall: heading3,
            bodyLarge: bodyLarge,
            bodyMedium: bodyMedium,
            bodySmall: bodySmall,
            labelLarge: buttonText,
          ),

      appBarTheme: AppBarTheme(
        elevation: 0,
        centerTitle: true,
        backgroundColor: surfaceRose,
        foregroundColor: textPrimary,
        titleTextStyle: heading3,
        iconTheme: const IconThemeData(color: Color(0xFF6E5488)),
      ),

      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusL),
        ),
        color: surfaceRose,
        shadowColor: Colors.black12,
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: MaterialStatePropertyAll(primaryColor),
          foregroundColor: MaterialStatePropertyAll(white),
          padding: MaterialStatePropertyAll(
            const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          ),
          shape: MaterialStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radiusM),
            ),
          ),
          textStyle: MaterialStatePropertyAll(buttonText),
          elevation: const MaterialStatePropertyAll(6),
        ),
      ),

      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: primaryColor,
        elevation: 6,
      ),

      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: surfaceRose,
        selectedItemColor: primaryColor,
        unselectedItemColor: textSecondary,
        elevation: 8,
        showUnselectedLabels: true,
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusM),
          borderSide: const BorderSide(color: dividerColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusM),
          borderSide: const BorderSide(color: dividerColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusM),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusM),
          borderSide: const BorderSide(color: errorColor),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: spacingM,
          vertical: spacingM,
        ),
        hintStyle: const TextStyle(color: textHint),
      ),

      iconTheme: const IconThemeData(color: Color(0xFF6E5488)),
    );
  }
}
