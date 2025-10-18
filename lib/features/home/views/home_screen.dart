import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/widgets/gradient_background.dart';
import '../../video/views/video_screen.dart';
import '../category_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late AnimationController _animationController;

  final List<Map<String, String>> categories = const [
    {'name': 'Patience', 'urdu_name': 'صبر'},
    {'name': 'Gratitude', 'urdu_name': 'شُکر'},
    {'name': 'Repentance', 'urdu_name': 'توبہ'},
    {'name': 'Hope', 'urdu_name': 'اُمید'},
    {'name': 'Purpose', 'urdu_name': 'مقصد'},
    {'name': 'Inner Peace', 'urdu_name': 'سکون'},
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // ===== ADJUSTED HEADER =====
            SliverAppBar(
              // Reduced height for a more compact header
              expandedHeight: 190,
              pinned: true,
              elevation: 0,
              backgroundColor: Colors.transparent,
              flexibleSpace: FlexibleSpaceBar(
                background: Padding(
                  // Adjusted vertical padding
                  padding:
                  const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.mosque_rounded,
                              color: Color(0xFF80CBC4), size: 28),
                          const SizedBox(width: 10),
                          Text(
                            'السلام عليكم',
                            style: GoogleFonts.notoNastaliqUrdu(
                              color: const Color(0xFF80CBC4),
                              // Smaller font size
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      // Reduced margin
                      const SizedBox(height: 16),
                      Text(
                        'EmanBooster',
                        style: GoogleFonts.playfairDisplay(
                          color: Colors.white,
                          // Smaller font size
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      // Reduced margin
                      const SizedBox(height: 6),
                      Text(
                        'Grow your Iman through reflection and peace.',
                        style: GoogleFonts.inter(
                          color: Colors.white70,
                          // Smaller font size
                          fontSize: 14,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // ===== CATEGORIES (Refined Grid Layout) =====
            SliverPadding(
              padding:
              const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 14,
                  crossAxisSpacing: 14,
                  // Adjusted to 0.95 (taller, thinner cards)
                  childAspectRatio: 0.95,
                ),
                delegate: SliverChildBuilderDelegate(
                      (context, index) {
                    final category = categories[index];
                    final delay = 0.1 * index;
                    final animation = CurvedAnimation(
                      parent: _animationController,
                      curve: Interval(delay, delay + 0.5,
                          curve: Curves.easeOut),
                    );

                    return AnimatedBuilder(
                      animation: animation,
                      builder: (context, child) {
                        return Transform.translate(
                          offset: Offset(0, 30 * (1 - animation.value)),
                          child:
                          Opacity(opacity: animation.value, child: child),
                        );
                      },
                      child: CategoryCard(
                        name: category['name']!,
                        urduName: category['urdu_name']!,
                        onTap: () {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              transitionDuration:
                              const Duration(milliseconds: 400),
                              pageBuilder: (context, anim, _) =>
                                  FadeTransition(
                                    opacity: anim,
                                    child: VideosScreen(
                                        categoryName: category['name']!),
                                  ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                  childCount: categories.length,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}