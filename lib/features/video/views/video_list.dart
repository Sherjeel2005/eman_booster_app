 import 'package:flutter/material.dart';
import '../../../core/widgets/gradient_background.dart';
import '../data/video_model.dart';
import 'video_player_page.dart';

class VideoListPage extends StatelessWidget {
  final String category;
  VideoListPage({required this.category, required String heroTag});

  @override
  Widget build(BuildContext context) {
    List<VideoModel> categoryVideos = videos[category] ?? [];

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(category),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: GradientBackground(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GridView.builder(
            itemCount: categoryVideos.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // 2 columns
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 0.75, // height like Instagram
            ),
            itemBuilder: (context, index) {
              final video = categoryVideos[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => VideoPlayerPage(video: video),
                    ),
                  );
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16), // rounded top & bottom
                  child: Stack(
                    children: [
                      // Thumbnail
                      Image.asset(
                        video.thumbnailPath,
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(color: Colors.grey[300]);
                        },
                      ),
                      // Play button overlay
                      Positioned.fill(
                        child: Align(
                          alignment: Alignment.center,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black38,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(Icons.play_arrow,
                                color: Colors.white, size: 50),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
