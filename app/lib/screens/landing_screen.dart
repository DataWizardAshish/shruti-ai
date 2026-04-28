import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'epic_selection_screen.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen>
    with TickerProviderStateMixin {
  late final AnimationController _enterCtrl;
  late final AnimationController _floatCtrl;

  late final Animation<double> _screenFade;
  late final Animation<double> _ornamentFade;
  late final Animation<double> _titleFade;
  late final Animation<Offset> _titleSlide;
  late final Animation<double> _sanskritFade;
  late final Animation<double> _taglineFade;
  late final Animation<double> _ctaFade;

  @override
  void initState() {
    super.initState();

    _enterCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    );
    _floatCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);

    _screenFade = CurvedAnimation(
      parent: _enterCtrl,
      curve: const Interval(0.0, 0.36, curve: Curves.easeOut),
    );
    _ornamentFade = CurvedAnimation(
      parent: _enterCtrl,
      curve: const Interval(0.36, 0.54, curve: Curves.easeOut),
    );
    _titleFade = CurvedAnimation(
      parent: _enterCtrl,
      curve: const Interval(0.45, 0.68, curve: Curves.easeOut),
    );
    _titleSlide = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _enterCtrl,
      curve: const Interval(0.45, 0.68, curve: Curves.easeOut),
    ));
    _sanskritFade = CurvedAnimation(
      parent: _enterCtrl,
      curve: const Interval(0.54, 0.72, curve: Curves.easeOut),
    );
    _taglineFade = CurvedAnimation(
      parent: _enterCtrl,
      curve: const Interval(0.63, 0.81, curve: Curves.easeOut),
    );
    _ctaFade = CurvedAnimation(
      parent: _enterCtrl,
      curve: const Interval(0.77, 1.0, curve: Curves.easeOut),
    );

    _floatCtrl.addListener(() => setState(() {}));
    _enterCtrl.forward();
  }

  @override
  void dispose() {
    _enterCtrl.dispose();
    _floatCtrl.dispose();
    super.dispose();
  }

  void _onBegin() {
    Navigator.of(context).push(PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 600),
      pageBuilder: (_, _, _) => const EpicSelectionScreen(),
      transitionsBuilder: (_, anim, _, child) =>
          FadeTransition(opacity: anim, child: child),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final floatOffset = _floatCtrl.value * 6.0;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFF1C1208),
        body: FadeTransition(
          opacity: _screenFade,
          child: Stack(
            children: [
              Positioned.fill(
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: RadialGradient(
                      center: Alignment.center,
                      radius: 0.6,
                      colors: [Color(0x148B4513), Colors.transparent],
                    ),
                  ),
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      FadeTransition(
                        opacity: _ornamentFade,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 40,
                              height: 0.5,
                              color: const Color(0xFFC9A84C)
                                  .withValues(alpha: 0.4),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              '✦',
                              style: TextStyle(
                                fontSize: 14,
                                color: const Color(0xFFC9A84C)
                                    .withValues(alpha: 0.6),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Container(
                              width: 40,
                              height: 0.5,
                              color: const Color(0xFFC9A84C)
                                  .withValues(alpha: 0.4),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      FadeTransition(
                        opacity: _titleFade,
                        child: SlideTransition(
                          position: _titleSlide,
                          child: Text(
                            'SHRUTI',
                            style: GoogleFonts.cinzel(
                              fontSize: 48,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFFF0E6D3),
                              letterSpacing: 12,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      FadeTransition(
                        opacity: _sanskritFade,
                        child: Text(
                          'श्रुति',
                          style: GoogleFonts.notoSerifDevanagari(
                            fontSize: 16,
                            color: const Color(0xFFC9A84C)
                                .withValues(alpha: 0.7),
                            letterSpacing: 4,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      FadeTransition(
                        opacity: _taglineFade,
                        child: Text(
                          'Step into the stories that shaped us',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.lato(
                            fontSize: 15,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.w300,
                            color: const Color(0xFFA09070),
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                      const SizedBox(height: 48),
                      FadeTransition(
                        opacity: _ctaFade,
                        child: GestureDetector(
                          onTap: _onBegin,
                          behavior: HitTestBehavior.opaque,
                          child: Column(
                            children: [
                              Text(
                                'BEGIN YOUR JOURNEY',
                                style: GoogleFonts.lato(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: const Color(0xFFE8821A),
                                  letterSpacing: 3,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Transform.translate(
                                offset: Offset(0, floatOffset),
                                child: Icon(
                                  Icons.expand_more,
                                  color: const Color(0xFFE8821A)
                                      .withValues(alpha: 0.6),
                                  size: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
