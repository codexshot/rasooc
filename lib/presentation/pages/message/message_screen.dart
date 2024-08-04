import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:rasooc/domain/helper/shared_pref_helper.dart';
import 'package:rasooc/domain/helper/utility.dart';
import 'package:rasooc/domain/models/chat_model.dart';
import 'package:rasooc/domain/models/post_submissions_model.dart';
import 'package:rasooc/domain/providers/chat_state.dart';
import 'package:rasooc/infra/resource/service/notification_service.dart';
import 'package:rasooc/presentation/common-widgets/common.dart';
import 'package:rasooc/presentation/common-widgets/custom_cached_image.dart';
import 'package:rasooc/presentation/common-widgets/custom_loader.dart';
import 'package:rasooc/presentation/common-widgets/custom_no_data_container.dart';
import 'package:rasooc/presentation/pages/posts/widgets/post_app_bar.dart';
import 'package:rasooc/presentation/themes/colors.dart';
import 'package:rasooc/presentation/themes/images.dart';
import 'package:rasooc/presentation/themes/styles.dart';

///`Generic message screen`
class MessageScreen extends StatefulWidget {
  final PostSubmissionsModel submissionsModel;

  const MessageScreen({Key? key, required this.submissionsModel})
      : super(key: key);

  @override
  _MessageScreenState createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  final TextEditingController _messageController = TextEditingController();

  int maxLines = 1;
  int breakCharacter = 30;
  bool isLoading = true;
  int id = 0;
  List<ChatModel> _intialData = [];

  @override
  void initState() {
    super.initState();
    getSubmissionComments();
  }

  Future<void> getSubmissionComments() async {
    final user = await SharedPreferenceHelper().getUserProfile();
    id = user?.userId ?? 0;

    final state = Provider.of<ChatState>(context, listen: false);
    final list = await state.getSubmissionComments(widget.submissionsModel.id!);
    _intialData = List.from(list);
    setState(() {
      isLoading = false;
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<ChatState>(context, listen: false);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PostAppBar(
        title: "Feedback",
        onLeadingPress: () {
          Navigator.of(context).pop();
        },
      ),
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.topRight,
              child: StreamBuilder<List<ChatModel>>(
                  stream: Stream.periodic(Duration(seconds: 1)).asyncMap(
                      (event) => state
                          .getSubmissionComments(widget.submissionsModel.id!)),
                  initialData: _intialData,
                  builder: (context, snapshot) {
                    final chats = snapshot.data;
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: RLoader(),
                      );
                    } else {
                      return chats != null && chats.isNotEmpty
                          ? SingleChildScrollView(
                              child: Column(
                                  children: chats.map((message) {
                                return _buildMessage(message);
                              }).toList()),
                            )
                          : SizedBox(
                              height: MediaQuery.of(context).size.height * 0.80,
                              child: Center(
                                child: RNoDataContainer(
                                  headingTitle: "Sorry!!! no comments here",
                                  subHeading:
                                      "Your chat for this submission will be here",
                                ),
                              ),
                            );
                    }
                  }),
            ),
            _bottomEntryField()
          ],
        ),
      ),
    );
  }

  Widget _bottomEntryField() {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: RColors.primaryColor,
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 2.0,
                offset: Offset(0.0, 2.0),
              )
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Divider(
                thickness: 0,
                height: 1,
              ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      maxLines: 5,
                      minLines: 1,
                      style: RStyles.inputText.copyWith(color: Colors.white),
                      controller: _messageController,
                      keyboardType: TextInputType.multiline,
                      decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 30, vertical: 13),
                        alignLabelWithHint: true,
                        hintText: "Start message...",
                        hintStyle: RStyles.hintTextStyle
                            .copyWith(color: Colors.white, fontSize: 16),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.send,
                      color: Colors.white,
                    ),
                    onPressed: () async {
                      if (_messageController.text.isNotEmpty) {
                        final state =
                            Provider.of<ChatState>(context, listen: false);
                        FocusScope.of(context).unfocus();
                        await state.submitComment(widget.submissionsModel.id!,
                            _messageController.text);
                        _messageController.clear();
                        if (state.error.isNotEmpty) {
                          Utility.displaySnackbar(context,
                              msg:
                                  "Some unexpected error occured. Please try again later");
                        }
                      }
                    },
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMessage(ChatModel chatModel) {
    bool isMe = true;
    if (id == chatModel.userId) {
      isMe = true;
    } else {
      isMe = false;
    }

    print(isMe);
    return Padding(
      padding: isMe ? EdgeInsets.only(right: 5.0) : EdgeInsets.only(left: 5.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (isMe)
            SizedBox()
          else
            SvgPicture.asset(
              RImages.userImage,
              height: 30,
            ),
          Container(
            margin: isMe
                ? EdgeInsets.only(top: 8.0, bottom: 8.0, left: 80, right: 5.0)
                : EdgeInsets.only(top: 8.0, bottom: 8.0, right: 80, left: 5.0),
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 10),
            decoration: BoxDecoration(
              borderRadius: isMe
                  ? BorderRadius.only(
                      topLeft: Radius.circular(12.0),
                      topRight: Radius.circular(12.0),
                      bottomLeft: Radius.circular(12.0),
                    )
                  : BorderRadius.only(
                      topLeft: Radius.circular(12.0),
                      topRight: Radius.circular(12.0),
                      bottomRight: Radius.circular(12.0),
                    ),
              color: isMe ? Colors.grey[400] : RColors.primaryColor,
            ),
            child: RText(
              chatModel.comment ?? "Error",
              variant: TypographyVariant.h2,
              style: TextStyle(
                  color: chatModel.comment != null ? Colors.white : Colors.red),
            ),
          ),
          if (isMe)
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: customNetworkImage(
                widget.submissionsModel.accountDetails?.profilePictureUrl ??
                    "https://cdn.pixabay.com/photo/2018/10/15/14/58/cheetah-3749168_1280.jpg",
                height: 30,
                width: 30,
                fit: BoxFit.cover,
              ),
            )
          else
            SizedBox()
        ],
      ),
    );
  }
}
