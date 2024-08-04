import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:rasooc/domain/helper/enums.dart';
import 'package:rasooc/domain/helper/utility.dart';
import 'package:rasooc/domain/models/notifications_model.dart';
import 'package:rasooc/domain/providers/notification_state.dart';
import 'package:rasooc/presentation/common-widgets/common.dart';
import 'package:rasooc/presentation/common-widgets/custom_cached_image.dart';
import 'package:rasooc/presentation/pages/posts/post_view_submission_screen.dart';
import 'package:rasooc/presentation/themes/common_themes.dart';

class NotificationTile extends StatefulWidget {
  final NotificationsModel notificationsModel;

  const NotificationTile({Key? key, required this.notificationsModel})
      : super(key: key);

  @override
  _NotificationTileState createState() => _NotificationTileState();
}

class _NotificationTileState extends State<NotificationTile> {
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(widget.notificationsModel.id),
      background: Container(
        color: Colors.red,
      ),
      confirmDismiss: (dierction) {
        return showDialog<bool>(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Remove notification?'),
              content: Text('This notification will be cleared'),
              actions: <Widget>[
                TextButton(
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all<OutlinedBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      backgroundColor: MaterialStateProperty.all<Color>(
                        RColors.primaryColor,
                      )),
                  onPressed: () async {
                    final state =
                        Provider.of<NotificationState>(context, listen: false);
                    final isCleared = await state.clearNotifications(
                        NotificationDecision.single,
                        id: widget.notificationsModel.id!);
                    if (state.error.isNotEmpty || !isCleared) {
                      print("HERE");
                      Navigator.of(context).pop(false);
                      Utility.displaySnackbar(context,
                          msg:
                              "Some unexpected error occured while clearing notifications");
                    } else {
                      Navigator.of(context).pop(true);
                    }
                  },
                  child: RText(
                    "Sure",
                    variant: TypographyVariant.h1,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                TextButton(
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all<OutlinedBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      backgroundColor: MaterialStateProperty.all<Color>(
                        RColors.redColor,
                      )),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: RText(
                    "Cancel",
                    variant: TypographyVariant.h1,
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            );
          },
        );
      },
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(
            CupertinoPageRoute(
              builder: (context) => PostViewSubmissionScreen(
                submissionId: widget.notificationsModel.submissionId!,
              ),
            ),
          );
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          margin: EdgeInsets.only(bottom: 5.0),
          color: Colors.grey[100],
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(6.0),
                child: customNetworkImage(
                  widget.notificationsModel.notificationImageUrl,
                  height: 52,
                  width: 52,
                  fit: BoxFit.cover,
                  defaultHolder: Container(
                    color: Colors.red,
                    height: 52,
                    width: 52,
                  ),
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                  child: SizedBox(
                height: 50,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    RText(
                      widget.notificationsModel.body ??
                          "Error: Something went wrong",
                      variant: TypographyVariant.h3,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    RText(
                      widget.notificationsModel.createdAt ??
                          "Error: Something went wrong",
                      variant: TypographyVariant.h4,
                      style: TextStyle(color: RColors.secondaryColor),
                      textAlign: TextAlign.end,
                    ),
                  ],
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }
}
