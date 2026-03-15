import 'package:flutter/material.dart';

class AppTheme {
  // Brand seed color — teal-blue medical feel
  static const Color seedColor = Color(0xFF0B6E6E);

  static const Color primary = Color(0xFF0B6E6E);
  static const Color primaryContainer = Color(0xFFB2EFEF);
  static const Color onPrimaryContainer = Color(0xFF002020);

  static const Color secondary = Color(0xFF4A6363);
  static const Color secondaryContainer = Color(0xFFCCE8E8);

  static const Color tertiary = Color(0xFF4B607C);
  static const Color tertiaryContainer = Color(0xFFD3E4FF);

  static const Color error = Color(0xFFBA1A1A);
  static const Color errorContainer = Color(0xFFFFDAD6);

  static const Color success = Color(0xFF1B6B3A);
  static const Color successContainer = Color(0xFFB7F0CE);

  static const Color warning = Color(0xFF7A4F00);
  static const Color warningContainer = Color(0xFFFFDEAA);

  static const Color surface = Color(0xFFF4FBFB);
  static const Color surfaceVariant = Color(0xFFDAE5E5);
  static const Color outline = Color(0xFF6F7979);
  static const Color outlineVariant = Color(0xFFBEC9C9);

  static ThemeData light() {
    final base = ColorScheme.fromSeed(
      seedColor: seedColor,
      brightness: Brightness.light,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: base.copyWith(
        primary: primary,
        primaryContainer: primaryContainer,
        secondary: secondary,
        secondaryContainer: secondaryContainer,
        tertiary: tertiary,
        tertiaryContainer: tertiaryContainer,
        error: error,
        errorContainer: errorContainer,
        surface: surface,
        surfaceContainerHighest: surfaceVariant,
        outline: outline,
        outlineVariant: outlineVariant,
      ),
      fontFamily: 'Nunito',
      textTheme: _textTheme(Colors.black),
      appBarTheme: const AppBarTheme(
        centerTitle: false,
        elevation: 0,
        scrolledUnderElevation: 2,
        backgroundColor: surface,
        foregroundColor: Color(0xFF002020),
        titleTextStyle: TextStyle(
          fontFamily: 'Nunito',
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: Color(0xFF002020),
          letterSpacing: -0.3,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: outlineVariant, width: 1),
        ),
        color: Colors.white,
        margin: const EdgeInsets.symmetric(vertical: 4),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          textStyle: const TextStyle(
            fontFamily: 'Nunito',
            fontSize: 15,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.1,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primary,
          side: const BorderSide(color: primary, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          textStyle: const TextStyle(
            fontFamily: 'Nunito',
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          textStyle: const TextStyle(
            fontFamily: 'Nunito',
            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFFF0F7F7),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: outlineVariant),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primary, width: 2),
        ),
        labelStyle: const TextStyle(fontFamily: 'Nunito', color: secondary),
        hintStyle: const TextStyle(fontFamily: 'Nunito', color: outline),
      ),
      chipTheme: ChipThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        side: const BorderSide(color: outlineVariant),
        labelStyle: const TextStyle(fontFamily: 'Nunito', fontSize: 13),
      ),
      navigationBarTheme: NavigationBarThemeData(
        height: 72,
        elevation: 0,
        backgroundColor: Colors.white,
        indicatorColor: primaryContainer,
        surfaceTintColor: Colors.transparent,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const TextStyle(
              fontFamily: 'Nunito',
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: primary,
            );
          }
          return const TextStyle(
            fontFamily: 'Nunito',
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: outline,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: primary, size: 22);
          }
          return const IconThemeData(color: outline, size: 22);
        }),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: primary,
        foregroundColor: Colors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      ),
      dividerTheme: const DividerThemeData(
        color: outlineVariant,
        thickness: 1,
        space: 1,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: const Color(0xFF002020),
        contentTextStyle:
            const TextStyle(fontFamily: 'Nunito', color: Colors.white),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
  static ThemeData dark() {
    final base = ColorScheme.fromSeed(
      seedColor: seedColor,
      brightness: Brightness.dark,
    );
    
    // Custom dark mode color overrides to maintain the teal aesthetic
    const darkSurface = Color(0xFF1E2626);
    const darkSurfaceVariant = Color(0xFF2B3A3A);
    const darkPrimary = Color(0xFF80D8D8);
    const darkPrimaryContainer = Color(0xFF004F4F);
    const darkOnPrimaryContainer = Color(0xFFB2EFEF);

    return ThemeData(
      useMaterial3: true,
      colorScheme: base.copyWith(
        primary: darkPrimary,
        primaryContainer: darkPrimaryContainer,
        onPrimaryContainer: darkOnPrimaryContainer,
        surface: darkSurface,
        surfaceContainerHighest: darkSurfaceVariant,
        outline: outlineVariant, // lighter outline for dark mode
        outlineVariant: outline,
      ),
      fontFamily: 'Nunito',
      textTheme: _textTheme(Colors.white),
      appBarTheme: const AppBarTheme(
        centerTitle: false,
        elevation: 0,
        scrolledUnderElevation: 2,
        backgroundColor: darkSurface,
        foregroundColor: Colors.white,
        titleTextStyle: TextStyle(
          fontFamily: 'Nunito',
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: Colors.white,
          letterSpacing: -0.3,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: outline, width: 1),
        ),
        color: const Color(0xFF222B2B), // Slightly lighter than surface
        margin: const EdgeInsets.symmetric(vertical: 4),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: darkPrimary,
          foregroundColor: const Color(0xFF003737),
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          textStyle: const TextStyle(
            fontFamily: 'Nunito',
            fontSize: 15,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.1,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: darkPrimary,
          side: const BorderSide(color: darkPrimary, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          textStyle: const TextStyle(
            fontFamily: 'Nunito',
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: darkPrimary,
          foregroundColor: const Color(0xFF003737),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          textStyle: const TextStyle(
            fontFamily: 'Nunito',
            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF192020),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: darkPrimary, width: 2),
        ),
        labelStyle: const TextStyle(fontFamily: 'Nunito', color: outlineVariant),
        hintStyle: const TextStyle(fontFamily: 'Nunito', color: outline),
      ),
      chipTheme: ChipThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        side: const BorderSide(color: outline),
        labelStyle: const TextStyle(fontFamily: 'Nunito', fontSize: 13),
      ),
      navigationBarTheme: NavigationBarThemeData(
        height: 72,
        elevation: 0,
        backgroundColor: const Color(0xFF1A2222),
        indicatorColor: darkPrimaryContainer,
        surfaceTintColor: Colors.transparent,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const TextStyle(
              fontFamily: 'Nunito',
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: darkPrimary,
            );
          }
          return const TextStyle(
            fontFamily: 'Nunito',
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: outlineVariant,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: darkPrimary, size: 22);
          }
          return const IconThemeData(color: outlineVariant, size: 22);
        }),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: darkPrimary,
        foregroundColor: const Color(0xFF003737),
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      ),
      dividerTheme: const DividerThemeData(
        color: outline,
        thickness: 1,
        space: 1,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: darkPrimaryContainer,
        contentTextStyle: const TextStyle(fontFamily: 'Nunito', color: darkOnPrimaryContainer),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  static TextTheme _textTheme(Color base) => TextTheme(
        displayLarge: TextStyle(
            fontFamily: 'Nunito',
            fontSize: 57,
            fontWeight: FontWeight.w800,
            color: base,
            letterSpacing: -1),
        displayMedium: TextStyle(
            fontFamily: 'Nunito',
            fontSize: 45,
            fontWeight: FontWeight.w700,
            color: base,
            letterSpacing: -0.5),
        displaySmall: TextStyle(
            fontFamily: 'Nunito',
            fontSize: 36,
            fontWeight: FontWeight.w700,
            color: base),
        headlineLarge: TextStyle(
            fontFamily: 'Nunito',
            fontSize: 32,
            fontWeight: FontWeight.w700,
            color: base,
            letterSpacing: -0.3),
        headlineMedium: TextStyle(
            fontFamily: 'Nunito',
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: base,
            letterSpacing: -0.2),
        headlineSmall: TextStyle(
            fontFamily: 'Nunito',
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: base),
        titleLarge: TextStyle(
            fontFamily: 'Nunito',
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: base,
            letterSpacing: -0.1),
        titleMedium: TextStyle(
            fontFamily: 'Nunito',
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: base),
        titleSmall: TextStyle(
            fontFamily: 'Nunito',
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: base),
        bodyLarge: TextStyle(
            fontFamily: 'Nunito',
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: base,
            height: 1.5),
        bodyMedium: TextStyle(
            fontFamily: 'Nunito',
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: base,
            height: 1.5),
        bodySmall: TextStyle(
            fontFamily: 'Nunito',
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: base,
            height: 1.4),
        labelLarge: TextStyle(
            fontFamily: 'Nunito',
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: base),
        labelMedium: TextStyle(
            fontFamily: 'Nunito',
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: base),
        labelSmall: TextStyle(
            fontFamily: 'Nunito',
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: base,
            letterSpacing: 0.3),
      );
}

// Status colors 
class StatusColors {
  // Light Mode Colors
  static const taken = Color(0xFF1B6B3A);
  static const takenContainer = Color(0xFFB7F0CE);
  static const missed = Color(0xFFBA1A1A);
  static const missedContainer = Color(0xFFFFDAD6);
  static const pending = Color(0xFF7A4F00);
  static const pendingContainer = Color(0xFFFFDEAA);
  static const lowStock = Color(0xFF6B3A00);
  static const lowStockContainer = Color(0xFFFFDCC2);

  // Dark Mode Adjustments
  static Color getTaken(BuildContext context) => Theme.of(context).brightness == Brightness.dark ? const Color(0xFF93D7A4) : taken;
  static Color getTakenContainer(BuildContext context) => Theme.of(context).brightness == Brightness.dark ? const Color(0xFF005324) : takenContainer;
  
  static Color getMissed(BuildContext context) => Theme.of(context).brightness == Brightness.dark ? const Color(0xFFFFB4AB) : missed;
  static Color getMissedContainer(BuildContext context) => Theme.of(context).brightness == Brightness.dark ? const Color(0xFF93000A) : missedContainer;
  
  static Color getPending(BuildContext context) => Theme.of(context).brightness == Brightness.dark ? const Color(0xFFF8BD49) : pending;
  static Color getPendingContainer(BuildContext context) => Theme.of(context).brightness == Brightness.dark ? const Color(0xFF5C3A00) : pendingContainer;

  static Color getLowStock(BuildContext context) => Theme.of(context).brightness == Brightness.dark ? const Color(0xFFFFB782) : lowStock;
  static Color getLowStockContainer(BuildContext context) => Theme.of(context).brightness == Brightness.dark ? const Color(0xFF4C2700) : lowStockContainer;
}
