import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'core/constants/app_theme.dart';
import 'core/router/app_router.dart';
import 'core/network/app_providers.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: 'AIzaSyDEMO_REPLACE_WITH_YOUR_KEY',
      authDomain: 'deltasigne.firebaseapp.com',
      projectId: 'deltasigne',
      storageBucket: 'deltasigne.appspot.com',
      messagingSenderId: '000000000000',
      appId: '1:000000000000:web:00000000000000000000',
    ),
  );
  runApp(const ProviderScope(child: DeltaSigneApp()));
}

class DeltaSigneApp extends ConsumerWidget {
  const DeltaSigneApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final isDark = ref.watch(isDarkModeProvider);

    return MaterialApp.router(
      title: 'DELTASIGNE',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
      routerConfig: router,
    );
  }
}
