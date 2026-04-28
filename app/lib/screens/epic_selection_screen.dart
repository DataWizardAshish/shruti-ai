import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../painters/wheel_painter.dart';
import 'main_shell.dart';
import 'mahabharata_coming_soon_screen.dart';
import 'onboarding_screen.dart';

class EpicSelectionScreen extends StatefulWidget {
  const EpicSelectionScreen({super.key});

  @override
  State<EpicSelectionScreen> createState() => _EpicSelectionScreenState();
}

class _EpicSelectionScreenState extends State<EpicSelectionScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _wheelCtrl;

  @override
  void initState() {
    super.initState();
    _wheelCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 60),
    )..repeat();
  }

  @override
  void dispose() {
    _wheelCtrl.dispose();
    super.dispose();
  }

  Future<void> _enterRamayana() async {
    final prefs = await SharedPreferences.getInstance();
    final onboardingComplete = prefs.getBool('onboarding_complete') ?? false;
    if (!mounted) return;
    Navigator.of(context).push(PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 500),
      pageBuilder: (_, _, _) =>
          onboardingComplete ? const MainShell() : _OnboardingBridge(),
      transitionsBuilder: (_, anim, _, child) => FadeTransition(
        opacity: anim,
        child: ScaleTransition(
          scale: Tween<double>(begin: 1.0, end: 1.04).animate(
            CurvedAnimation(parent: anim, curve: Curves.easeIn),
          ),
          child: child,
        ),
      ),
    ));
  }

  void _enterMahabharata() {
    Navigator.of(context).push(PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (_, _, _) => const MahabharataComingSoonScreen(),
      transitionsBuilder: (_, anim, _, child) =>
          FadeTransition(opacity: anim, child: child),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final topPad = MediaQuery.of(context).padding.top;
    final bottomPad = MediaQuery.of(context).padding.bottom;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFF0D0A06),
        body: Stack(
          children: [
            // Ramayana — left half background
            Positioned.fill(
              child: ClipPath(
                clipper: _LeftClipper(),
                child: Stack(
                  children: [
                    Container(color: const Color(0xFF1C0A04)),
                    Container(
                      decoration: const BoxDecoration(
                        gradient: RadialGradient(
                          center: Alignment(-0.4, 0.2),
                          radius: 0.9,
                          colors: [Color(0x506B2D0E), Colors.transparent],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Mahabharata — right half background
            Positioned.fill(
              child: ClipPath(
                clipper: _RightClipper(),
                child: Stack(
                  children: [
                    Container(color: const Color(0xFF070B14)),
                    Container(
                      decoration: const BoxDecoration(
                        gradient: RadialGradient(
                          center: Alignment(0.6, -0.3),
                          radius: 0.8,
                          colors: [Color(0x331A237E), Colors.transparent],
                        ),
                      ),
                    ),
                    Positioned(
                      right: size.width * 0.04,
                      bottom: 72,
                      child: RotationTransition(
                        turns: _wheelCtrl,
                        child: SizedBox(
                          width: 160,
                          height: 160,
                          child: CustomPaint(painter: WheelPainter()),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Tap targets — full half each
            Positioned.fill(
              child: ClipPath(
                clipper: _LeftClipper(),
                child: GestureDetector(
                  onTap: _enterRamayana,
                  behavior: HitTestBehavior.opaque,
                  child: const SizedBox.expand(),
                ),
              ),
            ),
            Positioned.fill(
              child: ClipPath(
                clipper: _RightClipper(),
                child: GestureDetector(
                  onTap: _enterMahabharata,
                  behavior: HitTestBehavior.opaque,
                  child: const SizedBox.expand(),
                ),
              ),
            ),
            // Diagonal divider + diamond
            Positioned.fill(
              child: IgnorePointer(
                child: CustomPaint(painter: _DividerPainter()),
              ),
            ),
            // Ramayana text block
            Positioned(
              left: 24,
              right: size.width * 0.53,
              top: size.height * 0.36,
              child: IgnorePointer(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Ramayana',
                      style: GoogleFonts.cinzel(
                        fontSize: 28,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFFF0E6D3),
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'रामायण',
                      style: GoogleFonts.notoSerifDevanagari(
                        fontSize: 14,
                        color: const Color(0xFFC9A84C).withValues(alpha: 0.8),
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      width: 28,
                      height: 0.5,
                      color: const Color(0xFFC9A84C).withValues(alpha: 0.4),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'The path of\ndharma and\ndevotion',
                      style: GoogleFonts.lato(
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w300,
                        color: const Color(0xFFA09070),
                        height: 1.6,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'ENTER →',
                      style: GoogleFonts.lato(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFFE8821A),
                        letterSpacing: 2,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Mahabharata text block
            Positioned(
              left: size.width * 0.54,
              right: 16,
              top: size.height * 0.36,
              child: IgnorePointer(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Mahabharata',
                      textAlign: TextAlign.right,
                      style: GoogleFonts.cinzel(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFFE8E0D0),
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'महाभारत',
                      style: GoogleFonts.notoSerifDevanagari(
                        fontSize: 13,
                        color: const Color(0xFFD4AF37).withValues(alpha: 0.8),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        width: 28,
                        height: 0.5,
                        color:
                            const Color(0xFFD4AF37).withValues(alpha: 0.4),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'The war of\ndharma and\nfate',
                      textAlign: TextAlign.right,
                      style: GoogleFonts.lato(
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w300,
                        color: const Color(0xFF9A8C7A),
                        height: 1.6,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'COMING SOON',
                      style: GoogleFonts.lato(
                        fontSize: 9,
                        color: const Color(0xFFD4AF37).withValues(alpha: 0.6),
                        letterSpacing: 2,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Header — spans both halves
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: IgnorePointer(
                child: Container(
                  padding: EdgeInsets.only(top: topPad + 12, bottom: 14),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        const Color(0xFF0D0A06).withValues(alpha: 0.7),
                        Colors.transparent,
                      ],
                    ),
                  ),
                  child: Text(
                    'Where does your journey begin?',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.lato(
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                      color: const Color(0xFFA09070).withValues(alpha: 0.8),
                    ),
                  ),
                ),
              ),
            ),
            // Bottom SHRUTI wordmark — spans both halves
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: IgnorePointer(
                child: Container(
                  padding:
                      EdgeInsets.only(bottom: bottomPad + 10, top: 8),
                  child: Text(
                    'SHRUTI',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.cinzel(
                      fontSize: 10,
                      color: const Color(0xFFA09070).withValues(alpha: 0.3),
                      letterSpacing: 8,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LeftClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final offset = size.height * 0.06;
    final topX = size.width / 2 + offset;
    final bottomX = size.width / 2 - offset;
    return Path()
      ..moveTo(0, 0)
      ..lineTo(topX, 0)
      ..lineTo(bottomX, size.height)
      ..lineTo(0, size.height)
      ..close();
  }

  @override
  bool shouldReclip(_LeftClipper _) => false;
}

class _RightClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final offset = size.height * 0.06;
    final topX = size.width / 2 + offset;
    final bottomX = size.width / 2 - offset;
    return Path()
      ..moveTo(topX, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width, size.height)
      ..lineTo(bottomX, size.height)
      ..close();
  }

  @override
  bool shouldReclip(_RightClipper _) => false;
}

class _DividerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final offset = size.height * 0.06;
    final topX = size.width / 2 + offset;
    final bottomX = size.width / 2 - offset;
    final midX = (topX + bottomX) / 2;
    final midY = size.height / 2;

    canvas.drawLine(
      Offset(topX, 0),
      Offset(bottomX, size.height),
      Paint()
        ..color = const Color(0xFFC9A84C).withValues(alpha: 0.25)
        ..strokeWidth = 0.8
        ..style = PaintingStyle.stroke,
    );

    canvas.drawPath(
      Path()
        ..moveTo(midX, midY - 5)
        ..lineTo(midX + 3, midY)
        ..lineTo(midX, midY + 5)
        ..lineTo(midX - 3, midY)
        ..close(),
      Paint()
        ..color = const Color(0xFFC9A84C).withValues(alpha: 0.45)
        ..style = PaintingStyle.fill,
    );
  }

  @override
  bool shouldRepaint(_DividerPainter _) => false;
}

class _OnboardingBridge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return OnboardingScreen(
      onComplete: () => Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const MainShell()),
      ),
    );
  }
}
