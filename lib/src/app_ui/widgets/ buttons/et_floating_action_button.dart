import 'package:expense_tracker/src/app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class ETFloatingActionButton extends StatelessWidget {
  const ETFloatingActionButton({required this.onPressed, super.key});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = context.zAppColors;

    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [colors.incomeSecondary, colors.incomePrimary],
        ),
        boxShadow: [
          BoxShadow(
            color: colors.incomePrimary.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          customBorder: const CircleBorder(),
          child: const Icon(Icons.add, color: Colors.white, size: 32),
        ),
      ),
    );
  }
}
