import 'package:flutter/material.dart';

import '../app_theme.dart';

class GradientButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final double? width;
  final IconData? icon;
  final Gradient? gradient;

  const GradientButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.width,
    this.icon,
    this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    final grad = gradient ?? const LinearGradient(
      colors: [Color(0xFF6E5488), AppTheme.primaryColor],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );

    Widget child = isLoading
        ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation<Color>(Colors.white)))
        : Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 20, color: Colors.white),
                const SizedBox(width: AppTheme.spacingS),
              ],
              Text(text, style: AppTheme.buttonText),
            ],
          );

    final button = DecoratedBox(
      decoration: BoxDecoration(
        gradient: grad,
        borderRadius: BorderRadius.circular(AppTheme.radiusM),
        boxShadow: AppTheme.buttonShadow,
      ),
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppTheme.radiusM)),
        ),
        child: child,
      ),
    );

    if (width != null) return SizedBox(width: width, child: button);
    return button;
  }
}
