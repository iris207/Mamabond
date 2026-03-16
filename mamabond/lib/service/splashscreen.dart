// splashscreen.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mamabond/service/login.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  // ================================
  // TEXT FADE ANIMATION CONTROLLER
  // ================================
  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;

  // ================================
  // LOADING DOTS CONTROL
  // ================================
  int activeDot = 0;

  @override
  void initState() {
    super.initState();

    // -------------------------------
    // Fade-in animation
    // -------------------------------
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );

    _controller.forward();

    // -------------------------------
    // Loading dots loop
    // -------------------------------
    Future.doWhile(() async {
      await Future.delayed(const Duration(milliseconds: 400));
      if (!mounted) return false;
      setState(() {
        activeDot = (activeDot + 1) % 3;
      });
      return true;
    });

    // ================================
    // 👉 NAVIGATE TO LOGIN AFTER SPLASH
    // ================================
    Future.delayed(const Duration(seconds: 3), () {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // ================================
          // BACKGROUND IMAGE
          // ================================
          Image.asset(
            'assets/background.png',
            fit: BoxFit.cover,
          ),

          // ================================
          // SOFT OVERLAY FOR READABILITY
          // ================================
          Container(
            color: Colors.white.withOpacity(0.05),
          ),

          // ================================
          // MAIN CONTENT
          // ================================
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // LOGO
                Image.asset(
                  'assets/logo.png',
                  width: 200,
                ),

                const SizedBox(height: 40),

                // FADING TEXT
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Text(
                    '“Empowering Mothers,\nConnecting Communities”',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.lobsterTwo(
                      fontSize: 30,
                      fontWeight: FontWeight.w600,
                      height: 1.5,
                      color: const Color(0xFFE94E80),
                      shadows: const [
                        Shadow(
                          blurRadius: 2,
                          offset: Offset(0, 1),
                          color: Colors.black26,
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // LOADING DOTS
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(3, (index) {
                    return AnimatedOpacity(
                      duration: const Duration(milliseconds: 300),
                      opacity: activeDot == index ? 1.0 : 0.3,
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 6),
                        child: CircleAvatar(
                          radius: 4,
                          backgroundColor: Color(0xFFE94E80),
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
