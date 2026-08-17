import 'package:flutter/material.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

class AppTabs {
  static final index = ValueNotifier<int>(0);

  static void goConverter() => index.value = 0;
  static void goFavorites() => index.value = 1;
  static void goHistory() => index.value = 2;
  static void goShop() => index.value = 3;
}

BuildContext? get rootContext => rootNavigatorKey.currentContext;

Future<T?> pushAppRoute<T>(Widget page) {
  final ctx = rootContext;
  if (ctx == null) return Future.value(null);
  return Navigator.of(ctx).push<T>(MaterialPageRoute(builder: (_) => page));
}

Future<T?> showAppModal<T>(Widget sheet) {
  final ctx = rootContext;
  if (ctx == null) return Future.value(null);
  return showModalBottomSheet<T>(
    context: ctx,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => sheet,
  );
}

void showAppSnack(String message) {
  final ctx = rootContext;
  if (ctx == null) return;
  ScaffoldMessenger.of(ctx).showSnackBar(
    SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
  );
}
