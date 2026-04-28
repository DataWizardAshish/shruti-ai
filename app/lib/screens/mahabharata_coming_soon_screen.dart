import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class MahabharataComingSoonScreen extends StatefulWidget {
  const MahabharataComingSoonScreen({super.key});

  @override
  State<MahabharataComingSoonScreen> createState() =>
      _MahabharataComingSoonScreenState();
}

class _MahabharataComingSoonScreenState
    extends State<MahabharataComingSoonScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _dotsCtrl;

  @override
  void initState() {
    super.initState();
    _dotsCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    )..repeat();
    _dotsCtrl.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _dotsCtrl.dispose();
    super.dispose();
  }

  double _dotOpacity(double phase) {
    final v = (_dotsCtrl.value - phase + 1.0) % 1.0;
    if (v < 0.15) return 0.15 + (v / 0.15) * 0.85;
    if (v < 0.33) return 1.0;
    if (v < 0.48) return 0.15 + (1.0 - (v - 0.33) / 0.15) * 0.85;
    return 0.15;
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
        backgroundColor: const Color(0xFF0D0D1E),
        body: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: _buildHeader(context, size, topPad),
            ),
            SliverPadding(
              padding: EdgeInsets.fromLTRB(28, 36, 28, bottomPad + 48),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  _buildStanza(
                    'BEFORE THE WAR',
                    'A king named Bharat ruled this land\n'
                        'with such justice, such completeness,\n'
                        'that the land itself took his name.\n\n'
                        'Bharata-varsha.\n'
                        'This country is his.\n\n'
                        'From his lineage came two branches\n'
                        'of the Kuru family.\n'
                        'From that family came the war.',
                  ),
                  const SizedBox(height: 40),
                  _buildStanza(
                    'THE WAR',
                    'Eighteen days.\n'
                        'Two armies of the same blood.\n'
                        'A prince who could not raise his bow\n'
                        'against his own teachers, his own brothers.\n\n'
                        'And in that moment of paralysis —\n'
                        'God spoke.\n\n'
                        'The words became the Bhagavad Gita.\n'
                        'Eighteen chapters.\n'
                        'The song that outlasted the war,\n'
                        'outlasted the kingdom,\n'
                        'outlasted everything.',
                  ),
                  const SizedBox(height: 40),
                  _buildComingSoon(),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, Size size, double topPad) {
    return SizedBox(
      height: size.height * 0.40,
      child: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.center,
                  radius: 0.75,
                  colors: [Color(0xFF1A237E), Color(0xFF0D0D1E)],
                ),
              ),
            ),
          ),
          Positioned(
            top: topPad + 4,
            left: 4,
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              color: const Color(0xFFD4AF37).withValues(alpha: 0.8),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'महाभारत',
                  style: GoogleFonts.notoSerifDevanagari(
                    fontSize: 56,
                    color: const Color(0xFFD4AF37).withValues(alpha: 0.75),
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'MAHABHARATA',
                  style: GoogleFonts.cinzel(
                    fontSize: 13,
                    color: const Color(0xFFD4AF37).withValues(alpha: 0.60),
                    letterSpacing: 6,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStanza(String label, String body) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.lato(
            fontSize: 9,
            color: const Color(0xFF9A8C7A),
            letterSpacing: 4,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          body,
          style: GoogleFonts.lato(
            fontSize: 15,
            fontWeight: FontWeight.w300,
            color: const Color(0xFFE8E0D0),
            height: 1.8,
          ),
        ),
      ],
    );
  }

  Widget _buildComingSoon() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'COMING TO SHRUTI',
          style: GoogleFonts.lato(
            fontSize: 9,
            color: const Color(0xFF9A8C7A),
            letterSpacing: 4,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'We are building this world\n'
          'with the same care as the Ramayana.\n\n'
          'Every parva. Every vow. Every moment\n'
          'where dharma broke and had to be\n'
          'rebuilt from the ground up.\n\n'
          'It will be worth the wait.',
          style: GoogleFonts.lato(
            fontSize: 15,
            fontWeight: FontWeight.w300,
            color: const Color(0xFFE8E0D0),
            height: 1.8,
          ),
        ),
        const SizedBox(height: 28),
        Row(
          children: [
            _buildPulsingDot(0.0),
            const SizedBox(width: 8),
            _buildPulsingDot(0.333),
            const SizedBox(width: 8),
            _buildPulsingDot(0.667),
          ],
        ),
      ],
    );
  }

  Widget _buildPulsingDot(double phase) {
    return Opacity(
      opacity: _dotOpacity(phase),
      child: Container(
        width: 6,
        height: 6,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Color(0xFFD4AF37),
        ),
      ),
    );
  }
}
