import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/constants/app_theme.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});
  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;
  late Animation<double> _opacity;
  late Animation<double> _ring;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1800));
    _scale = Tween<double>(begin: 0.5, end: 1.0).animate(CurvedAnimation(
        parent: _ctrl,
        curve: const Interval(0.0, 0.6, curve: Curves.elasticOut)));
    _opacity = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: _ctrl, curve: const Interval(0.4, 1.0, curve: Curves.easeIn)));
    _ring = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: _ctrl, curve: const Interval(0.5, 1.0, curve: Curves.easeOut)));
    _ctrl.forward();
    _navigate();
  }

  Future<void> _navigate() async {
    await Future.delayed(const Duration(seconds: 3));
    if (!mounted) return;
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    final seen = prefs.getBool('onboarding_seen') ?? false;
    if (seen) {
      context.go('/login');
    } else {
      context.go('/onboarding');
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.gradientBackground),
        child: Center(
          child: AnimatedBuilder(
            animation: _ctrl,
            builder: (_, __) => Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Pulsing ring
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Transform.scale(
                      scale: 1.0 + _ring.value * 0.4,
                      child: Opacity(
                        opacity: (1 - _ring.value).clamp(0.0, 1.0),
                        child: Container(
                          width: 140,
                          height: 140,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: AppColors.primary.withOpacity(0.4),
                                width: 2),
                          ),
                        ),
                      ),
                    ),
                    // Logo
                    Transform.scale(
                      scale: _scale.value,
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [AppColors.primary, AppColors.accent],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withOpacity(0.5),
                              blurRadius: 30,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: const Icon(Icons.sign_language,
                            color: Colors.white, size: 48),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                // App name
                Opacity(
                  opacity: _opacity.value,
                  child: Column(
                    children: [
                      ShaderMask(
                        blendMode: BlendMode.srcIn,
                        shaderCallback: (b) =>
                            AppColors.gradientPrimary.createShader(b),
                        child: Text(
                          'DELTASIGNE',
                          style: GoogleFonts.outfit(
                            fontSize: 36,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 3,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'La langue des signes pour tous',
                        style: GoogleFonts.outfit(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                          letterSpacing: 1,
                        ),
                      ),
                      const SizedBox(height: 48),
                      SizedBox(
                        width: 32,
                        height: 32,
                        child: CircularProgressIndicator(
                          color: AppColors.primary,
                          strokeWidth: 2,
                          value: _ctrl.value > 0.7 ? null : _ctrl.value,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 80),
                Opacity(
                  opacity: _opacity.value,
                  child: Text(
                    'Joseph Mukubu Kapoya',
                    style: GoogleFonts.outfit(
                      fontSize: 11,
                      color: AppColors.textMuted,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
