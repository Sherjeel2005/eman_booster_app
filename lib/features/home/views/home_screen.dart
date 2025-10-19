import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/widgets/gradient_background.dart';
import '../../video/views/video_list.dart';
import '../../video/views/video_player_page.dart';
import '../category_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _floatingController;

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
      duration: const Duration(milliseconds: 1800),
    )..forward();

    _floatingController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    _floatingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // ===== PREMIUM HEADER =====
            SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.fromLTRB(24, 60, 24, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Greeting with glass card
                    AnimatedBuilder(
                      animation: _floatingController,
                      builder: (context, child) {
                        return Transform.translate(
                          offset: Offset(0, 5 * _floatingController.value),
                          child: child,
                        );
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.white.withOpacity(0.15),
                                  Colors.white.withOpacity(0.05),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.3),
                                width: 1.5,
                              ),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        const Color(0xFF80CBC4),
                                        const Color(0xFF4DB6AC),
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(15),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(0xFF80CBC4).withOpacity(0.5),
                                        blurRadius: 12,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: const Icon(
                                    Icons.mosque_rounded,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // Urdu Text (AOA) - **ADJUSTED** for alignment and style
                                      Directionality(
                                        textDirection: TextDirection.rtl,
                                        child: Text(
                                          'السلام عليكم',
                                          textAlign: TextAlign.right, // Ensures alignment
                                          style: GoogleFonts.notoNastaliqUrdu(
                                            color: Colors.white,
                                            fontSize: 24, // Slightly increased size
                                            fontWeight: FontWeight.w700, // Bolder
                                            shadows: [
                                              Shadow(
                                                color: Colors.black.withOpacity(0.5),
                                                blurRadius: 10,
                                                offset: const Offset(0, 3),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 4), // Increased spacing
                                      // English Text (Welcome back) - **ADJUSTED**
                                      Text(
                                        'Welcome back',
                                        style: GoogleFonts.poppins( // Changed font to Poppins
                                          color: Colors.white.withOpacity(0.9), // Slightly brighter
                                          fontSize: 14, // Increased size
                                          fontWeight: FontWeight.w500, // Slightly bolder
                                          letterSpacing: 0.5,
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
                    ),

                    const SizedBox(height: 32),

                    // Main Title
                    FadeTransition(
                      opacity: _animationController,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ShaderMask(
                            shaderCallback: (bounds) => const LinearGradient(
                              colors: [
                                Color(0xFFFFFFFF),
                                Color(0xFF80CBC4),
                              ],
                            ).createShader(bounds),
                            child: Text(
                              'EmanBooster',
                              style: GoogleFonts.playfairDisplay(
                                color: Colors.white,
                                fontSize: 42,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1,
                                height: 1.2,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.2),
                              ),
                            ),
                            child: Text(
                              'Grow your Iman through reflection and peace',
                              style: GoogleFonts.inter(
                                color: Colors.white.withOpacity(0.9),
                                fontSize: 13,
                                height: 1.5,
                                letterSpacing: 0.3,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ===== PREMIUM CATEGORIES =====
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 18,
                  crossAxisSpacing: 18,
                  childAspectRatio: 1.0,
                ),
                delegate: SliverChildBuilderDelegate(
                      (context, index) {
                    final category = categories[index];
                    final delay = 0.1 * index;
                    final animation = CurvedAnimation(
                      parent: _animationController,
                      curve: Interval(delay, delay + 0.6, curve: Curves.easeOutBack),
                    );

                    return AnimatedBuilder(
                      animation: animation,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: 0.7 + (0.3 * animation.value),
                          child: Opacity(
                            opacity: animation.value,
                            child: child,
                          ),
                        );
                      },
                      child: CategoryCard(
                        name: category['name']!,
                        urduName: category['urdu_name']!,
                        index: index,
                        onTap: () {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              transitionDuration: const Duration(milliseconds: 500),
                              pageBuilder: (context, anim, _) {
                                return FadeTransition(
                                  opacity: anim,
                                  child: ScaleTransition(
                                    scale: Tween<double>(begin: 0.9, end: 1.0).animate(
                                      CurvedAnimation(
                                        parent: anim,
                                        curve: Curves.easeOut,
                                      ),
                                    ),
                                    child: VideoListPage(category: category['name']!),
                                  ),
                                );
                              },
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