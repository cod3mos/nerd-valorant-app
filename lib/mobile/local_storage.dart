import 'dart:convert';
import 'package:nerdvalorant/models/youtube_video.dart';
import 'package:nerdvalorant/models/notify_details.dart';
import 'package:shared_preferences/shared_preferences.dart';

String notifications = 'notifications';
String videos = 'favorite_videos';

class LocalStorage {
  static late SharedPreferences _localStorage;

  static Future init() async {
    _localStorage = await SharedPreferences.getInstance();
  }

  static Future writeString({required String key, required String data}) async {
    await _localStorage.setString(key, data);
  }

  static Future writeBool({required String key, required bool data}) async {
    await _localStorage.setBool(key, data);
  }

  static String readString(String key) {
    return _localStorage.getString(key) ?? '';
  }

  static bool readBool(String key) {
    return _localStorage.getBool(key) ?? false;
  }

  static Future<void> writeNotifications(List<NotifyDetails> notifyList) async {
    await _localStorage.setString(notifications, json.encode(notifyList));
  }

  static List<NotifyDetails> readNotifications() {
    final String listInString = _localStorage.getString(notifications) ?? '[]';

    final List notifyList = json.decode(listInString) as List;

    return notifyList.map((notify) => NotifyDetails.fromJson(notify)).toList();
  }

  static Future<void> writeFavoriteVideos(List<YoutubeVideo> videosList) async {
    await _localStorage.setString(videos, json.encode(videosList));
  }

  static List<YoutubeVideo> readFavoriteVideos() {
    final String listInString = _localStorage.getString(videos) ?? '[]';

    final List videosList = json.decode(listInString) as List;

    return videosList.map((video) => YoutubeVideo.fromJson(video)).toList();
  }
}
