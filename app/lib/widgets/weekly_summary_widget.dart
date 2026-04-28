import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

class WeeklySummaryWidget extends StatelessWidget {
  const WeeklySummaryWidget({
    super.key,
    required this.streakDays,
    required this.last7Days,
    this.weekSummary = '',
  });

  final int streakDays;
  final List<bool> last7Days;
  final String weekSummary;

  static const _dayLabels = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

  @override
  Widget build(BuildContext context) {
    final activeDays = last7Days.where((d) => d).length;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.sandalwood.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'This week',
            style: GoogleFonts.cinzel(
              fontSize: 12,
              color: AppColors.sandalwood,
              letterSpacing: 1,
            ),
          ),
          if (weekSummary.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              weekSummary,
              style: GoogleFonts.inter(
                fontSize: 13,
                color: AppColors.charcoal,
                height: 1.5,
              ),
            ),
          ],
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(7, (i) {
              final active = i < last7Days.length && last7Days[i];
              return Column(
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: active ? AppColors.gold : Colors.transparent,
                      border: Border.all(
                        color: active
                            ? AppColors.gold
                            : AppColors.sandalwood.withValues(alpha: 0.3),
                        width: 1.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _dayLabels[i],
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      color: active
                          ? AppColors.gold
                          : AppColors.sandalwood.withValues(alpha: 0.5),
                      fontWeight:
                          active ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                ],
              );
            }),
          ),
          const SizedBox(height: 10),
          Text(
            activeDays == 0
                ? 'Start today — Rama\'s story awaits'
                : activeDays == 7
                    ? 'Perfect week — every day with the Ramayan'
                    : 'Active $activeDays of 7 days this week',
            style: GoogleFonts.inter(
              fontSize: 12,
              color: AppColors.sandalwood,
            ),
          ),
        ],
      ),
    );
  }
}
