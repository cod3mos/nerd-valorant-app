import 'package:flutter_svg/svg.dart';
import 'package:flutter/material.dart';
import 'package:nerdvalorant/DB/models/videos_collection.dart';
import 'package:nerdvalorant/mobile/local_storage.dart';
import 'package:nerdvalorant/models/notify_details.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nerdvalorant/mobile/screen_size.dart';
import 'package:nerdvalorant/pages/pixels/styles.dart';
import 'package:nerdvalorant/services/google_sign_in.dart';
import 'package:nerdvalorant/assets/media_source_tree.dart';

class PixelBannerItem extends StatefulWidget {
  const PixelBannerItem({Key? key, required this.channel}) : super(key: key);

  final YoutubeChannel? channel;

  @override
  State<PixelBannerItem> createState() => _PixelBannerItemState();
}

class _PixelBannerItemState extends State<PixelBannerItem> {
  late User user;
  late List<NotifyDetails> notifyDetails;

  @override
  void initState() {
    super.initState();

    context.read<LocalStorageService>().readFavoriteVideos();
  }

  checkLocalStorageService() {
    user = context.watch<GoogleSignInProvider>().googleUser!;
    notifyDetails = context.watch<LocalStorageService>().localNotifications;
  }

  @override
  Widget build(BuildContext context) {
    checkLocalStorageService();

    String displayName(List<String> names) {
      if (names.length > 1) {
        return names.getRange(0, 2).join(' ');
      } else {
        return names.join(' ');
      }
    }

    goToNotifications() => Navigator.pushNamed(context, '/notifications');

    hasNotificationNotRead(List<NotifyDetails> list) {
      return list.where((item) => item.ready == false).toList().isEmpty;
    }

    hasNotificationNotRead(notifyDetails);

    return Container(
      height: ScreenSize.height(15),
      width: ScreenSize.screenWidth,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(bannerBackground),
          fit: BoxFit.cover,
          alignment: Alignment.center,
        ),
        boxShadow: const [
          BoxShadow(
            color: Colors.black,
            spreadRadius: 0,
            blurRadius: 4,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: ScreenSize.width(2)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Olá, ',
                            style: bannerTitleStyle,
                          ),
                          TextSpan(
                            text: displayName(user.displayName!.split(' ')),
                            style: bannerTitleBoldStyle,
                          ),
                          TextSpan(
                            text: '\nSEMPRE TEM UM PIXEL PARA CADA JOGADA!',
                            style: bannerTextStyle,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () => goToNotifications(),
                  icon: SvgPicture.asset(
                    hasNotificationNotRead(notifyDetails)
                        ? iconNotification
                        : iconNotificationAlert,
                    height: ScreenSize.width(8),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: ScreenSize.height(3),
          ),
          SizedBox(
            width: ScreenSize.screenWidth,
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                children: [
                  const TextSpan(text: 'Contamos com '),
                  TextSpan(
                    text: '${widget.channel?.videoCount ?? '0'}',
                    style: bannerSubtitleBoldStyle,
                  ),
                  const TextSpan(text: ' pixels disponíveis'),
                ],
                style: bannerSubtitleStyle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
