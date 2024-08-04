import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rasooc/domain/helper/enums.dart';
import 'package:rasooc/domain/helper/size_configs.dart';
import 'package:rasooc/domain/helper/utility.dart';
import 'package:rasooc/domain/providers/submission_state.dart';
import 'package:rasooc/presentation/common-widgets/common.dart';
import 'package:rasooc/presentation/pages/submissions/add_caption_screen.dart';
import 'package:rasooc/presentation/pages/submissions/add_note_branc.dart';
import 'package:rasooc/presentation/pages/submissions/charges_info_screen.dart';
import 'package:rasooc/presentation/pages/submissions/widgets/add_image_video.dart';
import 'package:rasooc/presentation/themes/colors.dart';
import 'package:rasooc/presentation/themes/common_themes.dart';

class SubmissionPostDetail extends StatefulWidget {
  const SubmissionPostDetail({Key? key, this.socialType, this.submissionType})
      : super(key: key);

  final List<CampaignSocialType>? socialType;
  final CampaignSubmissionType? submissionType;

  @override
  _SubmissionPostDetailState createState() => _SubmissionPostDetailState();
}

class _SubmissionPostDetailState extends State<SubmissionPostDetail> {
  late TextEditingController _priceController;

  @override
  void dispose() {
    _priceController.dispose();
    super.dispose();
  }

  // final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _priceController = TextEditingController();
  }

  Widget _buildImageContainer(SubmissionState state) {
    return AddImageVideo(
      uploadType: widget.submissionType ?? CampaignSubmissionType.posts,
    );
  }

  Widget _buildWriteCaption(SubmissionState state) {
    return _onTapTexts(
      state.caption.isNotEmpty
          ? state.caption
          : "Write Your caption exactly the way you'd like to have it published.",
      () {
        Navigator.of(context).push(
          CupertinoPageRoute(
              builder: (_) => AddCaptionScreen(
                    socialType: widget.socialType!,
                  ),
              fullscreenDialog: true),
        );
      },
      color: state.caption.isNotEmpty ? Colors.black : RColors.disableColor,
    );
  }

  Widget _buildFeeToBePaid(SubmissionState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            RText(
              "Add the fee you'd like to be paid",
              variant: TypographyVariant.h3,
              style: TextStyle(color: RColors.secondaryColor),
            ),
            SizedBox(width: 10),
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(CupertinoPageRoute(
                    builder: (_) => ChargesInfoScreen(),
                    fullscreenDialog: true));
              },
              child: Icon(
                Icons.info_outline,
                size: 18,
                color: RColors.secondaryColor,
              ),
            ),
          ],
        ).pH(20),
        SizedBox(height: 5),
        Row(
          children: [
            RText("\$ ", variant: TypographyVariant.titleSmall),
            Expanded(
              child: TextFormField(
                autocorrect: false,
                controller: _priceController,
                textInputAction: TextInputAction.done,
                onEditingComplete: () {
                  FocusScope.of(context).unfocus();
                  state.setAmountToBePaid(_priceController.text);
                },
                style: RStyles.priceTextStyle,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "0",
                  hintStyle: RStyles.priceTextStyle
                      .copyWith(color: RColors.disableColor),
                ),
              ),
            ),
          ],
        ).pH(20)
      ],
    );
  }

  Widget _buildNotes(SubmissionState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RText(
          "Notes",
          variant: TypographyVariant.h3,
          style: TextStyle(color: RColors.secondaryColor),
        ),
        SizedBox(height: 5),
        _onTapTexts(
          state.noteForBrand.isNotEmpty
              ? state.noteForBrand
              : "Add a note for the brand",
          () {
            if (state.postFile.path.isNotEmpty ||
                state.caraouselImages.isNotEmpty) {
              Navigator.of(context).push(CupertinoPageRoute(
                  builder: (_) => AddNoteBrandScreen(
                        submissionType: widget.submissionType!,
                      ),
                  fullscreenDialog: true));
            } else {
              Utility.displaySnackbar(context, msg: "Please add an post first");
            }
          },
          color: state.noteForBrand.isNotEmpty
              ? Colors.black
              : RColors.disableColor,
        ),
      ],
    ).pH(20);
  }

  ///Generic function to handle similar styled texts
  ///with `onTap` function
  Widget _onTapTexts(String text, Function()? onTap,
      {Color color = RColors.disableColor}) {
    return GestureDetector(
      onTap: onTap,
      child: RText(
        text,
        variant: TypographyVariant.h3,
        style: TextStyle(color: color),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    sizeConfig.init(context);

    return Consumer<SubmissionState>(
      builder: (context, state, child) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildImageContainer(state),
          SizedBox(height: 20),
          _buildWriteCaption(state).pH(20),

          ///`Future functionality to be added by the client for Payment`
          ///`Uncomment this when needed fee module`

          // SizedBox(height: 20),
          // _buildFeeToBePaid(state),
          //

          SizedBox(height: 20),
          _buildNotes(state),
        ],
      ),
    );
  }
}
