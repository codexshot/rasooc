import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rasooc/domain/providers/notification_state.dart';
import 'package:rasooc/presentation/common-widgets/custom_loader.dart';
import 'package:rasooc/presentation/common-widgets/custom_no_data_container.dart';
import 'package:rasooc/presentation/pages/chat/widgets/notification_tile.dart';

class NotificationsScreen extends StatefulWidget {
  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  void initState() {
    super.initState();
    fetchNotifications();
  }

  Future<void> fetchNotifications() async {
    final state = Provider.of<NotificationState>(context, listen: false);
    await state.getNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<NotificationState>(
      builder: (context, state, _) => state.isLoading
          ? Center(child: RLoader())
          : state.notifications.isNotEmpty
              ? SingleChildScrollView(
                  child: Column(
                      children: state.notifications
                          .map((model) => NotificationTile(
                                notificationsModel: model,
                              ))
                          .toList()),
                )
              : Center(
                  child: state.error.isNotEmpty
                      ? const RNoDataContainer(
                          headingTitle: "Some unexpected error occured",
                          subHeading: "",
                        )
                      : const RNoDataContainer(
                          headingTitle: "Its looks there's nothing",
                          subHeading: "Here's where your notifications live",
                        ),
                ),
    );
  }
}
