import 'package:mongo_dart/mongo_dart.dart';
import 'package:nerdvalorant/keys/keys.dart';
import 'package:nerdvalorant/DB/models/videos_collection.dart';
import 'package:nerdvalorant/DB/models/halftones_collection.dart';

class MongoDatabase {
  static late dynamic _database;

  static Future<void> connect() async {
    _database = await Db.create(mongoUrl);

    await _database.open();
  }

  static Future<List<HalftonesCollection>> fetchHalftones() async {
    final halftoneCollection = _database.collection('halftones');
    final List halftones = await halftoneCollection.find().toList();

    return halftones.map((item) => HalftonesCollection.fromDB(item)).toList();
  }

  static Future<YoutubeChannel> fetchChannel() async {
    final videoCollection = _database.collection('videos');

    final int videoCount = await videoCollection.count();

    final result = await fetchVideos(0, []);

    return YoutubeChannel(
      videos: result['videos'],
      title: 'NerdValorant',
      videoCount: videoCount,
    );
  }

  static Future<Map<String, dynamic>> fetchVideos(
      int pg, List<String> qr) async {
    int limit = 10;
    int skip = limit * pg;

    SelectorBuilder query;

    final videoCollection = _database.collection('videos');

    if (qr.isEmpty) {
      query = where.skip(skip).limit(limit);
    } else {
      query = where.all('key_words', qr).skip(skip).limit(limit);
    }

    int totalVideosFound = await videoCollection.count(query);
    List videos = await videoCollection.find(query).toList();

    return {
      'videos': videos.map((item) => YoutubeVideo.fromDB(item)).toList(),
      'totalVideosFound': totalVideosFound
    };
  }
}
