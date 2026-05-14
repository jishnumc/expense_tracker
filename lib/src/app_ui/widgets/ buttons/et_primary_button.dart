import 'package:flutter/material.dart';
import 'package:expense_tracker/src/app_ui/app_ui.dart';

class ETPrimaryButton extends StatelessWidget {
  const ETPrimaryButton({
    required this.label,
    this.onPressed,
    this.icon,
    super.key,
  });

  final String label;

  final VoidCallback? onPressed;

  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    final colors = context.zAppColors;

    return SizedBox(
      width: 343,
      height: 48,
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: colors.primary,
          foregroundColor: colors.onPrimary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[icon!, const SizedBox(width: 10)],
            Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
