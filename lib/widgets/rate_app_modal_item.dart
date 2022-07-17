import 'package:flutter/material.dart';
import 'package:nerdvalorant/keys/keys.dart';
import 'package:rate_my_app/rate_my_app.dart';

class RateAppModalItem extends StatefulWidget {
  const RateAppModalItem({Key? key, required this.builder}) : super(key: key);

  final Widget Function(RateMyApp) builder;

  @override
  State<RateAppModalItem> createState() => _RateAppModalItemState();
}

class _RateAppModalItemState extends State<RateAppModalItem> {
  RateMyApp? rateMyApp;

  @override
  Widget build(BuildContext context) {
    return RateMyAppBuilder(
      rateMyApp: RateMyApp(
        minDays: 0,
        minLaunches: 3,
        googlePlayIdentifier: packageName,
      ),
      onInitialized: (context, rateMyApp) {
        setState(() => this.rateMyApp = rateMyApp);

        if (rateMyApp.shouldOpenDialog) {
          rateMyApp.showRateDialog(
            context,
            title: '3ª vez por aqui, já pode pedir música!',
            message:
                'Se curtiu este app, por favor reserve um minuto para nos avaliar.\n\nNão se esqueça, é através do seu feedback que conseguimos trazer cada vez mais melhorias.',
            rateButton: 'AVALIAR',
            noButton: 'NÃO OBRIGADO',
            laterButton: 'AGORA NÃO',
            dialogStyle: const DialogStyle(
              titleAlign: TextAlign.justify,
              messageAlign: TextAlign.justify,
            ),
          );
        }
      },
      builder: (context) => rateMyApp == null
          ? const Center(child: CircularProgressIndicator())
          : widget.builder(rateMyApp!),
    );
  }
}
