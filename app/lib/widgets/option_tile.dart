import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

enum OptionState { idle, selected, correct, wrong }

class OptionTile extends StatelessWidget {
  const OptionTile({
    super.key,
    required this.label,
    required this.text,
    required this.state,
    required this.onTap,
  });

  final String label;
  final String text;
  final OptionState state;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final (bg, border, textColor, icon) = switch (state) {
      OptionState.idle => (AppColors.white, AppColors.sandalwood, AppColors.charcoal, null),
      OptionState.selected => (AppColors.saffron.withValues(alpha: 0.1), AppColors.saffron, AppColors.saffron, null),
      OptionState.correct => (AppColors.gold.withValues(alpha: 0.15), AppColors.gold, AppColors.charcoal, Icons.check_circle),
      OptionState.wrong => (Colors.grey.shade100, Colors.grey.shade400, Colors.grey.shade500, Icons.cancel),
    };

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: border, width: state == OptionState.idle ? 1 : 1.5),
          boxShadow: state == OptionState.correct
              ? [BoxShadow(color: AppColors.gold.withValues(alpha: 0.3), blurRadius: 8, spreadRadius: 1)]
              : null,
        ),
        child: Row(
          children: [
            Container(
              width: 30,
              height: 30,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: border.withValues(alpha: 0.15),
                border: Border.all(color: border),
              ),
              child: Text(
                label,
                style: TextStyle(
                  color: border,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  color: textColor,
                  fontSize: 15,
                  height: 1.3,
                ),
              ),
            ),
            if (icon != null) ...[
              const SizedBox(width: 8),
              Icon(icon, color: border, size: 20),
            ],
          ],
        ),
      ),
    );
  }
}
