import 'package:flutter/material.dart';
import '../models/question.dart';
import '../theme/app_theme.dart';

class PhaseMap extends StatelessWidget {
  const PhaseMap({
    super.key,
    required this.answeredIds,
    required this.totalPerPhase,
    required this.onPhaseTap,
  });

  final Set<int> answeredIds;
  final Map<String, List<int>> totalPerPhase;
  final void Function(String phase) onPhaseTap;

  static const _phaseIcons = [
    Icons.child_care,
    Icons.forest,
    Icons.favorite_border,
    Icons.search,
    Icons.local_fire_department,
    Icons.home,
  ];

  @override
  Widget build(BuildContext context) {
    final phases = storyPhases.where((p) => p != 'Other').toList();

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: phases.length,
      itemBuilder: (context, index) {
        final phase = phases[index];
        final ids = totalPerPhase[phase] ?? [];
        final answered = ids.where(answeredIds.contains).length;
        final total = ids.length;
        final progress = total > 0 ? answered / total : 0.0;
        final unlocked = index == 0 || _isUnlocked(phases, index);

        return _PhaseNode(
          phase: phase,
          icon: _phaseIcons[index],
          answered: answered,
          total: total,
          progress: progress,
          unlocked: unlocked,
          isLast: index == phases.length - 1,
          onTap: unlocked ? () => onPhaseTap(phase) : null,
        );
      },
    );
  }

  bool _isUnlocked(List<String> phases, int index) {
    if (index == 0) return true;
    final prev = phases[index - 1];
    final prevIds = totalPerPhase[prev] ?? [];
    if (prevIds.isEmpty) return true;
    final answered = prevIds.where(answeredIds.contains).length;
    return answered >= (prevIds.length * 0.5).ceil();
  }
}

class _PhaseNode extends StatelessWidget {
  const _PhaseNode({
    required this.phase,
    required this.icon,
    required this.answered,
    required this.total,
    required this.progress,
    required this.unlocked,
    required this.isLast,
    required this.onTap,
  });

  final String phase;
  final IconData icon;
  final int answered;
  final int total;
  final double progress;
  final bool unlocked;
  final bool isLast;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final color = unlocked ? AppColors.saffron : AppColors.sandalwood;
    final complete = progress >= 1.0;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 56,
            child: Column(
              children: [
                GestureDetector(
                  onTap: onTap,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: complete
                          ? AppColors.gold
                          : unlocked
                              ? AppColors.saffron.withValues(alpha: 0.15)
                              : AppColors.sandalwood.withValues(alpha: 0.1),
                      border: Border.all(
                        color: complete ? AppColors.gold : color,
                        width: 2,
                      ),
                    ),
                    child: Icon(
                      complete ? Icons.check : unlocked ? icon : Icons.lock_outline,
                      color: complete ? AppColors.white : color,
                      size: 22,
                    ),
                  ),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      color: unlocked
                          ? AppColors.saffron.withValues(alpha: 0.3)
                          : AppColors.sandalwood.withValues(alpha: 0.2),
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: onTap,
              child: Padding(
                padding: EdgeInsets.only(left: 12, bottom: isLast ? 0 : 24, top: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      phase,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: unlocked ? AppColors.charcoal : AppColors.sandalwood,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(height: 6),
                    if (total > 0) ...[
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: progress,
                          minHeight: 6,
                          backgroundColor: AppColors.sandalwood.withValues(alpha: 0.2),
                          valueColor: AlwaysStoppedAnimation(
                            complete ? AppColors.gold : AppColors.saffron,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '$answered / $total questions',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.sandalwood,
                            ),
                      ),
                    ] else
                      Text(
                        unlocked ? 'Tap to begin' : 'Complete previous phase to unlock',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.sandalwood,
                              fontStyle: FontStyle.italic,
                            ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
