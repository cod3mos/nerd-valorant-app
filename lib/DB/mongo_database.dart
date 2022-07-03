import 'package:mongo_dart/mongo_dart.dart';
import 'package:nerdvalorant/keys/keys.dart';
import 'package:nerdvalorant/DB/models/halftones_collection.dart';

class MongoDatabase {
  static late dynamic _database;

  static connect() async {
    _database = await Db.create(mongoUrl);

    await _database.open();
  }

  static Future<List<HalftonesCollection>> list() async {
    final halftoneCollection = _database.collection('halftones');
    final List halftones = await halftoneCollection.find().toList();

    return halftones.map((item) => HalftonesCollection.fromDB(item)).toList();
  }
}
