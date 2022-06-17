import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:nerdvalorant/mobile/screen_size.dart';
import 'package:nerdvalorant/mobile/local_storage.dart';
import 'package:nerdvalorant/themes/global_styles.dart';
import 'package:nerdvalorant/models/notify_details.dart';
import 'package:nerdvalorant/assets/media_source_tree.dart';
import 'package:nerdvalorant/pages/notifications/styles.dart';
import 'package:nerdvalorant/pages/notifications/widgets/notify_message.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({Key? key}) : super(key: key);

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  late List<NotifyDetails> notifyDetails;

  NotifyDetails? deletedItem;
  int? deletedIndex;

  @override
  void initState() {
    super.initState();

    notifyDetails = LocalStorage.readNotifications();
  }

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
                      'Notificações',
                      style: titleStyle,
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 9,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        color: notifyDetails.isEmpty
                            ? const Color(0xFF38393F)
                            : whiteColor,
                        width: 1.0,
                      ),
                    ),
                  ),
                  child: notifyDetails.isEmpty
                      ? Center(
                          child: Text(
                            'Não existem mais notificações :(',
                            style: textStyle,
                          ),
                        )
                      : Column(
                          children: [
                            Expanded(
                              child: ListView(
                                children: [
                                  for (var notification in notifyDetails)
                                    NotifyMessage(
                                      data: notification,
                                      onReady: onReady,
                                      onDelete: onDelete,
                                      openMessage: openMessage,
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
      ),
    );
  }

  void openMessage(NotifyDetails notify) {
    setState(() => notifyDetails[notifyDetails.indexOf(notify)].setReady(true));

    LocalStorage.writeNotifications(notifyDetails);

    Navigator.pushNamed(context, '/more_details', arguments: notify);
  }

  void onReady(NotifyDetails notify) {
    setState(() => notifyDetails[notifyDetails.indexOf(notify)].setReady(true));

    LocalStorage.writeNotifications(notifyDetails);

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Notificação marcada como lida',
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

  void onDelete(NotifyDetails notify) {
    deletedItem = notify;
    deletedIndex = notifyDetails.indexOf(notify);

    setState(() => notifyDetails.remove(notify));

    LocalStorage.writeNotifications(notifyDetails);

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Notificação removida com sucesso!',
          style: TextStyle(
            color: whiteColor,
          ),
        ),
        backgroundColor: Colors.red,
        action: SnackBarAction(
          onPressed: () {
            setState(() => notifyDetails.insert(deletedIndex!, deletedItem!));

            LocalStorage.writeNotifications(notifyDetails);
          },
          label: 'Desfazer',
          textColor: whiteColor,
        ),
        duration: const Duration(
          seconds: 2,
        ),
      ),
    );
  }
}
