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
  final String tumbnail;
  final String description;
  final String publishedAt;

  bool favorited;

  YoutubeVideo({
    required this.id,
    required this.title,
    required this.videoId,
    required this.tumbnail,
    required this.favorited,
    required this.description,
    required this.publishedAt,
  });

  YoutubeVideo.fromDB(Map<String, dynamic> db)
      : id = db['_id'].$oid,
        title = db['title'],
        videoId = db['video_id'],
        tumbnail = db['tumbnail'],
        favorited = false,
        description = db['description'],
        publishedAt = db['published_at'];

  YoutubeVideo.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        title = json['title'],
        videoId = json['videoId'],
        tumbnail = json['tumbnail'],
        favorited = json['favorited'],
        description = json['description'],
        publishedAt = json['publishedAt'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'videoId': videoId,
        'tumbnail': tumbnail,
        'favorited': favorited,
        'description': description,
        'publishedAt': publishedAt,
      };
}
