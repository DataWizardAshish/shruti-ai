import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/phase_story.dart';
import '../providers/providers.dart';
import '../theme/app_theme.dart';
import 'episode_list_screen.dart';

class PhaseStoryScreen extends ConsumerWidget {
  const PhaseStoryScreen({super.key, required this.storyPhase});
  final String storyPhase;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final storyAsync = ref.watch(phaseStoryProvider(storyPhase));

    return Scaffold(
      backgroundColor: AppColors.parchment,
      body: storyAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.saffron),
        ),
        error: (e, _) => _FallbackBody(storyPhase: storyPhase),
        data: (story) => _StoryBody(story: story),
      ),
    );
  }
}

class _StoryBody extends StatelessWidget {
  const _StoryBody({required this.story});
  final PhaseStory story;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 160,
          pinned: true,
          backgroundColor: AppColors.deepForest,
          foregroundColor: AppColors.parchment,
          flexibleSpace: FlexibleSpaceBar(
            titlePadding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
            title: Text(
              story.storyPhase,
              style: GoogleFonts.cinzel(
                fontSize: 14,
                color: AppColors.parchment,
                fontWeight: FontWeight.w600,
              ),
            ),
            background: Container(
              color: AppColors.deepForest,
              child: Opacity(
                opacity: 0.08,
                child: Center(
                  child: Text(
                    story.shlokaWatermark,
                    style: const TextStyle(
                      fontSize: 28,
                      fontFamily: 'serif',
                      color: AppColors.parchment,
                      letterSpacing: 2,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Mood tag
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                  decoration: BoxDecoration(
                    color: AppColors.saffron.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.saffron.withValues(alpha: 0.4)),
                  ),
                  child: Text(
                    story.mood,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: AppColors.saffron,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Title
                Text(
                  story.title,
                  style: GoogleFonts.cinzel(
                    fontSize: 22,
                    color: AppColors.templeRed,
                    fontWeight: FontWeight.w700,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 20),
                // Narrative
                Text(
                  story.narrative,
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    color: AppColors.charcoal,
                    height: 1.75,
                  ),
                ),
              ],
            ),
          ),
        ),

        // Key events
        if (story.keyEvents.isNotEmpty)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 28, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'KEY MOMENTS',
                    style: GoogleFonts.cinzel(
                      fontSize: 11,
                      color: AppColors.sandalwood,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...story.keyEvents.map(
                    (event) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            margin: const EdgeInsets.only(top: 7, right: 12),
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.gold,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              event,
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                color: AppColors.charcoal,
                                height: 1.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

        // Key characters
        if (story.keyCharacters.isNotEmpty)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'CHARACTERS',
                    style: GoogleFonts.cinzel(
                      fontSize: 11,
                      color: AppColors.sandalwood,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: story.keyCharacters
                        .map((c) => _CharacterChip(name: c))
                        .toList(),
                  ),
                ],
              ),
            ),
          ),

        // CTA
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 32, 20, 40),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.templeRed,
                  foregroundColor: AppColors.parchment,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) =>
                        EpisodeListScreen(storyPhase: story.storyPhase),
                  ),
                ),
                child: Text(
                  'Test your knowledge →',
                  style: GoogleFonts.cinzel(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _CharacterChip extends StatelessWidget {
  const _CharacterChip({required this.name});
  final String name;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.sandalwood.withValues(alpha: 0.4)),
      ),
      child: Text(
        name,
        style: GoogleFonts.inter(
          fontSize: 13,
          color: AppColors.charcoal,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

// Shown when backend doesn't have phase_stories yet — still lets user enter quiz
class _FallbackBody extends StatelessWidget {
  const _FallbackBody({required this.storyPhase});
  final String storyPhase;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          AppBar(
            title: Text(storyPhase),
            backgroundColor: AppColors.parchment,
            foregroundColor: AppColors.templeRed,
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              children: [
                Text(
                  storyPhase,
                  style: GoogleFonts.cinzel(
                    fontSize: 20,
                    color: AppColors.templeRed,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => EpisodeListScreen(storyPhase: storyPhase),
                      ),
                    ),
                    child: const Text('Browse Episodes →'),
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
