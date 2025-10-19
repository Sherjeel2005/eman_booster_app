import 'dart:ui';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'home_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  late AnimationController _fadeController;
  late AnimationController _particleController;

  final Random _random = Random();
  late final List<_Particle> _particles = List.generate(
    20,
        (index) => _Particle(
      left: _random.nextDouble(),
      top: _random.nextDouble(),
      radius: _random.nextDouble() * 2 + 1,
      speed: _random.nextDouble() * 0.3 + 0.2,
    ),
  );

  final List<OnboardingData> _pages = [
    OnboardingData(
      title: 'Strengthen Your Faith',
      titleUrdu: 'اپنے ایمان کو مضبوط کریں',
      description:
      'Watch inspiring Islamic videos that help you grow spiritually and strengthen your connection with Allah.',
      descriptionUrdu: 'روحانی ترقی کے لیے متاثر کن اسلامی ویڈیوز دیکھیں',
      icon: Icons.auto_awesome,
      gradient: [
        Color(0xFF128C7E),
        Color(0xFF0B4D3B),
      ],
    ),
    OnboardingData(
      title: 'Reflect & Transform',
      titleUrdu: 'غور و فکر اور تبدیلی',
      description:
      'Explore categories like Patience, Gratitude, and Hope. Find peace through meaningful reflection.',
      descriptionUrdu: 'صبر، شکر اور امید کے موضوعات سے سیکھیں',
      icon: Icons.mosque_rounded,
      gradient: [
        Color(0xFF0B4D3B),
        Color(0xFF064039),
      ],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..forward();

    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 15),
    )..repeat();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _fadeController.dispose();
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
              opacity: (1 - progress) * 0.5,
              child: Container(
                width: particle.radius,
                height: particle.radius,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF80CBC4).withOpacity(0.6),
                ),
              ),
            ),
          );
        },
      );
    }).toList();
  }

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
          const HomeScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
          transitionDuration: const Duration(milliseconds: 600),
        ),
      );
    }
  }

  void _skip() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
        const HomeScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 600),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: _pages[_currentPage].gradient,
          ),
        ),
        child: Stack(
          children: [
            // Particles
            ..._buildParticles(size),

            // Background glow
            Positioned(
              top: size.height * 0.2,
              left: -100,
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      Colors.white.withOpacity(0.1),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),

            // Main content
            SafeArea(
              child: Column(
                children: [
                  // Skip button
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        if (_currentPage < _pages.length - 1)
                          GestureDetector(
                            onTap: _skip,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.3),
                                ),
                              ),
                              child: Text(
                                'Skip',
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),

                  // Page content
                  Expanded(
                    child: PageView.builder(
                      controller: _pageController,
                      onPageChanged: (index) {
                        setState(() {
                          _currentPage = index;
                        });
                        _fadeController.reset();
                        _fadeController.forward();
                      },
                      itemCount: _pages.length,
                      itemBuilder: (context, index) {
                        return FadeTransition(
                          opacity: _fadeController,
                          child: _buildPage(_pages[index]),
                        );
                      },
                    ),
                  ),

                  // Page indicators
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        _pages.length,
                            (index) => AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: _currentPage == index ? 32 : 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: _currentPage == index
                                ? Colors.white
                                : Colors.white.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Next/Get Started button
                  Padding(
                    padding: const EdgeInsets.fromLTRB(32, 0, 32, 40),
                    child: GestureDetector(
                      onTap: _nextPage,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.white.withOpacity(0.3),
                              Colors.white.withOpacity(0.2),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.5),
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.white.withOpacity(0.2),
                              blurRadius: 20,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Text(
                          _currentPage < _pages.length - 1
                              ? 'Next'
                              : 'Get Started',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPage(OnboardingData data) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon with glow - REDUCED SIZE
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  Colors.white.withOpacity(0.2),
                  Colors.transparent,
                ],
              ),
            ),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.15),
                border: Border.all(
                  color: Colors.white.withOpacity(0.3),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.white.withOpacity(0.2),
                    blurRadius: 20,
                    spreadRadius: 3,
                  ),
                ],
              ),
              child: Icon(
                data.icon,
                size: 44,
                color: Colors.white,
              ),
            ),
          ),

          const SizedBox(height: 36),

          // Urdu title - REDUCED SIZE
          Text(
            data.titleUrdu,
            textAlign: TextAlign.center,
            style: GoogleFonts.notoNastaliqUrdu(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              shadows: [
                Shadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 8,
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // English title - REDUCED SIZE
          Text(
            data.title,
            textAlign: TextAlign.center,
            style: GoogleFonts.playfairDisplay(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: [
                Shadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 8,
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Description with glass effect - REFINED
          ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.25),
                    width: 1.5,
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      data.description,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.95),
                        height: 1.6,
                        letterSpacing: 0.2,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      data.descriptionUrdu,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.notoNastaliqUrdu(
                        fontSize: 15,
                        color: const Color(0xFF80CBC4),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class OnboardingData {
  final String title;
  final String titleUrdu;
  final String description;
  final String descriptionUrdu;
  final IconData icon;
  final List<Color> gradient;

  OnboardingData({
    required this.title,
    required this.titleUrdu,
    required this.description,
    required this.descriptionUrdu,
    required this.icon,
    required this.gradient,
  });
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