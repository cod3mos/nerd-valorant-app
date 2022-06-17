import 'package:flutter/material.dart';
import 'package:nerdvalorant/mobile/screen_size.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:nerdvalorant/themes/global_styles.dart';
import 'package:nerdvalorant/models/notify_details.dart';
import 'package:nerdvalorant/pages/notifications/styles.dart';

class NotifyMessage extends StatelessWidget {
  const NotifyMessage({
    Key? key,
    required this.data,
    required this.onReady,
    required this.onDelete,
    required this.openMessage,
  }) : super(key: key);

  final NotifyDetails data;
  final Function(NotifyDetails) onReady;
  final Function(NotifyDetails) onDelete;
  final Function(NotifyDetails) openMessage;

  @override
  Widget build(BuildContext context) {
    return Slidable(
      startActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            spacing: 2,
            onPressed: (_) => onDelete(data),
            label: 'Excluir',
            foregroundColor: whiteColor,
            backgroundColor: Colors.red,
          ),
        ],
      ),
      endActionPane: data.ready
          ? null
          : ActionPane(
              motion: const ScrollMotion(),
              children: [
                SlidableAction(
                  spacing: 2,
                  onPressed: (_) => onReady(data),
                  label: 'Marcar como lida',
                  foregroundColor: whiteColor,
                  backgroundColor: greenColor,
                ),
              ],
            ),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: whiteColor,
                  width: 1.0,
                ),
              ),
            ),
            height: ScreenSize.height(12),
            child: TextButton(
              onPressed: () => openMessage(data),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: ScreenSize.screenWidth,
                    child: Text(
                      data.title,
                      maxLines: 1,
                      style: data.ready
                          ? notifyTitleOvershadowedStyle
                          : notifyTitleStyle,
                      textAlign: TextAlign.left,
                    ),
                  ),
                  SizedBox(
                    height: ScreenSize.height(.5),
                    width: ScreenSize.screenWidth,
                  ),
                  SizedBox(
                    width: ScreenSize.screenWidth,
                    child: Text(
                      data.body,
                      maxLines: 3,
                      style: data.ready
                          ? notifyTextOvershadowedStyle
                          : notifyTextStyle,
                      textAlign: TextAlign.justify,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
