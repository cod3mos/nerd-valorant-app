import 'package:flutter/material.dart';
import 'package:nerdvalorant/keys/keys.dart';
import 'package:nerdvalorant/mobile/screen_size.dart';
import 'package:nerdvalorant/mobile/local_storage.dart';
import 'package:nerdvalorant/models/youtube_video.dart';
import 'package:nerdvalorant/themes/global_styles.dart';
import 'package:nerdvalorant/pages/favorites/styles.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:nerdvalorant/assets/media_source_tree.dart';
import 'package:nerdvalorant/pages/pixels/widgets/pixel_video_item.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({Key? key}) : super(key: key);

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  late List<YoutubeVideo> videos;
  late BannerAd bannerAd;

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

    videos = LocalStorage.readFavoriteVideos();
  }

  @override
  void dispose() {
    bannerAd.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    openVideo({id}) {
      Navigator.pushNamed(context, '/youtube_player', arguments: id);
    }

    favoriteOrDisfavor(YoutubeVideo video) async {
      int isFavorite = videos.indexWhere((item) => item.id == video.id);

      isFavorite == -1 ? videos.add(video) : videos.removeAt(isFavorite);

      setState(() => videos = videos);

      await LocalStorage.writeFavoriteVideos(videos);
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
          child: Column(
            children: [
              videos.isNotEmpty
                  ? Expanded(
                      flex: 9,
                      child: ListView.builder(
                        itemCount: videos.length,
                        itemBuilder: (context, int index) {
                          YoutubeVideo video = videos[index];

                          return GestureDetector(
                            onTap: () => openVideo(id: video.id),
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
                      flex: 9,
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
                            'Você ainda não adicionou nenhum pixel...',
                            textAlign: TextAlign.center,
                            style: titleStyle,
                          ),
                        ],
                      ),
                    ),
              Expanded(
                flex: 1,
                child: AdWidget(ad: bannerAd),
              ),
            ],
          )),
    );
  }
}
