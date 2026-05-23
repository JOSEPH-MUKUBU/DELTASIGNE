import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_theme.dart';
import '../../../../widgets/app_widgets.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});
  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final _controller = PageController();
  int _currentPage = 0;

  final _slides = const [
    _OnboardingSlide(
      emoji: '🤟',
      gradient: [Color(0xFF6C63FF), Color(0xFF4F46E5)],
      title: 'Traduisez naturellement',
      subtitle:
          'Pointez la caméra vers un geste et obtenez une phrase claire, prête à partager.',
    ),
    _OnboardingSlide(
      emoji: '🔊',
      gradient: [Color(0xFF00D4AA), Color(0xFF0891B2)],
      title: 'Faites entendre le message',
      subtitle:
          'La lecture vocale aide à transformer un signe en échange simple et direct.',
    ),
    _OnboardingSlide(
      emoji: '📚',
      gradient: [Color(0xFFF59E0B), Color(0xFFEF4444)],
      title: 'Gardez ce qui compte',
      subtitle:
          'Retrouvez vos traductions récentes et mettez de côté les phrases importantes.',
    ),
    _OnboardingSlide(
      emoji: '🎓',
      gradient: [Color(0xFF8B5CF6), Color(0xFFEC4899)],
      title: 'Progressez à votre rythme',
      subtitle:
          'Explorez le dictionnaire, testez vos acquis et revenez quand vous voulez.',
    ),
  ];

  void _next() {
    if (_currentPage < _slides.length - 1) {
      _controller.nextPage(
          duration: const Duration(milliseconds: 400), curve: Curves.easeInOut);
    } else {
      _finish();
    }
  }

  Future<void> _finish() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_seen', true);
    if (mounted) context.go('/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.gradientBackground),
        child: SafeArea(
          child: Column(
            children: [
              // Skip
              Align(
                alignment: Alignment.topRight,
                child: TextButton(
                  onPressed: _finish,
                  child: Text('Passer',
                      style:
                          GoogleFonts.outfit(color: AppColors.textSecondary)),
                ),
              ),
              // Pages
              Expanded(
                child: PageView.builder(
                  controller: _controller,
                  itemCount: _slides.length,
                  onPageChanged: (i) => setState(() => _currentPage = i),
                  itemBuilder: (_, i) => _slides[i],
                ),
              ),
              // Indicator + buttons
              Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  children: [
                    SmoothPageIndicator(
                      controller: _controller,
                      count: _slides.length,
                      effect: ExpandingDotsEffect(
                        activeDotColor: AppColors.primary,
                        dotColor: AppColors.bgCardLight,
                        dotHeight: 8,
                        dotWidth: 8,
                        expansionFactor: 3,
                      ),
                    ),
                    const SizedBox(height: 32),
                    AppButton(
                      label: _currentPage == _slides.length - 1
                          ? 'Commencer'
                          : 'Suivant',
                      onTap: _next,
                      icon: _currentPage == _slides.length - 1
                          ? Icons.rocket_launch
                          : Icons.arrow_forward,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OnboardingSlide extends StatelessWidget {
  final String emoji;
  final List<Color> gradient;
  final String title;
  final String subtitle;

  const _OnboardingSlide({
    required this.emoji,
    required this.gradient,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 160,
            height: 160,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: gradient,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                    color: gradient[0].withOpacity(0.4),
                    blurRadius: 40,
                    spreadRadius: 10)
              ],
            ),
            child: Center(
                child: Text(emoji, style: const TextStyle(fontSize: 72))),
          ),
          const SizedBox(height: 48),
          Text(title,
              textAlign: TextAlign.center,
              style: GoogleFonts.outfit(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary)),
          const SizedBox(height: 16),
          Text(subtitle,
              textAlign: TextAlign.center,
              style: GoogleFonts.outfit(
                  fontSize: 16, color: AppColors.textSecondary, height: 1.6)),
        ],
      ),
    );
  }
}
