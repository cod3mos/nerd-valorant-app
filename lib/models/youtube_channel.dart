import 'package:nerdvalorant/models/youtube_video.dart';

class YoutubeChannel {
  final String id;
  final String title;
  final int videoCount;
  final String uploadPlaylistId;

  List<YoutubeVideo> videos;

  YoutubeChannel({
    required this.id,
    required this.title,
    required this.videos,
    required this.videoCount,
    required this.uploadPlaylistId,
  });

  YoutubeChannel.fromMap(Map<String, dynamic> json)
      : id = json['id'],
        title = json['snippet']['title'],
        videos = [],
        videoCount = int.parse(json['statistics']['videoCount']),
        uploadPlaylistId =
            json['contentDetails']['relatedPlaylists']['uploads'];
}
