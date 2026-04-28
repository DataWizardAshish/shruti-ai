import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/question.dart';
import '../providers/saved_questions_provider.dart';
import '../theme/app_theme.dart';

class SaveWisdomButton extends ConsumerWidget {
  const SaveWisdomButton({super.key, required this.question});
  final Question question;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(savedQuestionsProvider);
    final isSaved = state.isSaved(question.id);
    final isSaving = state.savingIds.contains(question.id);

    return GestureDetector(
      onTap: isSaving
          ? null
          : () {
              HapticFeedback.mediumImpact();
              if (isSaved) {
                ref
                    .read(savedQuestionsProvider.notifier)
                    .unsave(question.id);
              } else {
                ref.read(savedQuestionsProvider.notifier).save(question);
              }
            },
      child: SizedBox(
        width: 32,
        height: 32,
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: isSaving
              ? const SizedBox(
                  key: ValueKey('loading'),
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.gold,
                  ),
                )
              : Icon(
                  isSaved ? Icons.bookmark : Icons.bookmark_outline,
                  key: ValueKey(isSaved),
                  color: isSaved ? AppColors.gold : AppColors.sandalwood,
                  size: 22,
                ),
        ),
      ),
    );
  }
}
