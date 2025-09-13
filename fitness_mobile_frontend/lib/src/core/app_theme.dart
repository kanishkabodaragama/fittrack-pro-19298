import 'package:flutter/material.dart';

const _primaryHex = 0xFFEC4899; // #EC4899
const _secondaryHex = 0xFF8B5CF6; // #8B5CF6
const _successHex = 0xFF10B981; // #10B981
const _errorHex = 0xFFEF4444; // #EF4444
const _backgroundHex = 0xFFFDF2F8; // #FDF2F8
const _surfaceHex = 0xFFFFFFFF; // #FFFFFF
const _textHex = 0xFF374151; // #374151

Color get kPrimary => const Color(_primaryHex);
Color get kSecondary => const Color(_secondaryHex);
Color get kSuccess => const Color(_successHex);
Color get kError => const Color(_errorHex);
Color get kBackground => const Color(_backgroundHex);
Color get kSurface => const Color(_surfaceHex);
Color get kText => const Color(_textHex);

ThemeData buildOceanPlayfulTheme() {
  final colorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: kPrimary,
    onPrimary: Colors.white,
    secondary: kSecondary,
    onSecondary: Colors.white,
    surface: kSurface,
    onSurface: kText,
    error: kError,
    onError: Colors.white,
    tertiary: kSuccess,
    onTertiary: Colors.white,
    // Use surface for backgrounds as background is deprecated in ColorScheme
    // but we still keep our kBackground to paint Scaffold backgrounds.
    // No direct field for background in ColorScheme anymore.
  );

  final base = ThemeData(
    useMaterial3: true,
    colorScheme: colorScheme,
    scaffoldBackgroundColor: kBackground,
    fontFamily: 'Roboto',
  );

  return base.copyWith(
    appBarTheme: AppBarTheme(
      centerTitle: true,
      elevation: 0,
      backgroundColor: Colors.transparent,
      foregroundColor: kText,
      titleTextStyle: TextStyle(
        color: kText,
        fontSize: 20,
        fontWeight: FontWeight.w700,
      ),
    ),
    cardTheme: CardTheme(
      color: kSurface,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: kSurface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: kSecondary.withAlpha(60)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: kSecondary.withAlpha(40)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: kPrimary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: kError),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: kPrimary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        textStyle: const TextStyle(fontWeight: FontWeight.bold),
      ),
    ),
    textTheme: base.textTheme.apply(
      bodyColor: kText,
      displayColor: kText,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: kSurface,
      selectedItemColor: kPrimary,
      unselectedItemColor: kText.withAlpha(140),
      type: BottomNavigationBarType.fixed,
      elevation: 8,
      selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w700),
    ),
    chipTheme: base.chipTheme.copyWith(
      backgroundColor: kSecondary.withAlpha(24),
      selectedColor: kSecondary,
      labelStyle: TextStyle(color: kText),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
    ),
  );
}

Widget buildOceanGradientBackground({required Widget child}) {
  // Gradient inspired by: from-pink-100 via-purple-100 to-blue-100
  return Container(
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [
          const Color(0xFFFFE4E6), // pink-100
          const Color(0xFFEDE9FE), // purple-100
          const Color(0xFFDBEAFE), // blue-100
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ),
    child: child,
  );
}

class GradientHeader extends StatelessWidget implements PreferredSizeWidget {
  const GradientHeader({super.key, required this.title, this.actions});

  final String title;
  final List<Widget>? actions;

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: ShaderMask(
        shaderCallback: (Rect bounds) => const LinearGradient(
          colors: [Color(_primaryHex), Color(_secondaryHex)],
        ).createShader(bounds),
        child: Text(
          title,
          style: const TextStyle(color: Colors.white),
        ),
      ),
      actions: actions,
    );
  }
}
