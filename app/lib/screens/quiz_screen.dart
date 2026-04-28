import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/question.dart';
import '../models/episode.dart';
import '../providers/providers.dart';
import '../providers/episode_flow_provider.dart';
import '../providers/home_data_provider.dart';
import '../providers/journey_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/option_tile.dart';
import '../widgets/save_wisdom_button.dart';
import '../widgets/episode_opening_card.dart';
import '../widgets/episode_closing_card.dart';

class QuizScreen extends ConsumerStatefulWidget {
  const QuizScreen({super.key, this.storyPhase, this.episode});
  final String? storyPhase;
  final Episode? episode;

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
  bool _nextEnabled = false;
  bool _showForwardHook = false;

  @override
  void initState() {
    super.initState();
    if (widget.episode != null) {
      _listenToEpisodeFlow();
    } else {
      _loadQuestions();
    }
  }

  @override
  void dispose() {
    // Force home and journey to refetch so Continue Journey reflects latest progress
    ref.invalidate(homeDataProvider);
    ref.invalidate(journeyProvider);
    super.dispose();
  }

  void _listenToEpisodeFlow() {
    final flowState = ref.read(episodeFlowProvider);
    if (flowState.questions.isNotEmpty) {
      setState(() {
        _questions = flowState.questions;
        _currentIndex = flowState.currentIndex;
        _loading = false;
      });
    } else {
      _loadQuestions();
    }
  }

  Future<void> _loadQuestions() async {
    try {
      final api = ref.read(apiServiceProvider);
      final questions = widget.episode != null
          ? await api.getEpisodeQuestions(widget.episode!.id)
          : await api.getQuestions(storyPhase: widget.storyPhase, limit: 10);
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
    setState(() {
      _revealed = true;
      _nextEnabled = false;
      _showForwardHook = false;
    });
    final correct = _current.isCorrect(_selectedAnswer!);
    final localProgress = ref.read(progressServiceProvider).valueOrNull;
    localProgress?.recordAnswer(_current.id, correct: correct);
    _syncAnswerToBackend(_current.id, correct);
    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted) setState(() => _nextEnabled = true);
    });
  }

  Future<void> _syncAnswerToBackend(int questionId, bool correct) async {
    try {
      final deviceId = await ref.read(deviceIdProvider.future);
      await ref.read(apiServiceProvider).recordAnswer(deviceId, questionId, correct);
    } catch (_) {
      // fire-and-forget — local progress is source of truth for UX
    }
  }

  void _next() {
    if (!_nextEnabled) return;
    final hook = _current.forwardHook;
    if (hook != null && hook.isNotEmpty && !_showForwardHook) {
      setState(() => _showForwardHook = true);
      return;
    }
    _doAdvance();
  }

  void _doAdvance() {
    if (widget.episode != null) {
      ref.read(episodeFlowProvider.notifier).advance();
      final flowState = ref.read(episodeFlowProvider);
      if (!flowState.showClosing) {
        setState(() {
          _currentIndex = flowState.currentIndex;
          _selectedAnswer = null;
          _revealed = false;
          _showForwardHook = false;
          _nextEnabled = false;
        });
      }
      return;
    }
    if (_currentIndex < _questions.length - 1) {
      setState(() {
        _currentIndex++;
        _selectedAnswer = null;
        _revealed = false;
        _showForwardHook = false;
        _nextEnabled = false;
      });
    }
  }

  void _complete() {
    if (widget.storyPhase != null || widget.episode != null) {
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
    // Episode mode: delegate to flow provider for opening/closing cards
    if (widget.episode != null) {
      final flowState = ref.watch(episodeFlowProvider);

      if (!flowState.openingDismissed) {
        return EpisodeOpeningCard(
          episode: widget.episode!,
          onBegin: () =>
              ref.read(episodeFlowProvider.notifier).dismissOpening(),
        );
      }

      if (flowState.isLoading) {
        return const Scaffold(
          backgroundColor: AppColors.deepForest,
          body: Center(
              child: CircularProgressIndicator(color: AppColors.saffron)),
        );
      }

      if (flowState.showClosing) {
        return EpisodeClosingCard(
          episode: widget.episode!,
          onReturn: () {
            ref.read(episodeFlowProvider.notifier).exitEpisode();
            Navigator.of(context).pop();
          },
        );
      }

      if (_questions.isEmpty && flowState.questions.isNotEmpty) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            setState(() {
              _questions = flowState.questions;
              _currentIndex = flowState.currentIndex;
              _loading = false;
            });
          }
        });
      }
    }

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
                Text('Well done!',
                    style: Theme.of(context)
                        .textTheme
                        .displaySmall
                        ?.copyWith(color: AppColors.templeRed)),
                const SizedBox(height: 12),
                Text(
                  'You have completed this set of questions.',
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(color: AppColors.charcoal, height: 1.5),
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
        appBar: AppBar(title: Text(widget.storyPhase ?? 'Quiz')),
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
                Text(
                  _error ?? 'Ensure backend is running on localhost:8000',
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: AppColors.templeRed),
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
    final inEpisodeMode = widget.episode != null;

    return Scaffold(
      backgroundColor: AppColors.parchment,
      appBar: AppBar(
        title: Text(widget.storyPhase ?? (widget.episode?.name ?? 'Quiz')),
        actions: [
          if (!inEpisodeMode)
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Center(
                child: Text(
                  '${_currentIndex + 1} / ${_questions.length}',
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: AppColors.sandalwood),
                ),
              ),
            ),
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              if (!inEpisodeMode)
                LinearProgressIndicator(
                  value: (_currentIndex + 1) / _questions.length,
                  backgroundColor: AppColors.sandalwood.withValues(alpha: 0.2),
                  valueColor: const AlwaysStoppedAnimation(AppColors.saffron),
                  minHeight: 3,
                ),
              Expanded(
                child: GestureDetector(
                  onHorizontalDragEnd: (d) {
                    if (d.primaryVelocity != null &&
                        d.primaryVelocity! < -300 &&
                        _revealed) {
                      _next();
                    }
                  },
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (q.sceneSetup != null && q.sceneSetup!.isNotEmpty)
                          _SceneSetupBlock(
                            key: ValueKey('scene_${q.id}'),
                            text: q.sceneSetup!,
                          )
                        else
                          const SizedBox(height: 8),
                        Text(
                          q.question,
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(
                                  color: AppColors.charcoal, height: 1.4),
                        ),
                        const SizedBox(height: 24),
                        ...q.options.entries.map(
                          (e) => OptionTile(
                            label: e.key,
                            text: e.value,
                            state: _stateFor(e.key),
                            onTap: _revealed
                                ? null
                                : () => _selectAnswer(e.key),
                          ),
                        ),
                        if (_revealed) ...[
                          const SizedBox(height: 12),
                          _ResultBanner(
                            correct: _current.isCorrect(_selectedAnswer ?? ''),
                          ),
                          const SizedBox(height: 12),
                          _ExplanationCard(
                            key: ValueKey('explanation_${q.id}'),
                            correct: _current.isCorrect(_selectedAnswer ?? ''),
                            question: q,
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
                nextEnabled: _nextEnabled,
                onSubmit: _submit,
                onNext: _next,
                onComplete: _complete,
              ),
            ],
          ),
          if (_showForwardHook && _current.forwardHook != null)
            _ForwardHookOverlay(
              text: _current.forwardHook!,
              onDismiss: _doAdvance,
            ),
        ],
      ),
    );
  }
}

// ── Scene setup block with enter animation ──────────────────────────────────

class _SceneSetupBlock extends StatefulWidget {
  const _SceneSetupBlock({super.key, required this.text});
  final String text;

  @override
  State<_SceneSetupBlock> createState() => _SceneSetupBlockState();
}

class _SceneSetupBlockState extends State<_SceneSetupBlock>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _controller,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 24),
        child: Text(
          widget.text,
          textAlign: TextAlign.center,
          style: GoogleFonts.inter(
            fontSize: 14,
            color: AppColors.sandalwood,
            fontStyle: FontStyle.italic,
            height: 1.5,
          ),
        ),
      ),
    );
  }
}

// ── Result banner — shown immediately after submit ───────────────────────────

class _ResultBanner extends StatelessWidget {
  const _ResultBanner({required this.correct});
  final bool correct;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: correct
            ? AppColors.gold.withValues(alpha: 0.15)
            : AppColors.templeRed.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: correct
              ? AppColors.gold.withValues(alpha: 0.5)
              : AppColors.templeRed.withValues(alpha: 0.4),
        ),
      ),
      child: Row(
        children: [
          Icon(
            correct ? Icons.check_circle : Icons.cancel,
            color: correct ? AppColors.gold : AppColors.templeRed,
            size: 22,
          ),
          const SizedBox(width: 10),
          Text(
            correct ? 'Correct!' : 'Not quite right',
            style: TextStyle(
              color: correct ? AppColors.gold : AppColors.templeRed,
              fontWeight: FontWeight.w700,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Explanation card — fixed animation (was broken: opacity hardcoded to 1) ──

class _ExplanationCard extends StatefulWidget {
  const _ExplanationCard({
    super.key,
    required this.correct,
    required this.question,
  });
  final bool correct;
  final Question question;

  @override
  State<_ExplanationCard> createState() => _ExplanationCardState();
}

class _ExplanationCardState extends State<_ExplanationCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _opacity;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _opacity = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.15),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.correct ? AppColors.gold : AppColors.sandalwood;
    final explanation =
        widget.question.narrativeContinuation?.isNotEmpty == true
            ? widget.question.narrativeContinuation!
            : widget.question.explanation;

    return FadeTransition(
      opacity: _opacity,
      child: SlideTransition(
        position: _slide,
        child: Container(
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        widget.correct
                            ? Icons.auto_awesome
                            : Icons.info_outline,
                        color: color,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        widget.correct
                            ? 'Well remembered!'
                            : 'The truth revealed',
                        style: TextStyle(
                          color: color,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  SaveWisdomButton(question: widget.question),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                explanation,
                style: GoogleFonts.notoSerif(
                  fontSize: 15,
                  color: AppColors.charcoal,
                  height: 1.6,
                ),
              ),
              if (widget.question.deepContext?.isNotEmpty == true) ...[
                const SizedBox(height: 12),
                _KnowMoreSection(
                    deepContext: widget.question.deepContext!),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// ── "Know More" expandable ───────────────────────────────────────────────────

class _KnowMoreSection extends StatefulWidget {
  const _KnowMoreSection({required this.deepContext});
  final String deepContext;

  @override
  State<_KnowMoreSection> createState() => _KnowMoreSectionState();
}

class _KnowMoreSectionState extends State<_KnowMoreSection> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () => setState(() => _expanded = !_expanded),
          child: Text(
            _expanded ? 'Know less ↑' : 'Know more ↓',
            style: GoogleFonts.inter(
              color: AppColors.saffron,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        ClipRect(
          child: AnimatedSize(
            duration: const Duration(milliseconds: 350),
            curve: Curves.easeInOut,
            child: _expanded
                ? Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      widget.deepContext,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: AppColors.charcoal,
                        height: 1.5,
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ),
      ],
    );
  }
}

// ── Forward hook overlay ─────────────────────────────────────────────────────

class _ForwardHookOverlay extends StatefulWidget {
  const _ForwardHookOverlay({
    required this.text,
    required this.onDismiss,
  });
  final String text;
  final VoidCallback onDismiss;

  @override
  State<_ForwardHookOverlay> createState() => _ForwardHookOverlayState();
}

class _ForwardHookOverlayState extends State<_ForwardHookOverlay> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onDismiss,
      child: Container(
        color: AppColors.charcoal.withValues(alpha: 0.88),
        alignment: Alignment.center,
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.text,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 18,
                color: AppColors.parchment,
                fontStyle: FontStyle.italic,
                height: 1.7,
              ),
            ),
            const SizedBox(height: 32),
            Text(
              'Tap to continue →',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 13,
                color: AppColors.sandalwood,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Bottom action bar ────────────────────────────────────────────────────────

class _BottomBar extends StatelessWidget {
  const _BottomBar({
    required this.revealed,
    required this.selected,
    required this.isLast,
    required this.nextEnabled,
    required this.onSubmit,
    required this.onNext,
    required this.onComplete,
  });

  final bool revealed;
  final bool selected;
  final bool isLast;
  final bool nextEnabled;
  final VoidCallback onSubmit;
  final VoidCallback onNext;
  final VoidCallback onComplete;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      decoration: BoxDecoration(
        color: AppColors.parchment,
        border: Border(
            top: BorderSide(
                color: AppColors.sandalwood.withValues(alpha: 0.3))),
      ),
      child: SizedBox(
        width: double.infinity,
        child: revealed
            ? isLast
                ? ElevatedButton(
                    onPressed: nextEnabled ? onComplete : null,
                    style: ElevatedButton.styleFrom(
                      disabledBackgroundColor:
                          AppColors.sandalwood.withValues(alpha: 0.3),
                    ),
                    child: const Text('Complete'),
                  )
                : ElevatedButton(
                    onPressed: nextEnabled ? onNext : null,
                    style: ElevatedButton.styleFrom(
                      disabledBackgroundColor:
                          AppColors.sandalwood.withValues(alpha: 0.3),
                    ),
                    child: const Text('Next question →'),
                  )
            : ElevatedButton(
                onPressed: selected ? onSubmit : null,
                style: ElevatedButton.styleFrom(
                  disabledBackgroundColor:
                      AppColors.sandalwood.withValues(alpha: 0.3),
                ),
                child: const Text('Submit answer'),
              ),
      ),
    );
  }
}
