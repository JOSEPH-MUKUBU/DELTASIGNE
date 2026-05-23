import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../models/app_models.dart';

// ─── Translation Repository ───────────────────────────────────────
final translationRepoProvider = Provider((ref) => TranslationRepository());

class TranslationRepository {
  final _col = FirebaseFirestore.instance.collection('translations');

  Future<void> save(TranslationModel t) async {
    await _col.add(t.toMap());
  }

  Stream<List<TranslationModel>> watchAll() {
    final uid = FirebaseAuth.instance.currentUser?.uid ?? '';
    return _col
        .where('uid', isEqualTo: uid)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs
            .map((d) => TranslationModel.fromMap(d.data(), d.id))
            .toList());
  }

  Future<void> delete(String id) => _col.doc(id).delete();
}

// ─── Translation List Provider ────────────────────────────────────
final translationsProvider = StreamProvider<List<TranslationModel>>((ref) {
  return ref.read(translationRepoProvider).watchAll();
});

// ─── Translation Counter ──────────────────────────────────────────
final translationCountProvider = Provider<int>((ref) {
  return ref.watch(translationsProvider).maybeWhen(
        data: (list) => list.length,
        orElse: () => 0,
      );
});

// ─── Favorites Repository ─────────────────────────────────────────
final favoritesRepoProvider = Provider((ref) => FavoritesRepository());

class FavoritesRepository {
  final _col = FirebaseFirestore.instance.collection('favorites');

  Future<void> add(FavoriteModel f) => _col.add(f.toMap());

  Stream<List<FavoriteModel>> watchAll() {
    final uid = FirebaseAuth.instance.currentUser?.uid ?? '';
    return _col
        .where('uid', isEqualTo: uid)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs
            .map((d) => FavoriteModel.fromMap(d.data(), d.id))
            .toList());
  }

  Future<void> delete(String id) => _col.doc(id).delete();

  Future<void> toggleImportant(String id, bool val) =>
      _col.doc(id).update({'isImportant': val});
}

final favoritesProvider = StreamProvider<List<FavoriteModel>>((ref) {
  return ref.read(favoritesRepoProvider).watchAll();
});

// ─── Settings / Theme Provider ────────────────────────────────────
final isDarkModeProvider = StateProvider<bool>((ref) => true);
final speechRateProvider = StateProvider<double>((ref) => 1.0);
final speechVolumeProvider = StateProvider<double>((ref) => 1.0);
final fontSizeProvider = StateProvider<double>((ref) => 1.0);

// ─── Gesture API Provider ─────────────────────────────────────────
final gestureApiUrlProvider =
    StateProvider<String>((ref) => 'http://localhost:5000');

// ─── Live Gesture State ───────────────────────────────────────────
class GestureState {
  final String currentGesture;
  final double confidence;
  final String builtSentence;
  final bool isDetecting;
  final List<String> detectedWords;

  const GestureState({
    this.currentGesture = '',
    this.confidence = 0.0,
    this.builtSentence = '',
    this.isDetecting = false,
    this.detectedWords = const [],
  });

  GestureState copyWith({
    String? currentGesture,
    double? confidence,
    String? builtSentence,
    bool? isDetecting,
    List<String>? detectedWords,
  }) =>
      GestureState(
        currentGesture: currentGesture ?? this.currentGesture,
        confidence: confidence ?? this.confidence,
        builtSentence: builtSentence ?? this.builtSentence,
        isDetecting: isDetecting ?? this.isDetecting,
        detectedWords: detectedWords ?? this.detectedWords,
      );
}

class GestureNotifier extends StateNotifier<GestureState> {
  DateTime? _lastAddedTime;

  GestureNotifier() : super(const GestureState());

  void updateGesture(String gesture, double confidence) {
    // Si la confiance est faible ou aucun geste, on réinitialise le geste courant
    if (gesture.isEmpty || confidence < 0.85) {
      state = state.copyWith(currentGesture: '', confidence: confidence);
      return;
    }

    // Évite répétitions consécutives immédiates
    if (gesture == state.currentGesture) {
      state = state.copyWith(confidence: confidence);
      return;
    }

    // Cooldown pour ne pas ajouter de mots trop rapidement (1.5 secondes)
    if (_lastAddedTime != null &&
        DateTime.now().difference(_lastAddedTime!) < const Duration(milliseconds: 1500)) {
      return;
    }

    _lastAddedTime = DateTime.now();

    final words = [...state.detectedWords, gesture];
    final sentence = words.join(' ');
    state = state.copyWith(
      currentGesture: gesture,
      confidence: confidence,
      builtSentence: sentence,
      detectedWords: words,
    );
  }

  void toggleDetection() {
    state = state.copyWith(isDetecting: !state.isDetecting);
  }

  void clearSentence() {
    state = const GestureState(isDetecting: true);
  }

  void stopDetection() {
    state = state.copyWith(isDetecting: false);
  }
}

final gestureNotifierProvider =
    StateNotifierProvider<GestureNotifier, GestureState>(
        (ref) => GestureNotifier());
