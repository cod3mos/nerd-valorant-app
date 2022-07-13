import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';
import 'package:nerdvalorant/keys/keys.dart';
import 'package:nerdvalorant/DB/mongo_database.dart';
import 'package:nerdvalorant/mobile/screen_size.dart';
import 'package:nerdvalorant/themes/global_styles.dart';
import 'package:nerdvalorant/pages/halftones/styles.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:nerdvalorant/services/plan_purchases.dart';
import 'package:nerdvalorant/assets/media_source_tree.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:nerdvalorant/DB/models/halftones_collection.dart';
import 'package:nerdvalorant/pages/halftones/widgets/halftones_banner_item.dart';

class HalftonesPage extends StatefulWidget {
  const HalftonesPage({Key? key}) : super(key: key);

  @override
  State<HalftonesPage> createState() => _HalftonesPageState();
}

class _HalftonesPageState extends State<HalftonesPage> {
  bool isUserPremium = false;

  late BannerAd bannerAd;
  late List<HalftonesCollection> halftones = [];

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
        request: const AdRequest(keywords: ['games', 'valorant']),
      );
    });

    bannerAd.load();
  }

  @override
  void dispose() {
    bannerAd.dispose();

    super.dispose();
  }

  checkLocalStorageService() {
    final accessType = context.watch<PlanPurchasesService>().accessType;

    if (accessType != null) {
      setState(() => isUserPremium = accessType.isNotEmpty);
    }
  }

  _halftonesList() async {
    final response = await MongoDatabase.fetchHalftones();

    setState(() => halftones = response);
  }

  @override
  Widget build(BuildContext context) {
    checkLocalStorageService();

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
                child: ListView(
                  children: [
                    for (var halftone in halftones)
                      Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: ScreenSize.height(.5),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: ScreenSize.width(1),
                          ),
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
                                              image: CachedNetworkImageProvider(
                                                halftone.imageUrl,
                                              ),
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
                                                    style:
                                                        halftoneCodeTextStyle,
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

  halftoneCopied(HalftonesCollection halftoneCode) {
    Clipboard.setData(
      ClipboardData(text: halftoneCode.halftoneCode),
    );

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Retícula ${halftoneCode.name} foi copiada com sucesso!',
          style: TextStyle(color: whiteColor),
        ),
        backgroundColor: greenColor,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
