class YoutubeVideo {
  final String id;
  final String title;
  final String tumbnail;
  final String description;
  final String publishedAt;

  bool favorited;

  YoutubeVideo({
    required this.id,
    required this.title,
    required this.tumbnail,
    required this.favorited,
    required this.description,
    required this.publishedAt,
  });

  YoutubeVideo.fromMap(Map<String, dynamic> snippet)
      : id = snippet['id'],
        title = snippet['title'],
        tumbnail = snippet['thumbnail'],
        favorited = false,
        description = snippet['description'],
        publishedAt = snippet['publishedAt'];

  YoutubeVideo.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        title = json['title'],
        tumbnail = json['tumbnail'],
        favorited = json['favorited'],
        description = json['description'],
        publishedAt = json['publishedAt'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'tumbnail': tumbnail,
        'favorited': favorited,
        'description': description,
        'publishedAt': publishedAt,
      };
}
