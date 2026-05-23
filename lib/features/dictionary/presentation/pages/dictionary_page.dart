import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_theme.dart';
import '../../../../widgets/app_widgets.dart';
import '../../../../models/app_models.dart';

// Static sign data based on existing model
final _signs = [
  SignModel(
      id: '1',
      label: 'Okay',
      description:
          'Pouce et index formant un cercle, autres doigts tendus. Signifie "d\'accord", "parfait".',
      difficultyLevel: 'Débutant',
      category: 'Expressions',
      emoji: '👌'),
  SignModel(
      id: '2',
      label: 'Peace',
      description: 'Index et majeur tendus en V. Signe de paix ou victoire.',
      difficultyLevel: 'Débutant',
      category: 'Expressions',
      emoji: '✌️'),
  SignModel(
      id: '3',
      label: 'Thumbs Up',
      description: 'Poing fermé, pouce levé. Signifie "super", "bravo".',
      difficultyLevel: 'Débutant',
      category: 'Expressions',
      emoji: '👍'),
  SignModel(
      id: '4',
      label: 'Thumbs Down',
      description: 'Poing fermé, pouce baissé. Signifie "non", "mauvais".',
      difficultyLevel: 'Débutant',
      category: 'Expressions',
      emoji: '👎'),
  SignModel(
      id: '5',
      label: 'Call Me',
      description: 'Pouce et auriculaire tendus. Signifie "appelle-moi".',
      difficultyLevel: 'Débutant',
      category: 'Communication',
      emoji: '🤙'),
  SignModel(
      id: '6',
      label: 'Stop',
      description:
          'Paume ouverte face à l\'interlocuteur. Signifie "arrêt", "stop".',
      difficultyLevel: 'Débutant',
      category: 'Commandes',
      emoji: '🛑'),
  SignModel(
      id: '7',
      label: 'Rock',
      description: 'Index et auriculaire tendus. Signe rock / métal.',
      difficultyLevel: 'Intermédiaire',
      category: 'Expressions',
      emoji: '🤘'),
  SignModel(
      id: '8',
      label: 'Live Long',
      description:
          'Main ouverte, pouce et auriculaire écartés. Signe "longue vie" (Star Trek).',
      difficultyLevel: 'Intermédiaire',
      category: 'Expressions',
      emoji: '🖖'),
  SignModel(
      id: '9',
      label: 'Fist',
      description: 'Poing fermé. Signe de force ou solidarité.',
      difficultyLevel: 'Débutant',
      category: 'Expressions',
      emoji: '✊'),
  SignModel(
      id: '10',
      label: 'Smile',
      description: 'Doigts recourbés formant un sourire. Signe de bonheur.',
      difficultyLevel: 'Intermédiaire',
      category: 'Émotions',
      emoji: '😊'),
];

class DictionaryPage extends StatefulWidget {
  const DictionaryPage({super.key});
  @override
  State<DictionaryPage> createState() => _DictionaryPageState();
}

class _DictionaryPageState extends State<DictionaryPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabCtrl;
  String _search = '';
  final _searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabCtrl.dispose();
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _signs
        .where(
            (s) => _search.isEmpty || s.label.toLowerCase().contains(_search))
        .toList();

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
                    IconButton(
                        onPressed: () => context.pop(),
                        icon: const Icon(Icons.arrow_back_ios,
                            color: AppColors.textSecondary, size: 18)),
                    Text('Dictionnaire',
                        style: GoogleFonts.outfit(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary)),
                  ],
                ),
              ),
              TabBar(
                controller: _tabCtrl,
                indicatorColor: AppColors.primary,
                labelColor: AppColors.primary,
                unselectedLabelColor: AppColors.textSecondary,
                labelStyle: GoogleFonts.outfit(fontWeight: FontWeight.w600),
                tabs: const [Tab(text: 'Gestes'), Tab(text: 'Apprentissage')],
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: TextField(
                  controller: _searchCtrl,
                  onChanged: (v) => setState(() => _search = v.toLowerCase()),
                  style: const TextStyle(color: AppColors.textPrimary),
                  decoration: InputDecoration(
                    hintText: 'Rechercher un geste...',
                    prefixIcon: const Icon(Icons.search,
                        color: AppColors.textMuted, size: 20),
                    filled: true,
                    fillColor: AppColors.bgCard,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none),
                  ),
                ),
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabCtrl,
                  children: [
                    // Gestures tab
                    GridView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 0.85,
                      ),
                      itemCount: filtered.length,
                      itemBuilder: (_, i) => _SignCard(sign: filtered[i]),
                    ),
                    // Learning tab
                    _LearningTab(),
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

class _SignCard extends StatelessWidget {
  final SignModel sign;
  const _SignCard({required this.sign});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => showModalBottomSheet(
        context: context,
        backgroundColor: AppColors.bgCard,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
        builder: (_) => _SignDetail(sign: sign),
      ),
      child: GlassCard(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(sign.emoji, style: const TextStyle(fontSize: 52)),
            const SizedBox(height: 12),
            Text(sign.label,
                style: GoogleFonts.outfit(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w700,
                    fontSize: 15)),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(sign.difficultyLevel,
                  style: GoogleFonts.outfit(
                      color: AppColors.primary,
                      fontSize: 10,
                      fontWeight: FontWeight.w500)),
            ),
            const SizedBox(height: 6),
            Text(sign.category,
                style: GoogleFonts.outfit(
                    color: AppColors.textMuted, fontSize: 11)),
          ],
        ),
      ),
    );
  }
}

class _SignDetail extends StatelessWidget {
  final SignModel sign;
  const _SignDetail({required this.sign});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                  color: AppColors.textMuted,
                  borderRadius: BorderRadius.circular(2))),
          const SizedBox(height: 20),
          Text(sign.emoji, style: const TextStyle(fontSize: 72)),
          const SizedBox(height: 16),
          Text(sign.label,
              style: GoogleFonts.outfit(
                  color: AppColors.textPrimary,
                  fontSize: 24,
                  fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _Chip(label: sign.difficultyLevel, color: AppColors.primary),
              const SizedBox(width: 8),
              _Chip(label: sign.category, color: AppColors.coral),
            ],
          ),
          const SizedBox(height: 20),
          Text(sign.description,
              textAlign: TextAlign.center,
              style: GoogleFonts.outfit(
                  color: AppColors.textSecondary, height: 1.6)),
          const SizedBox(height: 24),
          AppButton(
              label: 'Essayer maintenant',
              onTap: () {
                Navigator.pop(context);
                context.push('/translate');
              },
              icon: Icons.camera_alt),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;
  final Color color;
  const _Chip({required this.label, required this.color});
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
            color: color.withOpacity(0.15),
            borderRadius: BorderRadius.circular(20)),
        child: Text(label,
            style: GoogleFonts.outfit(
                color: color, fontSize: 12, fontWeight: FontWeight.w500)),
      );
}

class _LearningTab extends StatefulWidget {
  @override
  State<_LearningTab> createState() => _LearningTabState();
}

class _LearningTabState extends State<_LearningTab> {
  int _score = 0;
  int _quizIdx = 0;
  String? _selected;
  bool _answered = false;

  final _quiz = [
    {
      'question': '👌 Ce geste signifie ?',
      'answer': 'Okay',
      'options': ['Peace', 'Okay', 'Stop', 'Fist']
    },
    {
      'question': '✌️ Ce geste signifie ?',
      'answer': 'Peace',
      'options': ['Rock', 'Call Me', 'Peace', 'Live Long']
    },
    {
      'question': '👍 Ce geste signifie ?',
      'answer': 'Thumbs Up',
      'options': ['Thumbs Up', 'Thumbs Down', 'Okay', 'Fist']
    },
    {
      'question': '🤙 Ce geste signifie ?',
      'answer': 'Call Me',
      'options': ['Stop', 'Call Me', 'Rock', 'Peace']
    },
    {
      'question': '✊ Ce geste signifie ?',
      'answer': 'Fist',
      'options': ['Okay', 'Live Long', 'Fist', 'Smile']
    },
  ];

  @override
  Widget build(BuildContext context) {
    if (_quizIdx >= _quiz.length) {
      return Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          const Icon(Icons.celebration, size: 72, color: AppColors.gold),
          const SizedBox(height: 16),
          Text('Quiz terminé',
              style: GoogleFonts.outfit(
                  color: AppColors.textPrimary,
                  fontSize: 24,
                  fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          Text('Score : $_score / ${_quiz.length}',
              style: GoogleFonts.outfit(
                  color: AppColors.accent,
                  fontSize: 18,
                  fontWeight: FontWeight.w600)),
          const SizedBox(height: 24),
          AppButton(
              label: 'Recommencer',
              onTap: () => setState(() {
                    _quizIdx = 0;
                    _score = 0;
                    _selected = null;
                    _answered = false;
                  }),
              icon: Icons.refresh),
        ]),
      );
    }

    final q = _quiz[_quizIdx];
    final options = q['options'] as List<String>;
    final answer = q['answer'] as String;

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          LinearProgressIndicator(
            value: (_quizIdx + 1) / _quiz.length,
            backgroundColor: AppColors.bgCardLight,
            valueColor: const AlwaysStoppedAnimation(AppColors.primary),
            minHeight: 6,
            borderRadius: BorderRadius.circular(3),
          ),
          const SizedBox(height: 8),
          Text('Question ${_quizIdx + 1}/${_quiz.length} • Score: $_score',
              style: GoogleFonts.outfit(
                  color: AppColors.textSecondary, fontSize: 13)),
          const Spacer(),
          Text(q['question'] as String,
              style: GoogleFonts.outfit(
                  color: AppColors.textPrimary,
                  fontSize: 22,
                  fontWeight: FontWeight.w600),
              textAlign: TextAlign.center),
          const SizedBox(height: 32),
          ...options.map((opt) {
            Color? color;
            if (_answered) {
              if (opt == answer) {
                color = AppColors.success;
              } else if (opt == _selected) {
                color = AppColors.error;
              }
            }
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: GestureDetector(
                onTap: _answered
                    ? null
                    : () {
                        setState(() {
                          _selected = opt;
                          _answered = true;
                          if (opt == answer) {
                            _score++;
                          }
                        });
                      },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: color?.withOpacity(0.15) ?? AppColors.bgCard,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: color ?? const Color(0xFF374151)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(opt,
                          style: GoogleFonts.outfit(
                              color: color ?? AppColors.textPrimary,
                              fontWeight: FontWeight.w500)),
                      if (_answered && opt == answer)
                        const Icon(Icons.check_circle,
                            color: AppColors.success, size: 20),
                      if (_answered && opt == _selected && opt != answer)
                        const Icon(Icons.cancel,
                            color: AppColors.error, size: 20),
                    ],
                  ),
                ),
              ),
            );
          }),
          const Spacer(),
          if (_answered)
            AppButton(
              label: _quizIdx < _quiz.length - 1
                  ? 'Question suivante'
                  : 'Voir résultat',
              onTap: () => setState(() {
                _quizIdx++;
                _selected = null;
                _answered = false;
              }),
              icon: Icons.arrow_forward,
            ),
        ],
      ),
    );
  }
}
