import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/navigation/app_navigator.dart';
import '../../models/app_theme_preset.dart';
import '../../models/shop_item.dart';
import '../../providers/shop_provider.dart';
import '../../widgets/app_scaffold.dart';
import '../../widgets/app_toast.dart';
import '../../widgets/app_ui.dart';
import '../../widgets/coin_balance_chip.dart';
import '../../widgets/coin_purchase_sheet.dart';

enum ShopRewardsTab { themes, backgrounds, skins, features }

class ShopNav {
  static final section = ValueNotifier<ShopRewardsTab>(ShopRewardsTab.themes);

  static void open([ShopRewardsTab tab = ShopRewardsTab.themes]) {
    section.value = tab;
    AppTabs.goShop();
  }
}

class ShopScreen extends StatefulWidget {
  final ShopRewardsTab? initialTab;
  final bool embedded;

  const ShopScreen({super.key, this.initialTab, this.embedded = false});

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  late ShopRewardsTab _tab;

  @override
  void initState() {
    super.initState();
    _tab = widget.initialTab ?? ShopNav.section.value;
    ShopNav.section.addListener(_onSection);
  }

  void _onSection() {
    if (!mounted) return;
    final next = ShopNav.section.value;
    if (next != _tab) setState(() => _tab = next);
  }

  @override
  void dispose() {
    ShopNav.section.removeListener(_onSection);
    super.dispose();
  }

  List<ShopItem> get _items {
    return ShopCatalog.items.where((item) {
      return switch (_tab) {
        ShopRewardsTab.themes => item.category == ShopItemCategory.themes,
        ShopRewardsTab.backgrounds =>
          item.category == ShopItemCategory.backgrounds,
        ShopRewardsTab.skins => item.category == ShopItemCategory.skins,
        ShopRewardsTab.features => item.category == ShopItemCategory.features ||
            item.category == ShopItemCategory.premium,
      };
    }).toList();
  }

  void _setTab(ShopRewardsTab tab) {
    if (_tab == tab) return;
    setState(() => _tab = tab);
    if (ShopNav.section.value != tab) ShopNav.section.value = tab;
  }

  String get _tabTitle {
    return switch (_tab) {
      ShopRewardsTab.themes => AppStrings.t(context, 'shopMenuThemes'),
      ShopRewardsTab.backgrounds =>
        AppStrings.t(context, 'shopMenuBackgrounds'),
      ShopRewardsTab.skins => AppStrings.t(context, 'shopMenuSkins'),
      ShopRewardsTab.features => AppStrings.t(context, 'shopMenuFeatures'),
    };
  }

  @override
  Widget build(BuildContext context) {
    final shop = context.watch<ShopProvider>();
    final items = _items;

    final body = SafeArea(
      bottom: false,
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(widget.embedded ? 20 : 8, 12, 16, 0),
              child: Row(
                children: [
                  if (!widget.embedded && Navigator.of(context).canPop())
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(Icons.arrow_back_rounded,
                          color: AppColors.ink(context)),
                    ),
                  Expanded(
                    child: Text(
                      AppStrings.t(context, 'shop'),
                      style: GoogleFonts.nunito(
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          color: context.lumenAccent),
                    ),
                  ),
                  CoinBalanceChip(onTap: () => CoinPurchaseSheet.show(context)),
                ],
              ),
            ),
          ),
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: _TodayPaper(),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _ShopTab(
                      label: AppStrings.t(context, 'shopMenuThemes'),
                      selected: _tab == ShopRewardsTab.themes,
                      onTap: () => _setTab(ShopRewardsTab.themes),
                    ),
                    const SizedBox(width: 8),
                    _ShopTab(
                      label: AppStrings.t(context, 'shopMenuBackgrounds'),
                      selected: _tab == ShopRewardsTab.backgrounds,
                      onTap: () => _setTab(ShopRewardsTab.backgrounds),
                    ),
                    const SizedBox(width: 8),
                    _ShopTab(
                      label: AppStrings.t(context, 'shopMenuSkins'),
                      selected: _tab == ShopRewardsTab.skins,
                      onTap: () => _setTab(ShopRewardsTab.skins),
                    ),
                    const SizedBox(width: 8),
                    _ShopTab(
                      label: AppStrings.t(context, 'shopMenuFeatures'),
                      selected: _tab == ShopRewardsTab.features,
                      onTap: () => _setTab(ShopRewardsTab.features),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(22, 18, 22, 10),
              child: Text(
                _tabTitle,
                style: GoogleFonts.nunito(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: context.lumenAccent,
                    letterSpacing: 0.4),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 0.95,
              ),
              delegate: SliverChildBuilderDelegate(
                (_, i) => _DeskPaper(
                  item: items[i],
                  shop: shop,
                  paper: AppColors.paper(context, i),
                ),
                childCount: items.length,
              ),
            ),
          ),
          if (!shop.isBillingDisabled)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 36),
                child: TextButton(
                  onPressed: shop.restorePurchases,
                  style: TextButton.styleFrom(
                      foregroundColor: AppColors.muted(context)),
                  child: Text(AppStrings.t(context, 'restorePurchases'),
                      style: GoogleFonts.nunito(fontWeight: FontWeight.w700)),
                ),
              ),
            ),
        ],
      ),
    );

    if (widget.embedded) return body;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: FtrBackground(child: body),
    );
  }
}

class _ShopTab extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _ShopTab(
      {required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? context.lumenAccent : AppColors.card(context),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
              color: selected ? context.lumenAccent : AppColors.line(context)),
        ),
        child: Text(
          label,
          style: GoogleFonts.nunito(
            fontWeight: FontWeight.w800,
            color: selected ? context.lumenOnAccent : AppColors.ink(context),
          ),
        ),
      ),
    );
  }
}

class _TodayPaper extends StatefulWidget {
  const _TodayPaper();

  @override
  State<_TodayPaper> createState() => _TodayPaperState();
}

class _TodayPaperState extends State<_TodayPaper> {
  bool _dailyClaimed = false;
  bool _spinUsed = false;

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  Future<void> _refresh() async {
    final shop = context.read<ShopProvider>();
    final daily = await shop.hasClaimedDailyToday();
    final spin = await shop.hasSpunToday();
    if (!mounted) return;
    setState(() {
      _dailyClaimed = daily;
      _spinUsed = spin;
    });
  }

  @override
  Widget build(BuildContext context) {
    final shop = context.watch<ShopProvider>();
    return LumenPaper(
      fill: AppColors.card(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(AppStrings.t(context, 'shopToday'),
              style: GoogleFonts.nunito(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: AppColors.ink(context))),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _Pill(
                label: _dailyClaimed
                    ? AppStrings.t(context, 'dailyClaimed')
                    : AppStrings.t(context, 'claimDaily'),
                dim: _dailyClaimed,
                onTap: _dailyClaimed
                    ? null
                    : () async {
                        await shop.claimDailyReward();
                        if (context.mounted) _refresh();
                      },
              ),
              _Pill(
                label: _spinUsed
                    ? AppStrings.t(context, 'dailyClaimed')
                    : AppStrings.t(context, 'spinNow'),
                dim: _spinUsed,
                onTap: _spinUsed
                    ? null
                    : () async {
                        await shop.spinDailyWheel();
                        if (context.mounted) _refresh();
                      },
              ),
              if (!shop.isBillingDisabled)
                _Pill(
                  label: AppStrings.t(context, 'shopPacks'),
                  dim: false,
                  onTap: () => CoinPurchaseSheet.show(context),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  final String label;
  final bool dim;
  final VoidCallback? onTap;

  const _Pill({required this.label, required this.dim, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Opacity(
        opacity: dim ? 0.5 : 1,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: dim ? AppColors.card(context) : context.lumenAccent,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            label,
            style: GoogleFonts.nunito(
              fontWeight: FontWeight.w800,
              color: dim ? AppColors.muted(context) : context.lumenOnAccent,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }
}

class _DeskPaper extends StatelessWidget {
  final ShopItem item;
  final ShopProvider shop;
  final Color paper;

  const _DeskPaper(
      {required this.item, required this.shop, required this.paper});

  @override
  Widget build(BuildContext context) {
    final owned = shop.ownsItem(item.id);
    final active = _ShopActions.isActive(shop, item);
    final preset =
        item.type == ShopItemType.theme ? AppThemePresets.get(item.id) : null;
    final preview = preset != null && preset.isPremium;
    final titleColor = preview ? Colors.white : AppColors.ink(context);
    final descColor =
        preview ? Colors.white.withValues(alpha: 0.78) : AppColors.muted(context);

    final content = Padding(
      padding: const EdgeInsets.fromLTRB(14, 16, 14, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (preview) ...[
            Row(
              children: [
                _Swatch(preset.primary),
                const SizedBox(width: 6),
                _Swatch(preset.primaryLight),
                const SizedBox(width: 6),
                _Swatch(preset.glowColor),
              ],
            ),
            const SizedBox(height: 12),
          ],
          Text(
            AppStrings.t(context, item.nameKey),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.nunito(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: titleColor,
                height: 1.2),
          ),
          const SizedBox(height: 6),
          Text(
            AppStrings.t(context, item.descKey),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.nunito(
                fontSize: 13,
                height: 1.35,
                fontWeight: FontWeight.w500,
                color: descColor),
          ),
          const Spacer(),
          _Seal(item: item, shop: shop, owned: owned, active: active),
        ],
      ),
    );

    if (preview) {
      return SizedBox.expand(
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: owned && _ShopActions.canApply(item) && !active
                ? () => _ShopActions.apply(context, shop, item)
                : null,
            borderRadius: BorderRadius.circular(22),
            child: Ink(
              decoration: BoxDecoration(
                gradient: preset.shopPreviewGradient,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                    color: preset.glowColor.withValues(alpha: 0.55), width: 1.4),
                boxShadow: [
                  BoxShadow(
                    color: preset.glowColor.withValues(alpha: 0.28),
                    blurRadius: 18,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: content,
            ),
          ),
        ),
      );
    }

    return SizedBox.expand(
      child: LumenPaper(
        fill: paper,
        padding: EdgeInsets.zero,
        onTap: owned && _ShopActions.canApply(item) && !active
            ? () => _ShopActions.apply(context, shop, item)
            : null,
        child: content,
      ),
    );
  }
}

class _Swatch extends StatelessWidget {
  final Color color;
  const _Swatch(this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 18,
      height: 18,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white.withValues(alpha: 0.45)),
        boxShadow: [
          BoxShadow(color: color.withValues(alpha: 0.55), blurRadius: 8),
        ],
      ),
    );
  }
}

class _Seal extends StatelessWidget {
  final ShopItem item;
  final ShopProvider shop;
  final bool owned;
  final bool active;

  const _Seal(
      {required this.item,
      required this.shop,
      required this.owned,
      required this.active});

  @override
  Widget build(BuildContext context) {
    final label = !owned
        ? '${item.price}'
        : active
            ? AppStrings.t(context, 'active')
            : _ShopActions.canApply(item)
                ? AppStrings.t(context, 'apply')
                : AppStrings.t(context, 'unlocked');

    return GestureDetector(
      onTap: shop.isPurchasing
          ? null
          : () {
              if (!owned) {
                _ShopActions.buy(context, shop, item);
              } else if (_ShopActions.canApply(item) && !active) {
                _ShopActions.apply(context, shop, item);
              }
            },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: owned ? AppColors.card(context) : context.lumenAccent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: GoogleFonts.nunito(
            fontWeight: FontWeight.w800,
            color: owned ? AppColors.ink(context) : context.lumenOnAccent,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}

class _ShopActions {
  static bool isActive(ShopProvider shop, ShopItem item) {
    return switch (item.type) {
      ShopItemType.theme => shop.activeThemeId == item.id,
      ShopItemType.background => shop.activeBackgroundId == item.id,
      ShopItemType.skin => shop.activeSkinId == item.id,
      _ => false,
    };
  }

  static bool canApply(ShopItem item) =>
      item.type == ShopItemType.theme ||
      item.type == ShopItemType.background ||
      item.type == ShopItemType.skin;

  static Future<void> apply(
      BuildContext context, ShopProvider shop, ShopItem item) async {
    switch (item.type) {
      case ShopItemType.theme:
        await shop.selectTheme(item.id);
      case ShopItemType.background:
        await shop.selectBackground(item.id);
      case ShopItemType.skin:
        await shop.selectSkin(item.id);
      default:
        break;
    }
    if (context.mounted)
      AppToast.show(context, title: AppStrings.t(context, 'applied'));
  }

  static void buy(BuildContext context, ShopProvider shop, ShopItem item) {
    final result = shop.buyWithCoins(item.id);
    switch (result) {
      case ShopPurchaseResult.success:
        AppToast.show(context,
            title: AppStrings.t(
                context,
                item.type == ShopItemType.removeAds
                    ? 'removeAdsUnlocked'
                    : 'purchaseSuccess'));
      case ShopPurchaseResult.insufficientCoins:
        AppToast.show(context,
            title: AppStrings.t(context, 'insufficientCoins'));
        CoinPurchaseSheet.show(context);
      case ShopPurchaseResult.alreadyOwned:
        AppToast.show(context, title: AppStrings.t(context, 'alreadyOwned'));
      default:
        AppToast.show(context, title: AppStrings.t(context, 'purchaseFailed'));
    }
  }
}
