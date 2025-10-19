import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CategoryCard extends StatefulWidget {
  final String name;
  final String urduName;
  final int index;
  final VoidCallback onTap;

  const CategoryCard({
    super.key,
    required this.name,
    required this.urduName,
    required this.index,
    required this.onTap,
  });

  @override
  State<CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends State<CategoryCard> with SingleTickerProviderStateMixin {
  bool _isPressed = false;
  late AnimationController _shimmerController;

  // Different gradient combinations for each card
  final List<List<Color>> gradientSets = [
    [Color(0xFF0B4D3B), Color(0xFF128C7E), Color(0xFF4DB6AC)], // Teal
    [Color(0xFF064039), Color(0xFF0B6B5E), Color(0xFF3D9B8F)], // Deep Teal
    [Color(0xFF0A3D35), Color(0xFF0F6456), Color(0xFF2D8B7E)], // Emerald
    [Color(0xFF083832), Color(0xFF0D5A4D), Color(0xFF3A9984)], // Sea Green
    [Color(0xFF0C4A3E), Color(0xFF117768), Color(0xFF42B5A1)], // Mint
    [Color(0xFF073D34), Color(0xFF0E655A), Color(0xFF368E7E)], // Forest
  ];

  @override
  void initState() {
    super.initState();
    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = gradientSets[widget.index % gradientSets.length];

    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedScale(
        scale: _isPressed ? 0.92 : 1.0,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: colors[1].withOpacity(0.4),
                blurRadius: 24,
                offset: const Offset(0, 12),
                spreadRadius: -4,
              ),
              BoxShadow(
                color: const Color(0xFF80CBC4).withOpacity(0.2),
                blurRadius: 32,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(28),
            child: Stack(
              children: [
                // Animated gradient background
                AnimatedBuilder(
                  animation: _shimmerController,
                  builder: (context, child) {
                    return Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: colors,
                          stops: [
                            0.0,
                            0.5 + (0.3 * _shimmerController.value),
                            1.0,
                          ],
                        ),
                      ),
                    );
                  },
                ),

                // Glass morphism overlay
                BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.white.withOpacity(0.12),
                          Colors.white.withOpacity(0.05),
                          Colors.transparent,
                        ],
                      ),
                      border: Border.all(
                        width: 2,
                        color: Colors.white.withOpacity(0.25),
                      ),
                      borderRadius: BorderRadius.circular(28),
                    ),
                  ),
                ),

                // Top shimmer light
                Positioned(
                  top: -80,
                  right: -80,
                  child: AnimatedBuilder(
                    animation: _shimmerController,
                    builder: (context, child) {
                      return Opacity(
                        opacity: 0.3 + (0.2 * _shimmerController.value),
                        child: Container(
                          width: 180,
                          height: 180,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: RadialGradient(
                              colors: [
                                Colors.white.withOpacity(0.3),
                                Colors.white.withOpacity(0.1),
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // Bottom accent glow
                Positioned(
                  bottom: -60,
                  left: -60,
                  child: Container(
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          const Color(0xFF80CBC4).withOpacity(0.25),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),

                // Content
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // REMOVED SizedBox(height: 30) to allow Expanded widget to better center content
                      const SizedBox(height: 20), // Kept original small gap for top padding

                      // Urdu text - Centered using Expanded
                      Expanded(
                        child: Center(
                          child: Text(
                            widget.urduName,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.notoNastaliqUrdu(
                              color: Colors.white,
                              fontSize: 30,
                              fontWeight: FontWeight.w700,
                              shadows: [
                                Shadow(
                                  color: Colors.black.withOpacity(0.4),
                                  blurRadius: 12,
                                  offset: const Offset(0, 3),
                                ),
                                Shadow(
                                  color: const Color(0xFF80CBC4).withOpacity(0.5),
                                  blurRadius: 20,
                                  offset: const Offset(0, 0),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      // English text
                      Text(
                        widget.name,
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ],
                  ),
                ),

                // Hover indicator
                if (_isPressed)
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(28),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}