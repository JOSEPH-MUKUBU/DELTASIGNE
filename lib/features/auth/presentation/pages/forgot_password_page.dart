import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_theme.dart';
import '../../../../widgets/app_widgets.dart';
import '../providers/auth_providers.dart';

class ForgotPasswordPage extends ConsumerStatefulWidget {
  const ForgotPasswordPage({super.key});
  @override
  ConsumerState<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends ConsumerState<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  bool _sent = false;

  @override
  void dispose() { _emailCtrl.dispose(); super.dispose(); }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      ref.read(authNotifierProvider.notifier).resetPassword(_emailCtrl.text.trim());
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);
    ref.listen(authNotifierProvider, (_, next) {
      next.when(
        data: (_) => setState(() => _sent = true),
        error: (e, _) => ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString()), backgroundColor: AppColors.error),
        ),
        loading: () {},
      );
    });

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.gradientBackground),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                IconButton(
                  onPressed: () => context.pop(),
                  icon: const Icon(Icons.arrow_back_ios, color: AppColors.textSecondary),
                ),
                const SizedBox(height: 24),
                GradientText(
                  'Mot de passe oublié',
                  style: GoogleFonts.outfit(fontSize: 26, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 12),
                Text(
                  'Entrez votre email pour recevoir un lien de réinitialisation.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 40),
                if (_sent)
                  GlassCard(
                    borderColor: AppColors.success,
                    child: Row(children: [
                      const Icon(Icons.check_circle, color: AppColors.success),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Email envoyé ! Vérifiez votre boîte mail.',
                          style: GoogleFonts.outfit(color: AppColors.success),
                        ),
                      ),
                    ]),
                  )
                else
                  Form(
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
                        const SizedBox(height: 24),
                        AppButton(
                          label: 'Envoyer le lien',
                          onTap: _submit,
                          isLoading: authState.isLoading,
                          icon: Icons.send,
                        ),
                      ],
                    ),
                  ),
                if (_sent) ...[
                  const SizedBox(height: 20),
                  AppButton(
                    label: 'Retour à la connexion',
                    onTap: () => context.go('/login'),
                    outline: true,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
