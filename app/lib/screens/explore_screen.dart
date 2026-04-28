import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/providers.dart';
import '../models/phase_story.dart';
import '../theme/app_theme.dart';
import 'phase_story_screen.dart';

class ExploreScreen extends ConsumerWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final phasesAsync = ref.watch(phasesProvider);

    return Scaffold(
      backgroundColor: AppColors.parchment,
      body: Stack(
        children: [
          _ParchmentBg(),
          SafeArea(
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 24, 20, 4),
                    child: Text(
                      'THE STORY',
                      style: GoogleFonts.cinzel(
                        fontSize: 12,
                        color: AppColors.sandalwood,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 4, 20, 8),
                    child: Text(
                      'Explore the Epic',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            color: AppColors.templeRed,
                          ),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                    child: Text(
                      'Read the story of each chapter, then test your knowledge.',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: AppColors.sandalwood,
                        height: 1.5,
                      ),
                    ),
                  ),
                ),
                phasesAsync.when(
                  data: (phases) => SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, i) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _PhaseCard(
                            phase: phases[i],
                            onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => PhaseStoryScreen(
                                  storyPhase: phases[i].storyPhase,
                                ),
                              ),
                            ),
                          ),
                        ),
                        childCount: phases.length,
                      ),
                    ),
                  ),
                  loading: () => const SliverFillRemaining(
                    child: Center(
                      child: CircularProgressIndicator(color: AppColors.saffron),
                    ),
                  ),
                  error: (e, st) => _FallbackPhaseList(),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 32)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PhaseCard extends StatelessWidget {
  const _PhaseCard({required this.phase, required this.onTap});
  final PhaseSummary phase;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.sandalwood.withValues(alpha: 0.25)),
          boxShadow: [
            BoxShadow(
              color: AppColors.sandalwood.withValues(alpha: 0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    phase.title.isNotEmpty ? phase.title : phase.storyPhase,
                    style: GoogleFonts.cinzel(
                      fontSize: 15,
                      color: AppColors.templeRed,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const Icon(Icons.chevron_right, color: AppColors.sandalwood),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              phase.storyPhase,
              style: GoogleFonts.inter(
                fontSize: 11,
                color: AppColors.sandalwood,
                letterSpacing: 0.3,
              ),
            ),
            if (phase.mood.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                phase.mood,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: AppColors.sandalwood,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
            if (phase.keyCharacters.isNotEmpty) ...[
              const SizedBox(height: 10),
              Wrap(
                spacing: 6,
                children: phase.keyCharacters.take(4).map((c) => _MiniChip(label: c)).toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _MiniChip extends StatelessWidget {
  const _MiniChip({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.parchment,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.sandalwood.withValues(alpha: 0.3)),
      ),
      child: Text(
        label,
        style: GoogleFonts.inter(fontSize: 11, color: AppColors.sandalwood),
      ),
    );
  }
}

// Fallback: show static phase list when backend /phases not available yet
class _FallbackPhaseList extends StatelessWidget {
  static const _phases = [
    'Early Life of Rama',
    'Exile Phase',
    'Sita Haran',
    'Search for Sita',
    'Lanka War',
    'Return and Reunion',
  ];

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, i) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: InkWell(
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => PhaseStoryScreen(storyPhase: _phases[i]),
                ),
              ),
              borderRadius: BorderRadius.circular(14),
              child: Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                      color: AppColors.sandalwood.withValues(alpha: 0.25)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        _phases[i],
                        style: GoogleFonts.cinzel(
                          fontSize: 15,
                          color: AppColors.templeRed,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const Icon(Icons.chevron_right, color: AppColors.sandalwood),
                  ],
                ),
              ),
            ),
          ),
          childCount: _phases.length,
        ),
      ),
    );
  }
}

class _ParchmentBg extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: AppColors.parchment),
      child: Opacity(
        opacity: 0.06,
        child: Center(
          child: Text(
            'रामो विग्रहवान् धर्मः',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 32,
              fontFamily: 'serif',
              color: AppColors.templeRed,
              letterSpacing: 2,
            ),
          ),
        ),
      ),
    );
  }
}
