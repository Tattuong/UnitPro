import 'package:flutter/material.dart';

import '../../core/constants/app_strings.dart';
import '../../core/services/sound_service.dart';
import '../shop/shop_screen.dart';

Future<void> openProShop(BuildContext context) async {
  SoundService.instance.tap();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(AppStrings.t(context, 'lockedCategory'))),
  );
  ShopNav.open(ShopRewardsTab.features);
}
