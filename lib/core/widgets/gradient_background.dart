import 'dart:math';
import 'package:flutter/material.dart';

class GradientBackground extends StatefulWidget {
  final Widget child;
  const GradientBackground({super.key, required this.child});

  @override
  State<GradientBackground> createState() => _GradientBackgroundState();
}

class _GradientBackgroundState extends State<GradientBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  final Random _random = Random();

  late final List<_Star> _stars = List.generate(
    45,
        (index) => _Star(
      left: _random.nextDouble(),
      top: _random.nextDouble(),
      radius: _random.nextDouble() * 3.5 + 1.5, // ⭐ Bigger star size
      opacity: _random.nextDouble() * 0.5 + 0.3,
    ),
  );

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List<Widget> _buildStars(Size size) {
    return _stars.asMap().entries.map((entry) {
      final index = entry.key;
      final star = entry.value;

      return AnimatedBuilder(
        animation: _controller,
        builder: (_, __) {
          final flicker =
          (0.5 + 0.5 * sin(_controller.value * 2 * pi + index)).clamp(0.3, 1.0);
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
                    color: Colors.white.withOpacity(0.7 * flicker),
                    blurRadius: 4,
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

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF031C17),
            Color(0xFF064039),
            Color(0xFF0B4D3B),
            Color(0xFF128C7E),
            Color(0xFFA8E6CF),
          ],
          stops: [0.0, 0.25, 0.5, 0.75, 1.0],
        ),
      ),
      child: Stack(
        children: [
          ..._buildStars(size),

          // 🌙 Central teal–gold aura
          Positioned(
            top: size.height * 0.28,
            left: size.width * 0.25,
            child: Container(
              width: 420,
              height: 420,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  radius: 0.8,
                  colors: [
                    const Color(0xFF80CBC4).withOpacity(0.25),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // ✨ Golden aura top-right
          Positioned(
            top: -120,
            right: -100,
            child: Container(
              width: 360,
              height: 360,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFFD4AF37).withOpacity(0.12),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // 🌊 Bottom left teal aura
          Positioned(
            bottom: -160,
            left: -140,
            child: Container(
              width: 460,
              height: 460,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFF00BFA6).withOpacity(0.15),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          _buildEdgeGlow(top: true),
          _buildEdgeGlow(bottom: true),

          widget.child,
        ],
      ),
    );
  }

  Widget _buildEdgeGlow({bool top = false, bool bottom = false}) {
    return Positioned(
      top: top ? 0 : null,
      bottom: bottom ? 0 : null,
      left: 0,
      right: 0,
      height: 140,
      child: IgnorePointer(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: top ? Alignment.topCenter : Alignment.bottomCenter,
              end: top ? Alignment.bottomCenter : Alignment.topCenter,
              colors: [
                Colors.white.withOpacity(0.06),
                Colors.transparent,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Star {
  final double left;
  final double top;
  final double radius;
  final double opacity;

  const _Star({
    required this.left,
    required this.top,
    required this.radius,
    required this.opacity,
  });
}
