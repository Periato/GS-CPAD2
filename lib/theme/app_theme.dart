
import 'package:material_ui/material_ui.dart';

class AppTheme {
  static const Color primary = Color(0xFF173B57);
  static const Color secondary = Color(0xFF2878A5);
  static const Color background = Color(0xFFF4F7FA);
  static const Color surface = Color(0xFFFFFFFF);

  static const Color danger = Color(0xFFD94343);
  static const Color warning = Color(0xFFE99A32);
  static const Color success = Color(0xFF29966B);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: background,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primary,
        primary: primary,
        secondary: secondary,
        surface: surface,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: background,
        foregroundColor: primary,
        elevation: 0,
        centerTitle: false,
      ),
      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
}
