import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/providers.dart';
import '../theme/app_theme.dart';
import '../widgets/phase_map.dart';
import 'quiz_screen.dart';

class JourneyScreen extends ConsumerWidget {
  const JourneyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progressAsync = ref.watch(progressServiceProvider);
    final questionsAsync = ref.watch(allQuestionsProvider);

    return Scaffold(
      backgroundColor: AppColors.parchment,
      appBar: AppBar(
        title: const Text('Your Journey'),
      ),
      body: progressAsync.when(
        loading: () => const Center(child: CircularProgressIndicator(color: AppColors.saffron)),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (progress) => questionsAsync.when(
          loading: () => const Center(child: CircularProgressIndicator(color: AppColors.saffron)),
          error: (_, _e) => _buildMap(context, ref, progress.answeredIds, {}),
          data: (questions) {
            final byPhase = <String, List<int>>{};
            for (final q in questions) {
              byPhase.putIfAbsent(q.storyPhase, () => []).add(q.id);
            }
            return _buildMap(context, ref, progress.answeredIds, byPhase);
          },
        ),
      ),
    );
  }

  Widget _buildMap(
    BuildContext context,
    WidgetRef ref,
    Set<int> answeredIds,
    Map<String, List<int>> byPhase,
  ) {
    final total = answeredIds.length;
    final streak = ref.watch(progressServiceProvider).valueOrNull?.streakDays ?? 0;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _StatsRow(answeredTotal: total, streak: streak),
          const SizedBox(height: 28),
          Text(
            'Story Arc',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: AppColors.templeRed,
                ),
          ),
          const SizedBox(height: 20),
          PhaseMap(
            answeredIds: answeredIds,
            totalPerPhase: byPhase,
            onPhaseTap: (phase) => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => QuizScreen(storyPhase: phase),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatsRow extends StatelessWidget {
  const _StatsRow({required this.answeredTotal, required this.streak});
  final int answeredTotal;
  final int streak;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _StatCard(value: '$answeredTotal', label: 'Questions\nAnswered', icon: Icons.quiz)),
        const SizedBox(width: 12),
        Expanded(child: _StatCard(value: '$streak', label: 'Day\nStreak', icon: Icons.local_fire_department)),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.value, required this.label, required this.icon});
  final String value;
  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.sandalwood.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.saffron, size: 28),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: AppColors.templeRed,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.sandalwood,
                      height: 1.3,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
