import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:nerdvalorant/mobile/screen_size.dart';
import 'package:nerdvalorant/themes/global_styles.dart';
import 'package:nerdvalorant/pages/settings/styles.dart';
import 'package:nerdvalorant/assets/media_source_tree.dart';

class SubscriptionsPage extends StatefulWidget {
  const SubscriptionsPage({Key? key}) : super(key: key);

  @override
  State<SubscriptionsPage> createState() => _SubscriptionsPageState();
}

class _SubscriptionsPageState extends State<SubscriptionsPage> {
  @override
  Widget build(BuildContext context) {
    ScreenSize.init(context);

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
                      stickerOmen,
                      width: ScreenSize.width(30),
                    ),
                    SizedBox(height: ScreenSize.height(2)),
                    Text(
                      'Assinante Sem Patente',
                      style: textStyle,
                    ),
                    SizedBox(height: ScreenSize.height(2)),
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
                        SizedBox(height: ScreenSize.height(1)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Plano de assinatura',
                              style: textStyle,
                            ),
                            TextButton(
                              onPressed: () => {},
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
                        SizedBox(height: ScreenSize.height(1)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Assinatura Mensal',
                              style: textStyle,
                            ),
                            Text(
                              'R\$ 0,00',
                              style: textStyle,
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
}
