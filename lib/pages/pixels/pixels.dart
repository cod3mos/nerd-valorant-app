import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:ionicons/ionicons.dart';
import 'package:nerdvalorant/keys/keys.dart';
import 'package:nerdvalorant/mobile/screen_size.dart';
import 'package:nerdvalorant/pages/pixels/styles.dart';
import 'package:nerdvalorant/mobile/local_storage.dart';
import 'package:nerdvalorant/models/youtube_video.dart';
import 'package:nerdvalorant/widgets/loading_item.dart';
import 'package:nerdvalorant/themes/global_styles.dart';
import 'package:nerdvalorant/models/youtube_channel.dart';
import 'package:nerdvalorant/assets/media_source_tree.dart';
import 'package:nerdvalorant/services/google_api_youtube.dart';
import 'package:nerdvalorant/pages/pixels/widgets/pixel_modal_item.dart';
import 'package:nerdvalorant/pages/pixels/widgets/pixel_video_item.dart';
import 'package:nerdvalorant/pages/pixels/widgets/pixel_banner_item.dart';

class PixelsPage extends StatefulWidget {
  const PixelsPage({Key? key}) : super(key: key);

  @override
  State<PixelsPage> createState() => _PixelsPageState();
}

class _PixelsPageState extends State<PixelsPage> {
  late List<YoutubeVideo> videos;
  String querySearch = '';
  YoutubeChannel? channel;
  bool isLoading = false;
  int videoCount = 0;
  RewardedAd? rewardedAd;
  late BannerAd bannerAd;
  late AdRequest adRequest;

  @override
  void initState() {
    super.initState();

    videos = LocalStorage.readFavoriteVideos();

    _fetchChannel();

    adRequest = const AdRequest(keywords: ['games', 'valorant']);

    BannerAdListener bannerAdListener = BannerAdListener(onAdClosed: (ad) {
      bannerAd.load();
    }, onAdFailedToLoad: (ad, error) {
      bannerAd.load();
    });

    setState(() {
      bannerAd = BannerAd(
        size: AdSize.banner,
        adUnitId: bannerAdKey,
        listener: bannerAdListener,
        request: adRequest,
      );
    });

    bannerAd.load();

    initializeRewardedAd();
  }

  void initializeRewardedAd() {
    RewardedAdLoadCallback rewardAd = RewardedAdLoadCallback(onAdLoaded: (ad) {
      rewardedAd = ad;
    }, onAdFailedToLoad: (LoadAdError error) {
      rewardedAd = null;
    });

    RewardedAd.load(
      adUnitId: rewardedAdKey,
      rewardedAdLoadCallback: rewardAd,
      request: adRequest,
    );
  }

  void showRewarded(YoutubeVideo video) {
    if (rewardedAd != null) {
      rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdShowedFullScreenContent: (RewardedAd ad) {},
        onAdDismissedFullScreenContent: (RewardedAd ad) {
          ad.dispose();

          initializeRewardedAd();
        },
        onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError err) {
          ad.dispose();

          initializeRewardedAd();
        },
      );

      rewardedAd!.setImmersiveMode(true);
      rewardedAd!.show(
        onUserEarnedReward: (AdWithoutView ad, RewardItem reward) async {
          int isFavorite = videos.indexWhere((item) => item.id == video.id);

          setState(() => video.favorited = isFavorite != -1);

          isFavorite == -1 ? videos.add(video) : videos.removeAt(isFavorite);

          await LocalStorage.writeFavoriteVideos(videos);
        },
      );
    }
  }

  @override
  void dispose() {
    bannerAd.dispose();

    if (rewardedAd != null) {
      rewardedAd!.dispose();
    }

    super.dispose();
  }

  _fetchChannel() async {
    final youtubeChannel = await GoogleApiYoutube.instance.fetchChannel();

    setState(() => channel = youtubeChannel);
  }

  searchVideos(String search) async {
    setState(() => isLoading = true);

    final videos = await GoogleApiYoutube.instance
        .fetchVideos(channel!.uploadPlaylistId, search);

    setState(() {
      channel!.videos = videos;
      isLoading = false;
    });
  }

  loadMoreVideos() async {
    setState(() => isLoading = true);

    List<YoutubeVideo> videos = await GoogleApiYoutube.instance
        .fetchVideos(channel!.uploadPlaylistId, querySearch);

    List<YoutubeVideo> videoList = channel!.videos..addAll(videos);

    setState(() {
      channel!.videos = videoList;
      isLoading = false;
    });
  }

  openVideo({id}) {
    Navigator.pushNamed(context, '/youtube_player', arguments: id);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton.extended(
          onPressed: showFilter,
          label: Text(
            'Filtrar',
            style: filterButtonTextStyle,
          ),
          icon: Icon(
            Ionicons.funnel_outline,
            color: whiteColor,
          ),
          backgroundColor: greenColor.withOpacity(1),
          hoverColor: greenColor,
          splashColor: greenColor,
        ),
        backgroundColor: blackColor,
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(screenBackground),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            children: [
              PixelBannerItem(channel: channel),
              channel != null && !isLoading
                  ? channel!.videos.isNotEmpty
                      ? Expanded(
                          child: NotificationListener<ScrollNotification>(
                            onNotification: (ScrollNotification scroll) {
                              bool isNotLoading = !isLoading;
                              ScrollMetrics metrics = scroll.metrics;
                              bool haveMore =
                                  channel!.videos.length < channel!.videoCount;
                              bool finishedList =
                                  metrics.pixels != metrics.maxScrollExtent;

                              if (isNotLoading && haveMore && finishedList) {
                                loadMoreVideos();
                              }

                              return false;
                            },
                            child: Column(
                              children: [
                                Expanded(
                                  child: ListView.builder(
                                    itemCount: channel!.videos.length,
                                    itemBuilder: (context, int index) {
                                      YoutubeVideo video =
                                          channel!.videos[index];

                                      int isFavorite = videos.indexWhere(
                                          (item) => item.id == video.id);

                                      video.favorited = isFavorite != -1;

                                      return GestureDetector(
                                        onTap: () => openVideo(id: video.id),
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                            vertical: ScreenSize.height(1),
                                          ),
                                          child: PixelVideoItem(
                                            video: video,
                                            favoriteMode: false,
                                            title: channel!.title,
                                            onFavorite: showRewarded,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                stickerOmen,
                                width: ScreenSize.width(30),
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              Text(
                                'Nenhum resultado encontrado...',
                                textAlign: TextAlign.center,
                                style: bannerSubtitleStyle,
                              ),
                            ],
                          ),
                        )
                  : LoadingItem(
                      text: Text(
                        'Buscando pixels...',
                        style: loadingTextStyle,
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Future showFilter() async {
    await showModalBottomSheet(
      backgroundColor: Colors.red,
      context: context,
      builder: (context) => SizedBox(
        height: ScreenSize.height(65),
        child: PixelModalItem(
          filter: (List<String> search) {
            Navigator.pop(context);
            searchVideos(search.join(' ').trim());
            setState(() => querySearch = search.join(' ').trim());
          },
        ),
      ),
    );
  }
}
