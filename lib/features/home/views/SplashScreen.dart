import 'dart:ui';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _scaleController;
  late AnimationController _shimmerController;
  late AnimationController _particleController;

  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  final Random _random = Random();
  late final List<_Particle> _particles = List.generate(
    30,
        (index) => _Particle(
      left: _random.nextDouble(),
      top: _random.nextDouble(),
      radius: _random.nextDouble() * 3 + 1,
      speed: _random.nextDouble() * 0.3 + 0.2,
    ),
  );

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );

    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();

    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 15),
    )..repeat();

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _fadeController,
        curve: Curves.easeIn,
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _scaleController,
        curve: Curves.easeOutBack,
      ),
    );

    _startAnimations();
  }

  void _startAnimations() async {
    await Future.delayed(const Duration(milliseconds: 300));
    _fadeController.forward();
    _scaleController.forward();

    // Navigate to ONBOARDING screen after 3 seconds
    await Future.delayed(const Duration(seconds: 3));
    if (mounted) {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
          const OnboardingScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
          transitionDuration: const Duration(milliseconds: 800),
        ),
      );
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _scaleController.dispose();
    _shimmerController.dispose();
    _particleController.dispose();
    super.dispose();
  }

  List<Widget> _buildParticles(Size size) {
    return _particles.map((particle) {
      return AnimatedBuilder(
        animation: _particleController,
        builder: (_, __) {
          final progress = (_particleController.value + particle.speed) % 1.0;
          final yOffset = progress * size.height;

          return Positioned(
            top: yOffset,
            left: particle.left * size.width,
            child: Opacity(
              opacity: (1 - progress) * 0.6,
              child: Container(
                width: particle.radius,
                height: particle.radius,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      const Color(0xFF80CBC4).withOpacity(0.8),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF010C0A),
              Color(0xFF021C17),
              Color(0xFF042820),
              Color(0xFF064039),
              Color(0xFF0B4D3B),
              Color(0xFF128C7E),
            ],
            stops: [0.0, 0.2, 0.4, 0.6, 0.8, 1.0],
          ),
        ),
        child: Stack(
          children: [
            // Animated particles
            ..._buildParticles(size),

            // Central glow
            Positioned(
              top: size.height * 0.35,
              left: size.width * 0.1,
              child: AnimatedBuilder(
                animation: _shimmerController,
                builder: (context, child) {
                  final scale = 1.0 + (0.2 * _shimmerController.value);
                  return Transform.scale(
                    scale: scale,
                    child: Container(
                      width: 300,
                      height: 300,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            const Color(0xFF80CBC4).withOpacity(0.3),
                            const Color(0xFF4DB6AC).withOpacity(0.15),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            // Top glow
            Positioned(
              top: -100,
              right: -100,
              child: Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      const Color(0xFFFFD700).withOpacity(0.2),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),

            // Main content
            Center(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Mosque icon with glow
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              const Color(0xFF80CBC4).withOpacity(0.3),
                              Colors.transparent,
                            ],
                          ),
                        ),
                        child: AnimatedBuilder(
                          animation: _shimmerController,
                          builder: (context, child) {
                            return Container(
                              padding: const EdgeInsets.all(18),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: const Color(0xFF128C7E),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFF80CBC4).withOpacity(
                                      0.4 + (0.2 * _shimmerController.value),
                                    ),
                                    blurRadius: 30,
                                    spreadRadius: 5,
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.mosque_rounded,
                                size: 50,
                                color: Colors.white,
                              ),
                            );
                          },
                        ),
                      ),

                      const SizedBox(height: 32),

                      // App name with gradient
                      ShaderMask(
                        shaderCallback: (bounds) => const LinearGradient(
                          colors: [
                            Color(0xFFFFFFFF),
                            Color(0xFF80CBC4),
                            Color(0xFF4DB6AC),
                          ],
                        ).createShader(bounds),
                        child: Text(
                          'EmanBooster',
                          style: GoogleFonts.playfairDisplay(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),

                      // Urdu text
                      Text(
                        'ایمان بوسٹر',
                        style: GoogleFonts.notoNastaliqUrdu(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF80CBC4),
                          shadows: [
                            Shadow(
                              color: const Color(0xFF80CBC4).withOpacity(0.5),
                              blurRadius: 15,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Subtitle
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(25),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.2),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          'Strengthen Your Faith',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Colors.white.withOpacity(0.9),
                            letterSpacing: 1,
                          ),
                        ),
                      ),

                      const SizedBox(height: 50),

                      // Loading indicator
                      AnimatedBuilder(
                        animation: _shimmerController,
                        builder: (context, child) {
                          return Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: SweepGradient(
                                colors: [
                                  Colors.transparent,
                                  const Color(0xFF80CBC4).withOpacity(0.5),
                                  const Color(0xFF80CBC4),
                                ],
                                stops: const [0.0, 0.5, 1.0],
                                transform: GradientRotation(
                                  _shimmerController.value * 2 * pi,
                                ),
                              ),
                            ),
                            child: Container(
                              margin: const EdgeInsets.all(3),
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xFF042820),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Bottom decoration
            Positioned(
              bottom: 40,
              left: 0,
              right: 0,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Column(
                  children: [
                    Text(
                      'بِسْمِ اللَّهِ الرَّحْمَنِ الرَّحِيم',
                      style: GoogleFonts.notoNastaliqUrdu(
                        fontSize: 16,
                        color: Colors.white.withOpacity(0.6),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Version 1.0.0',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        color: Colors.white.withOpacity(0.4),
                        letterSpacing: 0.8,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Particle {
  final double left;
  final double top;
  final double radius;
  final double speed;

  const _Particle({
    required this.left,
    required this.top,
    required this.radius,
    required this.speed,
  });
}