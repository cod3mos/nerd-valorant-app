class YoutubeChannel {
  final String title;
  final int videoCount;

  List<YoutubeVideo> videos;

  YoutubeChannel({
    required this.title,
    required this.videos,
    required this.videoCount,
  });
}

class YoutubeVideo {
  final String id;
  final String title;
  final String videoId;
  final String description;
  final String publishedAt;

  bool favorited;

  YoutubeVideo({
    required this.id,
    required this.title,
    required this.videoId,
    required this.favorited,
    required this.description,
    required this.publishedAt,
  });

  YoutubeVideo.fromDB(Map<String, dynamic> db)
      : id = db['_id'].$oid,
        title = db['snippet']['title'],
        videoId = db['id']['videoId'],
        favorited = false,
        description = db['snippet']['description'],
        publishedAt = db['snippet']['publishedAt'];

  YoutubeVideo.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        title = json['title'],
        videoId = json['videoId'],
        favorited = json['favorited'],
        description = json['description'],
        publishedAt = json['publishedAt'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'videoId': videoId,
        'favorited': favorited,
        'description': description,
        'publishedAt': publishedAt,
      };
}
