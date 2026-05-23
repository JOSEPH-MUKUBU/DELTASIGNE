import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_theme.dart';
import '../../../../core/network/app_providers.dart';
import '../../../../widgets/app_widgets.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = FirebaseAuth.instance.currentUser;
    final translations = ref.watch(translationsProvider);
    final count = ref.watch(translationCountProvider);
    final now = DateTime.now();
    final hour = now.hour;
    final greeting = hour < 12
        ? 'Bonjour'
        : hour < 18
            ? 'Bon après-midi'
            : 'Bonsoir';

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Header
          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF0A0E1A), Color(0xFF1A1040)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              padding: const EdgeInsets.fromLTRB(24, 56, 24, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(greeting,
                              style: GoogleFonts.outfit(
                                  color: AppColors.textSecondary,
                                  fontSize: 14)),
                          const SizedBox(height: 4),
                          Text(user?.displayName ?? 'Utilisateur',
                              style: GoogleFonts.outfit(
                                  color: AppColors.textPrimary,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w700)),
                        ],
                      ),
                      GestureDetector(
                        onTap: () => context.push('/profile'),
                        child: CircleAvatar(
                          radius: 22,
                          backgroundColor: AppColors.primary.withOpacity(0.2),
                          backgroundImage: user?.photoURL != null
                              ? NetworkImage(user!.photoURL!)
                              : null,
                          child: user?.photoURL == null
                              ? Text(
                                  (user?.displayName ?? 'U')[0].toUpperCase(),
                                  style: GoogleFonts.outfit(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.w700),
                                )
                              : null,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // Hero CTA
                  GestureDetector(
                    onTap: () => context.push('/translate'),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            AppColors.primary,
                            AppColors.accent,
                            AppColors.coral
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                              color: AppColors.primary.withOpacity(0.4),
                              blurRadius: 20,
                              offset: const Offset(0, 8)),
                        ],
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Commencer la traduction',
                                    style: GoogleFonts.outfit(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700)),
                                const SizedBox(height: 6),
                                Text(
                                    'Ouvrez la caméra, signez, puis validez la phrase.',
                                    style: GoogleFonts.outfit(
                                        color: Colors.white70, fontSize: 13)),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: const Icon(Icons.sign_language,
                                color: Colors.white, size: 28),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Stats
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: Row(
                children: [
                  Expanded(
                    child: StatCard(
                      label: 'Traductions',
                      value: count.toString(),
                      icon: Icons.translate,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: StatCard(
                      label: "Aujourd'hui",
                      value: translations.maybeWhen(
                        data: (list) => list
                            .where((t) => t.createdAt.day == DateTime.now().day)
                            .length
                            .toString(),
                        orElse: () => '0',
                      ),
                      icon: Icons.today,
                      color: AppColors.accent,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Quick Actions
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: Text('Accès rapide',
                  style: GoogleFonts.outfit(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary)),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.5,
              ),
              delegate: SliverChildListDelegate([
                _QuickTile(
                    icon: Icons.history,
                    label: 'Historique',
                    color: AppColors.info,
                    route: '/history'),
                _QuickTile(
                    icon: Icons.favorite,
                    label: 'Favoris',
                    color: AppColors.error,
                    route: '/favorites'),
                _QuickTile(
                    icon: Icons.menu_book,
                    label: 'Dictionnaire',
                    color: AppColors.warning,
                    route: '/dictionary'),
                _QuickTile(
                    icon: Icons.settings,
                    label: 'Paramètres',
                    color: AppColors.textSecondary,
                    route: '/settings'),
              ]),
            ),
          ),

          // Recent
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Récent',
                      style: GoogleFonts.outfit(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary)),
                  TextButton(
                    onPressed: () => context.push('/history'),
                    child: Text('Voir tout',
                        style: GoogleFonts.outfit(
                            color: AppColors.primary, fontSize: 13)),
                  ),
                ],
              ),
            ),
          ),
          translations.when(
            loading: () => const SliverToBoxAdapter(child: AppLoadingSpinner()),
            error: (_, __) => const SliverToBoxAdapter(
              child: EmptyState(
                  title: 'Erreur',
                  subtitle: 'Impossible de charger',
                  icon: Icons.error_outline),
            ),
            data: (list) => list.isEmpty
                ? const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.all(40),
                      child: EmptyState(
                        title: 'Aucune traduction',
                        subtitle: 'Commencez par traduire un geste !',
                        icon: Icons.sign_language,
                      ),
                    ),
                  )
                : SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (_, i) {
                        final t = list[i];
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 4),
                          child: GlassCard(
                            onTap: () => context.push('/result',
                                extra: t.recognizedText),
                            child: Row(
                              children: [
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: AppColors.primary.withOpacity(0.15),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Icon(Icons.sign_language,
                                      color: AppColors.primary, size: 20),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(t.recognizedText,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.outfit(
                                              color: AppColors.textPrimary,
                                              fontWeight: FontWeight.w600)),
                                      Text(
                                          DateFormat('dd/MM • HH:mm')
                                              .format(t.createdAt),
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall),
                                    ],
                                  ),
                                ),
                                const Icon(Icons.arrow_forward_ios,
                                    size: 14, color: AppColors.textMuted),
                              ],
                            ),
                          ),
                        );
                      },
                      childCount: list.length > 5 ? 5 : list.length,
                    ),
                  ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 80)),
        ],
      ),
      bottomNavigationBar: _BottomNav(currentIndex: 0),
    );
  }
}

class _QuickTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final String route;
  const _QuickTile(
      {required this.icon,
      required this.label,
      required this.color,
      required this.route});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      onTap: () => context.push(route),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(8)),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              label,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.outfit(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                  fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}

class _BottomNav extends StatelessWidget {
  final int currentIndex;
  const _BottomNav({required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        border:
            const Border(top: BorderSide(color: Color(0xFF374151), width: 0.5)),
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        backgroundColor: Colors.transparent,
        elevation: 0,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textMuted,
        selectedLabelStyle:
            GoogleFonts.outfit(fontSize: 11, fontWeight: FontWeight.w600),
        unselectedLabelStyle: GoogleFonts.outfit(fontSize: 11),
        onTap: (i) {
          switch (i) {
            case 0:
              context.go('/home');
              break;
            case 1:
              context.go('/translate');
              break;
            case 2:
              context.go('/history');
              break;
            case 3:
              context.go('/profile');
              break;
          }
        },
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Accueil'),
          BottomNavigationBarItem(
              icon: Icon(Icons.sign_language_outlined),
              activeIcon: Icon(Icons.sign_language),
              label: 'Traduire'),
          BottomNavigationBarItem(
              icon: Icon(Icons.history_outlined),
              activeIcon: Icon(Icons.history),
              label: 'Historique'),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: 'Profil'),
        ],
      ),
    );
  }
}
