import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/auth/presentation/pages/forgot_password_page.dart';
import '../../features/onboarding/presentation/pages/splash_page.dart';
import '../../features/onboarding/presentation/pages/onboarding_page.dart';
import '../../features/translation/presentation/pages/home_page.dart';
import '../../features/translation/presentation/pages/live_translation_page.dart';
import '../../features/translation/presentation/pages/translation_result_page.dart';
import '../../features/translation/presentation/pages/history_page.dart';
import '../../features/favorites/presentation/pages/favorites_page.dart';
import '../../features/dictionary/presentation/pages/dictionary_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../features/settings/presentation/pages/settings_page.dart';
import '../../features/settings/presentation/pages/help_page.dart';
import '../../features/settings/presentation/pages/permissions_page.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/splash',
    redirect: (context, state) {
      return null;
    },
    routes: [
      GoRoute(path: '/splash', builder: (c, s) => const SplashPage()),
      GoRoute(path: '/onboarding', builder: (c, s) => const OnboardingPage()),
      GoRoute(path: '/login', builder: (c, s) => const LoginPage()),
      GoRoute(path: '/register', builder: (c, s) => const RegisterPage()),
      GoRoute(path: '/forgot', builder: (c, s) => const ForgotPasswordPage()),
      GoRoute(path: '/home', builder: (c, s) => const HomePage()),
      GoRoute(
          path: '/translate', builder: (c, s) => const LiveTranslationPage()),
      GoRoute(
        path: '/result',
        builder: (c, s) {
          final text = s.extra as String? ?? '';
          return TranslationResultPage(translatedText: text);
        },
      ),
      GoRoute(path: '/history', builder: (c, s) => const HistoryPage()),
      GoRoute(path: '/favorites', builder: (c, s) => const FavoritesPage()),
      GoRoute(path: '/dictionary', builder: (c, s) => const DictionaryPage()),
      GoRoute(path: '/profile', builder: (c, s) => const ProfilePage()),
      GoRoute(path: '/settings', builder: (c, s) => const SettingsPage()),
      GoRoute(path: '/help', builder: (c, s) => const HelpPage()),
      GoRoute(path: '/permissions', builder: (c, s) => const PermissionsPage()),
    ],
  );
});
