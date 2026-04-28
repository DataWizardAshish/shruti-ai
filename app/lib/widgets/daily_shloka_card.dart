import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/daily_shloka.dart';
import '../theme/app_theme.dart';

class DailyShlokaCard extends StatelessWidget {
  const DailyShlokaCard({super.key, required this.shloka});
  final DailyShloka shloka;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.parchment,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.gold.withValues(alpha: 0.5), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Align(
            alignment: Alignment.topRight,
            child: Text(
              "Today's verse",
              style: GoogleFonts.inter(
                fontSize: 11,
                color: AppColors.sandalwood,
                letterSpacing: 0.5,
              ),
            ),
          ),
          const SizedBox(height: 8),
          if (shloka.textDevanagari.isNotEmpty)
            Text(
              shloka.textDevanagari,
              textAlign: TextAlign.center,
              style: GoogleFonts.notoSerif(
                fontSize: 18,
                color: AppColors.templeRed,
                height: 1.6,
              ),
            ),
          if (shloka.transliteration.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              shloka.transliteration,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 13,
                color: AppColors.sandalwood,
                fontStyle: FontStyle.italic,
                height: 1.5,
              ),
            ),
          ],
          if (shloka.meaningContext.isNotEmpty) ...[
            Divider(
              height: 20,
              color: AppColors.gold.withValues(alpha: 0.3),
            ),
            Text(
              shloka.meaningContext,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: AppColors.charcoal,
                height: 1.5,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
