import 'package:flutter/material.dart';

class GradientBackground extends StatelessWidget {
  final Widget child;
  const GradientBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 🌿 Green → golden background
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF0F5132), // deep Islamic green
                Color(0xFFB6A14A), // soft golden
              ],
            ),
          ),
        ),

        // ✨ White light rays (edges)
        _edgeGlow(top: true),
        _edgeGlow(bottom: true),
        _edgeGlow(left: true),
        _edgeGlow(right: true),

        SafeArea(child: child),
      ],
    );
  }

  Widget _edgeGlow({
    bool top = false,
    bool bottom = false,
    bool left = false,
    bool right = false,
  }) {
    return Positioned(
      top: top ? 0 : null,
      bottom: bottom ? 0 : null,
      left: left ? 0 : null,
      right: right ? 0 : null,
      child: Container(
        width: (left || right) ? 100 : double.infinity,
        height: (top || bottom) ? 120 : double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: top
                ? Alignment.topCenter
                : bottom
                ? Alignment.bottomCenter
                : left
                ? Alignment.centerLeft
                : Alignment.centerRight,
            end: top
                ? Alignment.bottomCenter
                : bottom
                ? Alignment.topCenter
                : left
                ? Alignment.centerRight
                : Alignment.centerLeft,
            colors: [
              Colors.white.withOpacity(0.6),
              Colors.transparent,
            ],
          ),
        ),
      ),
    );
  }
}
