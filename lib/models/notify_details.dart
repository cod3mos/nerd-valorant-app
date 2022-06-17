class NotifyDetails {
  final int id;
  final String body;
  final String title;
  final String payload;
  final DateTime dateTime;

  bool ready;

  NotifyDetails({
    required this.id,
    required this.body,
    this.ready = false,
    required this.title,
    required this.payload,
    required this.dateTime,
  });

  NotifyDetails.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        body = json['body'],
        ready = json['ready'],
        title = json['title'],
        payload = json['payload'],
        dateTime = DateTime.parse(json['dateTime']);

  Map<String, dynamic> toJson() => {
        'id': id,
        'body': body,
        'ready': ready,
        'title': title,
        'payload': payload,
        'dateTime': dateTime.toIso8601String(),
      };

  setReady(ready) => this.ready = ready;
}
