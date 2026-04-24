import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'theme/app_theme.dart';
import 'providers/providers.dart';
import 'screens/home_screen.dart';
import 'screens/quiz_screen.dart';
import 'screens/journey_screen.dart';
import 'screens/explore_screen.dart';
import 'screens/onboarding_screen.dart';

void main() {
  runApp(const ProviderScope(child: ShrutiApp()));
}

class ShrutiApp extends StatelessWidget {
  const ShrutiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shruti',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      home: const AppEntry(),
    );
  }
}

class AppEntry extends ConsumerWidget {
  const AppEntry({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progressAsync = ref.watch(progressServiceProvider);

    return progressAsync.when(
      loading: () => const Scaffold(
        backgroundColor: AppColors.parchment,
        body: Center(child: CircularProgressIndicator(color: AppColors.saffron)),
      ),
      error: (_, __) => const MainShell(),
      data: (progress) {
        if (!progress.onboardingComplete) {
          return OnboardingScreen(
            onComplete: () => ref.refresh(progressServiceProvider),
          );
        }
        return const MainShell();
      },
    );
  }
}

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  static const _screens = [
    HomeScreen(),
    QuizScreen(),
    JourneyScreen(),
    ExploreScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.quiz_outlined),
            activeIcon: Icon(Icons.quiz),
            label: 'Quiz',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map_outlined),
            activeIcon: Icon(Icons.map),
            label: 'Journey',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.auto_stories_outlined),
            activeIcon: Icon(Icons.auto_stories),
            label: 'Explore',
          ),
        ],
      ),
    );
  }
}
