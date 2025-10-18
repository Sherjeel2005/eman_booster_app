class VideoModel {
  final String title;          // Video title
    // Thumbnail image path (local or network)
  final String videoPath;      // Video file path (local asset or network URL)
  final String thumbnailPath;
  VideoModel({
    required this.title,
    required this.thumbnailPath,
    required this.videoPath,
  });
}

// Local downloaded videos per category
final Map<String, List<VideoModel>> videos = {
  "Patience": [
    VideoModel(
      title: "Motivation 1",
      thumbnailPath: "assets/thumbnails/motivation1.png",
      videoPath: "assets/videos/motivation1.mp4",
    ),
    VideoModel(
      title: "Motivation 2",
      thumbnailPath: "assets/thumbnails/motivation1.png",
      videoPath: "assets/videos/motivation1.mp4",
    ),
  ],
  "Purpose": [
    VideoModel(
      title: "Depression 1",
      thumbnailPath: "assets/thumbnails/Nafs.png",
      videoPath: "assets/videos/Nafs.mp4",
    ),
    VideoModel(
      title: "Depression 2",
      thumbnailPath: "assets/thumbnails/motivation1.png",
      videoPath: "assets/videos/motivation1.mp4",
    ),
  ],
  "Toba": [
    VideoModel(
      title: "Toba 1",
      thumbnailPath: "assets/thumbnails/motivation1.png",
      videoPath: "assets/videos/motivation1.mp4",
    ),
  ],
};
