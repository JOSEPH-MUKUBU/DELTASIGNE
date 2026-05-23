import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_theme.dart';
import '../../../../widgets/app_widgets.dart';
import '../providers/auth_providers.dart';

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});
  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  bool _obscure = true;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      ref.read(authNotifierProvider.notifier).signUp(
          _nameCtrl.text.trim(), _emailCtrl.text.trim(), _passCtrl.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);
    ref.listen(authNotifierProvider, (_, next) {
      next.when(
        data: (_) => context.go('/home'),
        error: (e, _) => ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(e.toString()), backgroundColor: AppColors.error),
        ),
        loading: () {},
      );
    });

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.gradientBackground),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                IconButton(
                  onPressed: () => context.pop(),
                  icon: const Icon(Icons.arrow_back_ios,
                      color: AppColors.textSecondary),
                ),
                const SizedBox(height: 16),
                GradientText(
                  'Créer un compte',
                  style: GoogleFonts.outfit(
                      fontSize: 28, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 8),
                Text(
                    'Créez votre espace pour apprendre, traduire et garder vos phrases importantes.',
                    style: Theme.of(context).textTheme.bodyMedium),
                const SizedBox(height: 32),
                GlassCard(
                  padding: const EdgeInsets.all(18),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        AppTextField(
                          label: 'Nom complet',
                          controller: _nameCtrl,
                          prefixIcon: Icons.person_outline,
                          validator: (v) =>
                              (v == null || v.isEmpty) ? 'Nom requis' : null,
                        ),
                        const SizedBox(height: 16),
                        AppTextField(
                          label: 'Email',
                          controller: _emailCtrl,
                          prefixIcon: Icons.email_outlined,
                          keyboardType: TextInputType.emailAddress,
                          validator: (v) {
                            if (v == null || v.isEmpty) return 'Email requis';
                            if (!v.contains('@')) return 'Email invalide';
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        AppTextField(
                          label: 'Mot de passe',
                          controller: _passCtrl,
                          obscure: _obscure,
                          prefixIcon: Icons.lock_outline,
                          suffix: IconButton(
                            icon: Icon(
                                _obscure
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                size: 20,
                                color: AppColors.textMuted),
                            onPressed: () =>
                                setState(() => _obscure = !_obscure),
                          ),
                          validator: (v) {
                            if (v == null || v.isEmpty) {
                              return 'Mot de passe requis';
                            }
                            if (v.length < 6) return 'Min. 6 caractères';
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        AppTextField(
                          label: 'Confirmer le mot de passe',
                          controller: _confirmCtrl,
                          obscure: _obscure,
                          prefixIcon: Icons.lock_outline,
                          validator: (v) {
                            if (v != _passCtrl.text) {
                              return 'Les mots de passe ne correspondent pas';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 28),
                        AppButton(
                          label: "S'inscrire",
                          onTap: _submit,
                          isLoading: authState.isLoading,
                          icon: Icons.person_add,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 28),
                Center(
                  child: GestureDetector(
                    onTap: () => context.pop(),
                    child: RichText(
                      text: TextSpan(
                        text: 'Déjà un compte ? ',
                        style:
                            GoogleFonts.outfit(color: AppColors.textSecondary),
                        children: [
                          TextSpan(
                            text: 'Se connecter',
                            style: GoogleFonts.outfit(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
