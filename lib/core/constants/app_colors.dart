import 'package:flutter/material.dart';

/// UnitPro — dark charcoal, purple accent.
class AppColors {
  static const Color primary = Color(0xFF8B7CFF);
  static const Color primaryLight = Color(0xFFB8AEFF);
  static const Color primarySoft = Color(0xFF2A2450);
  static const Color primaryMuted = Color(0xFF6B5FD6);

  static const Color accent = Color(0xFF8B7CFF);
  static const Color accentLight = Color(0xFFB8AEFF);
  static const Color accentDeep = Color(0xFF6B5FD6);
  static const Color success = Color(0xFF5C8A6E);
  static const Color successDeep = Color(0xFF3E6250);
  static const Color warning = Color(0xFFC6A46A);
  static const Color error = Color(0xFFB85C5C);
  static const Color coin = Color(0xFFE4D2A4);
  static const Color onGold = Color(0xFF0A0A0C);

  static const Color background = Color(0xFFF4F2FA);
  static const Color surface = Color(0xFFFAF8FF);
  static const Color surfaceElevated = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFE8E4F4);
  static const Color border = Color(0xFF3A3650);
  static const Color borderBright = Color(0xFF8B7CFF);

  static const Color textPrimary = Color(0xFFF4F2FA);
  static const Color textSecondary = Color(0xFFB4B0C8);
  static const Color textMuted = Color(0xFF7E7A96);
  static const Color onPrimary = Color(0xFF0A0A0C);
  static const Color onSurface = textPrimary;
  static const Color onSurfaceVariant = textSecondary;

  static const Color navBar = Color(0xFF121214);
  static const Color navActive = primary;
  static const Color navInactive = Color(0xFF7E7A96);

  static const Color darkBackground = Color(0xFF000000);
  static const Color darkSurface = Color(0xFF1C1C1E);
  static const Color darkCard = Color(0xFF2C2C2E);
  static const Color trueBlack = Color(0xFF000000);
  static const Color darkInk = Color(0xFFF4F2FA);

  static const Color lightBackground = background;
  static const Color lightSurface = surface;
  static const Color lightPrimaryTint = Color(0xFFE8E4F8);
  static const Color lightWarmTint = Color(0xFFF4F2FA);
  static const Color lightTextPrimary = Color(0xFF16141F);

  static const Color salon = Color(0xFF000000);
  static const Color salonCard = Color(0xFF1C1C1E);
  static const Color salonLine = Color(0xFF3A3650);

  static const List<Color> papers = [
    Color(0xFF2C2C2E),
    Color(0xFF242436),
    Color(0xFF1E2A32),
    Color(0xFF2A2438),
    Color(0xFF22222A),
    Color(0xFF1C1C1E),
    Color(0xFF2A2830),
  ];

  static const List<Color> extraPapers = [
    Color(0xFF1E2430),
    Color(0xFF2A2030),
    Color(0xFF202828),
  ];

  static Color paperAt(int index, {bool extras = false}) {
    final all = extras ? [...papers, ...extraPapers] : papers;
    if (all.isEmpty) return darkCard;
    return all[index % all.length];
  }

  static Color ink(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? darkInk
          : lightTextPrimary;

  static Color muted(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? textSecondary
          : const Color(0xFF5A5670);

  static Color card(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? darkCard : Colors.white;

  static Color line(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? border
          : const Color(0xFFE4E0F0);

  static Color navBarColor(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? navBar : Colors.white;

  static Color paper(BuildContext context, int index) {
    if (Theme.of(context).brightness == Brightness.dark) return paperAt(index);
    const light = [
      Color(0xFFFFFFFF),
      Color(0xFFF3F0FA),
      Color(0xFFEEF4F8),
      Color(0xFFF6F0FA),
      Color(0xFFF4F2F8),
      Color(0xFFEEF2F0),
      Color(0xFFF8F4EE),
    ];
    return light[index % light.length];
  }

  static const LinearGradient headerGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF1A1628), Color(0xFF000000)],
  );

  static const LinearGradient gameGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF16141C), Color(0xFF000000), Color(0xFF000000)],
    stops: [0.0, 0.45, 1.0],
  );

  static const LinearGradient accentGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFB8AEFF), Color(0xFF8B7CFF)],
  );

  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFB8AEFF), Color(0xFF8B7CFF)],
  );

  static const LinearGradient heroGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF2C2C2E), Color(0xFF1C1C1E)],
  );

  static const LinearGradient goldShimmer = LinearGradient(
    colors: [Color(0xFFB8AEFF), Color(0xFF8B7CFF)],
  );

  static const LinearGradient shopPromoGradient = LinearGradient(
    colors: [Color(0xFF1C1C1E), Color(0xFF000000)],
  );

  static const LinearGradient vipGoldGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFB8AEFF), Color(0xFF8B7CFF), Color(0xFF6B5FD6)],
  );

  static const LinearGradient shopVipHeroGradient = LinearGradient(
    colors: [Color(0xFF2C2C2E), Color(0xFF000000)],
  );

  static const LinearGradient successGradient = LinearGradient(
    colors: [Color(0xFF7AA48A), Color(0xFF5C8A6E)],
  );

  static const LinearGradient cardGlow = LinearGradient(
    colors: [Color(0xFF2C2C2E), Color(0xFF1C1C1E)],
  );

  static List<BoxShadow> softShadow({double opacity = 0.18}) => [
        BoxShadow(
          color: const Color(0xFF000000).withValues(alpha: opacity),
          blurRadius: 18,
          offset: const Offset(0, 8),
        ),
      ];
}
