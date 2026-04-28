import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/episode.dart';
import '../theme/app_theme.dart';

class NarrativePathWidget extends StatefulWidget {
  const NarrativePathWidget({
    super.key,
    required this.episodes,
    required this.currentEpisodeSequence,
    required this.onEpisodeTap,
  });

  final List<Episode> episodes;
  final int currentEpisodeSequence;
  final void Function(Episode episode) onEpisodeTap;

  @override
  State<NarrativePathWidget> createState() => _NarrativePathWidgetState();
}

class _NarrativePathWidgetState extends State<NarrativePathWidget> {
  String? _expandedPhase;

  @override
  Widget build(BuildContext context) {
    if (widget.episodes.isEmpty) return const SizedBox.shrink();

    // Group by story phase (user-facing), preserve insertion order
    final grouped = <String, List<Episode>>{};
    final kandaForPhase = <String, String>{};

    for (final ep in widget.episodes) {
      final phase = ep.storyPhase.isNotEmpty ? ep.storyPhase : 'Other';
      grouped.putIfAbsent(phase, () => []).add(ep);
      kandaForPhase.putIfAbsent(phase, () => ep.kanda);
    }
    final phases = grouped.keys.toList();

    return Column(
      children: List.generate(phases.length, (i) {
        final phase = phases[i];
        final eps = grouped[phase]!;
        final isExpanded = _expandedPhase == phase;

        final minId = eps.map((e) => e.id).reduce((a, b) => a < b ? a : b);
        final maxId = eps.map((e) => e.id).reduce((a, b) => a > b ? a : b);
        final isComplete = maxId < widget.currentEpisodeSequence;
        final isCurrent = !isComplete &&
            minId <= widget.currentEpisodeSequence &&
            widget.currentEpisodeSequence <= maxId;

        final kandaLabel = kandaForPhase[phase] ?? '';

        return Column(
          children: [
            if (i > 0)
              Container(
                width: 2,
                height: 24,
                color: isComplete
                    ? AppColors.gold
                    : AppColors.sandalwood.withValues(alpha: 0.3),
              ),
            GestureDetector(
              onTap: () => setState(
                  () => _expandedPhase = isExpanded ? null : phase),
              child: Row(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isComplete
                          ? AppColors.gold
                          : isCurrent
                              ? AppColors.saffron.withValues(alpha: 0.15)
                              : AppColors.sandalwood.withValues(alpha: 0.08),
                      border: Border.all(
                        color: isComplete
                            ? AppColors.gold
                            : isCurrent
                                ? AppColors.saffron
                                : AppColors.sandalwood.withValues(alpha: 0.35),
                        width: 2,
                      ),
                    ),
                    child: Icon(
                      isComplete
                          ? Icons.check
                          : isCurrent
                              ? Icons.auto_stories_outlined
                              : Icons.circle_outlined,
                      color: isComplete
                          ? AppColors.white
                          : isCurrent
                              ? AppColors.saffron
                              : AppColors.sandalwood.withValues(alpha: 0.5),
                      size: isComplete ? 22 : isCurrent ? 22 : 16,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          phase,
                          style: GoogleFonts.cinzel(
                            fontSize: 14,
                            color: isComplete
                                ? AppColors.gold
                                : isCurrent
                                    ? AppColors.templeRed
                                    : AppColors.sandalwood,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Row(
                          children: [
                            if (kandaLabel.isNotEmpty) ...[
                              Text(
                                kandaLabel,
                                style: GoogleFonts.inter(
                                  fontSize: 11,
                                  color: AppColors.sandalwood
                                      .withValues(alpha: 0.7),
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                              Text(
                                '  ·  ',
                                style: GoogleFonts.inter(
                                    fontSize: 11,
                                    color: AppColors.sandalwood
                                        .withValues(alpha: 0.4)),
                              ),
                            ],
                            Text(
                              '${eps.length} episodes',
                              style: GoogleFonts.inter(
                                fontSize: 11,
                                color: AppColors.sandalwood,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: AppColors.sandalwood,
                    size: 20,
                  ),
                ],
              ),
            ),
            AnimatedSize(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: isExpanded
                  ? Padding(
                      padding: const EdgeInsets.only(left: 72, top: 8),
                      child: Column(
                        children: eps.map((ep) {
                          final epDone =
                              ep.id < widget.currentEpisodeSequence;
                          final epCurrent =
                              ep.id == widget.currentEpisodeSequence;
                          return GestureDetector(
                            onTap: () => widget.onEpisodeTap(ep),
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 8),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 10),
                              decoration: BoxDecoration(
                                color: epCurrent
                                    ? AppColors.saffron.withValues(alpha: 0.06)
                                    : AppColors.white,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: epCurrent
                                      ? AppColors.saffron
                                          .withValues(alpha: 0.4)
                                      : AppColors.sandalwood
                                          .withValues(alpha: 0.3),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          ep.name,
                                          style: GoogleFonts.inter(
                                            fontSize: 13,
                                            color: AppColors.charcoal,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        if (ep.subtitle.isNotEmpty)
                                          Text(
                                            ep.subtitle,
                                            style: GoogleFonts.inter(
                                              fontSize: 11,
                                              color: AppColors.sandalwood,
                                              fontStyle: FontStyle.italic,
                                            ),
                                          )
                                        else
                                          Text(
                                            '${ep.questionsCount} questions',
                                            style: GoogleFonts.inter(
                                              fontSize: 11,
                                              color: AppColors.sandalwood,
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                  Icon(
                                    epDone
                                        ? Icons.check_circle
                                        : epCurrent
                                            ? Icons.play_circle_filled
                                            : Icons.play_arrow_outlined,
                                    color: epDone
                                        ? AppColors.gold
                                        : epCurrent
                                            ? AppColors.saffron
                                            : AppColors.sandalwood
                                                .withValues(alpha: 0.5),
                                    size: 20,
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        );
      }),
    );
  }
}
