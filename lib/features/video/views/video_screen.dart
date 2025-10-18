import 'package:flutter/material.dart';
import '../../../core/widgets/gradient_background.dart';
import '../widgets/video_card.dart';

class VideosScreen extends StatelessWidget {
  final String categoryName;
  const VideosScreen({super.key, required this.categoryName});

  @override
  Widget build(BuildContext context) {
    final videos = [
      {
        'title': 'Beautiful Quran Recitation',
        'thumbnail': 'https://via.placeholder.com/300x400?text=Quran+Recitation',
      },
      {
        'title': 'Motivational Talk About Toba',
        'thumbnail': 'https://via.placeholder.com/300x400?text=Toba+Motivation',
      },
      {
        'title': 'Peace of Heart - Quran Message',
        'thumbnail': 'https://via.placeholder.com/300x400?text=Peace+Video',
      },
    ];

    return Scaffold(
      body: GradientBackground(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.arrow_back, color: Colors.white),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Text(
                    categoryName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                itemCount: videos.length,
                itemBuilder: (context, index) {
                  final video = videos[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: VideoCard(
                      title: video['title']!,
                      thumbnail: video['thumbnail']!,
                    ),
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
