import 'package:flutter/material.dart';
import '../../../core/widgets/gradient_background.dart';
import '../../video/views/video_screen.dart';
import '../category_card.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  final categories = const [
    {'name': 'Toba', 'icon': '📿', 'color': Colors.amber},
    {'name': 'Depression', 'icon': '💙', 'color': Colors.indigo},
    {'name': 'Motivation', 'icon': '🔥', 'color': Colors.orange},
    {'name': 'Success', 'icon': '🏆', 'color': Colors.yellow},
    {'name': 'Peace', 'icon': '🧘', 'color': Colors.teal},
    {'name': 'Health', 'icon': '💪', 'color': Colors.green},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Khush Reho', style: Theme.of(context).textTheme.headlineLarge),
                  const SizedBox(height: 8),
                  Text(
                    'Apni zindagi ko acha banao',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
            ),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 20,
                  crossAxisSpacing: 15,
                  childAspectRatio: 1.0,
                ),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final category = categories[index];
                  return CategoryCard(
                    name: category['name'] as String,
                    icon: category['icon'] as String,
                    color: category['color'] as Color,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => VideosScreen(categoryName: category['name'] as String),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
