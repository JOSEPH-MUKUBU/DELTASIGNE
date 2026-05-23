import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_theme.dart';
import '../../../../widgets/app_widgets.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  final _faq = const [
    {'q': 'Comment positionner ma main ?', 'a': 'Placez votre main à 30-50 cm de la caméra, bien éclairée, dans le cadre de détection. Évitez les arrière-plans chargés.'},
    {'q': 'Pourquoi la détection échoue ?', 'a': 'Assurez-vous d\'avoir une bonne luminosité, pas de flou de mouvement. L\'API Flask doit être lancée en parallèle.'},
    {'q': 'Comment lancer l\'API Flask ?', 'a': 'Ouvrez un terminal dans le dossier hand-gesture-recognition-code et lancez : python api_server.py'},
    {'q': 'Les traductions sont-elles sauvegardées ?', 'a': 'Oui, si vous êtes connecté à Firebase. Sinon elles ne persistent pas entre sessions.'},
    {'q': 'Quels gestes sont supportés ?', 'a': 'Okay, Peace, Thumbs Up, Thumbs Down, Call Me, Stop, Rock, Live Long, Fist, Smile — soit 10 gestes.'},
    {'q': 'Comment ajouter un favori ?', 'a': 'Depuis la page résultat, appuyez sur ⭐ Favori. Ou depuis la page Favoris, appuyez sur le bouton +.'},
  ];

  @override
  Widget build(BuildContext context) {
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
                    Text('Aide & Support', style: GoogleFonts.outfit(fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(20),
                  children: [
                    // Quick tips
                    GlassCard(
                      borderColor: AppColors.accent.withOpacity(0.3),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(children: [
                            const Icon(Icons.lightbulb_outline, color: AppColors.accent, size: 20),
                            const SizedBox(width: 8),
                            Text('Conseils rapides', style: GoogleFonts.outfit(color: AppColors.accent, fontWeight: FontWeight.w600)),
                          ]),
                          const SizedBox(height: 12),
                          ...[
                            '💡 Distance idéale : 30–50 cm de la caméra',
                            '☀️ Bonne luminosité : évitez l\'ombre directe',
                            '🖐️ Gardez la main dans le cadre de détection',
                            '🎯 Faites les gestes lentement et distinctement',
                            '⚡ Lancez d\'abord l\'API Flask avant l\'app',
                          ].map((tip) => Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Text(tip, style: GoogleFonts.outfit(color: AppColors.textSecondary, fontSize: 13, height: 1.5)),
                          )),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    Text('FAQ', style: GoogleFonts.outfit(color: AppColors.textSecondary, fontSize: 12, fontWeight: FontWeight.w600, letterSpacing: 1)),
                    const SizedBox(height: 12),

                    // FAQ
                    ..._faq.map((item) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: _FaqItem(question: item['q']!, answer: item['a']!),
                    )),

                    const SizedBox(height: 20),
                    // Contact
                    GlassCard(
                      child: Column(children: [
                        Row(children: [
                          const Icon(Icons.bug_report_outlined, color: AppColors.error, size: 20),
                          const SizedBox(width: 8),
                          Text('Signaler un problème', style: GoogleFonts.outfit(color: AppColors.textPrimary, fontWeight: FontWeight.w600)),
                        ]),
                        const SizedBox(height: 12),
                        Text('Si vous rencontrez un bug, contactez :', style: GoogleFonts.outfit(color: AppColors.textSecondary, fontSize: 13)),
                        const SizedBox(height: 8),
                        Text('joseph.mukubu@deltasigne.app', style: GoogleFonts.outfit(color: AppColors.primary, fontSize: 13, fontWeight: FontWeight.w500)),
                      ]),
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

class _FaqItem extends StatefulWidget {
  final String question;
  final String answer;
  const _FaqItem({required this.question, required this.answer});
  @override
  State<_FaqItem> createState() => _FaqItemState();
}

class _FaqItemState extends State<_FaqItem> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) => GlassCard(
    onTap: () => setState(() => _expanded = !_expanded),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: Text(widget.question, style: GoogleFonts.outfit(color: AppColors.textPrimary, fontWeight: FontWeight.w500, fontSize: 13))),
            Icon(_expanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down, color: AppColors.primary, size: 20),
          ],
        ),
        if (_expanded) ...[
          const SizedBox(height: 10),
          const Divider(color: Color(0xFF374151), height: 1),
          const SizedBox(height: 10),
          Text(widget.answer, style: GoogleFonts.outfit(color: AppColors.textSecondary, fontSize: 13, height: 1.5)),
        ],
      ],
    ),
  );
}
