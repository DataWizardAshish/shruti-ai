import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/journey_provider.dart';
import '../theme/app_theme.dart';
import 'episode_list_screen.dart';

class PhaseSelectorScreen extends ConsumerWidget {
  const PhaseSelectorScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final episodesAsync = ref.watch(episodesProvider);

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
                      'THE JOURNEY',
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
                    padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
                    child: Text(
                      'Choose a chapter',
                      style:
                          Theme.of(context).textTheme.headlineMedium?.copyWith(
                                color: AppColors.templeRed,
                              ),
                    ),
                  ),
                ),
                episodesAsync.when(
                  data: (episodes) {
                    final phases = <String, int>{};
                    for (final ep in episodes) {
                      final p = ep.storyPhase.isNotEmpty ? ep.storyPhase : 'Other';
                      phases[p] = (phases[p] ?? 0) + 1;
                    }
                    final phaseList = phases.keys.toList();
                    return SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, i) => Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: _KandaCard(
                              kanda: phaseList[i],
                              episodeCount: phases[phaseList[i]]!,
                              onTap: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => EpisodeListScreen(
                                      storyPhase: phaseList[i]),
                                ),
                              ),
                            ),
                          ),
                          childCount: phaseList.length,
                        ),
                      ),
                    );
                  },
                  loading: () => const SliverFillRemaining(
                    child: Center(
                      child:
                          CircularProgressIndicator(color: AppColors.saffron),
                    ),
                  ),
                  error: (e, _) => SliverFillRemaining(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(32),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.wifi_off,
                                color: AppColors.sandalwood, size: 48),
                            const SizedBox(height: 16),
                            Text(
                              'Could not load chapters\nEnsure backend is running on localhost:8000',
                              style: GoogleFonts.inter(
                                  color: AppColors.sandalwood, fontSize: 14),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
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

class _KandaCard extends StatelessWidget {
  const _KandaCard(
      {required this.kanda,
      required this.episodeCount,
      required this.onTap});
  final String kanda;
  final int episodeCount;
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
          border:
              Border.all(color: AppColors.sandalwood.withValues(alpha: 0.3)),
          boxShadow: [
            BoxShadow(
              color: AppColors.sandalwood.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.saffron.withValues(alpha: 0.1),
                border: Border.all(
                    color: AppColors.saffron.withValues(alpha: 0.4)),
              ),
              child: const Icon(Icons.auto_stories_outlined,
                  color: AppColors.saffron, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    kanda,
                    style: GoogleFonts.cinzel(
                      fontSize: 15,
                      color: AppColors.templeRed,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '$episodeCount episodes',
                    style: GoogleFonts.inter(
                        fontSize: 12, color: AppColors.sandalwood),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColors.sandalwood),
          ],
        ),
      ),
    );
  }
}
