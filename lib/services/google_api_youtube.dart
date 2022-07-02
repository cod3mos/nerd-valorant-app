import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:nerdvalorant/keys/keys.dart';
import 'package:nerdvalorant/keys/links.dart';
import 'package:nerdvalorant/models/youtube_video.dart';
import 'package:nerdvalorant/models/youtube_channel.dart';

class GoogleApiYoutube {
  GoogleApiYoutube._instance();

  static final GoogleApiYoutube instance = GoogleApiYoutube._instance();

  String _nextPageToken = '';

  Future<YoutubeChannel> fetchChannel() async {
    Map<String, String> params = {
      'id': youtubeChannelId,
      'key': youtubeApiKey,
      'part': 'snippet, statistics, contentDetails',
    };

    Uri uri = Uri.https(googleApis, '/youtube/v3/channels', params);

    Map<String, String> headers = {
      HttpHeaders.connectionHeader: 'application/json',
    };

    var response = await http.get(uri, headers: headers);

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body)['items'][0];

      YoutubeChannel channel = YoutubeChannel.fromMap(data);

      channel.videos = await fetchVideos(channel.uploadPlaylistId, '');

      return channel;
    } else {
      throw json.decode(response.body)['error']['message'];
    }
  }

  Future<List<YoutubeVideo>> fetchVideos(String playlistId, String q) async {
    Map<String, String> params = {
      'key': youtubeApiKey,
      'channelId': youtubeChannelId,
      'part': 'snippet',
      'maxResults': '10',
      'type': 'video',
      'q': q,
      'pageToken': _nextPageToken,
      'order': 'relevance'
    };

    Uri uri = Uri.https(googleApis, '/youtube/v3/search', params);

    Map<String, String> headers = {
      HttpHeaders.connectionHeader: 'application/json',
    };

    var response = await http.get(uri, headers: headers);

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);

      _nextPageToken = data['nextPageToken'] ?? '';

      List<YoutubeVideo> videos = [];

      for (var map in data['items']) {
        dynamic video = map['snippet'];
        String url = video['thumbnails']['high']['url'];

        video['id'] = map['id']['videoId'];
        video['thumbnail'] = url.replaceFirst('hqdefault', 'maxresdefault');

        videos.add(YoutubeVideo.fromMap(video));
      }

      return videos;
    } else {
      throw json.decode(response.body)['error']['message'];
    }
  }
}
