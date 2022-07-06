import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:nerdvalorant/mobile/screen_size.dart';
import 'package:nerdvalorant/themes/global_styles.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:nerdvalorant/pages/subscriptions/styles.dart';

class SubscriptionsModalItem extends StatelessWidget {
  const SubscriptionsModalItem({
    Key? key,
    required this.packages,
    required this.onClickedPackage,
  }) : super(key: key);

  final List<Package> packages;
  final Function(Package) onClickedPackage;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: blackColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(
            ScreenSize.height(
              1,
            ),
          ),
          topRight: Radius.circular(
            ScreenSize.height(
              1,
            ),
          ),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex: 2,
            child: Center(
              child: Text(
                'ESCOLHA SEU PLANO',
                style: titlePlanStyle,
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Expanded(
            flex: 8,
            child: Column(
              children: [
                for (var package in packages)
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: ScreenSize.height(2),
                    ),
                    child: Stack(
                      children: [
                        if (package.identifier == '\$rc_annual')
                          Container(
                            height: ScreenSize.height(4),
                            decoration: BoxDecoration(
                              color: greenColor,
                              border: Border.all(
                                color: greenColor,
                                width: ScreenSize.height(.2),
                              ),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(
                                  ScreenSize.height(
                                    1,
                                  ),
                                ),
                                topRight: Radius.circular(
                                  ScreenSize.height(
                                    1,
                                  ),
                                ),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Ionicons.star_outline,
                                  color: whiteColor,
                                  semanticLabel: 'Estrela',
                                  size: ScreenSize.height(2),
                                ),
                                Text(
                                  ' Recomendado',
                                  style: timePlanStyle,
                                ),
                              ],
                            ),
                          ),
                        Column(
                          children: [
                            Container(
                              width: ScreenSize.screenWidth,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: greenColor,
                                  width: ScreenSize.height(.2),
                                ),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(
                                    ScreenSize.height(
                                      1,
                                    ),
                                  ),
                                ),
                              ),
                              child: TextButton(
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.transparent,
                                  onPrimary: greenColor,
                                ),
                                onPressed: () => onClickedPackage(package),
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: ScreenSize.height(
                                        package.identifier == '\$rc_annual'
                                            ? 4
                                            : 1,
                                      ),
                                    ),
                                    Text(
                                      getPlanTime(package),
                                      style: timePlanStyle,
                                    ),
                                    SizedBox(
                                      height: ScreenSize.height(1),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          height: ScreenSize.height(4),
                                          child: Column(
                                            children: [
                                              Text(
                                                'R\$',
                                                style: charPricePlanStyle,
                                              ),
                                            ],
                                          ),
                                        ),
                                        Text(
                                          getPrice(package),
                                          style: pricePlanStyle,
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: ScreenSize.height(1),
                                    ),
                                    Text(
                                      package.product.description,
                                      style: descriptionPlanStyle,
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(
                                      height: ScreenSize.height(1),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: ScreenSize.height(2),
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
    );
  }

  String getPrice(Package package) {
    String period = package.identifier.toString();
    String price = package.product.priceString.replaceAll('R\$', '');

    switch (period) {
      case '\$rc_annual':
        return '$price/ano';

      case '\$rc_monthly':
        return '$price/mês';

      default:
        return 'Plano de assinatura indisponível';
    }
  }

  String getPlanTime(Package package) {
    String period = package.identifier.toString();

    switch (period) {
      case '\$rc_annual':
        return 'ANUAL';

      case '\$rc_monthly':
        return 'MENSAL';

      default:
        return 'Error ao carregar esta opção';
    }
  }
}
