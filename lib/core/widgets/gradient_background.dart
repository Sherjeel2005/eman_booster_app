import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';

class GradientBackground extends StatefulWidget {
  final Widget child;
  const GradientBackground({super.key, required this.child});

  @override
  State<GradientBackground> createState() => _GradientBackgroundState();
}

class _GradientBackgroundState extends State<GradientBackground>
    with TickerProviderStateMixin {
  late final AnimationController _starController;
  late final AnimationController _auraController;
  late final AnimationController _particleController;
  final Random _random = Random();

  late final List<_Star> _stars = List.generate(
    80,
        (index) => _Star(
      left: _random.nextDouble(),
      top: _random.nextDouble(),
      radius: _random.nextDouble() * 2.5 + 1.0,
      opacity: _random.nextDouble() * 0.5 + 0.3,
      speed: _random.nextDouble() * 0.5 + 0.5,
    ),
  );

  late final List<_Particle> _particles = List.generate(
    15,
        (index) => _Particle(
      left: _random.nextDouble(),
      top: _random.nextDouble(),
      radius: _random.nextDouble() * 4 + 2,
      speed: _random.nextDouble() * 0.3 + 0.2,
    ),
  );

  @override
  void initState() {
    super.initState();
    _starController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat(reverse: true);

    _auraController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat(reverse: true);

    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();
  }

  @override
  void dispose() {
    _starController.dispose();
    _auraController.dispose();
    _particleController.dispose();
    super.dispose();
  }

  List<Widget> _buildStars(Size size) {
    return _stars.asMap().entries.map((entry) {
      final index = entry.key;
      final star = entry.value;

      return AnimatedBuilder(
        animation: _starController,
        builder: (_, __) {
          final double flickerValue = 0.5 + 0.5 * sin(_starController.value * 2 * pi * star.speed + index);
          final double flicker = flickerValue.clamp(0.3, 1.0);
          return Positioned(
            top: star.top * size.height,
            left: star.left * size.width,
            child: Container(
              width: star.radius,
              height: star.radius,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(star.opacity * flicker),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF80CBC4).withOpacity(0.6 * flicker),
                    blurRadius: 8,
                    spreadRadius: 1.5,
                  ),
                ],
              ),
            ),
          );
        },
      );
    }).toList();
  }

  List<Widget> _buildParticles(Size size) {
    return _particles.asMap().entries.map((entry) {
      final particle = entry.value;

      return AnimatedBuilder(
        animation: _particleController,
        builder: (_, __) {
          final progress = (_particleController.value + particle.speed) % 1.0;
          final yOffset = progress * size.height;

          return Positioned(
            top: yOffset,
            left: particle.left * size.width,
            child: Opacity(
              opacity: (1 - progress) * 0.4,
              child: Container(
                width: particle.radius,
                height: particle.radius,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      const Color(0xFF80CBC4).withOpacity(0.6),
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
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = Size(
          constraints.maxWidth.isFinite ? constraints.maxWidth : 0,
          constraints.maxHeight.isFinite ? constraints.maxHeight : 0,
        );

        return Container(
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
                Color(0xFF4DB6AC),
              ],
              stops: [0.0, 0.15, 0.3, 0.5, 0.65, 0.8, 1.0],
            ),
          ),
          child: Stack(
            children: [
              // Mesh gradient overlay
              ClipRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: RadialGradient(
                        center: Alignment.topRight,
                        radius: 1.5,
                        colors: [
                          Colors.white.withOpacity(0.05),
                          Colors.transparent,
                          Colors.black.withOpacity(0.05),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // Stars
              ..._buildStars(size),

              // Floating particles
              ..._buildParticles(size),

              // Animated central aura
              AnimatedBuilder(
                animation: _auraController,
                builder: (context, child) {
                  final scale = 1.0 + (0.15 * _auraController.value);
                  return Positioned(
                    top: size.height * 0.3,
                    left: size.width * 0.15,
                    child: Transform.scale(
                      scale: scale,
                      child: ClipOval(
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
                          child: Container(
                            width: 400,
                            height: 400,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: RadialGradient(
                                colors: [
                                  const Color(0xFF80CBC4).withOpacity(0.35),
                                  const Color(0xFF4DB6AC).withOpacity(0.2),
                                  const Color(0xFF26A69A).withOpacity(0.1),
                                  Colors.transparent,
                                ],
                                stops: const [0.0, 0.4, 0.7, 1.0],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),

              // Top-right golden accent
              Positioned(
                top: -100,
                right: -100,
                child: ClipOval(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
                    child: Container(
                      width: 320,
                      height: 320,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            const Color(0xFFFFD700).withOpacity(0.25),
                            const Color(0xFFD4AF37).withOpacity(0.15),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // Bottom emerald glow
              Positioned(
                bottom: -120,
                left: -120,
                child: ClipOval(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 45, sigmaY: 45),
                    child: Container(
                      width: 450,
                      height: 450,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            const Color(0xFF00BFA6).withOpacity(0.3),
                            const Color(0xFF128C7E).withOpacity(0.15),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // Right side accent
              Positioned(
                top: size.height * 0.6,
                right: -80,
                child: ClipOval(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 35, sigmaY: 35),
                    child: Container(
                      width: 250,
                      height: 250,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            const Color(0xFF4DB6AC).withOpacity(0.25),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // Top atmospheric glow
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: 250,
                child: IgnorePointer(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.white.withOpacity(0.12),
                          Colors.white.withOpacity(0.06),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // Bottom vignette
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                height: 200,
                child: IgnorePointer(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Colors.black.withOpacity(0.2),
                          Colors.black.withOpacity(0.1),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // Glass overlay for depth
              Positioned.fill(
                child: IgnorePointer(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.white.withOpacity(0.03),
                          Colors.transparent,
                          Colors.white.withOpacity(0.02),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              widget.child,
            ],
          ),
        );
      },
    );
  }
}

class _Star {
  final double left;
  final double top;
  final double radius;
  final double opacity;
  final double speed;

  const _Star({
    required this.left,
    required this.top,
    required this.radius,
    required this.opacity,
    required this.speed,
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