import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/saved_questions_provider.dart';
import '../theme/app_theme.dart';
import 'saved_question_detail_screen.dart';

class SavedWisdomScreen extends ConsumerStatefulWidget {
  const SavedWisdomScreen({super.key});

  @override
  ConsumerState<SavedWisdomScreen> createState() => _SavedWisdomScreenState();
}

class _SavedWisdomScreenState extends ConsumerState<SavedWisdomScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(savedQuestionsProvider.notifier).load();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(savedQuestionsProvider);

    return Scaffold(
      backgroundColor: AppColors.parchment,
      appBar: AppBar(
        title: const Text('Your Wisdom'),
      ),
      body: _buildBody(context, state),
    );
  }

  Widget _buildBody(BuildContext context, SavedQuestionsState state) {
    if (state.isLoading && state.items.isEmpty) {
      return const Center(
          child: CircularProgressIndicator(color: AppColors.saffron));
    }

    if (state.error != null && state.items.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.wifi_off, color: AppColors.sandalwood, size: 48),
              const SizedBox(height: 16),
              Text('Could not load saved wisdom',
                  style: Theme.of(context).textTheme.titleMedium,
                  textAlign: TextAlign.center),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () =>
                    ref.read(savedQuestionsProvider.notifier).load(),
                child: const Text('Try again'),
              ),
            ],
          ),
        ),
      );
    }

    if (state.items.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.bookmark_outline,
                  color: AppColors.sandalwood, size: 56),
              const SizedBox(height: 20),
              Text(
                'Wisdom you save will rest here.',
                style: GoogleFonts.cinzel(
                    fontSize: 16,
                    color: AppColors.templeRed,
                    fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                'Tap the bookmark on any explanation to begin.',
                style: GoogleFonts.inter(
                    fontSize: 14, color: AppColors.sandalwood, height: 1.5),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: state.items.length,
      itemBuilder: (context, i) {
        final saved = state.items[i];
        return Dismissible(
          key: ValueKey(saved.id),
          direction: DismissDirection.endToStart,
          background: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20),
            decoration: BoxDecoration(
              color: AppColors.templeRed.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.bookmark_remove,
                color: AppColors.templeRed),
          ),
          onDismissed: (_) => ref
              .read(savedQuestionsProvider.notifier)
              .unsave(saved.questionId),
          child: GestureDetector(
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (_) =>
                  SavedQuestionDetailScreen(savedQuestion: saved),
            )),
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color: AppColors.gold.withValues(alpha: 0.3)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          saved.question.storyPhase,
                          style: GoogleFonts.inter(
                              fontSize: 11,
                              color: AppColors.saffron,
                              letterSpacing: 0.4),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          saved.question.question,
                          style: GoogleFonts.inter(
                              fontSize: 14,
                              color: AppColors.charcoal,
                              height: 1.4),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.bookmark,
                      color: AppColors.gold, size: 18),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
