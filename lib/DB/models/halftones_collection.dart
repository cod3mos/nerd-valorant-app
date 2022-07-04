class HalftonesCollection {
  String id;
  String name;
  String imageUrl;
  String halftoneCode;

  HalftonesCollection({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.halftoneCode,
  });

  HalftonesCollection.fromDB(Map<String, dynamic> db)
      : id = db['_id'].$oid,
        name = db['name'],
        imageUrl = db['image_url'],
        halftoneCode = db['halftone_code'];
}
