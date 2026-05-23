import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/constants/app_theme.dart';
import '../../../../core/network/app_providers.dart';
import '../../../../models/app_models.dart';
import '../../../../widgets/app_widgets.dart';

class TranslationResultPage extends ConsumerStatefulWidget {
  final String translatedText;
  const TranslationResultPage({super.key, required this.translatedText});
  @override
  ConsumerState<TranslationResultPage> createState() =>
      _TranslationResultPageState();
}

class _TranslationResultPageState extends ConsumerState<TranslationResultPage> {
  bool _isSpeaking = false;

  Future<void> _speak() async {
    setState(() => _isSpeaking = true);
    // flutter_tts speak
    await Future.delayed(const Duration(seconds: 2)); // placeholder
    setState(() => _isSpeaking = false);
  }

  Future<void> _addFavorite() async {
    final uid = FirebaseAuth.instance.currentUser?.uid ?? 'guest';
    final fav = FavoriteModel(
      id: const Uuid().v4(),
      uid: uid,
      title: widget.translatedText,
      content: widget.translatedText,
      category: 'Général',
      createdAt: DateTime.now(),
    );
    await ref.read(favoritesRepoProvider).add(fav);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Ajouté aux favoris.'),
            backgroundColor: AppColors.success),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final words = widget.translatedText.split(' ');

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.gradientBackground),
        child: SafeArea(
          child: Column(
            children: [
              // AppBar
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () => context.go('/home'),
                      icon: const Icon(Icons.home_outlined,
                          color: AppColors.textSecondary),
                    ),
                    Text('Résultat',
                        style: GoogleFonts.outfit(
                            color: AppColors.textPrimary,
                            fontSize: 18,
                            fontWeight: FontWeight.w700)),
                    IconButton(
                      onPressed: () => context.go('/translate'),
                      icon: const Icon(Icons.refresh, color: AppColors.primary),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      // Success icon
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: AppColors.success.withOpacity(0.15),
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: AppColors.success.withOpacity(0.4),
                              width: 2),
                        ),
                        child: const Icon(Icons.check,
                            color: AppColors.success, size: 40),
                      ),
                      const SizedBox(height: 16),
                      Text('Traduction prête',
                          style: GoogleFonts.outfit(
                              color: AppColors.success,
                              fontSize: 16,
                              fontWeight: FontWeight.w600)),
                      const SizedBox(height: 32),

                      // Full text
                      GlassCard(
                        borderColor: AppColors.primary.withOpacity(0.3),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Texte reconnu',
                                style: GoogleFonts.outfit(
                                    color: AppColors.textSecondary,
                                    fontSize: 12,
                                    letterSpacing: 1)),
                            const SizedBox(height: 12),
                            Text(
                              widget.translatedText,
                              style: GoogleFonts.outfit(
                                  color: AppColors.textPrimary,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w600,
                                  height: 1.4),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Word chips
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text('Mots détectés',
                            style: GoogleFonts.outfit(
                                color: AppColors.textSecondary,
                                fontSize: 13,
                                fontWeight: FontWeight.w500)),
                      ),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: words
                            .map((w) => Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 14, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary.withOpacity(0.15),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                        color:
                                            AppColors.primary.withOpacity(0.3)),
                                  ),
                                  child: Text(w,
                                      style: GoogleFonts.outfit(
                                          color: AppColors.primary,
                                          fontWeight: FontWeight.w500)),
                                ))
                            .toList(),
                      ),
                      const SizedBox(height: 32),

                      // Actions
                      _ActionRow(children: [
                        _ActionBtn(
                            icon: Icons.volume_up,
                            label: _isSpeaking ? 'Lecture...' : 'Écouter',
                            onTap: _speak,
                            color: AppColors.info),
                        _ActionBtn(
                          icon: Icons.copy,
                          label: 'Copier',
                          onTap: () {
                            Clipboard.setData(
                                ClipboardData(text: widget.translatedText));
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Texte copié.'),
                                  backgroundColor: AppColors.success),
                            );
                          },
                          color: AppColors.accent,
                        ),
                        _ActionBtn(
                          icon: Icons.share,
                          label: 'Partager',
                          onTap: () => Share.share(widget.translatedText),
                          color: AppColors.warning,
                        ),
                        _ActionBtn(
                          icon: Icons.star_outline,
                          label: 'Favori',
                          onTap: _addFavorite,
                          color: AppColors.error,
                        ),
                      ]),
                      const SizedBox(height: 24),
                      AppButton(
                        label: 'Nouvelle traduction',
                        onTap: () => context.go('/translate'),
                        icon: Icons.sign_language,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActionRow extends StatelessWidget {
  final List<Widget> children;
  const _ActionRow({required this.children});
  @override
  Widget build(BuildContext context) {
    return Row(
      children: children.map((c) => Expanded(child: c)).toList(),
    );
  }
}

class _ActionBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color color;
  const _ActionBtn(
      {required this.icon,
      required this.label,
      required this.onTap,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              shape: BoxShape.circle,
              border: Border.all(color: color.withOpacity(0.3)),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(height: 6),
          Text(label,
              style: GoogleFonts.outfit(
                  fontSize: 11, color: AppColors.textSecondary)),
        ],
      ),
    );
  }
}
