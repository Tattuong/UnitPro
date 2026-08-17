import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/navigation/app_navigator.dart';
import '../../core/services/sound_service.dart';
import '../../models/app_theme_preset.dart';
import '../../models/unit_catalog.dart';
import '../../providers/converter_provider.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final conv = context.watch<ConverterProvider>();
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
        children: [
          Text(AppStrings.t(context, 'favorites'), style: GoogleFonts.nunito(fontSize: 28, fontWeight: FontWeight.w800, color: context.lumenAccent)),
          const SizedBox(height: 8),
          if (conv.favorites.isEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 48),
              child: Text(AppStrings.t(context, 'favoritesEmpty'), style: GoogleFonts.nunito(color: AppColors.muted(context), fontWeight: FontWeight.w600)),
            )
          else
            for (final pair in conv.favorites)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Material(
                  color: AppColors.card(context),
                  borderRadius: BorderRadius.circular(18),
                  child: ListTile(
                    onTap: () {
                      SoundService.instance.tap();
                      conv.applyPair(pair);
                      AppTabs.goConverter();
                    },
                    title: Text(_pairTitle(pair), style: GoogleFonts.nunito(fontWeight: FontWeight.w800, color: AppColors.ink(context))),
                    subtitle: Text(AppStrings.t(context, UnitCatalog.get(pair.categoryId).titleKey), style: GoogleFonts.nunito(color: AppColors.muted(context))),
                    trailing: IconButton(
                      icon: Icon(Icons.star_rounded, color: context.lumenAccent),
                      onPressed: () => conv.removeFavorite(pair),
                    ),
                  ),
                ),
              ),
        ],
      ),
    );
  }

  String _pairTitle(ConversionPair pair) {
    final cat = UnitCatalog.get(pair.categoryId);
    return '${cat.unit(pair.fromId).symbol} → ${cat.unit(pair.toId).symbol}';
  }
}
