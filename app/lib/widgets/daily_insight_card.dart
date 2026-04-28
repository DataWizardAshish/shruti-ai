import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/story_insight.dart';
import '../theme/app_theme.dart';

class DailyInsightCard extends StatelessWidget {
  const DailyInsightCard({super.key, required this.insight});
  final StoryInsight insight;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.gold.withValues(alpha: 0.4)),
        boxShadow: [
          BoxShadow(
            color: AppColors.sandalwood.withValues(alpha: 0.15),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.gold.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.gold),
                ),
                child: Text(
                  '✦ Today\'s Insight',
                  style: TextStyle(
                    color: AppColors.gold,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              if (insight.character.isNotEmpty) ...[
                const Spacer(),
                Text(
                  insight.character,
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    color: AppColors.sandalwood,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 14),
          Text(
            insight.title,
            style: GoogleFonts.cinzel(
              fontSize: 16,
              color: AppColors.templeRed,
              fontWeight: FontWeight.w600,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            insight.narrative,
            style: GoogleFonts.inter(
              fontSize: 14,
              color: AppColors.charcoal,
              height: 1.6,
            ),
          ),
          if (insight.lesson.isNotEmpty) ...[
            const SizedBox(height: 14),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.parchment,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.sandalwood.withValues(alpha: 0.3)),
              ),
              child: Text(
                insight.lesson,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: AppColors.sandalwood,
                  fontStyle: FontStyle.italic,
                  height: 1.4,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
