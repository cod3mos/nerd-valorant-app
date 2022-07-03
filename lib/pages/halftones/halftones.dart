import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ionicons/ionicons.dart';
import 'package:nerdvalorant/keys/keys.dart';
import 'package:nerdvalorant/DB/mongo_database.dart';
import 'package:nerdvalorant/mobile/screen_size.dart';
import 'package:nerdvalorant/themes/global_styles.dart';
import 'package:nerdvalorant/pages/halftones/styles.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:nerdvalorant/assets/media_source_tree.dart';
import 'package:nerdvalorant/DB/models/halftones_collection.dart';
import 'package:nerdvalorant/pages/halftones/widgets/halftones_banner_item.dart';

class HalftonesPage extends StatefulWidget {
  const HalftonesPage({Key? key}) : super(key: key);

  @override
  State<HalftonesPage> createState() => _HalftonesPageState();
}

class _HalftonesPageState extends State<HalftonesPage> {
  late List<HalftonesCollection> halftones = [];
  late BannerAd bannerAd;

  @override
  void initState() {
    super.initState();

    _halftonesList();

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
        request: const AdRequest(keywords: ['s', 'd']),
      );
    });

    bannerAd.load();
  }

  @override
  void dispose() {
    bannerAd.dispose();

    super.dispose();
  }

  _halftonesList() async {
    final response = await MongoDatabase.list();
    setState(() {
      halftones = response;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
              const HalftonesBannerItem(),
              Expanded(
                flex: 9,
                child: ListView(
                  children: [
                    for (var halftone in halftones)
                      Padding(
                        padding: EdgeInsets.all(ScreenSize.height(2)),
                        child: Column(
                          children: [
                            Container(
                              height: ScreenSize.height(13),
                              width: ScreenSize.screenWidth,
                              decoration: BoxDecoration(
                                color: Colors.black,
                                border: Border.all(
                                  color: whiteColor,
                                  width: 2.0,
                                ),
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: Padding(
                                      padding:
                                          EdgeInsets.all(ScreenSize.width(3)),
                                      child: Container(
                                        width: ScreenSize.width(30),
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image:
                                                NetworkImage(halftone.imageUrl),
                                            fit: BoxFit.cover,
                                          ),
                                          border: Border.all(
                                            color: whiteColor,
                                            width: 2.0,
                                          ),
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(
                                              ScreenSize.width(2),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 7,
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              halftone.name,
                                              style: halftoneTitleStyle,
                                            ),
                                            IconButton(
                                              onPressed: () {
                                                halftoneCopied(halftone);
                                              },
                                              icon: Icon(
                                                Ionicons.copy_outline,
                                                color: whiteColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              'CÓDIGO DA RETÍCULA',
                                              style: halftoneTextStyle,
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Padding(
                                                padding: EdgeInsets.only(
                                                  right: ScreenSize.width(4),
                                                ),
                                                child: Text(
                                                  halftone.halftoneCode,
                                                  style: halftoneCodeTextStyle,
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: AdWidget(ad: bannerAd),
              ),
            ],
          ),
        ),
      ),
    );
  }

  halftoneCopied(HalftonesCollection halftoneCode) {
    Clipboard.setData(
      ClipboardData(text: halftoneCode.halftoneCode),
    );

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Retícula ${halftoneCode.name} foi copiada com sucesso!',
          style: TextStyle(
            color: whiteColor,
          ),
        ),
        backgroundColor: greenColor,
        duration: const Duration(
          seconds: 2,
        ),
      ),
    );
  }
}
