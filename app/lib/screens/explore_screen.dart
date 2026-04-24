import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/providers.dart';
import '../models/question.dart';
import '../theme/app_theme.dart';
import 'quiz_screen.dart';

class ExploreScreen extends ConsumerStatefulWidget {
  const ExploreScreen({super.key});

  @override
  ConsumerState<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends ConsumerState<ExploreScreen> {
  String? _selectedPhase;
  String? _selectedDifficulty;

  @override
  Widget build(BuildContext context) {
    final questionsAsync = ref.watch(allQuestionsProvider);

    return Scaffold(
      backgroundColor: AppColors.parchment,
      appBar: AppBar(title: const Text('Explore')),
      body: Column(
        children: [
          _FilterBar(
            selectedPhase: _selectedPhase,
            selectedDifficulty: _selectedDifficulty,
            onPhaseChanged: (p) => setState(() => _selectedPhase = p),
            onDifficultyChanged: (d) => setState(() => _selectedDifficulty = d),
          ),
          Expanded(
            child: questionsAsync.when(
              loading: () => const Center(
                child: CircularProgressIndicator(color: AppColors.saffron),
              ),
              error: (e, _) => _ErrorState(message: e.toString()),
              data: (questions) {
                final filtered = questions.where((q) {
                  if (_selectedPhase != null && q.storyPhase != _selectedPhase) return false;
                  if (_selectedDifficulty != null && q.difficulty != _selectedDifficulty) return false;
                  return true;
                }).toList();

                if (filtered.isEmpty) {
                  return const Center(
                    child: Text('No questions match filters'),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: filtered.length,
                  itemBuilder: (context, i) => _QuestionCard(question: filtered[i]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterBar extends StatelessWidget {
  const _FilterBar({
    required this.selectedPhase,
    required this.selectedDifficulty,
    required this.onPhaseChanged,
    required this.onDifficultyChanged,
  });

  final String? selectedPhase;
  final String? selectedDifficulty;
  final void Function(String?) onPhaseChanged;
  final void Function(String?) onDifficultyChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      decoration: BoxDecoration(
        color: AppColors.parchment,
        border: Border(bottom: BorderSide(color: AppColors.sandalwood.withValues(alpha: 0.3))),
      ),
      child: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _FilterChip(
                  label: 'All phases',
                  selected: selectedPhase == null,
                  onTap: () => onPhaseChanged(null),
                ),
                ...storyPhases.where((p) => p != 'Other').map(
                      (p) => _FilterChip(
                        label: p,
                        selected: selectedPhase == p,
                        onTap: () => onPhaseChanged(selectedPhase == p ? null : p),
                      ),
                    ),
              ],
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: ['easy', 'medium', 'hard'].map((d) {
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: _FilterChip(
                  label: d,
                  selected: selectedDifficulty == d,
                  onTap: () => onDifficultyChanged(selectedDifficulty == d ? null : d),
                  color: switch (d) {
                    'easy' => Colors.green,
                    'medium' => AppColors.saffron,
                    _ => AppColors.templeRed,
                  },
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
    this.color,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final c = color ?? AppColors.saffron;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? c.withValues(alpha: 0.15) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: selected ? c : AppColors.sandalwood.withValues(alpha: 0.5)),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? c : AppColors.sandalwood,
            fontSize: 12,
            fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}

class _QuestionCard extends StatefulWidget {
  const _QuestionCard({required this.question});
  final Question question;

  @override
  State<_QuestionCard> createState() => _QuestionCardState();
}

class _QuestionCardState extends State<_QuestionCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final q = widget.question;
    final diffColor = switch (q.difficulty) {
      'easy' => Colors.green,
      'medium' => AppColors.saffron,
      _ => AppColors.templeRed,
    };

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.sandalwood.withValues(alpha: 0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () => setState(() => _expanded = !_expanded),
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: diffColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: diffColor.withValues(alpha: 0.4)),
                        ),
                        child: Text(
                          q.difficulty,
                          style: TextStyle(color: diffColor, fontSize: 10, fontWeight: FontWeight.w600),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          q.storyPhase,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: AppColors.sandalwood,
                              ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (q.isDailyInsight)
                        const Icon(Icons.star, color: AppColors.gold, size: 16),
                      Icon(
                        _expanded ? Icons.expand_less : Icons.expand_more,
                        color: AppColors.sandalwood,
                        size: 20,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    q.question,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.charcoal,
                          height: 1.4,
                        ),
                    maxLines: _expanded ? null : 2,
                    overflow: _expanded ? null : TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
          if (_expanded) ...[
            Divider(height: 1, color: AppColors.sandalwood.withValues(alpha: 0.2)),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ...q.options.entries.map(
                    (e) => Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 22,
                            height: 22,
                            margin: const EdgeInsets.only(right: 8, top: 1),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: e.key == q.correctAnswer
                                  ? AppColors.gold.withValues(alpha: 0.2)
                                  : Colors.transparent,
                              border: Border.all(
                                color: e.key == q.correctAnswer
                                    ? AppColors.gold
                                    : AppColors.sandalwood.withValues(alpha: 0.5),
                              ),
                            ),
                            child: Text(
                              e.key,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: e.key == q.correctAnswer ? AppColors.gold : AppColors.sandalwood,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              e.value,
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: e.key == q.correctAnswer
                                        ? AppColors.charcoal
                                        : AppColors.sandalwood,
                                    fontWeight: e.key == q.correctAnswer
                                        ? FontWeight.w600
                                        : FontWeight.normal,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.parchment,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      q.explanation,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.charcoal,
                            height: 1.5,
                          ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message});
  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.wifi_off, size: 48, color: AppColors.sandalwood),
            const SizedBox(height: 12),
            Text(
              'Could not load questions',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Backend must be running on localhost:8000',
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
