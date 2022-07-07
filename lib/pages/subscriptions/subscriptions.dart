import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:nerdvalorant/mobile/screen_size.dart';
import 'package:nerdvalorant/pages/subscriptions/styles.dart';
import 'package:nerdvalorant/themes/global_styles.dart';
import 'package:nerdvalorant/services/plan_purchases.dart';
import 'package:nerdvalorant/assets/media_source_tree.dart';
import 'package:provider/provider.dart';
import 'package:purchases_flutter/models/offering_wrapper.dart';
import 'package:nerdvalorant/pages/subscriptions/widgets/subscriptions_modal_item.dart';
import 'package:purchases_flutter/models/package_wrapper.dart';

class SubscriptionsPage extends StatefulWidget {
  const SubscriptionsPage({Key? key}) : super(key: key);

  @override
  State<SubscriptionsPage> createState() => _SubscriptionsPageState();
}

class _SubscriptionsPageState extends State<SubscriptionsPage> {
  bool isUserPremium = false;
  List<Offering> offering = [];
  String planAmount = 'R\$ 0,00';

  @override
  void initState() {
    super.initState();

    _fetchOffering();
  }

  _fetchOffering() => context.read<PlanPurchasesService>().fetchOffers();

  checkPlanPurchasesService() {
    offering = context.watch<PlanPurchasesService>().offering;

    final accessType = context.watch<PlanPurchasesService>().accessType;

    if (accessType != null) {
      final packages = getPackages();

      int index =
          packages.indexWhere((item) => item.product.identifier == accessType);

      if (packages.isNotEmpty) {
        setState(() {
          isUserPremium = accessType.isNotEmpty;
          planAmount = packages[index].product.priceString;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    ScreenSize.init(context);

    checkPlanPurchasesService();

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
          padding: EdgeInsets.symmetric(
            horizontal: ScreenSize.width(5),
          ),
          child: Column(
            children: [
              Expanded(
                flex: 1,
                child: Row(
                  children: [
                    SizedBox(
                      width: ScreenSize.width(10),
                      child: TextButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.transparent,
                          onPrimary: greenColor,
                        ),
                        child: Icon(
                          Ionicons.arrow_back_outline,
                          color: whiteColor,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: ScreenSize.width(2),
                    ),
                    Text(
                      'Plano de assinatura',
                      style: titleStyle,
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 9,
                child: Column(
                  children: [
                    Image.asset(
                      isUserPremium ? stickerSova : stickerOmen,
                      width: ScreenSize.width(30),
                    ),
                    SizedBox(
                      height: ScreenSize.height(2),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'Assinante ',
                                style: textPremiumStyle,
                              ),
                              TextSpan(
                                text:
                                    isUserPremium ? 'Radiante ' : 'Sem Patente',
                                style: isUserPremium
                                    ? textPremiumBoldStyle
                                    : textPremiumStyle,
                              ),
                            ],
                          ),
                        ),
                        if (isUserPremium)
                          Icon(
                            Ionicons.diamond_outline,
                            color: blueColor,
                            size: ScreenSize.adaptiveFontSize(4),
                          ),
                      ],
                    ),
                    SizedBox(
                      height: ScreenSize.height(2),
                    ),
                    Container(
                      decoration: const BoxDecoration(
                        border: Border(
                          top: BorderSide(
                            color: Color(0xFF38393F),
                            width: 1.0,
                          ),
                        ),
                      ),
                    ),
                    Column(
                      children: [
                        SizedBox(
                          height: ScreenSize.height(1),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Plano de assinatura',
                              style: textStyle,
                            ),
                            TextButton(
                              onPressed: showOfferings,
                              style: ElevatedButton.styleFrom(
                                primary: Colors.transparent,
                                onPrimary: greenColor,
                              ),
                              child: Text(
                                'Gerenciar',
                                style: textBoldStyle,
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: ScreenSize.height(1),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Valor do plano atual:',
                              style: textStyle,
                            ),
                            Text(
                              planAmount,
                              style: textStyle,
                            ),
                          ],
                        ),
                        if (isUserPremium)
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: ScreenSize.height(10),
                              ),
                              Image.asset(
                                stickerSage,
                                width: ScreenSize.width(30),
                              ),
                              SizedBox(
                                height: ScreenSize.height(2),
                              ),
                              Text(
                                'Agradecemos a sua assinatura, agora você é um Radiante e sua missão é aproveitar muito nosso app!',
                                style: textStyle,
                                textAlign: TextAlign.center,
                              ),
                            ],
                          )
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  List<Package> getPackages() {
    return offering
        .map((offers) => offers.availablePackages)
        .expand((pair) => pair)
        .toList();
  }

  Future showOfferings() async {
    final packages = getPackages();

    await showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) => SizedBox(
        height: ScreenSize.height(65),
        child: SubscriptionsModalItem(
          onClickedPackage: (package) async {
            Navigator.pop(context);
            await context.read<PlanPurchasesService>().signPlan(package);
          },
          packages: packages,
        ),
      ),
    );
  }
}
