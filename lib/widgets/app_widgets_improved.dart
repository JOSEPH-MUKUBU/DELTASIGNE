import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../core/constants/app_theme.dart';
import 'package:google_fonts/google_fonts.dart';

// ═══════════════════════════════════════════════════════════════════════════
// 🎨 COMPOSANTS AMÉLIORÉS ET MODERNES
// ═══════════════════════════════════════════════════════════════════════════

// 🔘 PRIMARY BUTTON - Animé avec micro-interactions
class AppButton extends StatefulWidget {
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
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width ?? double.infinity,
      height: 56,
      child: MouseRegion(
        onEnter: (_) => setState(() => _isPressed = true),
        onExit: (_) => setState(() => _isPressed = false),
        child: GestureDetector(
          onTapDown: (_) => setState(() => _isPressed = true),
          onTapUp: (_) => setState(() => _isPressed = false),
          onTapCancel: () => setState(() => _isPressed = false),
          child: AnimatedScale(
            scale: _isPressed ? 0.95 : 1.0,
            duration: const Duration(milliseconds: 150),
            curve: Curves.easeOutQuad,
            child: widget.outline
                ? _OutlineButton(
                    label: widget.label,
                    icon: widget.icon,
                    color: widget.color,
                    isLoading: widget.isLoading,
                    onTap: widget.onTap,
                    isPressed: _isPressed,
                  )
                : _FilledButton(
                    label: widget.label,
                    icon: widget.icon,
                    color: widget.color,
                    isLoading: widget.isLoading,
                    onTap: widget.onTap,
                    isPressed: _isPressed,
                  ),
          ),
        ),
      ),
    );
  }
}

class _FilledButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final Color? color;
  final bool isLoading;
  final VoidCallback? onTap;
  final bool isPressed;

  const _FilledButton({
    required this.label,
    this.icon,
    this.color,
    required this.isLoading,
    this.onTap,
    required this.isPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            (color ?? AppColors.primary),
            (color ?? AppColors.primary).withOpacity(0.9),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color:
                (color ?? AppColors.primary).withOpacity(isPressed ? 0.3 : 0.5),
            blurRadius: isPressed ? 10 : 20,
            offset: Offset(0, isPressed ? 2 : 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isLoading ? null : onTap,
          borderRadius: BorderRadius.circular(14),
          child: Center(
            child: isLoading
                ? SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2.5,
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (icon != null) ...[
                        Icon(icon, size: 18, color: Colors.white),
                        const SizedBox(width: 8),
                      ],
                      Text(
                        label,
                        style: GoogleFonts.outfit(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                          color: Colors.white,
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

class _OutlineButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final Color? color;
  final bool isLoading;
  final VoidCallback? onTap;
  final bool isPressed;

  const _OutlineButton({
    required this.label,
    this.icon,
    this.color,
    required this.isLoading,
    this.onTap,
    required this.isPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: (color ?? AppColors.primary),
          width: 2,
        ),
      ),
      child: Material(
        color: (color ?? AppColors.primary).withOpacity(isPressed ? 0.1 : 0),
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          onTap: isLoading ? null : onTap,
          borderRadius: BorderRadius.circular(14),
          child: Center(
            child: isLoading
                ? SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      color: color ?? AppColors.primary,
                      strokeWidth: 2.5,
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (icon != null) ...[
                        Icon(icon, size: 18, color: color ?? AppColors.primary),
                        const SizedBox(width: 8),
                      ],
                      Text(
                        label,
                        style: GoogleFonts.outfit(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                          color: color ?? AppColors.primary,
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

// 🎴 GLASS CARD - Effet verre moderne avec animation
class GlassCard extends StatefulWidget {
  final Widget child;
  final EdgeInsets? padding;
  final VoidCallback? onTap;
  final double? borderRadius;
  final Color? borderColor;
  final double elevation;

  const GlassCard({
    super.key,
    required this.child,
    this.padding,
    this.onTap,
    this.borderRadius,
    this.borderColor,
    this.elevation = 12,
  });

  @override
  State<GlassCard> createState() => _GlassCardState();
}

class _GlassCardState extends State<GlassCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutQuad,
          padding: widget.padding ?? const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Color.fromARGB(
              _isHovered ? 25 : 15,
              255,
              255,
              255,
            ),
            borderRadius: BorderRadius.circular(widget.borderRadius ?? 16),
            border: Border.all(
              color: widget.borderColor ?? Colors.white.withOpacity(0.2),
              width: _isHovered ? 1.5 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.blue.withOpacity(_isHovered ? 0.25 : 0.15),
                blurRadius: _isHovered ? 20 : 15,
                offset: Offset(0, _isHovered ? 8 : 4),
              ),
            ],
          ),
          child: widget.child,
        ),
      ),
    );
  }
}

// 📊 STAT CARD - Statistiques animées
class StatCard extends StatefulWidget {
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
  State<StatCard> createState() => _StatCardState();
}

class _StatCardState extends State<StatCard> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  widget.color.withOpacity(0.3),
                  widget.color.withOpacity(0.1),
                ],
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(widget.icon, color: widget.color, size: 22),
          )
              .animate()
              .scale(
                begin: const Offset(0.8, 0.8),
                end: const Offset(1, 1),
                duration: const Duration(milliseconds: 500),
                curve: Curves.elasticOut,
              )
              .fadeIn(duration: const Duration(milliseconds: 500)),
          const SizedBox(height: 14),
          Text(
            widget.value,
            style: GoogleFonts.outfit(
              fontSize: 26,
              fontWeight: FontWeight.w800,
              color: widget.color,
            ),
          )
              .animate()
              .fadeIn(delay: const Duration(milliseconds: 200))
              .slideX(begin: -0.2, end: 0),
          const SizedBox(height: 4),
          Text(
            widget.label,
            style: GoogleFonts.outfit(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }
}

// 🔐 CONFIDENCE BAR - Barre de confiance animée
class ConfidenceBar extends StatefulWidget {
  final double confidence;
  const ConfidenceBar({super.key, required this.confidence});

  @override
  State<ConfidenceBar> createState() => _ConfidenceBarState();
}

class _ConfidenceBarState extends State<ConfidenceBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    )..forward();
  }

  @override
  void didUpdateWidget(ConfidenceBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.confidence != widget.confidence) {
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.confidence > 0.75
        ? AppColors.success
        : widget.confidence > 0.50
            ? AppColors.warning
            : AppColors.error;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Confiance',
              style: GoogleFonts.outfit(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Text(
                  '${(widget.confidence * 100).toStringAsFixed(0)}%',
                  style: GoogleFonts.outfit(
                    color: color,
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                );
              },
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, _) {
              return LinearProgressIndicator(
                value: Curves.easeOutQuad.transform(_controller.value) *
                    widget.confidence,
                backgroundColor: Colors.grey[200],
                valueColor: AlwaysStoppedAnimation<Color>(color),
                minHeight: 8,
              );
            },
          ),
        ),
      ],
    );
  }
}

// 📝 GRADIENT TEXT
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

// 📱 APP TEXT FIELD - Champ de texte amélioré
class AppTextField extends StatefulWidget {
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
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late bool _obscure;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _obscure = widget.obscure;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOutQuad,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: _isFocused
            ? [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.2),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ]
            : [],
      ),
      child: Focus(
        onFocusChange: (isFocused) => setState(() => _isFocused = isFocused),
        child: TextFormField(
          controller: widget.controller,
          obscureText: _obscure,
          validator: widget.validator,
          keyboardType: widget.keyboardType,
          style: GoogleFonts.outfit(fontSize: 15, fontWeight: FontWeight.w500),
          decoration: InputDecoration(
            labelText: widget.label,
            hintText: widget.hint,
            prefixIcon: widget.prefixIcon != null
                ? Icon(widget.prefixIcon, size: 20, color: AppColors.textMuted)
                : null,
            suffixIcon: widget.obscure
                ? IconButton(
                    icon: Icon(
                      _obscure ? Icons.visibility_off : Icons.visibility,
                      color: AppColors.textMuted,
                      size: 20,
                    ),
                    onPressed: () => setState(() => _obscure = !_obscure),
                  )
                : widget.suffix,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: Color(0xFFE5E7EB),
                width: 1.5,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Color(0xFFE5E7EB),
                width: 1.5,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: AppColors.primary,
                width: 2,
              ),
            ),
            filled: true,
            fillColor: Colors.grey[50],
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            labelStyle: GoogleFonts.outfit(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.grey[700],
            ),
            hintStyle: GoogleFonts.outfit(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ),
      ),
    );
  }
}

// 📂 LOADING SPINNER - Spinner amélioré
class AppLoadingSpinner extends StatelessWidget {
  final String? message;
  const AppLoadingSpinner({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 56,
            height: 56,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CircularProgressIndicator(
                  color: AppColors.primary.withOpacity(0.2),
                  strokeWidth: 8,
                ),
                CircularProgressIndicator(
                  color: AppColors.primary,
                  strokeWidth: 4,
                  value: 0.3,
                ),
              ],
            ),
          )
              .animate(onPlay: (controller) => controller.repeat())
              .rotate(duration: const Duration(seconds: 2)),
          if (message != null) ...[
            const SizedBox(height: 20),
            Text(
              message!,
              style: GoogleFonts.outfit(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// 🪦 EMPTY STATE - État vide sympathique
class EmptyState extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Widget? action;

  const EmptyState({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primary.withOpacity(0.2),
                  AppColors.accent.withOpacity(0.1),
                ],
              ),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Icon(
              icon,
              size: 48,
              color: AppColors.primary,
            ),
          )
              .animate()
              .scale(
                begin: const Offset(0.8, 0.8),
                end: const Offset(1, 1),
                duration: const Duration(milliseconds: 500),
                curve: Curves.elasticOut,
              )
              .fadeIn(),
          const SizedBox(height: 20),
          Text(
            title,
            style: GoogleFonts.outfit(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.grey[800],
            ),
          )
              .animate()
              .fadeIn(delay: const Duration(milliseconds: 100))
              .slideY(begin: 0.2, end: 0),
          const SizedBox(height: 8),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: GoogleFonts.outfit(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Colors.grey[600],
            ),
          )
              .animate()
              .fadeIn(delay: const Duration(milliseconds: 200))
              .slideY(begin: 0.2, end: 0),
          if (action != null) ...[
            const SizedBox(height: 24),
            action!,
          ],
        ],
      ),
    );
  }
}

// ✨ ANIMATED GESTURE INDICATOR
class AnimatedGestureIndicator extends StatefulWidget {
  final String gesture;
  final double confidence;

  const AnimatedGestureIndicator({
    super.key,
    required this.gesture,
    required this.confidence,
  });

  @override
  State<AnimatedGestureIndicator> createState() =>
      _AnimatedGestureIndicatorState();
}

class _AnimatedGestureIndicatorState extends State<AnimatedGestureIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    )..forward();
  }

  @override
  void didUpdateWidget(AnimatedGestureIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.gesture != widget.gesture) {
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: Tween<double>(begin: 0.8, end: 1.0).animate(
        CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.primary.withOpacity(0.8),
              AppColors.accent.withOpacity(0.6),
            ],
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.4),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
              ),
            ).animate(onPlay: (controller) => controller.repeat()).scale(
                  begin: const Offset(0.8, 0.8),
                  end: const Offset(1.2, 1.2),
                  duration: const Duration(milliseconds: 600),
                ),
            const SizedBox(width: 10),
            Text(
              widget.gesture.toUpperCase(),
              style: GoogleFonts.outfit(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
