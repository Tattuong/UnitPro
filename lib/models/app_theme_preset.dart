import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../widgets/app_ui.dart';

@immutable
class FtrTheme extends ThemeExtension<FtrTheme> {
  final Color primary;
  final Color primaryLight;
  final Color surface;
  final Color surfaceElevated;
  final Color border;
  final Color navBar;
  final Color navActive;
  final Color glowColor;
  final LinearGradient balanceGradient;
  final bool isPremium;

  const FtrTheme({
    required this.primary,
    required this.primaryLight,
    required this.surface,
    required this.surfaceElevated,
    required this.border,
    required this.navBar,
    required this.navActive,
    required this.glowColor,
    required this.balanceGradient,
    required this.isPremium,
  });

  factory FtrTheme.fromPreset(AppThemePreset preset, {bool isDark = true}) {
    final surface = isDark ? preset.darkSurface : preset.surface;
    final lift = preset.isPremium ? 0.14 : 0.08;
    final surfaceElevated = isDark
        ? (Color.lerp(preset.darkSurface, preset.isPremium ? preset.primary : Colors.white, lift) ??
            preset.darkSurface)
        : (Color.lerp(preset.surface, Colors.white, 0.12) ?? preset.surface);
    final border = Color.lerp(preset.primary, surface, preset.isPremium ? 0.35 : (isDark ? 0.55 : 0.72))
            ?.withValues(alpha: preset.isPremium ? 0.7 : (isDark ? 0.55 : 0.35)) ??
        AppColors.border;
    return FtrTheme(
      primary: preset.primary,
      primaryLight: preset.primaryLight,
      surface: surface,
      surfaceElevated: surfaceElevated,
      border: border,
      navBar: isDark
          ? (preset.isPremium
              ? (Color.lerp(const Color(0xFF0A0A0C), preset.primary, 0.16) ?? AppColors.navBar)
              : AppColors.navBar)
          : Colors.white,
      navActive: preset.primary,
      glowColor: preset.glowColor,
      balanceGradient: preset.balanceGradient,
      isPremium: preset.isPremium,
    );
  }

  static FtrTheme get fallback =>
      FtrTheme.fromPreset(AppThemePresets.defaultPreset, isDark: true);

  @override
  FtrTheme copyWith({
    Color? primary,
    Color? primaryLight,
    Color? surface,
    Color? surfaceElevated,
    Color? border,
    Color? navBar,
    Color? navActive,
    Color? glowColor,
    LinearGradient? balanceGradient,
    bool? isPremium,
  }) {
    return FtrTheme(
      primary: primary ?? this.primary,
      primaryLight: primaryLight ?? this.primaryLight,
      surface: surface ?? this.surface,
      surfaceElevated: surfaceElevated ?? this.surfaceElevated,
      border: border ?? this.border,
      navBar: navBar ?? this.navBar,
      navActive: navActive ?? this.navActive,
      glowColor: glowColor ?? this.glowColor,
      balanceGradient: balanceGradient ?? this.balanceGradient,
      isPremium: isPremium ?? this.isPremium,
    );
  }

  @override
  FtrTheme lerp(ThemeExtension<FtrTheme>? other, double t) {
    if (other is! FtrTheme) return this;
    return FtrTheme(
      primary: Color.lerp(primary, other.primary, t)!,
      primaryLight: Color.lerp(primaryLight, other.primaryLight, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      surfaceElevated: Color.lerp(surfaceElevated, other.surfaceElevated, t)!,
      border: Color.lerp(border, other.border, t)!,
      navBar: Color.lerp(navBar, other.navBar, t)!,
      navActive: Color.lerp(navActive, other.navActive, t)!,
      glowColor: Color.lerp(glowColor, other.glowColor, t)!,
      balanceGradient:
          LinearGradient.lerp(balanceGradient, other.balanceGradient, t) ??
              balanceGradient,
      isPremium: t < 0.5 ? isPremium : other.isPremium,
    );
  }

  BoxDecoration surfaceCard(
      {double radius = 20, bool elevated = true, bool intense = false}) {
    return BoxDecoration(
      color: elevated ? surfaceElevated : surface,
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(
        color: isPremium
            ? glowColor.withValues(alpha: intense ? 0.62 : 0.4)
            : border,
        width: isPremium ? 1.5 : 1,
      ),
      boxShadow: [
        if (isPremium)
          BoxShadow(
            color: glowColor.withValues(alpha: intense ? 0.34 : 0.2),
            blurRadius: intense ? 28 : 18,
            spreadRadius: -2,
            offset: const Offset(0, 6),
          ),
        BoxShadow(
            color: const Color(0xFF2A241F).withValues(alpha: 0.08),
            blurRadius: 18,
            offset: const Offset(0, 8)),
      ],
    );
  }

  BoxDecoration accentButton({double radius = 14}) {
    return BoxDecoration(
      gradient: isPremium ? balanceGradient : null,
      color: isPremium ? null : primary,
      borderRadius: BorderRadius.circular(radius),
      boxShadow: isPremium
          ? [
              BoxShadow(
                  color: glowColor.withValues(alpha: 0.45),
                  blurRadius: 18,
                  offset: const Offset(0, 5)),
              BoxShadow(
                  color: primaryLight.withValues(alpha: 0.22), blurRadius: 8),
            ]
          : null,
    );
  }

  BoxDecoration pillBadge({double radius = 20}) {
    return BoxDecoration(
      color: surface,
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(
          color: isPremium ? glowColor.withValues(alpha: 0.62) : primary,
          width: isPremium ? 1.5 : 1),
      boxShadow: isPremium
          ? [
              BoxShadow(
                  color: glowColor.withValues(alpha: 0.38),
                  blurRadius: 14,
                  spreadRadius: -2)
            ]
          : null,
    );
  }

  BoxDecoration coinChip({bool header = false}) {
    if (!isPremium) {
      return BoxDecoration(
        color: header ? surfaceElevated : surface,
        borderRadius: BorderRadius.circular(header ? 12 : 20),
        border: Border.all(color: border),
      );
    }
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [surfaceElevated, Color.lerp(surface, glowColor, 0.14)!],
      ),
      borderRadius: BorderRadius.circular(header ? 12 : 20),
      border: Border.all(color: glowColor.withValues(alpha: 0.58), width: 1.5),
      boxShadow: [
        BoxShadow(
            color: glowColor.withValues(alpha: 0.32),
            blurRadius: 14,
            spreadRadius: -2)
      ],
    );
  }
}

extension FtrThemeContext on BuildContext {
  FtrTheme get ftrTheme =>
      Theme.of(this).extension<FtrTheme>() ?? FtrTheme.fallback;

  Color get lumenAccent => Theme.of(this).colorScheme.primary;
  Color get lumenOnAccent => Theme.of(this).colorScheme.onPrimary;
  Color get lumenAccentSoft =>
      Color.lerp(Theme.of(this).scaffoldBackgroundColor, lumenAccent, 0.2) ??
      lumenAccent;
}

class AppThemePreset {
  final String id;
  final Color primary;
  final Color primaryLight;
  final Color background;
  final Color surface;
  final Color darkBackground;
  final Color darkSurface;
  final Color glowColor;
  final LinearGradient headerGradient;
  final LinearGradient balanceGradient;
  final LinearGradient shopPreviewGradient;

  const AppThemePreset({
    required this.id,
    required this.primary,
    required this.primaryLight,
    required this.background,
    required this.surface,
    required this.darkBackground,
    required this.darkSurface,
    required this.glowColor,
    required this.headerGradient,
    required this.balanceGradient,
    required this.shopPreviewGradient,
  });

  bool get isPremium => id != 'theme_default';

  ThemeData lightTheme() => _buildTheme(
        brightness: Brightness.light,
        scaffold: background,
        surfaceColor: surface,
        onSurface: AppColors.lightTextPrimary,
      );

  ThemeData darkTheme() => _buildTheme(
        brightness: Brightness.dark,
        scaffold: darkBackground,
        surfaceColor: darkSurface,
        onSurface: AppColors.darkInk,
      );

  ThemeData _buildTheme({
    required Brightness brightness,
    required Color scaffold,
    required Color surfaceColor,
    required Color onSurface,
  }) {
    final isDark = brightness == Brightness.dark;
    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      scaffoldBackgroundColor: scaffold,
      colorScheme: isDark
          ? ColorScheme.dark(
              primary: primary,
              onPrimary: Colors.white,
              secondary: primaryLight,
              tertiary: primaryLight,
              surface: surfaceColor,
              onSurface: onSurface,
              onSurfaceVariant: AppColors.textSecondary,
              outline: Color.lerp(primary, surfaceColor, 0.55)
                  ?.withValues(alpha: 0.55),
            )
          : ColorScheme.light(
              primary: primary,
              onPrimary: Colors.white,
              secondary: primaryLight,
              tertiary: primaryLight,
              surface: surfaceColor,
              onSurface: onSurface,
              onSurfaceVariant: const Color(0xFF5A5670),
              outline: Color.lerp(primary, surfaceColor, 0.72)
                  ?.withValues(alpha: 0.35),
            ),
      textTheme: AppTypography.textTheme(brightness),
      iconTheme: IconThemeData(color: onSurface),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        foregroundColor: onSurface,
        iconTheme: IconThemeData(color: onSurface),
        titleTextStyle: TextStyle(
          color: isDark ? AppColors.textSecondary : AppColors.textMuted,
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
      ),
      cardTheme: CardThemeData(
        color: surfaceColor,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
              color: isDark ? AppColors.border : const Color(0xFFE2E5EF)),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: primary,
        foregroundColor: Colors.white,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
        ),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected) ? primary : null,
        ),
        trackColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? primary.withValues(alpha: 0.45)
              : null,
        ),
      ),
      extensions: [FtrTheme.fromPreset(this, isDark: isDark)],
    );
  }
}

class AppThemePresets {
  AppThemePresets._();

  static const defaultPreset = AppThemePreset(
    id: 'theme_default',
    primary: AppColors.primary,
    primaryLight: AppColors.primaryLight,
    background: AppColors.background,
    surface: AppColors.surface,
    darkBackground: AppColors.darkBackground,
    darkSurface: AppColors.darkSurface,
    glowColor: AppColors.primaryLight,
    headerGradient: AppColors.headerGradient,
    balanceGradient: AppColors.primaryGradient,
    shopPreviewGradient: AppColors.primaryGradient,
  );

  static const emerald = AppThemePreset(
    id: 'theme_emerald',
    primary: Color(0xFF2DD4BF),
    primaryLight: Color(0xFF5EEAD4),
    background: Color(0xFFECFDF8),
    surface: Color(0xFFF0FDFA),
    darkBackground: Color(0xFF020807),
    darkSurface: Color(0xFF0B1C18),
    glowColor: Color(0xFF2DD4BF),
    headerGradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Color(0xFF06302A), Color(0xFF020807)],
    ),
    balanceGradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFF99F6E4), Color(0xFF2DD4BF), Color(0xFF0F766E)],
    ),
    shopPreviewGradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFF042F2E), Color(0xFF115E59), Color(0xFF2DD4BF)],
    ),
  );

  static const gold = AppThemePreset(
    id: 'theme_gold',
    primary: Color(0xFFF5C542),
    primaryLight: Color(0xFFFFE08A),
    background: Color(0xFFFFF7E8),
    surface: Color(0xFFFFFBEB),
    darkBackground: Color(0xFF0A0803),
    darkSurface: Color(0xFF1C1608),
    glowColor: Color(0xFFFFD56A),
    headerGradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Color(0xFF3A2A0A), Color(0xFF0A0803)],
    ),
    balanceGradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFFFFF1C2), Color(0xFFF5C542), Color(0xFFB45309)],
    ),
    shopPreviewGradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFF2A1C06), Color(0xFF854D0E), Color(0xFFF5C542)],
    ),
  );

  static const midnight = AppThemePreset(
    id: 'theme_midnight',
    primary: Color(0xFFC084FC),
    primaryLight: Color(0xFFE9D5FF),
    background: Color(0xFFF5F0FF),
    surface: Color(0xFFFAF5FF),
    darkBackground: Color(0xFF07040F),
    darkSurface: Color(0xFF161022),
    glowColor: Color(0xFFD8B4FE),
    headerGradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Color(0xFF2E1064), Color(0xFF07040F)],
    ),
    balanceGradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFFE9D5FF), Color(0xFFC084FC), Color(0xFF7C3AED)],
    ),
    shopPreviewGradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFF1E0B3A), Color(0xFF6D28D9), Color(0xFFC084FC)],
    ),
  );

  static const Map<String, AppThemePreset> byId = {
    'theme_default': defaultPreset,
    'theme_emerald': emerald,
    'theme_gold': gold,
    'theme_midnight': midnight,
  };

  static AppThemePreset get(String? id) => byId[id] ?? defaultPreset;
}

class AppBackground {
  final String id;
  final LinearGradient gradient;
  final LinearGradient darkGradient;

  const AppBackground({
    required this.id,
    required this.gradient,
    LinearGradient? darkGradient,
  }) : darkGradient = darkGradient ?? gradient;

  LinearGradient forBrightness(Brightness brightness) =>
      brightness == Brightness.dark ? darkGradient : gradient;

  static const defaultBg =
      AppBackground(id: 'bg_default', gradient: AppColors.gameGradient);

  static const forest = AppBackground(
    id: 'bg_forest',
    gradient: LinearGradient(
      colors: [Color(0xFFDCE6C8), Color(0xFFF1EFE4), Color(0xFFC5D4A8)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    darkGradient: LinearGradient(
      colors: [Color(0xFF10160E), Color(0xFF000000), Color(0xFF1A2414)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
  );

  static const aurora = AppBackground(
    id: 'bg_aurora',
    gradient: LinearGradient(
      colors: [Color(0xFFD8D4EC), Color(0xFFF4F0EA), Color(0xFFC8E0DC)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    darkGradient: LinearGradient(
      colors: [Color(0xFF14101C), Color(0xFF000000), Color(0xFF10181A)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
  );

  static const sunset = AppBackground(
    id: 'bg_sunset',
    gradient: LinearGradient(
      colors: [Color(0xFFF6D8B8), Color(0xFFF8F0E4), Color(0xFFE8B898)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    darkGradient: LinearGradient(
      colors: [Color(0xFF1C120C), Color(0xFF000000), Color(0xFF1A1010)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
  );

  static const Map<String, AppBackground> byId = {
    'bg_default': defaultBg,
    'bg_forest': forest,
    'bg_aurora': aurora,
    'bg_sunset': sunset,
  };

  static AppBackground get(String? id) => byId[id] ?? defaultBg;
}

class CardStyle {
  final String id;
  final double borderRadius;
  final double borderWidth;
  final Color borderColor;
  final Color accentColor;
  final bool glassEffect;
  final bool neonGlow;

  const CardStyle({
    required this.id,
    this.borderRadius = 18,
    this.borderWidth = 0,
    this.borderColor = Colors.transparent,
    this.accentColor = AppColors.primaryLight,
    this.glassEffect = false,
    this.neonGlow = false,
  });

  static const defaultStyle = CardStyle(id: 'skin_default');

  static const soft = CardStyle(
    id: 'skin_soft',
    borderRadius: 24,
    glassEffect: true,
  );

  static const neon = CardStyle(
    id: 'skin_neon',
    borderRadius: 16,
    borderWidth: 2,
    borderColor: AppColors.primaryLight,
    accentColor: AppColors.primaryLight,
    neonGlow: true,
  );

  static const Map<String, CardStyle> byId = {
    'skin_default': defaultStyle,
    'skin_soft': soft,
    'skin_neon': neon,
  };

  static CardStyle get(String? id) => byId[id] ?? defaultStyle;

  double paperRadius([double fallback = 22]) =>
      id == 'skin_default' ? fallback : borderRadius;

  BoxDecoration lookDecoration({
    required Color fill,
    required Color accent,
    double? radius,
  }) {
    final r = radius ?? paperRadius();
    if (glassEffect) {
      return BoxDecoration(
        color: fill.withValues(alpha: 0.78),
        borderRadius: BorderRadius.circular(r),
        border: Border.all(color: accent.withValues(alpha: 0.28), width: 1.2),
        boxShadow: [
          BoxShadow(
              color: accent.withValues(alpha: 0.14),
              blurRadius: 20,
              offset: const Offset(0, 8)),
        ],
      );
    }
    if (neonGlow) {
      return BoxDecoration(
        color: fill,
        borderRadius: BorderRadius.circular(r),
        border: Border.all(color: accent, width: 1.6),
        boxShadow: [
          BoxShadow(
              color: accent.withValues(alpha: 0.3),
              blurRadius: 16,
              spreadRadius: -2),
        ],
      );
    }
    return BoxDecoration(
      color: fill,
      borderRadius: BorderRadius.circular(r),
    );
  }

  BoxDecoration gameCardDecoration({
    required Color fill,
    bool highlight = false,
    Color? stateBorder,
    double stateBorderWidth = 1.5,
  }) {
    final hasSkinBorder = borderWidth > 0;
    final defaultBorder = hasSkinBorder ? borderColor : AppColors.border;
    final width = stateBorder != null
        ? stateBorderWidth
        : (hasSkinBorder ? borderWidth : 1.0);
    final border = highlight && stateBorder == null
        ? accentColor.withValues(alpha: 0.85)
        : (stateBorder ?? defaultBorder);

    if (glassEffect) {
      return BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        color: fill.withValues(alpha: stateBorder != null ? 0.82 : 0.68),
        border: Border.all(
          color: stateBorder != null
              ? border
              : Colors.white.withValues(alpha: 0.16),
          width: width,
        ),
        boxShadow: [
          BoxShadow(
            color: accentColor.withValues(alpha: neonGlow ? 0.42 : 0.14),
            blurRadius: neonGlow ? 18 : 22,
            offset: const Offset(0, 8),
          ),
          if (neonGlow)
            BoxShadow(
                color: accentColor.withValues(alpha: 0.18), blurRadius: 6),
        ],
      );
    }

    return BoxDecoration(
      color: fill,
      borderRadius: BorderRadius.circular(borderRadius),
      border: Border.all(color: border, width: width),
      boxShadow: neonGlow
          ? [
              BoxShadow(
                  color: accentColor.withValues(alpha: 0.42),
                  blurRadius: 18,
                  spreadRadius: -2),
              BoxShadow(
                  color: accentColor.withValues(alpha: 0.18), blurRadius: 6),
            ]
          : null,
    );
  }
}
