import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CyberTheme {
  // Colors based on the tailwind-config from HTML
  static const Color surface = Color(0xFF131313);
  static const Color surfaceContainerLowest = Color(0xFF0E0E0E);
  static const Color surfaceContainerLow = Color(0xFF1C1B1B);
  static const Color surfaceContainer = Color(0xFF201F1F);
  static const Color surfaceContainerHigh = Color(0xFF2A2A2A);
  static const Color surfaceContainerHighest = Color(0xFF353534);
  static const Color surfaceBright = Color(0xFF3A3939);

  static const Color primary = Color(0xFFECB1FF);
  static const Color primaryContainer = Color(0xFFBF00FF);
  static const Color onPrimary = Color(0xFF520070);
  static const Color onPrimaryContainer = Color(0xFFFFFFFF);

  static const Color outline = Color(0xFF9D8BA0);
  static const Color outlineVariant = Color(0xFF514254);

  static const Color onSurface = Color(0xFFE5E2E1);
  static const Color onSurfaceVariant = Color(0xFFD5C0D7);

  static const Color error = Color(0xFFFFB4AB);
  static const Color errorContainer = Color(0xFF93000A);
  
  static const Color secondary = Color(0xFFC8C6C5);
  static const Color secondaryContainer = Color(0xFF4A4949);
  static const Color onSecondaryContainer = Color(0xFFBAB8B7);

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: surface,
      colorScheme: const ColorScheme.dark(
        surface: surface,
        primary: primary,
        primaryContainer: primaryContainer,
        onPrimary: onPrimary,
        onPrimaryContainer: onPrimaryContainer,
        secondary: secondary,
        secondaryContainer: secondaryContainer,
        onSecondaryContainer: onSecondaryContainer,
        outline: outline,
        outlineVariant: outlineVariant,
        onSurface: onSurface,
        onSurfaceVariant: onSurfaceVariant,
        error: error,
        errorContainer: errorContainer,
      ),
      textTheme: TextTheme(
        // Space Grotesk: Headlines/Display/Labels
        displayLarge: GoogleFonts.getFont('Space Grotesk', fontSize: 57, fontWeight: FontWeight.normal, letterSpacing: -0.25),
        displayMedium: GoogleFonts.getFont('Space Grotesk', fontSize: 45, fontWeight: FontWeight.normal, letterSpacing: 0),
        displaySmall: GoogleFonts.getFont('Space Grotesk', fontSize: 36, fontWeight: FontWeight.normal, letterSpacing: 0),
        headlineLarge: GoogleFonts.getFont('Space Grotesk', fontSize: 32, fontWeight: FontWeight.normal, letterSpacing: 0),
        headlineMedium: GoogleFonts.getFont('Space Grotesk', fontSize: 28, fontWeight: FontWeight.normal, letterSpacing: 0),
        headlineSmall: GoogleFonts.getFont('Space Grotesk', fontSize: 24, fontWeight: FontWeight.normal, letterSpacing: 0),
        titleLarge: GoogleFonts.getFont('Space Grotesk', fontSize: 22, fontWeight: FontWeight.w500, letterSpacing: 0),
        titleMedium: GoogleFonts.getFont('Space Grotesk', fontSize: 16, fontWeight: FontWeight.w500, letterSpacing: 0.15),
        titleSmall: GoogleFonts.getFont('Space Grotesk', fontSize: 14, fontWeight: FontWeight.w500, letterSpacing: 0.1),
        labelLarge: GoogleFonts.getFont('Space Grotesk', fontSize: 14, fontWeight: FontWeight.w500, letterSpacing: 0.1),
        labelMedium: GoogleFonts.getFont('Space Grotesk', fontSize: 12, fontWeight: FontWeight.w500, letterSpacing: 0.5),
        labelSmall: GoogleFonts.getFont('Space Grotesk', fontSize: 11, fontWeight: FontWeight.w500, letterSpacing: 0.5),
        
        // Inter: Body text
        bodyLarge: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.normal, letterSpacing: 0.5),
        bodyMedium: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.normal, letterSpacing: 0.25),
        bodySmall: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.normal, letterSpacing: 0.4),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryContainer,
          foregroundColor: onPrimary,
          textStyle: GoogleFonts.getFont('Space Grotesk', fontWeight: FontWeight.bold, letterSpacing: 1.5, fontSize: 14),
          shape: const ContinuousRectangleBorder(borderRadius: BorderRadius.zero),
          elevation: 0,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primary,
          textStyle: GoogleFonts.getFont('Space Grotesk', fontWeight: FontWeight.bold, letterSpacing: 1.5, fontSize: 14),
          shape: const ContinuousRectangleBorder(borderRadius: BorderRadius.zero),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: onSurface,
          side: const BorderSide(color: outlineVariant, width: 1), // usually 15% opacity or just the variant
          shape: const ContinuousRectangleBorder(borderRadius: BorderRadius.zero),
          textStyle: GoogleFonts.getFont('Space Grotesk', fontWeight: FontWeight.bold, letterSpacing: 1.5, fontSize: 14),
        )
      ),
    );
  }

  // Helper method for the Mono font commonly used in the financial data
  static TextStyle monoFont({double? fontSize, FontWeight? fontWeight, Color? color, double? letterSpacing, TextDecoration? decoration}) {
    return GoogleFonts.getFont(
      'JetBrains Mono',
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      letterSpacing: letterSpacing,
      decoration: decoration,
    );
  }
}
