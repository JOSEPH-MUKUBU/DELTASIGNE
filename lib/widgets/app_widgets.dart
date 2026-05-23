import 'package:flutter/material.dart';
import '../core/constants/app_theme.dart';
import 'package:google_fonts/google_fonts.dart';

// ─── Primary Button ───────────────────────────────────────────────
class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final bool isLoading;
  final bool outline;
  final IconData? icon;
  final Color? color;
  final double? width;

  const AppButton({
    super.key,
    required this.label,
    this.onTap,
    this.isLoading = false,
    this.outline = false,
    this.icon,
    this.color,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      height: 54,
      child: outline
          ? OutlinedButton.icon(
              onPressed: isLoading ? null : onTap,
              icon:
                  icon != null ? Icon(icon, size: 18) : const SizedBox.shrink(),
              label: Text(label),
              style: OutlinedButton.styleFrom(
                foregroundColor: color ?? AppColors.primary,
                side: BorderSide(
                    color: (color ?? AppColors.primary).withOpacity(0.75),
                    width: 1.2),
                backgroundColor: (color ?? AppColors.primary).withOpacity(0.08),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
              ),
            )
          : DecoratedBox(
              decoration: BoxDecoration(
                gradient: color == null
                    ? AppColors.gradientPrimary
                    : LinearGradient(
                        colors: [color!, color!.withOpacity(0.82)]),
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: (color ?? AppColors.primary).withOpacity(0.28),
                    blurRadius: 18,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: isLoading ? null : onTap,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
                child: isLoading
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                            color: Colors.white, strokeWidth: 2.5),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (icon != null) ...[
                            Icon(icon, size: 18),
                            const SizedBox(width: 8)
                          ],
                          Flexible(
                            child: Text(
                              label,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.outfit(
                                  fontWeight: FontWeight.w700, fontSize: 15),
                            ),
                          ),
                        ],
                      ),
              ),
            ),
    );
  }
}

// ─── Glass Card ───────────────────────────────────────────────────
class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final VoidCallback? onTap;
  final double? borderRadius;
  final Color? borderColor;

  const GlassCard({
    super.key,
    required this.child,
    this.padding,
    this.onTap,
    this.borderRadius,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: padding ?? const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark
              ? AppColors.bgCard.withOpacity(0.86)
              : AppColors.bgLightCard,
          borderRadius: BorderRadius.circular(borderRadius ?? 14),
          border: Border.all(
            color: borderColor ??
                (isDark ? const Color(0xFF32364C) : const Color(0xFFE8DED3)),
            width: 1,
          ),
          boxShadow: isDark
              ? [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.18),
                      blurRadius: 18,
                      offset: const Offset(0, 10))
                ]
              : [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 18,
                      offset: const Offset(0, 10))
                ],
        ),
        child: child,
      ),
    );
  }
}

// ─── Loading Spinner ──────────────────────────────────────────────
class AppLoadingSpinner extends StatelessWidget {
  final String? message;
  const AppLoadingSpinner({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(color: AppColors.primary),
          if (message != null) ...[
            const SizedBox(height: 16),
            Text(message!, style: Theme.of(context).textTheme.bodyMedium),
          ],
        ],
      ),
    );
  }
}

// ─── Confidence Bar ───────────────────────────────────────────────
class ConfidenceBar extends StatelessWidget {
  final double confidence;
  const ConfidenceBar({super.key, required this.confidence});

  @override
  Widget build(BuildContext context) {
    final color = confidence > 0.75
        ? AppColors.success
        : confidence > 0.50
            ? AppColors.warning
            : AppColors.error;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Confiance', style: Theme.of(context).textTheme.bodySmall),
            Text('${(confidence * 100).toStringAsFixed(0)}%',
                style: TextStyle(
                    color: color, fontWeight: FontWeight.w600, fontSize: 12)),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: confidence,
            backgroundColor: AppColors.bgCardLight,
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 6,
          ),
        ),
      ],
    );
  }
}

// ─── Gradient Text ────────────────────────────────────────────────
class GradientText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final Gradient gradient;

  const GradientText(
    this.text, {
    super.key,
    this.style,
    this.gradient = AppColors.gradientPrimary,
  });

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (bounds) => gradient.createShader(bounds),
      child: Text(text, style: style),
    );
  }
}

// ─── App TextField ────────────────────────────────────────────────
class AppTextField extends StatelessWidget {
  final String label;
  final String? hint;
  final TextEditingController controller;
  final bool obscure;
  final IconData? prefixIcon;
  final Widget? suffix;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final VoidCallback? onToggleObscure;

  const AppTextField({
    super.key,
    required this.label,
    required this.controller,
    this.hint,
    this.obscure = false,
    this.prefixIcon,
    this.suffix,
    this.validator,
    this.keyboardType,
    this.onToggleObscure,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      validator: validator,
      keyboardType: keyboardType,
      style: Theme.of(context).textTheme.bodyLarge,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: prefixIcon != null
            ? Icon(prefixIcon, color: AppColors.textMuted, size: 20)
            : null,
        suffixIcon: suffix,
      ),
    );
  }
}

// ─── Stat Card ────────────────────────────────────────────────────
class StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const StatCard({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 12),
          Text(value,
              style: GoogleFonts.outfit(
                  fontSize: 24, fontWeight: FontWeight.w700, color: color)),
          const SizedBox(height: 4),
          Text(label, style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }
}

// ─── Empty State ──────────────────────────────────────────────────
class EmptyState extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;

  const EmptyState({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 64, color: AppColors.textMuted),
          const SizedBox(height: 16),
          Text(title,
              style: GoogleFonts.outfit(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary)),
          const SizedBox(height: 8),
          Text(subtitle,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }
}
