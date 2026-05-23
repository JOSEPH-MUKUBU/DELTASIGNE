import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/constants/app_theme.dart';
import '../../../../core/network/app_providers.dart';
import '../../../../models/app_models.dart';
import '../../../../widgets/app_widgets.dart';

class FavoritesPage extends ConsumerStatefulWidget {
  const FavoritesPage({super.key});
  @override
  ConsumerState<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends ConsumerState<FavoritesPage> {
  String _selectedCategory = 'Tous';
  final _categories = ['Tous', 'Salutations', 'Urgence', 'Famille', 'École', 'Santé', 'Quotidien', 'Général'];

  void _showAddDialog() {
    final titleCtrl = TextEditingController();
    String category = 'Général';
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.bgCard,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Ajouter un favori', style: GoogleFonts.outfit(color: AppColors.textPrimary, fontWeight: FontWeight.w600)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleCtrl,
              style: const TextStyle(color: AppColors.textPrimary),
              decoration: InputDecoration(
                hintText: 'Contenu du favori',
                filled: true,
                fillColor: AppColors.bgCardLight,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 16),
            StatefulBuilder(
              builder: (_, set) => DropdownButtonFormField<String>(
                value: category,
                dropdownColor: AppColors.bgCard,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: AppColors.bgCardLight,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                ),
                items: _categories.skip(1).map((c) => DropdownMenuItem(value: c, child: Text(c, style: const TextStyle(color: AppColors.textPrimary)))).toList(),
                onChanged: (v) { set(() => category = v!); },
                style: const TextStyle(color: AppColors.textPrimary),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text('Annuler', style: GoogleFonts.outfit(color: AppColors.textSecondary))),
          ElevatedButton(
            onPressed: () async {
              if (titleCtrl.text.trim().isEmpty) return;
              final uid = FirebaseAuth.instance.currentUser?.uid ?? 'guest';
              final fav = FavoriteModel(
                id: const Uuid().v4(), uid: uid,
                title: titleCtrl.text.trim(), content: titleCtrl.text.trim(),
                category: category, createdAt: DateTime.now(),
              );
              await ref.read(favoritesRepoProvider).add(fav);
              if (ctx.mounted) Navigator.pop(ctx);
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            child: const Text('Ajouter'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final favs = ref.watch(favoritesProvider);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddDialog,
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
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
                    Text('Favoris', style: GoogleFonts.outfit(fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                  ],
                ),
              ),
              // Category filter
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: _categories.map((c) {
                    final sel = _selectedCategory == c;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: GestureDetector(
                        onTap: () => setState(() => _selectedCategory = c),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: sel ? AppColors.primary : AppColors.bgCard,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: sel ? AppColors.primary : const Color(0xFF374151)),
                          ),
                          child: Text(c, style: GoogleFonts.outfit(color: sel ? Colors.white : AppColors.textSecondary, fontSize: 12, fontWeight: FontWeight.w500)),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              Expanded(
                child: favs.when(
                  loading: () => const AppLoadingSpinner(),
                  error: (e, _) => EmptyState(title: 'Erreur', subtitle: e.toString(), icon: Icons.error_outline),
                  data: (list) {
                    final filtered = _selectedCategory == 'Tous'
                        ? list
                        : list.where((f) => f.category == _selectedCategory).toList();
                    if (filtered.isEmpty) {
                      return const EmptyState(
                        title: 'Aucun favori',
                        subtitle: 'Appuyez sur + pour ajouter',
                        icon: Icons.star_outline,
                      );
                    }
                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: filtered.length,
                      itemBuilder: (_, i) {
                        final f = filtered[i];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Dismissible(
                            key: Key(f.id),
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
                            onDismissed: (_) => ref.read(favoritesRepoProvider).delete(f.id),
                            child: GlassCard(
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: AppColors.error.withOpacity(0.15),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Icon(
                                      f.isImportant ? Icons.star : Icons.star_outline,
                                      color: AppColors.warning, size: 20,
                                    ),
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(f.title, style: GoogleFonts.outfit(color: AppColors.textPrimary, fontWeight: FontWeight.w500)),
                                        const SizedBox(height: 4),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: AppColors.primary.withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          child: Text(f.category, style: GoogleFonts.outfit(color: AppColors.primary, fontSize: 10)),
                                        ),
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () => ref.read(favoritesRepoProvider).toggleImportant(f.id, !f.isImportant),
                                    icon: Icon(f.isImportant ? Icons.star : Icons.star_border, color: AppColors.warning, size: 20),
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
