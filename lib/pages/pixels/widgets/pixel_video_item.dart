import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:nerdvalorant/mobile/screen_size.dart';
import 'package:nerdvalorant/pages/pixels/styles.dart';
import 'package:nerdvalorant/models/youtube_video.dart';
import 'package:nerdvalorant/themes/global_styles.dart';
import 'package:cached_network_image/cached_network_image.dart';

class PixelVideoItem extends StatelessWidget {
  const PixelVideoItem({
    Key? key,
    required this.video,
    required this.title,
    required this.favoriteMode,
    required this.onFavorite,
  }) : super(key: key);

  final String title;
  final bool favoriteMode;
  final YoutubeVideo video;
  final Function(YoutubeVideo) onFavorite;

  @override
  Widget build(BuildContext context) {
    String agentImage(String title) {
      return 'assets/images/profiles/${title.split(' | ')[0].toLowerCase()}.png';
    }

    String publishedAt(dateInString) {
      DateTime date = DateTime.parse(dateInString);

      return DateFormat('dd/MM/yyyy').format(date);
    }

    sharedPixel(YoutubeVideo video) {
      FlutterShare.share(
        title: video.title,
        text:
            'Baixe o app Nerd Valorant para ver todos os pixels disponíveis\n\nhttps://www.youtube.com/watch?v=${video.id}_channel=${title.split(' ').join('')}',
      );
    }

    return Stack(
      children: [
        Container(
          height: ScreenSize.height(41),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                blackColor,
                blackColor.withOpacity(.5),
              ],
            ),
          ),
          child: Column(
            children: [
              Image(
                fit: BoxFit.cover,
                height: ScreenSize.height(27),
                width: ScreenSize.screenWidth,
                image: CachedNetworkImageProvider(
                  video.tumbnail,
                ),
              ),
              SizedBox(
                height: ScreenSize.height(1),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: ScreenSize.width(2),
                ),
                child: Row(
                  children: [
                    Expanded(
                      flex: 15,
                      child: Container(
                        width: ScreenSize.height(6),
                        height: ScreenSize.height(6),
                        decoration: BoxDecoration(
                          color: const Color.fromRGBO(56, 57, 63, 1.0),
                          borderRadius: BorderRadius.all(
                            Radius.circular(
                              ScreenSize.width(1.5),
                            ),
                          ),
                        ),
                        child: Stack(
                          alignment: AlignmentDirectional.center,
                          fit: StackFit.expand,
                          children: [
                            Padding(
                              padding: EdgeInsets.all(ScreenSize.width(.5)),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(ScreenSize.width(1.5)),
                                  ),
                                  image: DecorationImage(
                                    image: AssetImage(
                                      agentImage(
                                        video.title,
                                      ),
                                    ),
                                    alignment: Alignment.center,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 56,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: ScreenSize.width(2),
                        ),
                        child: SizedBox(
                          height: ScreenSize.height(7),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                video.title,
                                maxLines: 1,
                                overflow: TextOverflow.clip,
                                style: titleTextStyle,
                              ),
                              Text(
                                'Publicado em ${publishedAt(video.publishedAt)}',
                                textAlign: TextAlign.left,
                                style: publishedAtTextStyle,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 25,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          !favoriteMode
                              ? video.favorited
                                  ? IconButton(
                                      icon: const Icon(Ionicons.heart),
                                      color: greenColor,
                                      onPressed: () => onFavorite(video),
                                    )
                                  : IconButton(
                                      icon: const Icon(Ionicons.heart_outline),
                                      color: Colors.white,
                                      onPressed: () => onFavorite(video),
                                    )
                              : IconButton(
                                  icon: const Icon(Ionicons.heart_dislike),
                                  color: greenColor,
                                  onPressed: () => onFavorite(video),
                                ),
                          IconButton(
                              icon: Icon(
                                Ionicons.share_social_outline,
                                color: whiteColor,
                              ),
                              color: Colors.white,
                              onPressed: () => sharedPixel(video)),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: ScreenSize.height(1),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: ScreenSize.screenWidth,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: ScreenSize.width(2),
                      ),
                      child: Text(
                        maxLines: 2,
                        video.description,
                        style: descriptionTextStyle,
                        overflow: TextOverflow.clip,
                        textAlign: TextAlign.left,
                        textWidthBasis: TextWidthBasis.longestLine,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
