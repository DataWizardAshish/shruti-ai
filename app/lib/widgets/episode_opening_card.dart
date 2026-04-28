import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/episode.dart';
import '../theme/app_theme.dart';

class EpisodeOpeningCard extends StatefulWidget {
  const EpisodeOpeningCard({
    super.key,
    required this.episode,
    required this.onBegin,
  });

  final Episode episode;
  final VoidCallback onBegin;

  @override
  State<EpisodeOpeningCard> createState() => _EpisodeOpeningCardState();
}

class _EpisodeOpeningCardState extends State<EpisodeOpeningCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  bool _beginEnabled = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..forward();
    Future.delayed(const Duration(milliseconds: 1200), () {
      if (mounted) setState(() => _beginEnabled = true);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.deepForest,
      body: FadeTransition(
        opacity: _controller,
        child: SafeArea(
          child: Stack(
            children: [
              Positioned(
                top: 4,
                left: 4,
                child: IconButton(
                  icon: const Icon(Icons.close, color: AppColors.sandalwood),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        widget.episode.name,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.cinzel(
                          fontSize: 28,
                          color: AppColors.gold,
                          fontWeight: FontWeight.w600,
                          height: 1.3,
                        ),
                      ),
                      if (widget.episode.subtitle.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        Text(
                          widget.episode.subtitle,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            color: AppColors.sandalwood,
                            fontStyle: FontStyle.italic,
                            height: 1.5,
                          ),
                        ),
                      ],
                      const SizedBox(height: 32),
                      if (widget.episode.openingText.isNotEmpty)
                        Text(
                          widget.episode.openingText,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                            fontSize: 18,
                            color: AppColors.parchment,
                            height: 1.6,
                          ),
                        ),
                      const SizedBox(height: 48),
                      ElevatedButton(
                        onPressed: _beginEnabled ? widget.onBegin : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.saffron,
                          disabledBackgroundColor:
                              AppColors.sandalwood.withValues(alpha: 0.3),
                          foregroundColor: AppColors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 40, vertical: 16),
                        ),
                        child: const Text('Begin →'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
