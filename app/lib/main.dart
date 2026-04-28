import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'theme/app_theme.dart';
import 'screens/landing_screen.dart';

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
      home: const LandingScreen(),
    );
  }
}
