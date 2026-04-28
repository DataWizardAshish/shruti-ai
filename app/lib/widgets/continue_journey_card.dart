import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/episode.dart';
import '../theme/app_theme.dart';

class ContinueJourneyCard extends StatelessWidget {
  const ContinueJourneyCard({
    super.key,
    required this.currentEpisode,
    required this.progress,
    required this.onContinue,
  });

  final Episode? currentEpisode;
  final double progress;
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    if (currentEpisode == null) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.templeRed.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.templeRed.withValues(alpha: 0.2)),
        ),
        child: Row(
          children: [
            const Icon(Icons.play_circle_outline,
                color: AppColors.saffron, size: 32),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Begin your journey',
                    style: GoogleFonts.cinzel(
                      fontSize: 15,
                      color: AppColors.templeRed,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Start with the Early Life of Rama',
                    style: GoogleFonts.inter(
                        fontSize: 13, color: AppColors.sandalwood),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return GestureDetector(
      onTap: onContinue,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.saffron.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(16),
          border:
              Border.all(color: AppColors.saffron.withValues(alpha: 0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Continue',
              style: GoogleFonts.inter(
                fontSize: 11,
                color: AppColors.saffron,
                letterSpacing: 0.8,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              currentEpisode!.name,
              style: GoogleFonts.cinzel(
                fontSize: 16,
                color: AppColors.templeRed,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (currentEpisode!.subtitle.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                currentEpisode!.subtitle,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: AppColors.sandalwood,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value: progress.clamp(0.0, 1.0),
              backgroundColor: AppColors.sandalwood.withValues(alpha: 0.2),
              valueColor:
                  const AlwaysStoppedAnimation(AppColors.saffron),
              minHeight: 3,
              borderRadius: BorderRadius.circular(4),
            ),
          ],
        ),
      ),
    );
  }
}
