import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CategoryCard extends StatelessWidget {
  final String name;
  final String urduName;
  final String imageAsset;
  final VoidCallback onTap;
  final int index;

  const CategoryCard({
    super.key,
    required this.name,
    required this.urduName,
    required this.imageAsset,
    required this.onTap,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Hero(
        tag: 'category_$name',
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(28),
            child:               Stack(
              fit: StackFit.expand,
              children: [
                // Optimized image loading with aggressive caching
                Image.asset(
                  imageAsset,
                  fit: BoxFit.cover,
                  cacheWidth: 300, // Lower resolution for better performance
                  cacheHeight: 300,
                  filterQuality: FilterQuality.low,
                  color: Colors.black.withOpacity(0.2),
                  colorBlendMode: BlendMode.darken,
                  gaplessPlayback: true,
                  isAntiAlias: false, // Disable antialiasing for speed
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[800],
                      child: const Icon(Icons.image_not_supported, color: Colors.white54),
                    );
                  },
                ),
                // Content layer
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Center(
                          child: Text(
                            urduName,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.notoNastaliqUrdu(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.w700,
                              shadows: [
                                Shadow(
                                  color: Colors.black.withOpacity(0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Text(
                        name,
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}