import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:nerdvalorant/DB/models/videos_collection.dart';
import 'package:nerdvalorant/models/notify_details.dart';
import 'package:shared_preferences/shared_preferences.dart';

String seenIntro = 'seenIntro';
String videos = 'favorite_videos';
String notifications = 'local_notifications';

class LocalStorageService extends ChangeNotifier {
  static late SharedPreferences _localStorage;

  static Future init() async {
    _localStorage = await SharedPreferences.getInstance();
  }

  // Already Viewed

  bool alreadyViewed = false;

  readSeenIntro() {
    alreadyViewed = _localStorage.getBool(seenIntro) ?? false;
  }

  Future<void> writeSeenIntro(bool data) async {
    await _localStorage.setBool(seenIntro, data);

    await readSeenIntro();

    notifyListeners();
  }

  // Notifications

  List<NotifyDetails> localNotifications = [];

  readNotifications() {
    final String listInString = _localStorage.getString(notifications) ?? '[]';

    final List list = json.decode(listInString) as List;

    localNotifications =
        list.map((item) => NotifyDetails.fromJson(item)).toList();
  }

  Future<void> writeNotifications(List<NotifyDetails> notifyList) async {
    await _localStorage.setString(notifications, json.encode(notifyList));
    await readNotifications();

    notifyListeners();
  }

  // Favorite Videos

  List<YoutubeVideo> favoriteVideos = [];

  readFavoriteVideos() {
    final String listInString = _localStorage.getString(videos) ?? '[]';

    final List list = json.decode(listInString) as List;

    favoriteVideos = list.map((item) => YoutubeVideo.fromJson(item)).toList();
  }

  Future<void> writeFavoriteVideos(List<YoutubeVideo> videosList) async {
    await _localStorage.setString(videos, json.encode(videosList));
    await readFavoriteVideos();

    notifyListeners();
  }
}
