import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';
import '../models/saved_question.dart';
import '../models/question.dart';
import '../theme/app_theme.dart';
import '../widgets/option_tile.dart';

class SavedQuestionDetailScreen extends StatefulWidget {
  const SavedQuestionDetailScreen({super.key, required this.savedQuestion});
  final SavedQuestion savedQuestion;

  @override
  State<SavedQuestionDetailScreen> createState() =>
      _SavedQuestionDetailScreenState();
}

class _SavedQuestionDetailScreenState
    extends State<SavedQuestionDetailScreen> {
  bool _deepContextExpanded = false;

  Question get q => widget.savedQuestion.question;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.parchment,
      appBar: AppBar(
        title: Text(q.storyPhase),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined),
            onPressed: _share,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (q.sceneSetup != null && q.sceneSetup!.isNotEmpty) ...[
              Text(
                q.sceneSetup!,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: AppColors.sandalwood,
                  fontStyle: FontStyle.italic,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 24),
            ],
            Text(
              q.question,
              style: GoogleFonts.cinzel(
                fontSize: 18,
                color: AppColors.charcoal,
                height: 1.4,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 20),
            ...q.options.entries.map((e) {
              final state = e.key == q.correctAnswer
                  ? OptionState.correct
                  : OptionState.idle;
              return OptionTile(
                label: e.key,
                text: e.value,
                state: state,
                onTap: null,
              );
            }),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.parchment,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color: AppColors.gold.withValues(alpha: 0.5), width: 1.5),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.auto_awesome,
                          color: AppColors.gold, size: 16),
                      const SizedBox(width: 8),
                      Text(
                        'Wisdom',
                        style: GoogleFonts.inter(
                            color: AppColors.gold,
                            fontWeight: FontWeight.w600,
                            fontSize: 13),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    q.narrativeContinuation?.isNotEmpty == true
                        ? q.narrativeContinuation!
                        : q.explanation,
                    style: GoogleFonts.notoSerif(
                      fontSize: 15,
                      color: AppColors.charcoal,
                      height: 1.6,
                    ),
                  ),
                  if (q.deepContext != null &&
                      q.deepContext!.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    GestureDetector(
                      onTap: () => setState(
                          () => _deepContextExpanded = !_deepContextExpanded),
                      child: Text(
                        _deepContextExpanded
                            ? 'Know less ↑'
                            : 'Know more ↓',
                        style: GoogleFonts.inter(
                          color: AppColors.saffron,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    AnimatedSize(
                      duration: const Duration(milliseconds: 350),
                      curve: Curves.easeInOut,
                      child: _deepContextExpanded
                          ? Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(
                                q.deepContext!,
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  color: AppColors.charcoal,
                                  height: 1.5,
                                ),
                              ),
                            )
                          : const SizedBox.shrink(),
                    ),
                  ],
                ],
              ),
            ),
            if (q.forwardHook != null && q.forwardHook!.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text(
                q.forwardHook!,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: AppColors.sandalwood,
                  fontStyle: FontStyle.italic,
                  height: 1.5,
                ),
              ),
            ],
            const SizedBox(height: 48),
          ],
        ),
      ),
    );
  }

  void _share() {
    final text =
        '${q.question}\n\n${q.narrativeContinuation?.isNotEmpty == true ? q.narrativeContinuation! : q.explanation}\n\n— From Ramayan: ${q.storyPhase}\n\nLearn with SHRUTI';
    Share.share(text);
  }
}
