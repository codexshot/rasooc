import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rasooc/domain/helper/enums.dart';
import 'package:rasooc/domain/helper/utility.dart';
import 'package:rasooc/domain/models/post_submissions_model.dart';
import 'package:rasooc/domain/providers/post_state.dart';
import 'package:rasooc/presentation/common-widgets/common.dart';
import 'package:rasooc/presentation/common-widgets/custom_divider.dart';
import 'package:rasooc/presentation/common-widgets/custom_loader.dart';
import 'package:rasooc/presentation/common-widgets/custom_no_data_container.dart';
import 'package:rasooc/presentation/pages/posts/widgets/post_app_bar.dart';
import 'package:rasooc/presentation/pages/posts/widgets/post_view_tile.dart';
import 'package:rasooc/presentation/themes/common_themes.dart';

class ApprovedPostScreen extends StatefulWidget {
  @override
  _ApprovedPostScreenState createState() => _ApprovedPostScreenState();
}

class _ApprovedPostScreenState extends State<ApprovedPostScreen> {
  final ValueNotifier<bool> _isLoading = ValueNotifier<bool>(false);
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();
  final TextEditingController _instagramUrlController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _isLoading.dispose();
    _instagramUrlController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    getApprovedSubmissions();
  }

  Future<void> publishStoryAndCarousel(PostSubmissionsModel model) async {
    showDialog(
        context: context,
        builder: (_) => Form(
              key: _formKey,
              child: AlertDialog(
                title: RText(
                  "Are you sure you want to publish your submission? Please enter your instagram story or post link here for this submission",
                  variant: TypographyVariant.h1,
                ),
                content: Container(
                  height: 100,
                  width: double.infinity,
                  // color: Colors.red,
                  child: TextFormField(
                    controller: _instagramUrlController,
                    cursorColor: RColors.primaryColor,
                    style: RStyles.inputText,
                    validator: (value) {
                      if (value != null && value.isNotEmpty) {
                        return null;
                      } else {
                        return "URL cannot be empty";
                      }
                    },
                    decoration: InputDecoration(
                      focusColor: RColors.primaryColor,
                      hintText: "Paste your instagram media link here",
                      hintStyle: RStyles.hintTextStyle.copyWith(fontSize: 15),
                    ),
                  ),
                ),
                actions: [
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
                      final isValidated = _formKey.currentState!.validate();
                      if (isValidated) {
                        //CALLING PUBLISHING
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                        _isLoading.value = true;
                        final state =
                            Provider.of<PostState>(context, listen: false);

                        //Carousel/Stories
                        print("Carousel/Stories");
                        await state.publishStoryAndCarousel(
                            _instagramUrlController.text, model);
                        if (state.error.isNotEmpty) {
                          _isLoading.value = false;
                          Utility.displaySnackbar(context,
                              msg:
                                  "Some unexpected error occured. Please try again later",
                              key: _scaffoldKey);
                        } else {
                          await state
                              .getSubmissionList(SubmissionStatus.approved);
                          _isLoading.value = false;
                          if (state.error.isNotEmpty) {
                            Utility.displaySnackbar(context,
                                msg:
                                    "Some unexpected error occured. Please try again later",
                                key: _scaffoldKey);
                          }
                        }
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
                      _instagramUrlController.clear();
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
              ),
            ));
  }

  Future<void> publishPost(PostSubmissionsModel submissionsModel) async {
    showDialog(
        context: context,
        builder: (context) {
          return Form(
            key: _formKey,
            child: AlertDialog(
              title: RText("Are you sure you want to publish your submission?",
                  variant: TypographyVariant.h1),
              actions: [
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
                    //CALLING PUBLISHING
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                    _isLoading.value = true;
                    final state =
                        Provider.of<PostState>(context, listen: false);

                    if (submissionsModel.accountType ==
                        CampaignSocialType.twitter) {
                      //TWITTER
                      print("TWITTER");
                      // await state.publishToTwitter(submissionsModel);
                    } else {
                      //INSTA/FACEBOOK POST
                      print("INSTA/FACEBOOK POST");
                      // await state.publishSingleMedia(submissionsModel);
                    }

                    if (state.error.isNotEmpty) {
                      _isLoading.value = false;
                      Utility.displaySnackbar(context,
                          msg:
                              "Some unexpected error occured. Please try again later",
                          key: _scaffoldKey);
                    } else {
                      await state.getSubmissionList(SubmissionStatus.approved);
                      _isLoading.value = false;
                      if (state.error.isNotEmpty) {
                        Utility.displaySnackbar(context,
                            msg:
                                "Some unexpected error occured. Please try again later",
                            key: _scaffoldKey);
                      }
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
            ),
          );
        });
  }

  Future<void> getApprovedSubmissions() async {
    _isLoading.value = true;
    final state = Provider.of<PostState>(context, listen: false);
    await state.getSubmissionList(SubmissionStatus.approved);
    _isLoading.value = false;
    if (state.error.isNotEmpty) {
      Utility.displaySnackbar(context,
          msg: "Some unexpected error occured. Please try again later");
    }
  }

  Future<void> showModelSheet(PostSubmissionsModel submissionsModel) async {
    await showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: () async {
                if (submissionsModel.submissionType ==
                    CampaignSubmissionType.posts) {
                  await publishPost(submissionsModel);
                } else {
                  print("TEST");
                  await publishStoryAndCarousel(submissionsModel);
                }
              },
              child: Column(
                children: [
                  SizedBox(height: 10),
                  RText("Publish Submission", variant: TypographyVariant.h1),
                  SizedBox(height: 10),
                ],
              ),
            ),
            RDivider(),
            GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Column(
                children: [
                  SizedBox(height: 10),
                  RText(
                    "Cancel",
                    variant: TypographyVariant.h1,
                    style: TextStyle(color: RColors.redColor),
                  ),
                  SizedBox(height: 10),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: PostAppBar(
        title: "Approved Post",
        onLeadingPress: () {
          Navigator.of(context).pop();
        },
      ),
      body: ValueListenableBuilder<bool>(
        valueListenable: _isLoading,
        builder: (context, isLoading, _) => isLoading
            ? Center(child: RLoader())
            : Consumer<PostState>(
                builder: (context, state, _) =>
                    state.listOfSubmissions.isNotEmpty
                        ? SingleChildScrollView(
                            child: Column(
                              children: state.listOfSubmissions
                                  .map(
                                    (model) => PostViewTile(
                                      postSubmissionsModel: model,
                                      isExtended: true,
                                      onPressed: () {
                                        showModelSheet(model);
                                      },
                                    ),
                                  )
                                  .toList(),
                            ),
                          )
                        : Center(
                            child: RNoDataContainer(
                              headingTitle: "No Approved Posts",
                              subHeading:
                                  "Your approved posts will be available here",
                            ),
                          ),
              ),
      ),
    );
  }
}
