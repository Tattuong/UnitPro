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

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final conv = context.watch<ConverterProvider>();
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
        children: [
          Row(
            children: [
              Expanded(
                child: Text(AppStrings.t(context, 'history'), style: GoogleFonts.nunito(fontSize: 28, fontWeight: FontWeight.w800, color: context.lumenAccent)),
              ),
              if (conv.history.isNotEmpty)
                TextButton(
                  onPressed: () {
                    SoundService.instance.tap();
                    conv.clearHistory();
                  },
                  child: Text(AppStrings.t(context, 'clearHistory'), style: GoogleFonts.nunito(fontWeight: FontWeight.w800, color: AppColors.muted(context))),
                ),
            ],
          ),
          const SizedBox(height: 8),
          if (conv.history.isEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 48),
              child: Text(AppStrings.t(context, 'historyEmpty'), style: GoogleFonts.nunito(color: AppColors.muted(context), fontWeight: FontWeight.w600)),
            )
          else
            for (final row in conv.history)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Material(
                  color: AppColors.card(context),
                  borderRadius: BorderRadius.circular(18),
                  child: ListTile(
                    onTap: () {
                      SoundService.instance.tap();
                      conv.applyPair(row.pair);
                      conv.setInput(row.input);
                      AppTabs.goConverter();
                    },
                    title: Text(
                      '${row.input} ${UnitCatalog.get(row.pair.categoryId).unit(row.pair.fromId).symbol} → ${row.output} ${UnitCatalog.get(row.pair.categoryId).unit(row.pair.toId).symbol}',
                      style: GoogleFonts.nunito(fontWeight: FontWeight.w800, color: AppColors.ink(context)),
                    ),
                    subtitle: Text(AppStrings.t(context, UnitCatalog.get(row.pair.categoryId).titleKey), style: GoogleFonts.nunito(color: AppColors.muted(context))),
                  ),
                ),
              ),
        ],
      ),
    );
  }
}
