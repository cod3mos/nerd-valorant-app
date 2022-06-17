import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nerdvalorant/mobile/screen_size.dart';
import 'package:nerdvalorant/mobile/local_storage.dart';
import 'package:nerdvalorant/themes/global_styles.dart';
import 'package:nerdvalorant/pages/settings/styles.dart';
import 'package:nerdvalorant/assets/media_source_tree.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late bool notify;

  @override
  void initState() {
    super.initState();

    notify = LocalStorage.readBool('airplane_mode');
  }

  @override
  Widget build(BuildContext context) {
    ScreenSize.init(context);

    final user = ModalRoute.of(context)?.settings.arguments as User;

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
                      'Detalhes do conta',
                      style: titleStyle,
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 9,
                child: Column(
                  children: [
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
                              'Nome do usuário',
                              style: textStyle,
                            ),
                            Text(
                              '${user.displayName}',
                              style: textBoldStyle,
                            ),
                          ],
                        ),
                        SizedBox(height: ScreenSize.height(1)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'E-mail',
                              style: textStyle,
                            ),
                            Text(
                              '${user.email}',
                              style: textBoldStyle,
                            ),
                          ],
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
