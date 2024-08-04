import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:provider/provider.dart';
import 'package:rasooc/domain/helper/enums.dart';
import 'package:rasooc/domain/helper/size_configs.dart';
import 'package:rasooc/domain/helper/utility.dart';
import 'package:rasooc/domain/providers/submission_state.dart';
import 'package:rasooc/presentation/common-widgets/common.dart';
import 'package:rasooc/presentation/common-widgets/custom_divider.dart';
import 'package:rasooc/presentation/themes/common_themes.dart';
import 'package:video_player/video_player.dart';

class AddImageVideo extends StatefulWidget {
  final CampaignSubmissionType uploadType;

  const AddImageVideo({Key? key, required this.uploadType}) : super(key: key);
  @override
  _AddImageVideoState createState() => _AddImageVideoState();
}

class _AddImageVideoState extends State<AddImageVideo> {
  late File _singleImage;
  late Widget _displayWidget;
  late File _storyVideo;
  List<Asset> _multipleImages = <Asset>[];
  late VideoPlayerController _videoPlayerController;
  bool isImage = true;

  @override
  void initState() {
    super.initState();
    setDisplayWidget(isFirst: true);

    _videoPlayerController = VideoPlayerController.network('')
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    super.dispose();
  }

  void setDisplayWidget({bool isFirst = false}) {
    final submissionState =
        Provider.of<SubmissionState>(context, listen: false);

    if (isFirst) {
      _displayWidget = Container(
        alignment: Alignment.center,
        color: Colors.grey[200],
        child: Icon(
          Icons.add,
          size: 30,
          color: RColors.secondaryColor,
        ),
      );
    } else {
      switch (widget.uploadType) {
        case CampaignSubmissionType.posts:
          if (isImage) {
            _displayWidget = Image.file(
              _singleImage,
              width: 1080,
              height: 1080,
            );
          } else {
            _displayWidget = VideoPlayer(_videoPlayerController);
          }
          submissionState.setPostFile(
              _singleImage, CampaignSubmissionType.posts);

          break;
        case CampaignSubmissionType.carousel:
          _displayWidget = PageView.builder(
            itemCount: _multipleImages.length,
            itemBuilder: (context, index) {
              final asset = _multipleImages[index];
              return AssetThumb(
                asset: asset,
                width: 1080,
                height: 1080,
              );
            },
          );
          submissionState.multipleImages(_multipleImages);

          break;
        case CampaignSubmissionType.stories:
          _displayWidget = VideoPlayer(_videoPlayerController);
          submissionState.setPostFile(
              _storyVideo, CampaignSubmissionType.stories);
          break;
      }
    }
  }

  ///`Single Image function`
  Future<void> pickSingleImage() async {
    final picker = ImagePicker();
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          color: Colors.white,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RText(
                "CHOOSE THE TYPE OF FILE",
                variant: TypographyVariant.h1,
              ),
              RDivider(),
              Row(
                children: [
                  Column(
                    children: [
                      IconButton(
                          icon: Icon(
                            Icons.camera,
                            color: RColors.secondaryColor,
                          ),
                          onPressed: () async {
                            try {
                              isImage = true;
                              final image = await picker.getImage(
                                source: ImageSource.gallery,
                                imageQuality: 80,
                                maxHeight: 1080,
                                maxWidth: 1080,
                              );

                              Navigator.of(context).pop();
                              setState(() {
                                _singleImage = File(image!.path);
                                setDisplayWidget();
                              });
                            } catch (e) {
                              if (e.toString().contains("null")) {
                                Utility.displaySnackbar(context,
                                    msg: "Cancelled by user");
                              } else {
                                Utility.displaySnackbar(context,
                                    msg: e.toString());
                              }
                            }
                          }),
                      RText(
                        "Image",
                        variant: TypographyVariant.h3,
                        style: TextStyle(color: RColors.secondaryColor),
                      ),
                    ],
                  ),
                  SizedBox(width: 20),
                  Column(
                    children: [
                      IconButton(
                          icon: Icon(
                            Icons.video_call,
                            color: RColors.secondaryColor,
                          ),
                          onPressed: () async {
                            try {
                              isImage = false;
                              final image = await picker.getVideo(
                                source: ImageSource.gallery,
                                maxDuration: Duration(seconds: 60),
                              );
                              Navigator.of(context).pop();

                              _singleImage = File(image!.path);
                              _videoPlayerController =
                                  VideoPlayerController.file(_singleImage)
                                    ..initialize().then((_) {
                                      setState(() {
                                        setDisplayWidget();
                                      });
                                    })
                                    ..play();
                            } catch (e) {
                              if (e.toString().contains("null")) {
                                Utility.displaySnackbar(context,
                                    msg: "Cancelled by user");
                              } else {
                                Utility.displaySnackbar(context,
                                    msg: e.toString());
                              }
                            }
                          }),
                      RText(
                        "Video",
                        variant: TypographyVariant.h3,
                        style: TextStyle(color: RColors.secondaryColor),
                      ),
                    ],
                  )
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  ///`Multiple Image function`
  Future<void> pickMultipleImages() async {
    List<Asset> resultList = <Asset>[];
    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 10,
        selectedAssets: _multipleImages,
        materialOptions: MaterialOptions(
          actionBarTitle: "Rasooc",
        ),
      );
    } on Exception catch (e) {
      if (e.toString().contains("null")) {
        Utility.displaySnackbar(context, msg: "Cancelled by user");
      } else {
        Utility.displaySnackbar(context, msg: e.toString());
      }
    }
    setState(() {
      _multipleImages = resultList;
      setDisplayWidget();
    });
  }

  ///`Video for story`
  Future<void> addStory() async {
    print("I AM HERE FOR STORY");
    final picker = ImagePicker();
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          color: Colors.white,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RText(
                "CHOOSE THE TYPE OF FILE",
                variant: TypographyVariant.h1,
              ),
              RDivider(),
              Row(
                children: [
                  Column(
                    children: [
                      IconButton(
                          icon: Icon(
                            Icons.camera,
                            color: RColors.secondaryColor,
                          ),
                          onPressed: () async {
                            try {
                              isImage = true;
                              final image = await picker.getImage(
                                source: ImageSource.gallery,
                                imageQuality: 80,
                                maxHeight: 1080,
                                maxWidth: 1080,
                              );

                              Navigator.of(context).pop();
                              setState(() {
                                _singleImage = File(image!.path);
                                setDisplayWidget();
                              });
                            } catch (e) {
                              if (e.toString().contains("null")) {
                                Utility.displaySnackbar(context,
                                    msg: "Cancelled by user");
                              } else {
                                Utility.displaySnackbar(context,
                                    msg: e.toString());
                              }
                            }
                          }),
                      RText(
                        "Image",
                        variant: TypographyVariant.h3,
                        style: TextStyle(color: RColors.secondaryColor),
                      ),
                    ],
                  ),
                  SizedBox(width: 20),
                  Column(
                    children: [
                      IconButton(
                          icon: Icon(
                            Icons.video_call,
                            color: RColors.secondaryColor,
                          ),
                          onPressed: () async {
                            try {
                              isImage = false;
                              final image = await picker.getVideo(
                                source: ImageSource.gallery,
                                maxDuration: Duration(seconds: 15),
                              );
                              Navigator.of(context).pop();

                              _singleImage = File(image!.path);
                              _videoPlayerController =
                                  VideoPlayerController.file(_singleImage)
                                    ..initialize().then((_) {
                                      setState(() {
                                        setDisplayWidget();
                                      });
                                    })
                                    ..play();
                            } catch (e) {
                              if (e.toString().contains("null")) {
                                Utility.displaySnackbar(context,
                                    msg: "Cancelled by user");
                              } else {
                                Utility.displaySnackbar(context,
                                    msg: e.toString());
                              }
                            }
                          }),
                      RText(
                        "Video",
                        variant: TypographyVariant.h3,
                        style: TextStyle(color: RColors.secondaryColor),
                      ),
                    ],
                  )
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    sizeConfig.init(context);
    return AspectRatio(
      aspectRatio: 1,
      child: GestureDetector(
          onTap: () async {
            switch (widget.uploadType) {
              case CampaignSubmissionType.posts:
                await pickSingleImage();
                break;
              case CampaignSubmissionType.carousel:
                await pickMultipleImages();
                break;
              case CampaignSubmissionType.stories:
                await addStory();
                break;
            }
          },
          child: _displayWidget),
    );
  }
}
