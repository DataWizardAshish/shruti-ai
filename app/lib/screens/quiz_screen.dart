import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/question.dart';
import '../providers/providers.dart';
import '../theme/app_theme.dart';
import '../widgets/option_tile.dart';

class QuizScreen extends ConsumerStatefulWidget {
  const QuizScreen({super.key, this.storyPhase});
  final String? storyPhase;

  @override
  ConsumerState<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends ConsumerState<QuizScreen> {
  List<Question> _questions = [];
  int _currentIndex = 0;
  String? _selectedAnswer;
  bool _revealed = false;
  bool _loading = true;
  String? _error;
  bool _completed = false;

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  Future<void> _loadQuestions() async {
    try {
      final api = ref.read(apiServiceProvider);
      final questions = await api.getQuestions(
        storyPhase: widget.storyPhase,
        limit: 10,
      );
      setState(() {
        _questions = questions;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  Question get _current => _questions[_currentIndex];

  void _selectAnswer(String answer) {
    if (_revealed) return;
    setState(() => _selectedAnswer = answer);
  }

  void _submit() {
    if (_selectedAnswer == null || _revealed) return;
    setState(() => _revealed = true);

    final correct = _current.isCorrect(_selectedAnswer!);
    final progress = ref.read(progressServiceProvider).valueOrNull;
    progress?.recordAnswer(_current.id, correct: correct);
  }

  void _next() {
    if (_currentIndex < _questions.length - 1) {
      setState(() {
        _currentIndex++;
        _selectedAnswer = null;
        _revealed = false;
      });
    }
  }

  void _complete() {
    if (widget.storyPhase != null) {
      Navigator.of(context).pop();
      return;
    }
    setState(() => _completed = true);
  }

  OptionState _stateFor(String key) {
    if (!_revealed) {
      return _selectedAnswer == key ? OptionState.selected : OptionState.idle;
    }
    if (key == _current.correctAnswer) return OptionState.correct;
    if (key == _selectedAnswer) return OptionState.wrong;
    return OptionState.idle;
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator(color: AppColors.saffron)),
      );
    }

    if (_completed) {
      return Scaffold(
        appBar: AppBar(title: Text(widget.storyPhase ?? 'Quiz')),
        backgroundColor: AppColors.parchment,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.auto_awesome, size: 64, color: AppColors.gold),
                const SizedBox(height: 20),
                Text(
                  'Well done!',
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        color: AppColors.templeRed,
                      ),
                ),
                const SizedBox(height: 12),
                Text(
                  widget.storyPhase != null
                      ? 'You have completed all questions in ${widget.storyPhase}.'
                      : 'You have completed this set of questions.',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppColors.charcoal,
                        height: 1.5,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: () => setState(() {
                    _completed = false;
                    _currentIndex = 0;
                    _selectedAnswer = null;
                    _revealed = false;
                    _loading = true;
                    _questions = [];
                    _error = null;
                    _loadQuestions();
                  }),
                  child: const Text('Play again'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    if (_error != null || _questions.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Quiz')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.wifi_off, size: 48, color: AppColors.sandalwood),
                const SizedBox(height: 16),
                Text(
                  _error != null ? 'Could not load questions' : 'No questions found',
                  style: Theme.of(context).textTheme.titleMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                if (_error != null)
                  Text(
                    _error!,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.templeRed,
                        ),
                    textAlign: TextAlign.center,
                  )
                else
                  Text(
                    'Ensure backend is running on localhost:8000',
                    style: Theme.of(context).textTheme.bodySmall,
                    textAlign: TextAlign.center,
                  ),
              ],
            ),
          ),
        ),
      );
    }

    final q = _current;
    final isLast = _currentIndex == _questions.length - 1;

    return Scaffold(
      backgroundColor: AppColors.parchment,
      appBar: AppBar(
        title: Text(
          widget.storyPhase ?? 'Quiz',
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Text(
                '${_currentIndex + 1} / ${_questions.length}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.sandalwood,
                    ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          LinearProgressIndicator(
            value: (_currentIndex + 1) / _questions.length,
            backgroundColor: AppColors.sandalwood.withValues(alpha: 0.2),
            valueColor: const AlwaysStoppedAnimation(AppColors.saffron),
            minHeight: 3,
          ),
          Expanded(
            child: GestureDetector(
              onHorizontalDragEnd: (d) {
                if (d.primaryVelocity != null && d.primaryVelocity! < -300 && _revealed) {
                  _next();
                }
              },
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (q.storyPhase.isNotEmpty)
                      Text(
                        q.storyPhase,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.sandalwood,
                              letterSpacing: 0.5,
                            ),
                      ),
                    const SizedBox(height: 8),
                    Text(
                      q.question,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: AppColors.charcoal,
                            height: 1.4,
                          ),
                    ),
                    const SizedBox(height: 24),
                    ...q.options.entries.map(
                      (e) => OptionTile(
                        label: e.key,
                        text: e.value,
                        state: _stateFor(e.key),
                        onTap: _revealed ? null : () => _selectAnswer(e.key),
                      ),
                    ),
                    if (_revealed) ...[
                      const SizedBox(height: 20),
                      _ExplanationCard(
                        correct: _current.isCorrect(_selectedAnswer ?? ''),
                        explanation: q.explanation,
                      ),
                    ],
                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ),
          ),
          _BottomBar(
            revealed: _revealed,
            selected: _selectedAnswer != null,
            isLast: isLast,
            onSubmit: _submit,
            onNext: _next,
            onComplete: _complete,
          ),
        ],
      ),
    );
  }
}

class _ExplanationCard extends StatelessWidget {
  const _ExplanationCard({required this.correct, required this.explanation});
  final bool correct;
  final String explanation;

  @override
  Widget build(BuildContext context) {
    final color = correct ? AppColors.gold : AppColors.sandalwood;
    return AnimatedOpacity(
      opacity: 1,
      duration: const Duration(milliseconds: 400),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.4)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  correct ? Icons.auto_awesome : Icons.info_outline,
                  color: color,
                  size: 18,
                ),
                const SizedBox(width: 8),
                Text(
                  correct ? 'Well remembered!' : 'The truth revealed',
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              explanation,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.charcoal,
                    height: 1.5,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BottomBar extends StatelessWidget {
  const _BottomBar({
    required this.revealed,
    required this.selected,
    required this.isLast,
    required this.onSubmit,
    required this.onNext,
    required this.onComplete,
  });

  final bool revealed;
  final bool selected;
  final bool isLast;
  final VoidCallback onSubmit;
  final VoidCallback onNext;
  final VoidCallback onComplete;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      decoration: BoxDecoration(
        color: AppColors.parchment,
        border: Border(top: BorderSide(color: AppColors.sandalwood.withValues(alpha: 0.3))),
      ),
      child: SizedBox(
        width: double.infinity,
        child: revealed
            ? isLast
                ? ElevatedButton(
                    onPressed: onComplete,
                    child: const Text('Complete'),
                  )
                : ElevatedButton(
                    onPressed: onNext,
                    child: const Text('Next question →'),
                  )
            : ElevatedButton(
                onPressed: selected ? onSubmit : null,
                style: ElevatedButton.styleFrom(
                  disabledBackgroundColor: AppColors.sandalwood.withValues(alpha: 0.3),
                ),
                child: const Text('Submit answer'),
              ),
      ),
    );
  }
}
