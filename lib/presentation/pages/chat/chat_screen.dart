import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rasooc/domain/helper/enums.dart';
import 'package:rasooc/domain/helper/size_configs.dart';
import 'package:rasooc/domain/helper/utility.dart';
import 'package:rasooc/domain/providers/notification_state.dart';
import 'package:rasooc/presentation/common-widgets/common.dart';
import 'package:rasooc/presentation/pages/chat/notifications_screen.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    sizeConfig.init(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0.0,
        title: RText("Notifications", variant: TypographyVariant.titleSmall),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: GestureDetector(
              onTap: () async {
                final state =
                    Provider.of<NotificationState>(context, listen: false);
                final isCleared =
                    await state.clearNotifications(NotificationDecision.all);
                if (state.error.isNotEmpty || !isCleared) {
                  Utility.displaySnackbar(context,
                      msg:
                          "Some unexpected error occured while clearing notifications");
                }
              },
              child: Container(
                alignment: Alignment.centerLeft,
                height: kToolbarHeight,
                child: RText(
                  "Clear all",
                  variant: TypographyVariant.h3,
                ),
              ),
            ),
          ),
        ],
        // bottom: TabBar(
        //   controller: _tabController,
        //   indicatorColor: RColors.primaryColor,
        //   labelStyle: TextStyle(
        //     fontWeight: FontWeight.w500,
        //     fontSize: 16,
        //     height: 1.0,
        //     fontFamily: 'Roboto',
        //   ),
        //   labelColor: RColors.primaryColor,
        //   unselectedLabelColor: Colors.black,
        //   unselectedLabelStyle: TextStyle(
        //     fontWeight: FontWeight.w500,
        //     fontSize: 16,
        //     height: 1.0,
        //     fontFamily: 'Roboto',
        //   ),
        //   tabs: const [
        //     Tab(text: "Notifications"),
        //     Tab(text: "Messages"),
        //   ],
        // ),
      ),
      // body: TabBarView(
      //   controller: _tabController,
      //   children: [
      //     NotificationsScreen(),
      //     InfluencerChatScreen(),
      //   ],
      // ),
      body: NotificationsScreen(),
    );
  }
}
