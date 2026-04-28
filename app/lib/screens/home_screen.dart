import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/providers.dart';
import '../providers/home_data_provider.dart';
import '../providers/journey_provider.dart';
import '../providers/saved_questions_provider.dart';
import '../providers/episode_flow_provider.dart';
import '../theme/app_theme.dart';
import '../models/episode.dart';
import '../models/question.dart' show storyPhases;
import '../widgets/daily_insight_card.dart';
import '../widgets/daily_shloka_card.dart';
import '../widgets/continue_journey_card.dart';
import '../widgets/recent_wisdom_strip.dart';
import 'quiz_screen.dart';
import 'phase_story_screen.dart';
import 'saved_question_detail_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeDataAsync = ref.watch(homeDataProvider);
    final dailyInsight = ref.watch(dailyInsightProvider);
    final savedState = ref.watch(savedQuestionsProvider);
    final episodesAsync = ref.watch(episodesProvider);

    return Scaffold(
      body: Stack(
        children: [
          _ParchmentBackground(),
          SafeArea(
            child: CustomScrollView(
              slivers: [
                // Header
                SliverToBoxAdapter(
                  child: homeDataAsync.when(
                    data: (data) => _Header(greeting: data.greeting),
                    loading: () => _Header(greeting: 'Welcome, traveler'),
                    error: (_, _) => _Header(greeting: 'Welcome, traveler'),
                  ),
                ),

                // Daily Shloka
                SliverToBoxAdapter(
                  child: homeDataAsync.when(
                    data: (data) {
                      if (data.dailyShloka == null) return const SizedBox.shrink();
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
                        child: DailyShlokaCard(shloka: data.dailyShloka!),
                      );
                    },
                    loading: () => const SizedBox.shrink(),
                    error: (_, _) => const SizedBox.shrink(),
                  ),
                ),

                // Continue Journey card
                SliverToBoxAdapter(
                  child: homeDataAsync.when(
                    data: (data) {
                      // Look up full Episode object by ID from episodes list
                      Episode? fullEpisode;
                      if (data.currentEpisodeId != null) {
                        fullEpisode = episodesAsync.valueOrNull
                            ?.where((e) => e.id == data.currentEpisodeId)
                            .firstOrNull;
                        // Fallback: construct minimal episode from home data
                        fullEpisode ??= data.currentEpisodeId != null
                            ? Episode(
                                id: data.currentEpisodeId!,
                                name: data.currentEpisodeName ?? '',
                                kanda: '',
                                storyPhase: '',
                                subtitle: '',
                                openingText: '',
                                closingText: '',
                                emotionalTone: '',
                                questionsCount: 0,
                              )
                            : null;
                      }
                      final total = fullEpisode?.questionsCount ?? 0;
                      final remaining = data.questionsRemaining ?? 0;
                      final progress = total > 0
                          ? ((total - remaining) / total).clamp(0.0, 1.0)
                          : 0.0;
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                        child: ContinueJourneyCard(
                          currentEpisode: fullEpisode,
                          progress: progress,
                          onContinue: () {
                            if (fullEpisode != null) {
                              _startEpisode(context, ref, fullEpisode);
                            }
                          },
                        ),
                      );
                    },
                    loading: () => const SizedBox.shrink(),
                    error: (_, _) => const SizedBox.shrink(),
                  ),
                ),

                // Daily Insight card
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
                    child: dailyInsight.when(
                      data: (insight) => DailyInsightCard(insight: insight),
                      loading: () => _LoadingSkeleton(),
                      error: (e, _) => _ErrorCard(message: e.toString()),
                    ),
                  ),
                ),

                // Recent Wisdom strip
                if (savedState.items.isNotEmpty)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 24),
                      child: RecentWisdomStrip(
                        onTap: (i) {
                          final saved = savedState.items[i];
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (_) => SavedQuestionDetailScreen(
                                savedQuestion: saved),
                          ));
                        },
                      ),
                    ),
                  ),

                // Phase chips (collapsed)
                SliverToBoxAdapter(
                  child: _PhaseQuickAccessCollapsed(),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 32)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _startEpisode(
      BuildContext context, WidgetRef ref, Episode episode) {
    ref.read(episodeFlowProvider.notifier).startEpisode(episode);
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => QuizScreen(episode: episode),
    ));
  }
}

class _ParchmentBackground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: AppColors.parchment),
      child: Opacity(
        opacity: 0.07,
        child: Center(
          child: Text(
            'रामो विग्रहवान् धर्मः\nसाधुश्च सत्यसन्धश्च\nराजा सर्वस्य लोकस्य\nदेवानाम् इव वासवः',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 28,
              fontFamily: 'serif',
              color: AppColors.templeRed,
              height: 2.2,
              letterSpacing: 2,
            ),
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.greeting});
  final String greeting;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Ramayana',
            style: Theme.of(context).textTheme.displayMedium?.copyWith(
                  color: AppColors.templeRed,
                  letterSpacing: 4,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            greeting,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.sandalwood,
                  fontStyle: FontStyle.italic,
                ),
          ),
        ],
      ),
    );
  }
}

class _PhaseQuickAccessCollapsed extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
        ),
        child: ExpansionTile(
          title: Text(
            'Explore by story phase',
            style: GoogleFonts.cinzel(
              fontSize: 14,
              color: AppColors.templeRed,
              fontWeight: FontWeight.w600,
            ),
          ),
          iconColor: AppColors.sandalwood,
          collapsedIconColor: AppColors.sandalwood,
          tilePadding: EdgeInsets.zero,
          initiallyExpanded: false,
          children: [
            const SizedBox(height: 12),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: storyPhases
                  .where((p) => p != 'Other')
                  .map((phase) => _PhaseChip(phase: phase))
                  .toList(),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

class _PhaseChip extends StatelessWidget {
  const _PhaseChip({required this.phase});
  final String phase;

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      label: Text(phase),
      labelStyle: const TextStyle(
        color: AppColors.templeRed,
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
      backgroundColor: AppColors.parchment,
      side: const BorderSide(color: AppColors.sandalwood),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      onPressed: () => Navigator.of(context).push(
        MaterialPageRoute(
            builder: (_) => PhaseStoryScreen(storyPhase: phase)),
      ),
    );
  }
}

class _LoadingSkeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 220,
      decoration: BoxDecoration(
        color: AppColors.sandalwood.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Center(
        child: CircularProgressIndicator(color: AppColors.saffron),
      ),
    );
  }
}

class _ErrorCard extends StatelessWidget {
  const _ErrorCard({required this.message});
  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.parchment,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.sandalwood),
      ),
      child: Column(
        children: [
          const Icon(Icons.wifi_off, color: AppColors.sandalwood, size: 40),
          const SizedBox(height: 12),
          Text(
            "Could not load today's insight",
            style: Theme.of(context).textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Make sure the backend is running on localhost:8000',
            style: Theme.of(context).textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
