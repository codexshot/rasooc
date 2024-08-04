import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rasooc/domain/helper/enums.dart';
import 'package:rasooc/domain/helper/utility.dart';
import 'package:rasooc/domain/models/post_submissions_model.dart';
import 'package:rasooc/domain/providers/social_account_state.dart';
import 'package:rasooc/domain/providers/submission_state.dart';
import 'package:rasooc/presentation/common-widgets/common.dart';
import 'package:rasooc/presentation/common-widgets/overlay_loader.dart';
import 'package:rasooc/presentation/pages/submissions/complete_submission.dart';
import 'package:rasooc/presentation/pages/submissions/widgets/submission_connected_accounts.dart';
import 'package:rasooc/presentation/pages/submissions/widgets/submission_post_detail.dart';
import 'package:rasooc/presentation/themes/common_themes.dart';
import 'package:rasooc/domain/providers/post_state.dart';

class EditPendingSubmissionScreen extends StatefulWidget {
  const EditPendingSubmissionScreen({Key? key, required this.submissionId})
      : super(key: key);

  final int submissionId;

  @override
  _EditPendingSubmissionScreenState createState() =>
      _EditPendingSubmissionScreenState();
}

class _EditPendingSubmissionScreenState
    extends State<EditPendingSubmissionScreen> {
  final ValueNotifier<bool> _isLoading = ValueNotifier<bool>(false);
  PostSubmissionsModel model = PostSubmissionsModel();

  @override
  void dispose() {
    _isLoading.dispose();
    super.dispose();
  }

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
          msg:
              "Sorry, we are not able to get the submission details you requested at the moment");
    }
  }

  void setDetails() {
    final socialAccountState =
        Provider.of<SocialAccountState>(context, listen: false);
    final subState = Provider.of<SubmissionState>(context, listen: false);
  }

  ///`Submitting submissions`
  Future<void> submitSubmission(
      SocialAccountState socialState, SubmissionState subState) async {
    if (socialState.selectedInstaAccount.instagramId != null ||
        socialState.selectedFBAccount.pageId != null ||
        socialState.selectedTwitterAccount.userId != null) {
      if (subState.caption.isNotEmpty) {
        if (subState.noteForBrand.isNotEmpty) {
          if (subState.postFile.path.isNotEmpty ||
              subState.caraouselImages.isNotEmpty) {
            if (socialState.selectedInstaAccount.instagramId != null) {
              _isLoading.value = true;
              if (subState.caraouselImages.isNotEmpty &&
                  subState.caraouselImages.length < 2) {
                _isLoading.value = false;
                Utility.displaySnackbar(context,
                    msg: "Carousel should atleast have 2 images");
                return;
              } else {
                await subState.submitSubmission(CampaignSocialType.instagram,
                    socialState.selectedInstaAccount);
              }
            } else if (socialState.selectedFBAccount.pageId != null) {
              _isLoading.value = true;
              await subState.submitSubmission(
                  CampaignSocialType.facebook, socialState.selectedFBAccount);
            } else {
              _isLoading.value = true;

              await subState.submitSubmission(CampaignSocialType.twitter,
                  socialState.selectedTwitterAccount);
            }

            _isLoading.value = false;
            if (subState.error.isNotEmpty) {
              Utility.displaySnackbar(context, msg: subState.error);
            } else {
              Navigator.of(context).pushAndRemoveUntil(
                  CupertinoPageRoute(
                      builder: (_) => CompleteSubmissionScreen()),
                  (route) => false);
              socialState.clearState();
              subState.clearState();
            }
          } else {
            // Utility.displaySnackbar(context,
            //     msg: "Please add an ${widget.submissionType?.asString()}");
          }
        } else {
          Utility.displaySnackbar(context,
              msg: "Note for the brand cannot be empty");
        }
      } else {
        Utility.displaySnackbar(context, msg: "Caption cannot be empty");
      }
    } else {
      Utility.displaySnackbar(context,
          msg: "Please select an account to continue");
    }
  }

  Widget _buildTopBar(BuildContext context) {
    return SizedBox(
      height: kToolbarHeight,
      width: double.maxFinite,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () async {
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: RText(
                      "Are you sure you want to discard your submission?",
                      variant: TypographyVariant.h1),
                  actions: [
                    TextButton(
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all<OutlinedBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        backgroundColor: MaterialStateProperty.all<Color>(
                          RColors.primaryColor,
                        ),
                      ),
                      onPressed: () {
                        Provider.of<SubmissionState>(context, listen: false)
                            .clearState();
                        Provider.of<SocialAccountState>(context, listen: false)
                            .clearState();
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                      },
                      child: RText(
                        "Discard",
                        variant: TypographyVariant.h1,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    TextButton(
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all<OutlinedBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        backgroundColor: MaterialStateProperty.all<Color>(
                          RColors.redColor,
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: RText(
                        "Cancel",
                        variant: TypographyVariant.h1,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              );
            },
            child: RText(
              "Cancel",
              variant: TypographyVariant.h2,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const title = "Post";

    return WillPopScope(
      onWillPop: () async {
        Provider.of<SubmissionState>(context, listen: false).clearState();
        Provider.of<SocialAccountState>(context, listen: false).clearState();
        return true;
      },
      child: Scaffold(
        body: SafeArea(
          child: Consumer2<SubmissionState, SocialAccountState>(
            builder: (context, subState, socialState, child) => Stack(
              children: [
                SingleChildScrollView(
                  padding: EdgeInsets.only(bottom: 40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTopBar(context).pH(20),
                      SizedBox(height: 20),
                      RText("Edit $title",
                              variant: TypographyVariant.titleSmall)
                          .pH(20),
                      SizedBox(height: 20),
                      SubmissionConnectedAccounts(
                              // submissionType: widget.submissionType,
                              // socialType: widget.socialType,
                              )
                          .pH(20),
                      SizedBox(height: 20),
                      SubmissionPostDetail(
                          // submissionType: widget.submissionType,
                          // socialType: widget.socialType,
                          ),
                      SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 22.0),
                        child: SizedBox(
                          height: 48,
                          width: double.maxFinite,
                          child: FlatButton(
                            color: const Color(0xff27DEBF),
                            textColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(32.0)),
                            onPressed: () async {
                              await submitSubmission(socialState, subState);
                            },
                            child: RText(
                              "UPDATE",
                              variant: TypographyVariant.h1,
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                OverlayLoading(
                  showLoader: _isLoading,
                  loadingMessage: "Submitting...",
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
