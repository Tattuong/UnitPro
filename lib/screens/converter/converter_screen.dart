import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/services/sound_service.dart';
import '../../models/app_theme_preset.dart';
import '../../models/unit_catalog.dart';
import '../../providers/converter_provider.dart';
import '../../providers/shop_provider.dart';
import '../../widgets/app_toast.dart';
import '../../widgets/coin_balance_chip.dart';
import '../home/settings_screen.dart';
import 'pro_shop.dart';

class ConverterScreen extends StatelessWidget {
  const ConverterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final conv = context.watch<ConverterProvider>();
    final shop = context.watch<ShopProvider>();
    final decimals = shop.hasPrecision ? 10 : 6;
    final ink = AppColors.ink(context);

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  AppStrings.t(context, 'unitConverter'),
                  style: GoogleFonts.nunito(
                      fontSize: 22, fontWeight: FontWeight.w800, color: ink),
                ),
              ),
              const CoinBalanceChip(variant: CoinChipVariant.header),
              IconButton(
                onPressed: () {
                  SoundService.instance.tap();
                  conv.toggleFavorite();
                  AppToast.show(
                    context,
                    title: AppStrings.t(
                        context,
                        conv.isFavoritePair(conv.currentPair)
                            ? 'addedFavorite'
                            : 'removedFavorite'),
                  );
                },
                icon: Icon(
                  conv.isFavoritePair(conv.currentPair)
                      ? Icons.star_rounded
                      : Icons.star_outline_rounded,
                  color: context.lumenAccent,
                ),
              ),
              PopupMenuButton<String>(
                icon: Icon(Icons.more_vert_rounded, color: ink),
                onSelected: (value) {
                  SoundService.instance.tap();
                  if (value == 'settings') {
                    Navigator.push(
                        context,
                        MaterialPageRoute<void>(
                            builder: (_) => const SettingsScreen()));
                  }
                },
                itemBuilder: (_) => [
                  PopupMenuItem(
                      value: 'settings',
                      child: Text(AppStrings.t(context, 'settings'))),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (final cat in UnitCatalog.all) ...[
                  _CatChip(
                    category: cat,
                    selected: conv.categoryId == cat.id,
                    locked: cat.premium && !shop.hasProPack,
                    onTap: () async {
                      SoundService.instance.tap();
                      if (cat.premium && !shop.hasProPack) {
                        await openProShop(context);
                        return;
                      }
                      await conv.setCategory(cat.id);
                    },
                  ),
                  const SizedBox(width: 8),
                ],
              ],
            ),
          ),
          const SizedBox(height: 18),
          Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              Column(
                children: [
                  _UnitCard(
                    unit: conv.fromUnit,
                    value: conv.input,
                    editable: true,
                    onChanged: conv.setInput,
                    onPick: () => _pickUnit(context, conv, from: true),
                  ),
                  const SizedBox(height: 16),
                  _UnitCard(
                    unit: conv.toUnit,
                    value: conv.output(decimals: decimals),
                    editable: false,
                    onPick: () => _pickUnit(context, conv, from: false),
                    onLongPress: () async {
                      final text = conv.output(decimals: decimals);
                      if (text.isEmpty) return;
                      await Clipboard.setData(ClipboardData(text: text));
                      if (context.mounted) {
                        AppToast.show(context,
                            title: AppStrings.t(context, 'copyResult'));
                      }
                    },
                  ),
                ],
              ),
              Positioned(
                right: 14,
                child: Material(
                  color: context.lumenAccent,
                  shape: const CircleBorder(),
                  elevation: 6,
                  shadowColor: Colors.black54,
                  child: InkWell(
                    customBorder: const CircleBorder(),
                    onTap: () {
                      SoundService.instance.tap();
                      conv.swap();
                    },
                    child: const SizedBox(
                      width: 44,
                      height: 44,
                      child: Icon(Icons.swap_vert_rounded, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(AppStrings.t(context, 'quickAccess'),
              style: GoogleFonts.nunito(
                  fontSize: 16, fontWeight: FontWeight.w800, color: ink)),
          const SizedBox(height: 12),
          GridView.count(
            crossAxisCount: 3,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 1.55,
            children: [
              for (final id in conv.category.quickIds)
                _QuickTile(
                  unit: conv.category.unit(id),
                  selected: conv.toId == id || conv.fromId == id,
                  onTap: () {
                    SoundService.instance.tap();
                    conv.setTo(id);
                  },
                ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _pickUnit(BuildContext context, ConverterProvider conv,
      {required bool from}) async {
    SoundService.instance.tap();
    final picked = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: AppColors.card(context),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) => SafeArea(
        child: ListView(
          shrinkWrap: true,
          children: [
            for (final unit in conv.category.units)
              ListTile(
                title: Text(unit.label,
                    style: GoogleFonts.nunito(
                        fontWeight: FontWeight.w700,
                        color: AppColors.ink(ctx))),
                trailing: (from ? conv.fromId : conv.toId) == unit.id
                    ? Icon(Icons.check_rounded, color: ctx.lumenAccent)
                    : null,
                onTap: () => Navigator.pop(ctx, unit.id),
              ),
          ],
        ),
      ),
    );
    if (picked == null) return;
    if (from) {
      await conv.setFrom(picked);
    } else {
      await conv.setTo(picked);
    }
  }
}

class _CatChip extends StatelessWidget {
  final UnitCategory category;
  final bool selected;
  final bool locked;
  final VoidCallback onTap;

  const _CatChip(
      {required this.category,
      required this.selected,
      required this.locked,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    final accent = context.lumenAccent;
    return Material(
      color: selected ? accent : AppColors.card(context),
      borderRadius: BorderRadius.circular(22),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                AppStrings.t(context, category.titleKey),
                style: GoogleFonts.nunito(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: selected ? context.lumenOnAccent : AppColors.ink(context),
                ),
              ),
              if (locked) ...[
                const SizedBox(width: 6),
                Icon(
                  Icons.lock_rounded,
                  size: 14,
                  color: selected ? context.lumenOnAccent : AppColors.muted(context),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _UnitCard extends StatelessWidget {
  final MeasureUnit unit;
  final String value;
  final bool editable;
  final ValueChanged<String>? onChanged;
  final VoidCallback onPick;
  final VoidCallback? onLongPress;

  const _UnitCard({
    required this.unit,
    required this.value,
    required this.editable,
    required this.onPick,
    this.onChanged,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final ink = AppColors.ink(context);
    return Material(
      color: AppColors.card(context),
      borderRadius: BorderRadius.circular(22),
      child: InkWell(
        onLongPress: onLongPress,
        borderRadius: BorderRadius.circular(22),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 16, 14, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: onPick,
                child: Row(
                  children: [
                    Expanded(
                      child: Text(unit.label,
                          style: GoogleFonts.nunito(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: ink)),
                    ),
                    Icon(Icons.expand_more_rounded,
                        color: AppColors.muted(context)),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              if (editable)
                _ValueField(
                  value: value,
                  onChanged: onChanged!,
                  onSubmit: () async {
                    await context.read<ConverterProvider>().logConversion();
                    if (context.mounted)
                      await context.read<ShopProvider>().rewardForConversion();
                  },
                )
              else
                Text(value.isEmpty ? '—' : value,
                    style: GoogleFonts.nunito(
                        fontSize: 36, fontWeight: FontWeight.w800, color: ink)),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuickTile extends StatelessWidget {
  final MeasureUnit unit;
  final bool selected;
  final VoidCallback onTap;

  const _QuickTile(
      {required this.unit, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.card(context),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(unit.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.nunito(
                      fontWeight: FontWeight.w800,
                      fontSize: 13,
                      color: AppColors.ink(context))),
              Text(unit.symbol,
                  style: GoogleFonts.nunito(
                      fontSize: 12,
                      color: selected
                          ? context.lumenAccent
                          : AppColors.muted(context),
                      fontWeight: FontWeight.w700)),
            ],
          ),
        ),
      ),
    );
  }
}

class _ValueField extends StatefulWidget {
  final String value;
  final ValueChanged<String> onChanged;
  final VoidCallback onSubmit;

  const _ValueField(
      {required this.value, required this.onChanged, required this.onSubmit});

  @override
  State<_ValueField> createState() => _ValueFieldState();
}

class _ValueFieldState extends State<_ValueField> {
  late final TextEditingController _controller;
  late final FocusNode _focus;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value);
    _focus = FocusNode();
    _focus.addListener(() {
      if (!_focus.hasFocus) widget.onSubmit();
    });
  }

  @override
  void didUpdateWidget(covariant _ValueField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != _controller.text) {
      _controller.value = TextEditingValue(
        text: widget.value,
        selection: TextSelection.collapsed(offset: widget.value.length),
      );
    }
  }

  @override
  void dispose() {
    _focus.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      focusNode: _focus,
      keyboardType:
          const TextInputType.numberWithOptions(decimal: true, signed: true),
      style: GoogleFonts.nunito(
          fontSize: 36,
          fontWeight: FontWeight.w800,
          color: AppColors.ink(context)),
      decoration:
          const InputDecoration(border: InputBorder.none, isDense: true),
      onChanged: widget.onChanged,
      onSubmitted: (_) => widget.onSubmit(),
    );
  }
}
