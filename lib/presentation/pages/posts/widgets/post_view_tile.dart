import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rasooc/domain/helper/enums.dart';
import 'package:rasooc/domain/helper/size_configs.dart';
import 'package:rasooc/domain/models/post_submissions_model.dart';
import 'package:rasooc/presentation/common-widgets/common.dart';
import 'package:rasooc/presentation/common-widgets/custom_cached_image.dart';
import 'package:rasooc/presentation/common-widgets/custom_divider.dart';
import 'package:rasooc/presentation/common-widgets/custom_profile_tile.dart';
import 'package:rasooc/presentation/pages/message/message_screen.dart';
import 'package:rasooc/presentation/themes/colors.dart';
import 'package:rasooc/presentation/themes/common_themes.dart';
import 'package:video_player/video_player.dart';

///`Generic view tile for every screen under POSTS`
///`This is not tappable & non-editable field`
class PostViewTile extends StatefulWidget {
  final PostSubmissionsModel postSubmissionsModel;
  final bool isExtended;
  final Function()? onPressed;

  const PostViewTile(
      {Key? key,
      required this.postSubmissionsModel,
      this.isExtended = false,
      this.onPressed})
      : super(key: key);
  @override
  _PostViewTileState createState() => _PostViewTileState();
}

class _PostViewTileState extends State<PostViewTile> {
  bool showDetail = false;
  late PostSubmissionsModel model;
  late VideoPlayerController videoPlayerController;

  @override
  void initState() {
    super.initState();
    model = widget.postSubmissionsModel;
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
                                submissionsModel: widget.postSubmissionsModel,
                              )));
                    },
                    child: Icon(
                      Icons.chat_bubble,
                      size: 30,
                      color: RColors.primaryColor,
                    ),
                  ),
                  if (widget.isExtended) SizedBox(width: 10) else SizedBox(),
                  if (widget.isExtended)
                    GestureDetector(
                      onTap: widget.onPressed,
                      child: Icon(
                        Icons.more_horiz,
                        size: 30,
                        color: RColors.primaryColor,
                      ),
                    )
                  else
                    SizedBox(),
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
                ElevatedButton(
                    style: ButtonStyle(
                      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                          EdgeInsets.symmetric(horizontal: 20)),
                      shape: MaterialStateProperty.all<OutlinedBorder>(
                          RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      )),
                      backgroundColor: MaterialStateProperty.all<Color>(
                          RColors.primaryColor),
                    ),
                    onPressed: () {
                      setState(() {
                        showDetail = !showDetail;
                      });
                    },
                    child: RText(
                      showDetail ? "Close" : "View",
                      variant: TypographyVariant.h3,
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ))
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
            model.caption ?? "Error: Some unxpected data",
            variant: TypographyVariant.h3,
          ),
        ],
      ),
    ).pH(10);
  }

  @override
  Widget build(BuildContext context) {
    sizeConfig.init(context);
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: RColors.addImageColor,
        // color: Colors.red,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildShortTile(),
          if (showDetail) RDivider() else SizedBox(),
          if (showDetail) _buildPostDetail() else SizedBox(),
        ],
      ),
    ).pH(20);
  }
}
