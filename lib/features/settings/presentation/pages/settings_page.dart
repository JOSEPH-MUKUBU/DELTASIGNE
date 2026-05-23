import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_theme.dart';
import '../../../../core/network/app_providers.dart';
import '../../../../widgets/app_widgets.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(isDarkModeProvider);
    final speechRate = ref.watch(speechRateProvider);
    final speechVol = ref.watch(speechVolumeProvider);
    final fontSize = ref.watch(fontSizeProvider);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.gradientBackground),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: Row(
                  children: [
                    IconButton(onPressed: () => context.pop(), icon: const Icon(Icons.arrow_back_ios, color: AppColors.textSecondary, size: 18)),
                    Text('Paramètres', style: GoogleFonts.outfit(fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(20),
                  children: [
                    // Appearance
                    _Section('Apparence', [
                      GlassCard(
                        child: Column(children: [
                          _SwitchTile(
                            icon: Icons.dark_mode,
                            label: 'Mode sombre',
                            value: isDark,
                            onChanged: (v) => ref.read(isDarkModeProvider.notifier).state = v,
                          ),
                          const Divider(color: Color(0xFF374151), height: 1),
                          Padding(
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(children: [
                                  const Icon(Icons.text_fields, color: AppColors.textSecondary, size: 20),
                                  const SizedBox(width: 12),
                                  Text('Taille du texte', style: GoogleFonts.outfit(color: AppColors.textPrimary, fontSize: 14)),
                                ]),
                                Expanded(
                                  child: Slider(
                                    value: fontSize,
                                    min: 0.8, max: 1.4,
                                    divisions: 3,
                                    activeColor: AppColors.primary,
                                    onChanged: (v) => ref.read(fontSizeProvider.notifier).state = v,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ]),
                      ),
                    ]),
                    const SizedBox(height: 16),

                    // Audio
                    _Section('Audio & Voix', [
                      GlassCard(
                        child: Column(children: [
                          Padding(
                            padding: const EdgeInsets.all(12),
                            child: Row(children: [
                              const Icon(Icons.speed, color: AppColors.textSecondary, size: 20),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                  Text('Vitesse de parole', style: GoogleFonts.outfit(color: AppColors.textPrimary, fontSize: 14)),
                                  Text('${speechRate.toStringAsFixed(1)}x', style: GoogleFonts.outfit(color: AppColors.textMuted, fontSize: 12)),
                                ]),
                              ),
                              Expanded(child: Slider(value: speechRate, min: 0.5, max: 2.0, divisions: 6, activeColor: AppColors.primary, onChanged: (v) => ref.read(speechRateProvider.notifier).state = v)),
                            ]),
                          ),
                          const Divider(color: Color(0xFF374151), height: 1),
                          Padding(
                            padding: const EdgeInsets.all(12),
                            child: Row(children: [
                              const Icon(Icons.volume_up, color: AppColors.textSecondary, size: 20),
                              const SizedBox(width: 12),
                              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                Text('Volume', style: GoogleFonts.outfit(color: AppColors.textPrimary, fontSize: 14)),
                                Text('${(speechVol * 100).toStringAsFixed(0)}%', style: GoogleFonts.outfit(color: AppColors.textMuted, fontSize: 12)),
                              ])),
                              Expanded(child: Slider(value: speechVol, min: 0.0, max: 1.0, activeColor: AppColors.primary, onChanged: (v) => ref.read(speechVolumeProvider.notifier).state = v)),
                            ]),
                          ),
                        ]),
                      ),
                    ]),
                    const SizedBox(height: 16),

                    // Privacy & Data
                    _Section('Confidentialité & Données', [
                      GlassCard(
                        child: Column(children: [
                          ListTile(
                            dense: true,
                            leading: const Icon(Icons.camera_alt_outlined, color: AppColors.textSecondary, size: 20),
                            title: Text('Permissions caméra', style: GoogleFonts.outfit(color: AppColors.textPrimary, fontSize: 14)),
                            trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: AppColors.textMuted),
                            onTap: () => context.push('/permissions'),
                          ),
                          const Divider(color: Color(0xFF374151), height: 1),
                          ListTile(
                            dense: true,
                            leading: const Icon(Icons.delete_sweep, color: AppColors.textSecondary, size: 20),
                            title: Text('Vider le cache', style: GoogleFonts.outfit(color: AppColors.textPrimary, fontSize: 14)),
                            onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('✅ Cache vidé !'), backgroundColor: AppColors.success),
                            ),
                          ),
                        ]),
                      ),
                    ]),
                    const SizedBox(height: 16),

                    // Support
                    _Section('Support', [
                      GlassCard(
                        child: Column(children: [
                          ListTile(
                            dense: true,
                            leading: const Icon(Icons.help_outline, color: AppColors.textSecondary, size: 20),
                            title: Text('Aide & FAQ', style: GoogleFonts.outfit(color: AppColors.textPrimary, fontSize: 14)),
                            trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: AppColors.textMuted),
                            onTap: () => context.push('/help'),
                          ),
                        ]),
                      ),
                    ]),
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

class _Section extends StatelessWidget {
  final String title;
  final List<Widget> children;
  const _Section(this.title, this.children);
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(title, style: GoogleFonts.outfit(color: AppColors.textSecondary, fontSize: 12, fontWeight: FontWeight.w600, letterSpacing: 1)),
      const SizedBox(height: 10),
      ...children,
    ],
  );
}

class _SwitchTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;
  const _SwitchTile({required this.icon, required this.label, required this.value, required this.onChanged});
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
    child: Row(children: [
      Icon(icon, color: AppColors.textSecondary, size: 20),
      const SizedBox(width: 12),
      Expanded(child: Text(label, style: GoogleFonts.outfit(color: AppColors.textPrimary, fontSize: 14))),
      Switch(value: value, onChanged: onChanged, activeColor: AppColors.primary),
    ]),
  );
}
