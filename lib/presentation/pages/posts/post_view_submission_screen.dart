import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rasooc/domain/helper/size_configs.dart';
import 'package:rasooc/domain/helper/utility.dart';
import 'package:rasooc/domain/models/post_submissions_model.dart';
import 'package:rasooc/domain/providers/post_state.dart';
import 'package:rasooc/presentation/common-widgets/common.dart';
import 'package:rasooc/presentation/common-widgets/custom_cached_image.dart';
import 'package:rasooc/presentation/common-widgets/custom_divider.dart';
import 'package:rasooc/presentation/common-widgets/custom_loader.dart';
import 'package:rasooc/presentation/common-widgets/custom_no_data_container.dart';
import 'package:rasooc/presentation/common-widgets/custom_profile_tile.dart';
import 'package:rasooc/presentation/pages/message/message_screen.dart';
import 'package:rasooc/presentation/themes/common_themes.dart';
import 'package:video_player/video_player.dart';

class PostViewSubmissionScreen extends StatefulWidget {
  final int submissionId;

  const PostViewSubmissionScreen({Key? key, required this.submissionId})
      : super(key: key);
  @override
  _PostViewSubmissionScreenState createState() =>
      _PostViewSubmissionScreenState();
}

class _PostViewSubmissionScreenState extends State<PostViewSubmissionScreen> {
  late PostSubmissionsModel model;
  late VideoPlayerController videoPlayerController;

  @override
  void initState() {
    super.initState();
    getSubmissionDetails();
  }

  Future<void> getSubmissionDetails() async {
    final state = Provider.of<PostState>(context, listen: false);
    model = await state.getSubmissionDetail(widget.submissionId);

    if (state.error.isNotEmpty) {
      Utility.displaySnackbar(context,
          msg: "Some unexpected error occured while fetching details");
    }
    if (model.video != null) {
      videoPlayerController = VideoPlayerController.network(
        model.video!,
      )..initialize();
    }
  }

  ///`Short desc of the Pending submission`
  Widget _buildShortTile() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RText(
                model.createdAt?.toLocal().toString() ??
                    "18 Mar 2021, 11:00 am",
                variant: TypographyVariant.h4,
              ),
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(CupertinoPageRoute(
                          builder: (_) => MessageScreen(
                                submissionsModel: model,
                              )));
                    },
                    child: Icon(
                      Icons.chat_bubble,
                      size: 30,
                      color: RColors.primaryColor,
                    ),
                  ),
                  SizedBox(width: 10),
                  // GestureDetector(
                  //   child: Icon(
                  //     Icons.more_horiz,
                  //     size: 30,
                  //     color: RColors.primaryColor,
                  //   ),
                  // )
                ],
              ),
            ],
          ),
          SizedBox(height: 5),
          SizedBox(
            height: 65,
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: customNetworkImage(
                    model.coverImage ??
                        "https://cdn.pixabay.com/photo/2020/09/16/11/48/donkeys-5576167_1280.jpg",
                    height: 52,
                    width: 52,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  flex: 3,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RText(
                        "Submitted to",
                        variant: TypographyVariant.h3,
                        style: TextStyle(
                            fontSize: 12, color: RColors.secondaryColor),
                      ),
                      RText(
                        model.title ?? "Brand Name",
                        variant: TypographyVariant.h1,
                        style: TextStyle(fontSize: 15),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      )
                    ],
                  ),
                ),
                Spacer(),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildPostDetail() {
    return Container(
      padding: EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RProfileTile(
            followersCount: model.accountDetails?.followersCount ?? 3,
            profilePic: model.accountDetails?.profilePictureUrl ??
                "https://cdn.pixabay.com/photo/2020/09/03/14/43/pollination-5541489_1280.jpg",
            accountType: model.accountType,
            userName: model.accountDetails?.username ?? "cutie_pie1997",
          ),
          SizedBox(height: 10),
          AspectRatio(
            aspectRatio: 1.0,
            child: Container(
              child: model.image != null
                  ? customNetworkImage(
                      model.image ??
                          "https://cdn.pixabay.com/photo/2021/04/21/01/53/mother-6195216_1280.jpg",
                      fit: BoxFit.cover,
                    )
                  : model.carousel != null
                      ? PageView.builder(
                          itemCount: model.carousel?.length,
                          itemBuilder: (context, index) => customNetworkImage(
                            model.carousel?[index] ??
                                "https://cdn.pixabay.com/photo/2021/04/21/01/53/mother-6195216_1280.jpg",
                            fit: BoxFit.cover,
                          ),
                        )
                      : VideoPlayer(videoPlayerController),
            ),
          ),
          SizedBox(height: 10),
          RText(
            model.caption ?? "Write your caption like you would...",
            variant: TypographyVariant.h3,
          ),
        ],
      ),
    ).pH(10);
  }

  @override
  Widget build(BuildContext context) {
    sizeConfig.init(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          color: Colors.black,
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 0.0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        centerTitle: true,
        title: RText(
          "View Submission",
          variant: TypographyVariant.titleSmall,
        ),
      ),
      body: Consumer<PostState>(
        builder: (context, state, child) => state.isLoading
            ? Center(
                child: RLoader(),
              )
            : model.id != null
                ? Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: RColors.addImageColor,
                      // color: Colors.red,
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildShortTile(),
                          RDivider(),
                          _buildPostDetail(),
                        ],
                      ),
                    ),
                  ).pH(20)
                : Center(
                    child: RNoDataContainer(
                      headingTitle: "We cannot find the submission right now.",
                      subHeading:
                          "Please contact the support to raise concern.",
                    ),
                  ),
      ),
    );
  }
}
