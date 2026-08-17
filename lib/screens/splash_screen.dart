import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../core/constants/app_colors.dart';
import '../core/constants/app_strings.dart';
import '../core/services/sound_service.dart';
import '../providers/converter_provider.dart';
import '../providers/shop_provider.dart';
import 'home/main_shell.dart';
import 'onboarding/onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _enterCtrl;
  late final Animation<double> _fade;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _enterCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    _fade = CurvedAnimation(parent: _enterCtrl, curve: Curves.easeOut);
    _scale = Tween<double>(begin: 0.88, end: 1).animate(CurvedAnimation(parent: _enterCtrl, curve: Curves.easeOut));
    _enterCtrl.forward();
    _boot();
  }

  @override
  void dispose() {
    _enterCtrl.dispose();
    super.dispose();
  }

  Future<void> _boot() async {
    try {
      await Future.wait([
        context.read<ConverterProvider>().init(),
        context.read<ShopProvider>().claimDailyReward(),
        Future<void>.delayed(const Duration(milliseconds: 1100)),
      ]).timeout(const Duration(seconds: 8));
    } catch (e) {
      debugPrint('Splash boot timeout/error: $e');
    }
    if (!mounted) return;
    SoundService.instance.navigate();
    final onboarded = context.read<ConverterProvider>().onboardingComplete;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute<void>(builder: (_) => onboarded ? const MainShell() : const OnboardingScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: AppColors.darkBackground,
        body: DecoratedBox(
          decoration: const BoxDecoration(gradient: AppColors.headerGradient),
          child: SafeArea(
            child: SizedBox(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Spacer(flex: 3),
                  FadeTransition(
                    opacity: _fade,
                    child: ScaleTransition(
                      scale: _scale,
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(28),
                            child: Image.asset('assets/logo.png', width: 108, height: 108, filterQuality: FilterQuality.medium),
                          ),
                          const SizedBox(height: 22),
                          Text(
                            AppStrings.t(context, 'appName'),
                            style: GoogleFonts.nunito(fontSize: 38, fontWeight: FontWeight.w800, color: AppColors.primary, letterSpacing: 0.4),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            AppStrings.t(context, 'appTagline'),
                            style: GoogleFonts.nunito(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Spacer(flex: 4),
                  Text(AppStrings.t(context, 'loading'), style: GoogleFonts.nunito(color: AppColors.textMuted, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 36),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
