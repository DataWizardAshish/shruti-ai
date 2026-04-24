import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/providers.dart';
import '../theme/app_theme.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key, required this.onComplete});
  final VoidCallback onComplete;

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _controller = PageController();
  int _page = 0;

  static const _slides = [
    _Slide(
      title: 'SHRUTI',
      subtitle: 'From Questions to Wisdom',
      body:
          'The Ramayana is not just a story — it is a mirror. Every question here opens a doorway into the epic, inviting you to walk alongside Rama, Sita, and the great sages of ancient India.',
      icon: Icons.auto_stories,
    ),
    _Slide(
      title: 'How it works',
      subtitle: 'Learn through the story',
      body:
          'Follow the narrative arc from Rama\'s early life through exile, the search for Sita, the great Lanka war, and triumphant return. Answer questions, read immersive explanations, track your journey.',
      icon: Icons.map_outlined,
    ),
    _Slide(
      title: 'Begin your journey',
      subtitle: 'No account required',
      body:
          'Your progress is saved locally. No sign-up, no interruptions. Just you and the epic. Start with today\'s insight, or dive into any chapter.',
      icon: Icons.play_circle_outline,
    ),
  ];

  void _next() {
    if (_page < _slides.length - 1) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _finish();
    }
  }

  Future<void> _finish() async {
    final progress = await ref.read(progressServiceProvider.future);
    await progress.completeOnboarding();
    widget.onComplete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.parchment,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _controller,
                onPageChanged: (i) => setState(() => _page = i),
                itemCount: _slides.length,
                itemBuilder: (_, i) => _SlideView(slide: _slides[i]),
              ),
            ),
            _BottomNav(
              page: _page,
              total: _slides.length,
              onNext: _next,
              onSkip: _finish,
            ),
          ],
        ),
      ),
    );
  }
}

class _Slide {
  const _Slide({
    required this.title,
    required this.subtitle,
    required this.body,
    required this.icon,
  });
  final String title;
  final String subtitle;
  final String body;
  final IconData icon;
}

class _SlideView extends StatelessWidget {
  const _SlideView({required this.slide});
  final _Slide slide;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.saffron.withValues(alpha: 0.12),
              border: Border.all(color: AppColors.saffron.withValues(alpha: 0.4), width: 2),
            ),
            child: Icon(slide.icon, size: 56, color: AppColors.saffron),
          ),
          const SizedBox(height: 40),
          Text(
            slide.title,
            style: Theme.of(context).textTheme.displayMedium?.copyWith(
                  letterSpacing: 3,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            slide.subtitle,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.sandalwood,
                  fontStyle: FontStyle.italic,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 28),
          Text(
            slide.body,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.charcoal,
                  height: 1.6,
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _BottomNav extends StatelessWidget {
  const _BottomNav({
    required this.page,
    required this.total,
    required this.onNext,
    required this.onSkip,
  });

  final int page;
  final int total;
  final VoidCallback onNext;
  final VoidCallback onSkip;

  @override
  Widget build(BuildContext context) {
    final isLast = page == total - 1;

    return Padding(
      padding: const EdgeInsets.fromLTRB(32, 0, 32, 32),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              total,
              (i) => AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: i == page ? 24 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: i == page ? AppColors.saffron : AppColors.sandalwood.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onNext,
              child: Text(isLast ? 'Begin Journey' : 'Next'),
            ),
          ),
          if (!isLast) ...[
            const SizedBox(height: 12),
            TextButton(
              onPressed: onSkip,
              child: Text(
                'Skip',
                style: TextStyle(color: AppColors.sandalwood),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
