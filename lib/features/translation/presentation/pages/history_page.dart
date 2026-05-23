import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_theme.dart';
import '../../../../core/network/app_providers.dart';
import '../../../../widgets/app_widgets.dart';

class HistoryPage extends ConsumerStatefulWidget {
  const HistoryPage({super.key});
  @override
  ConsumerState<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends ConsumerState<HistoryPage> {
  final _searchCtrl = TextEditingController();
  String _filter = 'Tous';
  String _search = '';

  @override
  void dispose() { _searchCtrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final translations = ref.watch(translationsProvider);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.gradientBackground),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: Row(
                  children: [
                    IconButton(onPressed: () => context.pop(), icon: const Icon(Icons.arrow_back_ios, color: AppColors.textSecondary, size: 18)),
                    Text('Historique', style: GoogleFonts.outfit(fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                  ],
                ),
              ),
              // Search
              Padding(
                padding: const EdgeInsets.all(16),
                child: TextField(
                  controller: _searchCtrl,
                  onChanged: (v) => setState(() => _search = v.toLowerCase()),
                  style: const TextStyle(color: AppColors.textPrimary),
                  decoration: InputDecoration(
                    hintText: 'Rechercher...',
                    prefixIcon: const Icon(Icons.search, color: AppColors.textMuted, size: 20),
                    suffixIcon: _search.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear, color: AppColors.textMuted, size: 18),
                            onPressed: () { _searchCtrl.clear(); setState(() => _search = ''); },
                          )
                        : null,
                    filled: true,
                    fillColor: AppColors.bgCard,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  ),
                ),
              ),
              // Filter chips
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: ['Tous', "Aujourd'hui", 'Cette semaine', 'Ce mois'].map((f) {
                    final selected = _filter == f;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: FilterChip(
                        label: Text(f, style: GoogleFonts.outfit(color: selected ? Colors.white : AppColors.textSecondary, fontSize: 12)),
                        selected: selected,
                        onSelected: (_) => setState(() => _filter = f),
                        selectedColor: AppColors.primary,
                        backgroundColor: AppColors.bgCard,
                        checkmarkColor: Colors.white,
                        side: BorderSide(color: selected ? AppColors.primary : const Color(0xFF374151)),
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 12),
              // List
              Expanded(
                child: translations.when(
                  loading: () => const AppLoadingSpinner(message: 'Chargement...'),
                  error: (e, _) => EmptyState(title: 'Erreur', subtitle: e.toString(), icon: Icons.error_outline),
                  data: (list) {
                    var filtered = list.where((t) {
                      final matchSearch = _search.isEmpty || t.recognizedText.toLowerCase().contains(_search);
                      final now = DateTime.now();
                      final matchFilter = _filter == 'Tous' ||
                          (_filter == "Aujourd'hui" && t.createdAt.day == now.day) ||
                          (_filter == 'Cette semaine' && now.difference(t.createdAt).inDays < 7) ||
                          (_filter == 'Ce mois' && t.createdAt.month == now.month);
                      return matchSearch && matchFilter;
                    }).toList();

                    if (filtered.isEmpty) {
                      return const EmptyState(
                        title: 'Aucune traduction',
                        subtitle: 'Rien à afficher pour ce filtre',
                        icon: Icons.history,
                      );
                    }
                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: filtered.length,
                      itemBuilder: (_, i) {
                        final t = filtered[i];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Dismissible(
                            key: Key(t.id),
                            direction: DismissDirection.endToStart,
                            background: Container(
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.only(right: 20),
                              decoration: BoxDecoration(
                                color: AppColors.error.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: const Icon(Icons.delete_outline, color: AppColors.error),
                            ),
                            onDismissed: (_) => ref.read(translationRepoProvider).delete(t.id),
                            child: GlassCard(
                              onTap: () => context.push('/result', extra: t.recognizedText),
                              child: Row(
                                children: [
                                  Container(
                                    width: 44,
                                    height: 44,
                                    decoration: BoxDecoration(
                                      color: AppColors.primary.withOpacity(0.15),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Icon(Icons.sign_language, color: AppColors.primary, size: 22),
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          t.recognizedText,
                                          style: GoogleFonts.outfit(color: AppColors.textPrimary, fontWeight: FontWeight.w500),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 4),
                                        Row(
                                          children: [
                                            const Icon(Icons.access_time, size: 12, color: AppColors.textMuted),
                                            const SizedBox(width: 4),
                                            Text(
                                              DateFormat('dd MMM yyyy • HH:mm').format(t.createdAt),
                                              style: GoogleFonts.outfit(color: AppColors.textMuted, fontSize: 11),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                        '${(t.confidenceScore * 100).toStringAsFixed(0)}%',
                                        style: GoogleFonts.outfit(color: AppColors.success, fontSize: 12, fontWeight: FontWeight.w600),
                                      ),
                                      const Icon(Icons.arrow_forward_ios, size: 12, color: AppColors.textMuted),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
