import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/journey_data.dart';
import '../providers/providers.dart';
import '../providers/journey_provider.dart';
import '../providers/episode_flow_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/narrative_path_widget.dart';
import '../widgets/weekly_summary_widget.dart';
import 'quiz_screen.dart';

class JourneyScreen extends ConsumerWidget {
  const JourneyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final journeyAsync = ref.watch(journeyProvider);
    final episodesAsync = ref.watch(episodesProvider);
    final progressAsync = ref.watch(progressServiceProvider);
    final streak = progressAsync.valueOrNull?.streakDays ?? 0;
    final last7Days = _computeLast7Days(streak);

    return Scaffold(
      backgroundColor: AppColors.parchment,
      appBar: AppBar(title: const Text('Your Story')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Narrative: milestones reached + next milestone
            journeyAsync.when(
              data: (data) => _NarrativeSection(journeyData: data),
              loading: () => const Padding(
                padding: EdgeInsets.only(bottom: 20),
                child: CircularProgressIndicator(color: AppColors.saffron),
              ),
              error: (_, e) => const SizedBox.shrink(),
            ),

            Text(
              'The Path Ahead',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: AppColors.templeRed,
                  ),
            ),
            const SizedBox(height: 20),

            // Episode path
            episodesAsync.when(
              data: (episodes) => journeyAsync.when(
                data: (journey) => NarrativePathWidget(
                  episodes: episodes,
                  currentEpisodeSequence:
                      journey.currentPosition.episodeSequence,
                  onEpisodeTap: (episode) {
                    ref
                        .read(episodeFlowProvider.notifier)
                        .startEpisode(episode);
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => QuizScreen(episode: episode),
                    ));
                  },
                ),
                loading: () => NarrativePathWidget(
                  episodes: episodes,
                  currentEpisodeSequence: 1,
                  onEpisodeTap: (episode) {
                    ref
                        .read(episodeFlowProvider.notifier)
                        .startEpisode(episode);
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => QuizScreen(episode: episode),
                    ));
                  },
                ),
                error: (_, e) => NarrativePathWidget(
                  episodes: episodes,
                  currentEpisodeSequence: 1,
                  onEpisodeTap: (episode) {
                    ref
                        .read(episodeFlowProvider.notifier)
                        .startEpisode(episode);
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => QuizScreen(episode: episode),
                    ));
                  },
                ),
              ),
              loading: () => const Center(
                child: CircularProgressIndicator(color: AppColors.saffron),
              ),
              error: (_, e) => _ErrorFallback(),
            ),

            const SizedBox(height: 32),

            journeyAsync.when(
              data: (data) => WeeklySummaryWidget(
                streakDays: streak,
                last7Days: last7Days,
                weekSummary: data.weekSummary,
              ),
              loading: () => WeeklySummaryWidget(
                streakDays: streak,
                last7Days: last7Days,
              ),
              error: (e, st) => WeeklySummaryWidget(
                streakDays: streak,
                last7Days: last7Days,
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  List<bool> _computeLast7Days(int streakDays) {
    final days = List<bool>.filled(7, false);
    if (streakDays <= 0) return days;
    final count = streakDays.clamp(0, 7);
    for (int i = 7 - count; i < 7; i++) {
      days[i] = true;
    }
    return days;
  }
}

class _NarrativeSection extends StatelessWidget {
  const _NarrativeSection({required this.journeyData});
  final JourneyData journeyData;

  @override
  Widget build(BuildContext context) {
    final milestones = journeyData.milestonesReached;
    final next = journeyData.nextMilestone;

    if (milestones.isEmpty && next.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Your Story So Far',
            style: GoogleFonts.cinzel(
              fontSize: 13,
              color: AppColors.sandalwood,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 8),
          if (milestones.isNotEmpty)
            Text(
              milestones.join(' · '),
              style: GoogleFonts.inter(
                fontSize: 14,
                color: AppColors.charcoal,
                height: 1.6,
              ),
            ),
          if (next.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              'Next: $next',
              style: GoogleFonts.inter(
                fontSize: 13,
                color: AppColors.saffron,
                fontStyle: FontStyle.italic,
                height: 1.5,
              ),
            ),
          ],
          const SizedBox(height: 16),
          Divider(color: AppColors.sandalwood.withValues(alpha: 0.3)),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class _ErrorFallback extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Icon(Icons.wifi_off, color: AppColors.sandalwood, size: 40),
        const SizedBox(height: 12),
        Text(
          'Could not load journey data',
          style: GoogleFonts.inter(color: AppColors.sandalwood, fontSize: 14),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
