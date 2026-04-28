import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/saved_questions_provider.dart';
import '../theme/app_theme.dart';

class RecentWisdomStrip extends ConsumerWidget {
  const RecentWisdomStrip({super.key, required this.onTap});
  final void Function(int index) onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(savedQuestionsProvider);
    final recent = state.items.take(3).toList();
    if (recent.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
          child: Text(
            'Return to your saved insights',
            style: GoogleFonts.cinzel(
              fontSize: 14,
              color: AppColors.templeRed,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        SizedBox(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: recent.length,
            itemBuilder: (context, i) {
              final saved = recent[i];
              return GestureDetector(
                onTap: () => onTap(i),
                child: Container(
                  width: 180,
                  margin: const EdgeInsets.only(right: 12),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: AppColors.gold.withValues(alpha: 0.4)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              saved.question.storyPhase,
                              style: GoogleFonts.inter(
                                fontSize: 10,
                                color: AppColors.sandalwood,
                                letterSpacing: 0.3,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const Icon(Icons.bookmark,
                              size: 14, color: AppColors.gold),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Expanded(
                        child: Text(
                          saved.question.question,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: AppColors.charcoal,
                            height: 1.4,
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
