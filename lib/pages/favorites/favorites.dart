import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:nerdvalorant/keys/keys.dart';
import 'package:nerdvalorant/mobile/screen_size.dart';
import 'package:nerdvalorant/mobile/local_storage.dart';
import 'package:nerdvalorant/themes/global_styles.dart';
import 'package:nerdvalorant/pages/favorites/styles.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:nerdvalorant/services/plan_purchases.dart';
import 'package:nerdvalorant/assets/media_source_tree.dart';
import 'package:nerdvalorant/DB/models/videos_collection.dart';
import 'package:nerdvalorant/pages/pixels/widgets/pixel_video_item.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({Key? key}) : super(key: key);

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  bool isUserPremium = false;

  late BannerAd bannerAd;
  late List<YoutubeVideo> videos;

  @override
  void initState() {
    super.initState();

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
        request: const AdRequest(keywords: ['games', 'valorant']),
      );
    });

    bannerAd.load();

    context.read<LocalStorageService>().readFavoriteVideos();
  }

  @override
  void dispose() {
    bannerAd.dispose();
    super.dispose();
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

    openVideo(id) {
      Navigator.pushNamed(context, '/youtube_player', arguments: id);
    }

    favoriteOrDisfavor(YoutubeVideo video) {
      int isFavorite =
          videos.indexWhere((item) => item.videoId == video.videoId);

      isFavorite == -1 ? videos.add(video) : videos.removeAt(isFavorite);

      setState(() => videos = videos);

      context.read<LocalStorageService>().writeFavoriteVideos(videos);
    }

    return Scaffold(
      backgroundColor: blackColor,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(screenBackground),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            children: [
              videos.isNotEmpty
                  ? Expanded(
                      child: ListView.builder(
                        itemCount: videos.length,
                        itemBuilder: (context, int index) {
                          YoutubeVideo video = videos[index];

                          return GestureDetector(
                            onTap: () => openVideo(video.videoId),
                            child: Padding(
                              padding: EdgeInsets.only(
                                bottom: ScreenSize.height(1),
                              ),
                              child: PixelVideoItem(
                                video: video,
                                favoriteMode: true,
                                title: 'NerdValorant',
                                onFavorite: favoriteOrDisfavor,
                              ),
                            ),
                          );
                        },
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
                            'Você ainda não favoritou nenhum pixel...',
                            textAlign: TextAlign.center,
                            style: titleStyle,
                          ),
                        ],
                      ),
                    ),
              if (!isUserPremium)
                SizedBox(
                  height: ScreenSize.height(7),
                  width: ScreenSize.screenWidth,
                  child: AdWidget(ad: bannerAd),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
