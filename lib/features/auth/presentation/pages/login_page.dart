import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_theme.dart';
import '../../../../widgets/app_widgets.dart';
import '../providers/auth_providers.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});
  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _obscure = true;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      ref
          .read(authNotifierProvider.notifier)
          .signIn(_emailCtrl.text.trim(), _passCtrl.text);
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
                const SizedBox(height: 32),
                // Logo
                Center(
                  child: Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppColors.primary, AppColors.accent],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                            color: AppColors.primary.withOpacity(0.4),
                            blurRadius: 20)
                      ],
                    ),
                    child: const Icon(Icons.sign_language,
                        color: Colors.white, size: 38),
                  ),
                ),
                const SizedBox(height: 32),
                GradientText(
                  'Bon retour',
                  style: GoogleFonts.outfit(
                      fontSize: 30, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 8),
                Text(
                    'Ravi de vous revoir. Connectez-vous pour retrouver vos traductions.',
                    style: Theme.of(context).textTheme.bodyMedium),
                const SizedBox(height: 30),
                GlassCard(
                  padding: const EdgeInsets.all(18),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
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
                        const SizedBox(height: 8),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () => context.push('/forgot'),
                            child: Text('Mot de passe oublié ?',
                                style: GoogleFonts.outfit(
                                    color: AppColors.primary, fontSize: 13)),
                          ),
                        ),
                        const SizedBox(height: 16),
                        AppButton(
                          label: 'Se connecter',
                          onTap: _submit,
                          isLoading: authState.isLoading,
                          icon: Icons.login,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                // Divider
                Row(children: [
                  const Expanded(child: Divider(color: Color(0xFF374151))),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text('ou',
                        style: Theme.of(context).textTheme.bodySmall),
                  ),
                  const Expanded(child: Divider(color: Color(0xFF374151))),
                ]),
                const SizedBox(height: 24),
                AppButton(
                  label: 'Continuer en tant qu\'invité',
                  onTap: () => context.go('/home'),
                  outline: true,
                  icon: Icons.person_outline,
                ),
                const SizedBox(height: 32),
                Center(
                  child: GestureDetector(
                    onTap: () => context.push('/register'),
                    child: RichText(
                      text: TextSpan(
                        text: 'Pas encore de compte ? ',
                        style:
                            GoogleFonts.outfit(color: AppColors.textSecondary),
                        children: [
                          TextSpan(
                            text: "S'inscrire",
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
