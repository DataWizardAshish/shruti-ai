import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/providers.dart';
import '../theme/app_theme.dart';
import '../models/question.dart';
import '../widgets/daily_insight_card.dart';
import 'quiz_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dailyInsight = ref.watch(dailyInsightProvider);

    return Scaffold(
      body: Stack(
        children: [
          _ParchmentBackground(),
          SafeArea(
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(child: _Header()),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    child: Text(
                      "Today's Quest",
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            color: AppColors.templeRed,
                          ),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: dailyInsight.when(
                      data: (q) => DailyInsightCard(question: q),
                      loading: () => _LoadingSkeleton(),
                      error: (e, _) => _ErrorCard(message: e.toString()),
                    ),
                  ),
                ),
                SliverToBoxAdapter(child: _PhaseQuickAccess()),
                const SliverToBoxAdapter(child: SizedBox(height: 32)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ParchmentBackground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: AppColors.parchment),
      child: Opacity(
        opacity: 0.07,
        child: Center(
          child: Text(
            'रामो विग्रहवान् धर्मः\nसाधुश्च सत्यसन्धश्च\nराजा सर्वस्य लोकस्य\nदेवानाम् इव वासवः',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 28,
              fontFamily: 'serif',
              color: AppColors.templeRed,
              height: 2.2,
              letterSpacing: 2,
            ),
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'SHRUTI',
            style: Theme.of(context).textTheme.displayMedium?.copyWith(
                  color: AppColors.templeRed,
                  letterSpacing: 4,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            'What do you seek today?',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.sandalwood,
                  fontStyle: FontStyle.italic,
                ),
          ),
        ],
      ),
    );
  }
}

class _PhaseQuickAccess extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Begin your journey',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppColors.templeRed,
                ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: storyPhases
                .where((p) => p != 'Other')
                .map((phase) => _PhaseChip(phase: phase))
                .toList(),
          ),
        ],
      ),
    );
  }
}

class _PhaseChip extends StatelessWidget {
  const _PhaseChip({required this.phase});
  final String phase;

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      label: Text(phase),
      labelStyle: TextStyle(
        color: AppColors.templeRed,
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
      backgroundColor: AppColors.parchment,
      side: const BorderSide(color: AppColors.sandalwood),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      onPressed: () => Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => QuizScreen(storyPhase: phase)),
      ),
    );
  }
}

class _LoadingSkeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 220,
      decoration: BoxDecoration(
        color: AppColors.sandalwood.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Center(
        child: CircularProgressIndicator(color: AppColors.saffron),
      ),
    );
  }
}

class _ErrorCard extends StatelessWidget {
  const _ErrorCard({required this.message});
  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.parchment,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.sandalwood),
      ),
      child: Column(
        children: [
          const Icon(Icons.wifi_off, color: AppColors.sandalwood, size: 40),
          const SizedBox(height: 12),
          Text(
            'Could not load today\'s insight',
            style: Theme.of(context).textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Make sure the backend is running on localhost:8000',
            style: Theme.of(context).textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
