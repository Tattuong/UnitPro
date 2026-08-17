import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/constants/app_colors.dart';
import '../models/app_theme_preset.dart';
import '../models/shop_item.dart';
import '../providers/shop_provider.dart';
import 'app_ui.dart';

class FtrBackground extends StatelessWidget {
  final Widget child;

  const FtrBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final bg = context.select<ShopProvider, AppBackground>((s) => s.activeBackground);
    final ftr = context.ftrTheme;
    return Stack(
      fit: StackFit.expand,
      children: [
        if (bg.id != ShopCatalog.defaultBackgroundId)
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: bg.forBrightness(Theme.of(context).brightness),
            ),
          ),
        if (ftr.isPremium) ...[
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    ftr.glowColor.withValues(alpha: 0.22),
                    Colors.transparent,
                    ftr.primary.withValues(alpha: 0.16),
                    ftr.glowColor.withValues(alpha: 0.08),
                  ],
                  stops: const [0.0, 0.32, 0.72, 1.0],
                ),
              ),
            ),
          ),
          Positioned(
            top: -110,
            right: -80,
            child: IgnorePointer(
              child: GlowOrb(color: ftr.glowColor.withValues(alpha: 0.48), size: 320),
            ),
          ),
          Positioned(
            top: 120,
            left: -90,
            child: IgnorePointer(
              child: GlowOrb(color: ftr.primary.withValues(alpha: 0.28), size: 240),
            ),
          ),
          Positioned(
            bottom: 48,
            right: -40,
            child: IgnorePointer(
              child: GlowOrb(color: ftr.primaryLight.withValues(alpha: 0.26), size: 200),
            ),
          ),
        ],
        child,
      ],
    );
  }
}

class FtrScaffold extends StatelessWidget {
  final Widget body;
  final PreferredSizeWidget? appBar;
  final Widget? floatingActionButton;
  final Widget? bottomNavigationBar;
  final bool extendBody;

  const FtrScaffold({
    super.key,
    required this.body,
    this.appBar,
    this.floatingActionButton,
    this.bottomNavigationBar,
    this.extendBody = true,
  });

  @override
  Widget build(BuildContext context) {
    final scaffoldColor = Theme.of(context).scaffoldBackgroundColor;
    return Scaffold(
      extendBody: extendBody,
      backgroundColor: scaffoldColor,
      appBar: appBar,
      floatingActionButton: floatingActionButton,
      body: FtrBackground(child: body),
      bottomNavigationBar: bottomNavigationBar,
    );
  }
}

class AppSheetHandle extends StatelessWidget {
  const AppSheetHandle({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 36,
        height: 4,
        margin: const EdgeInsets.only(top: 10, bottom: 8),
        decoration: BoxDecoration(
          color: AppColors.border,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }
}
