import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:nerdvalorant/keys/keys.dart';
import 'package:nerdvalorant/keys/links.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:nerdvalorant/mobile/screen_size.dart';
import 'package:nerdvalorant/pages/pixels/styles.dart';
import 'package:nerdvalorant/themes/global_styles.dart';
import 'package:nerdvalorant/DB/models/videos_collection.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

class PixelVideoItem extends StatefulWidget {
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
  State<PixelVideoItem> createState() => _PixelVideoItemState();
}

class _PixelVideoItemState extends State<PixelVideoItem> {
  FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;
  bool imageError = false;

  @override
  Widget build(BuildContext context) {
    String agentImage(String title) {
      return 'assets/images/profiles/${title.split(' | ')[0].toLowerCase()}.png';
    }

    String removeFirstName(String title) {
      return title.split(' | ').getRange(1, 3).join(' | ');
    }

    String publishedAt(dateInString) {
      DateTime date = DateTime.parse(dateInString);

      return DateFormat('dd/MM/yyyy').format(date);
    }

    Future sharedPixel(YoutubeVideo video) async {
      List<String> title = video.title.split(' | ');

      final DynamicLinkParameters params = DynamicLinkParameters(
        uriPrefix: baseUrl,
        link: Uri.parse(baseUrl + pathWithParameters + video.videoId),
        androidParameters: AndroidParameters(packageName: packageName),
      );

      final link = await FirebaseDynamicLinks.instance.buildShortLink(params);

      FlutterShare.share(
        title: video.title,
        text:
            'Olha que massa esse pixel de ${title[0]} no mapa ${title[1]}.\n\nClique e confira: ${link.shortUrl.toString()}.',
      );
    }

    String makeThumbnailUrl(String id, {bool maxQuality = true}) {
      final baseUrl = thumbnailInitialUrl.replaceAll('nv-id', id);

      return baseUrl + (maxQuality ? imageMaxQuality : imageHdQuality);
    }

    ImageProvider _getNetworkImage(String id) {
      return CachedNetworkImageProvider(makeThumbnailUrl(id, maxQuality: true),
          errorListener: () => setState(() => imageError = true));
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
                image: imageError
                    ? CachedNetworkImageProvider(makeThumbnailUrl(
                        widget.video.videoId,
                        maxQuality: false))
                    : _getNetworkImage(widget.video.videoId),
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
                                        widget.video.title,
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
                                removeFirstName(widget.video.title),
                                maxLines: 1,
                                overflow: TextOverflow.clip,
                                style: titleTextStyle,
                              ),
                              Text(
                                'Publicado em ${publishedAt(widget.video.publishedAt)}',
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
                          !widget.favoriteMode
                              ? widget.video.favorited
                                  ? IconButton(
                                      icon: const Icon(Ionicons.heart),
                                      color: greenColor,
                                      onPressed: () =>
                                          widget.onFavorite(widget.video),
                                    )
                                  : IconButton(
                                      icon: const Icon(Ionicons.heart_outline),
                                      color: Colors.white,
                                      onPressed: () =>
                                          widget.onFavorite(widget.video),
                                    )
                              : IconButton(
                                  icon: const Icon(Ionicons.heart_dislike),
                                  color: greenColor,
                                  onPressed: () =>
                                      widget.onFavorite(widget.video),
                                ),
                          IconButton(
                            icon: Icon(
                              Ionicons.share_social_outline,
                              color: whiteColor,
                            ),
                            color: Colors.white,
                            onPressed: () async {
                              await sharedPixel(widget.video);
                            },
                          ),
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
                        widget.video.description,
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
