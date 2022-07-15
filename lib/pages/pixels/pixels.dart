import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';
import 'package:nerdvalorant/keys/keys.dart';
import 'package:nerdvalorant/DB/mongo_database.dart';
import 'package:nerdvalorant/mobile/screen_size.dart';
import 'package:nerdvalorant/pages/pixels/styles.dart';
import 'package:nerdvalorant/mobile/local_storage.dart';
import 'package:nerdvalorant/widgets/loading_item.dart';
import 'package:nerdvalorant/themes/global_styles.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:nerdvalorant/services/plan_purchases.dart';
import 'package:nerdvalorant/assets/media_source_tree.dart';
import 'package:nerdvalorant/DB/models/videos_collection.dart';
import 'package:nerdvalorant/pages/pixels/widgets/pixel_modal_item.dart';
import 'package:nerdvalorant/pages/pixels/widgets/pixel_video_item.dart';
import 'package:nerdvalorant/pages/pixels/widgets/pixel_banner_item.dart';

class PixelsPage extends StatefulWidget {
  const PixelsPage({Key? key}) : super(key: key);

  @override
  State<PixelsPage> createState() => _PixelsPageState();
}

class _PixelsPageState extends State<PixelsPage> {
  int page = 1;
  int videoCount = 0;
  bool isLoading = true;
  RewardedAd? rewardedAd;
  YoutubeChannel? channel;
  bool isUserPremium = false;
  List<String> querySearch = [];

  late BannerAd bannerAd;
  late AdRequest adRequest;
  late List<YoutubeVideo> videos;

  @override
  void initState() {
    super.initState();

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

  initializeRewardedAd() {
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

  showRewarded(YoutubeVideo video) {
    int isFavorite = videos.indexWhere((item) => item.videoId == video.videoId);

    if (rewardedAd != null && isFavorite == -1 && !isUserPremium) {
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
        onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
          setState(() => video.favorited = isFavorite != -1);

          isFavorite == -1 ? videos.add(video) : videos.removeAt(isFavorite);

          context.read<LocalStorageService>().writeFavoriteVideos(videos);
        },
      );
    } else if (isUserPremium && isFavorite == -1) {
      setState(() => video.favorited = isFavorite != -1);

      isFavorite == -1 ? videos.add(video) : videos.removeAt(isFavorite);

      context.read<LocalStorageService>().writeFavoriteVideos(videos);
    } else {
      videos.removeAt(isFavorite);
      context.read<LocalStorageService>().writeFavoriteVideos(videos);
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
    setState(() => isLoading = true);

    final response = await MongoDatabase.fetchChannel();

    setState(() {
      channel = response;
      isLoading = false;
    });
  }

  searchVideos(List<String> search) async {
    setState(() => isLoading = true);

    final result = await MongoDatabase.fetchVideos(0, search);

    if (result['totalVideosFound'] > 0) {
      halftoneCopied(result['totalVideosFound']);
    }

    setState(() {
      channel!.videos = result['videos'];
      querySearch = search;
      isLoading = false;
      page = 1;
    });
  }

  halftoneCopied(int totalVideosFound) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '$totalVideosFound resultados encontrados',
          style: TextStyle(color: whiteColor),
        ),
        backgroundColor: appBarColor.withOpacity(.8),
        duration: const Duration(milliseconds: 1500),
      ),
    );
  }

  loadMoreVideos(int currentPage) async {
    final result = await MongoDatabase.fetchVideos(currentPage, querySearch);

    List<YoutubeVideo> videoList = channel!.videos..addAll(result['videos']);

    setState(() {
      channel!.videos = videoList;
      isLoading = false;
    });
  }

  openVideo(id) {
    Navigator.pushNamed(context, '/youtube_player', arguments: id);
  }

  checkLocalStorageService() {
    videos = context.watch<LocalStorageService>().favoriteVideos;

    final accessType = context.watch<PlanPurchasesService>().accessType;

    if (accessType != null) {
      setState(() => isUserPremium = accessType.isNotEmpty);
    }
  }

  @override
  Widget build(BuildContext context) {
    checkLocalStorageService();

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
              if (!isUserPremium)
                SizedBox(
                  height: ScreenSize.height(7),
                  width: ScreenSize.screenWidth,
                  child: AdWidget(ad: bannerAd),
                ),
              channel != null && !isLoading
                  ? channel!.videos.isNotEmpty
                      ? Expanded(
                          child: NotificationListener<ScrollNotification>(
                            onNotification: (ScrollNotification scroll) {
                              bool isNotLoading = !isLoading;
                              ScrollMetrics metrics = scroll.metrics;
                              bool haveMore =
                                  channel!.videos.length != channel!.videoCount;
                              bool finishedList =
                                  metrics.pixels == metrics.maxScrollExtent;

                              if (isNotLoading && haveMore && finishedList) {
                                int currentPage = page++;
                                loadMoreVideos(currentPage);
                                setState(() => page = page++);
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
                                          (item) =>
                                              item.videoId == video.videoId);

                                      video.favorited = isFavorite != -1;

                                      return GestureDetector(
                                        onTap: () => openVideo(video.videoId),
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
                  : Expanded(
                      child: LoadingItem(
                        text: Text(
                          'Buscando pixels...',
                          style: loadingTextStyle,
                        ),
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
      context: context,
      builder: (context) => SafeArea(
        child: SizedBox(
          height: ScreenSize.height(65),
          child: PixelModalItem(
            filter: (List<String> search) {
              Navigator.pop(context);

              search.removeWhere((item) => [''].contains(item));

              searchVideos(search);
            },
          ),
        ),
      ),
    );
  }
}
