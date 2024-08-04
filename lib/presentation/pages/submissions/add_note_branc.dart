import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:provider/provider.dart';
import 'package:rasooc/domain/helper/enums.dart';
import 'package:rasooc/domain/helper/size_configs.dart';
import 'package:rasooc/domain/helper/utility.dart';
import 'package:rasooc/domain/providers/submission_state.dart';
import 'package:rasooc/presentation/common-widgets/common.dart';
import 'package:rasooc/presentation/themes/colors.dart';
import 'package:rasooc/presentation/themes/styles.dart';
import 'package:rasooc/presentation/themes/common_themes.dart';

class AddNoteBrandScreen extends StatefulWidget {
  final CampaignSubmissionType submissionType;

  const AddNoteBrandScreen({Key? key, required this.submissionType})
      : super(key: key);

  @override
  _AddNoteBrandScreenState createState() => _AddNoteBrandScreenState();
}

class _AddNoteBrandScreenState extends State<AddNoteBrandScreen> {
  late TextEditingController _textEditingController;
  bool isImage = true;
  File _file = File("");
  late Asset _carauselFile;
  String fileSize = "N.A";

  @override
  void initState() {
    super.initState();
    intializeText();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  void intializeText() async {
    final state = Provider.of<SubmissionState>(context, listen: false);
    _textEditingController = TextEditingController(text: state.noteForBrand);
    if (state.postFile.path.isNotEmpty) {
      _file = state.postFile;
      if (_file.path.contains("jpg") || _file.path.contains("jpeg")) {
        isImage = true;
      } else {
        isImage = false;
      }
      final len = await _file.length();
      fileSize = Utility.formatBytes(len, 2);
    }
    if (state.caraouselImages.isNotEmpty) {
      _carauselFile = state.caraouselImages[0];
      ByteData byteData = await _carauselFile.getByteData();
      final len = byteData.lengthInBytes;
      fileSize = Utility.formatBytes(len, 2);
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    sizeConfig.init(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(Icons.clear),
          color: RColors.secondaryColor,
          iconSize: 30,
          onPressed: () {
            _textEditingController.clear();
            Navigator.of(context).pop();
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.check),
            color: RColors.secondaryColor,
            iconSize: 30,
            onPressed: () {
              final state =
                  Provider.of<SubmissionState>(context, listen: false);
              state.setNoteForBrand(_textEditingController.text);
              Navigator.of(context).pop();
            },
          )
        ],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 40, horizontal: 20),
        child: Column(
          children: [
            _buildImageAndPost(),
            Expanded(child: _buildNoteTextField()),
          ],
        ),
      ),
    );
  }

  Widget _buildNoteTextField() {
    return Container(
      child: TextFormField(
        controller: _textEditingController,
        cursorColor: RColors.primaryColor,
        autocorrect: false,
        enableInteractiveSelection: true,
        style: RStyles.hintTextStyle
            .copyWith(color: RColors.primaryColor, height: 1.2),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintMaxLines: 3,
          hintText: "Example: I am working as....",
          hintStyle: RStyles.hintTextStyle,
        ),
        maxLength: 180,
        maxLines: 5,
        toolbarOptions: ToolbarOptions(
          paste: true,
          copy: true,
          cut: true,
          selectAll: true,
        ),
      ),
    );
  }

  Widget _buildImageAndPost() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _file.path.isNotEmpty
            ? isImage
                ? Image.file(
                    _file,
                    height: 66,
                    width: 66,
                    fit: BoxFit.cover,
                  )
                : SvgPicture.asset(
                    RImages.submitPostThanks,
                    height: 66,
                    width: 66,
                    fit: BoxFit.cover,
                  )
            : AssetThumb(
                asset: _carauselFile,
                width: 66,
                quality: 100,
                height: 66,
              ),
        SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RText(
              widget.submissionType.asString()!.capitalize(),
              variant: TypographyVariant.h3,
              style: TextStyle(
                color: RColors.secondaryColor,
              ),
            ),
            RText(
              fileSize,
              variant: TypographyVariant.h3,
              style: TextStyle(
                color: Color(0xffCCCCCC),
              ),
            ),
          ],
        )
      ],
    );
  }
}
