import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../models/app_models.dart';

// ─── Firebase instances ───────────────────────────────────────────
final firebaseAuthProvider = Provider<FirebaseAuth>((ref) => FirebaseAuth.instance);
final firestoreProvider = Provider<FirebaseFirestore>((ref) => FirebaseFirestore.instance);

// ─── Auth State ───────────────────────────────────────────────────
final authStateProvider = StreamProvider<User?>((ref) {
  return ref.watch(firebaseAuthProvider).authStateChanges();
});

// ─── Current User Model ───────────────────────────────────────────
final currentUserProvider = FutureProvider<UserModel?>((ref) async {
  final authState = ref.watch(authStateProvider);
  return authState.when(
    data: (user) async {
      if (user == null) return null;
      final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      if (doc.exists) return UserModel.fromMap(doc.data()!);
      return UserModel(
        uid: user.uid,
        name: user.displayName ?? 'Utilisateur',
        email: user.email ?? '',
        createdAt: DateTime.now(),
      );
    },
    loading: () => null,
    error: (_, __) => null,
  );
});

// ─── Auth Notifier ────────────────────────────────────────────────
class AuthNotifier extends StateNotifier<AsyncValue<void>> {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  AuthNotifier(this._auth, this._firestore) : super(const AsyncValue.data(null));

  Future<void> signIn(String email, String password) async {
    state = const AsyncValue.loading();
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      state = const AsyncValue.data(null);
    } on FirebaseAuthException catch (e) {
      state = AsyncValue.error(_mapError(e.code), StackTrace.current);
    }
  }

  Future<void> signUp(String name, String email, String password) async {
    state = const AsyncValue.loading();
    try {
      final cred = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      await cred.user?.updateDisplayName(name);
      final userModel = UserModel(
        uid: cred.user!.uid,
        name: name,
        email: email,
        createdAt: DateTime.now(),
      );
      await _firestore.collection('users').doc(cred.user!.uid).set(userModel.toMap());
      state = const AsyncValue.data(null);
    } on FirebaseAuthException catch (e) {
      state = AsyncValue.error(_mapError(e.code), StackTrace.current);
    }
  }

  Future<void> resetPassword(String email) async {
    state = const AsyncValue.loading();
    try {
      await _auth.sendPasswordResetEmail(email: email);
      state = const AsyncValue.data(null);
    } on FirebaseAuthException catch (e) {
      state = AsyncValue.error(_mapError(e.code), StackTrace.current);
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
    state = const AsyncValue.data(null);
  }

  Future<void> deleteAccount() async {
    await _auth.currentUser?.delete();
    state = const AsyncValue.data(null);
  }

  String _mapError(String code) {
    switch (code) {
      case 'user-not-found': return 'Aucun compte avec cet email.';
      case 'wrong-password': return 'Mot de passe incorrect.';
      case 'email-already-in-use': return 'Cet email est déjà utilisé.';
      case 'weak-password': return 'Mot de passe trop faible (min. 6 caractères).';
      case 'invalid-email': return 'Adresse email invalide.';
      case 'network-request-failed': return 'Erreur réseau. Vérifiez votre connexion.';
      default: return 'Une erreur est survenue. Réessayez.';
    }
  }
}

final authNotifierProvider = StateNotifierProvider<AuthNotifier, AsyncValue<void>>((ref) {
  return AuthNotifier(
    ref.read(firebaseAuthProvider),
    ref.read(firestoreProvider),
  );
});
