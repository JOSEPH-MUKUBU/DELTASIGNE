import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_theme.dart';
import '../../../../widgets/app_widgets.dart';

class PermissionsPage extends StatefulWidget {
  const PermissionsPage({super.key});
  @override
  State<PermissionsPage> createState() => _PermissionsPageState();
}

class _PermissionsPageState extends State<PermissionsPage> {
  bool _cameraGranted = false;
  bool _micGranted = false;
  bool _storageGranted = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.gradientBackground),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  IconButton(onPressed: () => context.pop(), icon: const Icon(Icons.arrow_back_ios, color: AppColors.textSecondary, size: 18)),
                  Text('Permissions', style: GoogleFonts.outfit(fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                ]),
                const SizedBox(height: 24),
                GlassCard(
                  borderColor: AppColors.primary.withOpacity(0.3),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Row(children: [
                      const Icon(Icons.info_outline, color: AppColors.primary, size: 20),
                      const SizedBox(width: 8),
                      Text('Pourquoi ces permissions ?', style: GoogleFonts.outfit(color: AppColors.primary, fontWeight: FontWeight.w600)),
                    ]),
                    const SizedBox(height: 10),
                    Text('DELTASIGNE a besoin d\'accéder à votre caméra pour analyser les gestes. Ces données ne quittent jamais votre appareil.',
                        style: GoogleFonts.outfit(color: AppColors.textSecondary, fontSize: 13, height: 1.5)),
                  ]),
                ),
                const SizedBox(height: 24),
                Expanded(
                  child: ListView(
                    children: [
                      _PermissionTile(
                        icon: Icons.camera_alt,
                        title: 'Caméra',
                        subtitle: 'Requis pour la détection des gestes en temps réel.',
                        required: true,
                        granted: _cameraGranted,
                        onToggle: (v) => setState(() => _cameraGranted = v),
                      ),
                      const SizedBox(height: 12),
                      _PermissionTile(
                        icon: Icons.mic,
                        title: 'Microphone',
                        subtitle: 'Optionnel. Nécessaire pour les commandes vocales.',
                        required: false,
                        granted: _micGranted,
                        onToggle: (v) => setState(() => _micGranted = v),
                      ),
                      const SizedBox(height: 12),
                      _PermissionTile(
                        icon: Icons.folder_outlined,
                        title: 'Stockage',
                        subtitle: 'Optionnel. Pour exporter les traductions en fichier texte.',
                        required: false,
                        granted: _storageGranted,
                        onToggle: (v) => setState(() => _storageGranted = v),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                AppButton(
                  label: _cameraGranted ? 'Continuer →' : 'Accorder la permission caméra',
                  onTap: () {
                    if (_cameraGranted) {
                      context.go('/home');
                    } else {
                      setState(() => _cameraGranted = true);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('✅ Permission caméra accordée'), backgroundColor: AppColors.success),
                      );
                    }
                  },
                  icon: _cameraGranted ? Icons.check : Icons.camera_alt,
                  color: _cameraGranted ? AppColors.success : AppColors.primary,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PermissionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool required;
  final bool granted;
  final ValueChanged<bool> onToggle;

  const _PermissionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.required,
    required this.granted,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      borderColor: granted ? AppColors.success.withOpacity(0.3) : null,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: granted ? AppColors.success.withOpacity(0.15) : AppColors.bgCardLight,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: granted ? AppColors.success : AppColors.textSecondary, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Text(title, style: GoogleFonts.outfit(color: AppColors.textPrimary, fontWeight: FontWeight.w600, fontSize: 14)),
                const SizedBox(width: 6),
                if (required)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                    decoration: BoxDecoration(color: AppColors.error.withOpacity(0.15), borderRadius: BorderRadius.circular(6)),
                    child: Text('Requis', style: GoogleFonts.outfit(color: AppColors.error, fontSize: 10, fontWeight: FontWeight.w600)),
                  ),
              ]),
              const SizedBox(height: 4),
              Text(subtitle, style: GoogleFonts.outfit(color: AppColors.textMuted, fontSize: 12, height: 1.4)),
            ]),
          ),
          Switch(value: granted, onChanged: onToggle, activeColor: AppColors.success),
        ],
      ),
    );
  }
}
