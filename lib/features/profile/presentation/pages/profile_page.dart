import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../core/constants/app_theme.dart';
import '../../../../core/network/app_providers.dart';
import '../../../../features/auth/presentation/providers/auth_providers.dart';
import '../../../../widgets/app_widgets.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = FirebaseAuth.instance.currentUser;
    final count = ref.watch(translationCountProvider);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.gradientBackground),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Header gradient
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF1A1040), Color(0xFF0A0E1A)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          IconButton(
                            onPressed: () => context.pop(),
                            icon: const Icon(Icons.arrow_back_ios, color: AppColors.textSecondary, size: 18),
                          ),
                          Text('Profil',
                              style: GoogleFonts.outfit(
                                  fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                        ],
                      ),
                      const SizedBox(height: 20),
                      // Avatar
                      Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          Container(
                            width: 90,
                            height: 90,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: const LinearGradient(
                                  colors: [AppColors.primary, AppColors.accent]),
                              boxShadow: [
                                BoxShadow(color: AppColors.primary.withOpacity(0.4), blurRadius: 20)
                              ],
                            ),
                            child: Center(
                              child: Text(
                                (user?.displayName ?? 'U')[0].toUpperCase(),
                                style: GoogleFonts.outfit(
                                    fontSize: 36, color: Colors.white, fontWeight: FontWeight.w700),
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration:
                                const BoxDecoration(color: AppColors.accent, shape: BoxShape.circle),
                            child: const Icon(Icons.camera_alt, color: Colors.white, size: 14),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(user?.displayName ?? 'Utilisateur',
                          style: GoogleFonts.outfit(
                              fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                      const SizedBox(height: 4),
                      Text(user?.email ?? '',
                          style: GoogleFonts.outfit(color: AppColors.textSecondary, fontSize: 14)),
                      const SizedBox(height: 20),
                      // Stats row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _StatItem(label: 'Traductions', value: count.toString()),
                          Container(width: 1, height: 40, color: const Color(0xFF374151)),
                          const _StatItem(label: 'Gestes appris', value: '10'),
                          Container(width: 1, height: 40, color: const Color(0xFF374151)),
                          const _StatItem(label: 'Favoris', value: '—'),
                        ],
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      _SectionTitle('Préférences'),
                      GlassCard(
                        child: Column(children: [
                          _MenuItem(
                              icon: Icons.language,
                              label: 'Langue préférée',
                              value: 'Français',
                              onTap: () {}),
                          const Divider(color: Color(0xFF374151), height: 1),
                          _MenuItem(
                              icon: Icons.notifications_outlined,
                              label: 'Notifications',
                              onTap: () {}),
                          const Divider(color: Color(0xFF374151), height: 1),
                          _MenuItem(
                              icon: Icons.settings,
                              label: 'Paramètres',
                              onTap: () => context.push('/settings')),
                        ]),
                      ),
                      const SizedBox(height: 16),
                      _SectionTitle('Compte'),
                      GlassCard(
                        child: Column(children: [
                          _MenuItem(
                              icon: Icons.help_outline,
                              label: 'Aide & Support',
                              onTap: () => context.push('/help')),
                          const Divider(color: Color(0xFF374151), height: 1),
                          _MenuItem(
                            icon: Icons.logout,
                            label: 'Se déconnecter',
                            color: AppColors.warning,
                            onTap: () async {
                              await ref.read(authNotifierProvider.notifier).signOut();
                              if (context.mounted) context.go('/login');
                            },
                          ),
                          const Divider(color: Color(0xFF374151), height: 1),
                          _MenuItem(
                            icon: Icons.delete_forever,
                            label: 'Supprimer le compte',
                            color: AppColors.error,
                            onTap: () => _showDeleteDialog(context, ref),
                          ),
                        ]),
                      ),
                      const SizedBox(height: 32),
                      Text('DELTASIGNE v1.0.0 • Joseph Mukubu Kapoya',
                          style: GoogleFonts.outfit(color: AppColors.textMuted, fontSize: 11)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.bgCard,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Supprimer le compte ?',
            style: GoogleFonts.outfit(color: AppColors.error, fontWeight: FontWeight.w700)),
        content: Text('Cette action est irréversible.',
            style: GoogleFonts.outfit(color: AppColors.textSecondary)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Annuler')),
          ElevatedButton(
            onPressed: () async {
              await ref.read(authNotifierProvider.notifier).deleteAccount();
              if (context.mounted) {
                Navigator.pop(context);
                context.go('/login');
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label, value;
  const _StatItem({required this.label, required this.value});
  @override
  Widget build(BuildContext context) => Column(children: [
        Text(value,
            style: GoogleFonts.outfit(
                color: AppColors.primary, fontSize: 22, fontWeight: FontWeight.w700)),
        Text(label, style: GoogleFonts.outfit(color: AppColors.textSecondary, fontSize: 11)),
      ]);
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle(this.title);
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(title,
              style: GoogleFonts.outfit(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1)),
        ),
      );
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? value;
  final Color? color;
  final VoidCallback onTap;
  const _MenuItem(
      {required this.icon, required this.label, required this.onTap, this.value, this.color});

  @override
  Widget build(BuildContext context) => ListTile(
        dense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        leading: Icon(icon, color: color ?? AppColors.textSecondary, size: 20),
        title: Text(label,
            style: GoogleFonts.outfit(
                color: color ?? AppColors.textPrimary,
                fontSize: 14,
                fontWeight: FontWeight.w500)),
        trailing: value != null
            ? Text(value!, style: GoogleFonts.outfit(color: AppColors.textSecondary, fontSize: 13))
            : const Icon(Icons.arrow_forward_ios, size: 14, color: AppColors.textMuted),
        onTap: onTap,
      );
}
