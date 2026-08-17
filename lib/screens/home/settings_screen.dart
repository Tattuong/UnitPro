import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/services/sound_service.dart';
import '../../models/app_theme_preset.dart';
import '../../providers/converter_provider.dart';
import '../../providers/shop_provider.dart';
import '../../providers/theme_provider.dart';
import '../../widgets/app_toast.dart';
import '../../widgets/app_ui.dart';
import '../../widgets/app_scaffold.dart';
import '../privacy_policy_screen.dart';
import '../shop/shop_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeProvider>();
    final sound = context.watch<SoundService>();
    final conv = context.watch<ConverterProvider>();
    final ftr = context.ftrTheme;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(AppStrings.t(context, 'settings')),
        backgroundColor: Colors.transparent,
        foregroundColor: AppColors.ink(context),
      ),
      body: FtrBackground(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text(
                AppStrings.t(
                    context, 'statsConverts', {'n': '${conv.weekConverts}'}),
                style: AppTypography.labelBold(
                    size: 15, color: AppColors.ink(context))),
            const SizedBox(height: 4),
            Text(AppStrings.t(context, 'statsStreak', {'n': '${conv.streak}'}),
                style: TextStyle(color: AppColors.muted(context))),
            const SizedBox(height: 4),
            Text(
                AppStrings.t(context, 'statsFavorites',
                    {'n': '${conv.favorites.length}'}),
                style: TextStyle(color: AppColors.muted(context))),
            const SizedBox(height: 18),
            _Tile(
              icon: Icons.storefront_outlined,
              title: AppStrings.t(context, 'shop'),
              onTap: () {
                Navigator.pop(context);
                ShopNav.open();
              },
            ),
            _Tile(
              icon: Icons.volume_up_outlined,
              title: AppStrings.t(context, 'soundEffects'),
              trailing: Switch(
                  value: sound.enabled,
                  onChanged: sound.setEnabled,
                  activeThumbColor: ftr.primaryLight),
            ),
            _Tile(
              icon: Icons.dark_mode_outlined,
              title: AppStrings.t(context, 'darkMode'),
              trailing: Switch(
                  value: theme.isDarkMode,
                  onChanged: (_) => theme.toggleTheme(),
                  activeThumbColor: ftr.primaryLight),
            ),
            _Tile(
              icon: Icons.restart_alt_rounded,
              title: AppStrings.t(context, 'resetDefault'),
              subtitle: AppStrings.t(context, 'resetDefaultDesc'),
              onTap: () async {
                await context.read<ShopProvider>().resetThemeToDefault();
                await context.read<ShopProvider>().resetBackgroundToDefault();
                await context.read<ShopProvider>().resetSkinToDefault();
                if (context.mounted)
                  AppToast.show(context,
                      title: AppStrings.t(context, 'applied'));
              },
            ),
            _Tile(
              icon: Icons.privacy_tip_outlined,
              title: AppStrings.t(context, 'privacyPolicy'),
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                      builder: (_) => const PrivacyPolicyScreen())),
            ),
            _Tile(
              icon: Icons.info_outline,
              title: AppStrings.t(context, 'about'),
              subtitle: AppStrings.t(context, 'version', {'v': '1.0.1'}),
            ),
          ],
        ),
      ),
    );
  }
}

class _Tile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  const _Tile(
      {required this.icon,
      required this.title,
      this.subtitle,
      this.trailing,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    final ftr = context.ftrTheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: LumenPaper(
        fill: ftr.surface,
        fallbackRadius: 16,
        padding: EdgeInsets.zero,
        onTap: onTap,
        child: ListTile(
          leading: Icon(icon, color: ftr.primary),
          title: Text(title,
              style: AppTypography.labelBold(
                  size: 15, color: AppColors.ink(context))),
          subtitle: subtitle != null
              ? Text(subtitle!,
                  style:
                      TextStyle(color: AppColors.muted(context), fontSize: 12))
              : null,
          trailing: trailing ??
              (onTap != null
                  ? const Icon(Icons.chevron_right_rounded,
                      color: AppColors.textMuted)
                  : null),
        ),
      ),
    );
  }
}
