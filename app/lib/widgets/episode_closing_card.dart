import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/episode.dart';
import '../theme/app_theme.dart';

class EpisodeClosingCard extends StatelessWidget {
  const EpisodeClosingCard({
    super.key,
    required this.episode,
    required this.onReturn,
    this.nextEpisode,
    this.onNextEpisode,
  });

  final Episode episode;
  final VoidCallback onReturn;
  final Episode? nextEpisode;
  final VoidCallback? onNextEpisode;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.deepForest,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.auto_awesome, color: AppColors.gold, size: 56),
              const SizedBox(height: 24),
              Text(
                'End of Episode',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: AppColors.sandalwood,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                episode.name,
                textAlign: TextAlign.center,
                style: GoogleFonts.cinzel(
                  fontSize: 24,
                  color: AppColors.gold,
                  fontWeight: FontWeight.w600,
                  height: 1.3,
                ),
              ),
              if (episode.closingText.isNotEmpty) ...[
                const SizedBox(height: 24),
                Text(
                  episode.closingText,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    color: AppColors.parchment,
                    height: 1.6,
                  ),
                ),
              ],
              const SizedBox(height: 48),
              if (nextEpisode != null && onNextEpisode != null) ...[
                ElevatedButton(
                  onPressed: onNextEpisode,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.saffron,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 14),
                  ),
                  child: Text('Next: ${nextEpisode!.name} →'),
                ),
                const SizedBox(height: 12),
              ],
              TextButton(
                onPressed: onReturn,
                child: Text(
                  'Return to Journey',
                  style: GoogleFonts.inter(
                      color: AppColors.sandalwood, fontSize: 14),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
