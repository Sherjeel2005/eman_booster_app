import 'package:flutter/material.dart';
import '../data/video_model.dart';

class VideoTile extends StatelessWidget {
  final VideoModel video;
  final VoidCallback onTap;

  VideoTile({required this.video, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16), // top & bottom rounded
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 6,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              // Thumbnail Image
              Image.asset(
                video.thumbnailPath,
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: double.infinity,
                    height: 200,
                    color: Colors.grey[300],
                  );
                },
              ),
              // Play Button Overlay
              Positioned.fill(
                child: Align(
                  alignment: Alignment.center,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black38,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                      size: 50,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
