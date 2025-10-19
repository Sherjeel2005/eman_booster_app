import 'package:flutter/material.dart';
import 'package:lit_starfield/lit_starfield.dart';

class GradientBackground extends StatelessWidget {
  final Widget child;
  const GradientBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Animated starfield background with gradient
        const LitStarfieldContainer(
          backgroundDecoration: BoxDecoration(
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
          velocity: 0.7,
          number: 1000,
          depth: 0.9,
          starColor: Colors.white,
          scale: 2,
        ),

        // Main content goes here
        child,
      ],
    );
  }
}
