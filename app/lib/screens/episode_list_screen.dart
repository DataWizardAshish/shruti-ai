import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/episode.dart';
import '../providers/journey_provider.dart';
import '../providers/episode_flow_provider.dart';
import '../theme/app_theme.dart';
import 'quiz_screen.dart';

class EpisodeListScreen extends ConsumerWidget {
  const EpisodeListScreen({super.key, this.storyPhase, this.title});
  final String? storyPhase;
  final String? title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final episodesAsync = ref.watch(episodesProvider);

    return Scaffold(
      backgroundColor: AppColors.parchment,
      appBar: AppBar(
        title: Text(title ?? storyPhase ?? 'Episodes'),
      ),
      body: episodesAsync.when(
        data: (episodes) {
          final filtered = storyPhase != null
              ? episodes
                  .where((e) => e.storyPhase == storyPhase)
                  .toList()
              : episodes;

          if (filtered.isEmpty) {
            return Center(
              child: Text(
                'No episodes found',
                style: GoogleFonts.inter(color: AppColors.sandalwood),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: filtered.length,
            itemBuilder: (context, i) => _EpisodeCard(
              episode: filtered[i],
              onTap: () {
                ref
                    .read(episodeFlowProvider.notifier)
                    .startEpisode(filtered[i]);
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => QuizScreen(episode: filtered[i]),
                  ),
                );
              },
            ),
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.saffron),
        ),
        error: (e, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.wifi_off,
                    color: AppColors.sandalwood, size: 48),
                const SizedBox(height: 16),
                Text(
                  'Could not load episodes',
                  style:
                      GoogleFonts.inter(color: AppColors.sandalwood, fontSize: 14),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _EpisodeCard extends StatelessWidget {
  const _EpisodeCard({required this.episode, required this.onTap});
  final Episode episode;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
                color: AppColors.sandalwood.withValues(alpha: 0.25)),
            boxShadow: [
              BoxShadow(
                color: AppColors.sandalwood.withValues(alpha: 0.08),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      episode.name,
                      style: GoogleFonts.cinzel(
                        fontSize: 14,
                        color: AppColors.charcoal,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (episode.subtitle.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        episode.subtitle,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: AppColors.sandalwood,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                    const SizedBox(height: 6),
                    Text(
                      '${episode.questionsCount} questions',
                      style: GoogleFonts.inter(
                          fontSize: 11, color: AppColors.sandalwood),
                    ),
                  ],
                ),
              ),
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.saffron.withValues(alpha: 0.12),
                ),
                child: const Icon(Icons.play_arrow,
                    color: AppColors.saffron, size: 20),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
