import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:nerdvalorant/mobile/screen_size.dart';
import 'package:nerdvalorant/models/notify_details.dart';
import 'package:nerdvalorant/themes/global_styles.dart';
import 'package:nerdvalorant/pages/settings/styles.dart';
import 'package:nerdvalorant/assets/media_source_tree.dart';
import 'package:intl/date_symbol_data_local.dart';

class MoreDetailsPage extends StatefulWidget {
  const MoreDetailsPage({Key? key}) : super(key: key);

  @override
  State<MoreDetailsPage> createState() => _MoreDetailsPageState();
}

class _MoreDetailsPageState extends State<MoreDetailsPage> {
  @override
  Widget build(BuildContext context) {
    ScreenSize.init(context);

    initializeDateFormatting('pt_BR', null);

    final notify = ModalRoute.of(context)!.settings.arguments as NotifyDetails;

    String formatBR = "dd 'de' MMMM 'de' yyyy";

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
                      'Detalhes da notificação',
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
                      stickerKilljoy,
                      width: ScreenSize.width(30),
                    ),
                    SizedBox(
                      height: ScreenSize.height(2),
                    ),
                    Text(
                      DateFormat(formatBR, 'pt_BR').format(notify.dateTime),
                      style: textStyle,
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
                          height: ScreenSize.height(2),
                        ),
                        SizedBox(
                          width: ScreenSize.screenWidth,
                          child: Text(
                            notify.title,
                            style: textStyle,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(
                          height: ScreenSize.height(2),
                        ),
                        SizedBox(
                          width: ScreenSize.screenWidth,
                          child: Text(
                            notify.body,
                            style: textStyle,
                            textAlign: TextAlign.center,
                          ),
                        ),
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
