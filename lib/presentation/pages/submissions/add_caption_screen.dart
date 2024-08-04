import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rasooc/domain/helper/enums.dart';
import 'package:rasooc/domain/helper/size_configs.dart';
import 'package:rasooc/domain/providers/campaign_state.dart';
import 'package:rasooc/domain/providers/submission_state.dart';
import 'package:rasooc/presentation/common-widgets/common.dart';
import 'package:rasooc/presentation/common-widgets/custom_tags.dart';
import 'package:rasooc/presentation/themes/colors.dart';
import 'package:rasooc/presentation/themes/styles.dart';

class AddCaptionScreen extends StatefulWidget {
  final List<CampaignSocialType> socialType;

  const AddCaptionScreen({Key? key, required this.socialType})
      : super(key: key);
  @override
  _AddCaptionScreenState createState() => _AddCaptionScreenState();
}

class _AddCaptionScreenState extends State<AddCaptionScreen> {
  late TextEditingController _textEditingController;

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

  void intializeText() {
    final caption =
        Provider.of<SubmissionState>(context, listen: false).caption;
    _textEditingController = TextEditingController(text: caption);
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
              state.setCaption(_textEditingController.text);
              Navigator.of(context).pop();
            },
          )
        ],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 40, horizontal: 20),
        child: Column(
          children: [
            Expanded(child: _buildCaptionTextField()),
            SizedBox(height: 10),
            _addRequiredTags(),
          ],
        ),
      ),
    );
  }

  Widget _buildCaptionTextField() {
    return TextFormField(
      controller: _textEditingController,
      cursorColor: RColors.primaryColor,
      autocorrect: false,
      style: RStyles.hintTextStyle
          .copyWith(color: RColors.primaryColor, height: 1.2),
      decoration: InputDecoration(
        border: InputBorder.none,
        hintMaxLines: 3,
        hintText:
            "Write your caption exactly the way you'd like to have it published",
        hintStyle: RStyles.hintTextStyle,
      ),
      maxLines: 10,
      toolbarOptions: ToolbarOptions(
        paste: true,
        copy: true,
        cut: true,
        selectAll: true,
      ),
    );
  }

  Widget _addRequiredTags() {
    final campaign =
        Provider.of<CampaignState>(context, listen: false).selectedCampaign;

    List<Widget> children = [];
    widget.socialType.forEach((type) {
      switch (type) {
        case CampaignSocialType.instagram:
          children = <Widget>[
            ...campaign.instaTags!
                .map(
                  (tag) => RTags(
                    key: ValueKey(tag),
                    tag: tag,
                    backgroundColor: Color(0xffF2F2F2),
                    tagColor: Colors.black,
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    onPressed: () {
                      _textEditingController.text =
                          _textEditingController.text + tag;
                      // setState(() {
                      //   print(children.length);
                      //   children.removeWhere(
                      //       (element) => element.key == ValueKey(tag));
                      //   print(children.length);
                      // });
                    },
                  ),
                )
                .toList()
          ];
          break;
        case CampaignSocialType.facebook:
          children = <Widget>[
            ...campaign.fbTag!
                .map(
                  (tag) => RTags(
                    key: ValueKey(tag),
                    tag: tag,
                    backgroundColor: Color(0xffF2F2F2),
                    tagColor: Colors.black,
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    onPressed: () {
                      _textEditingController.text =
                          _textEditingController.text + tag;
                      // setState(() {
                      //   children.removeWhere(
                      //       (element) => element.key == ValueKey(tag));
                      // });
                    },
                  ),
                )
                .toList()
          ];
          break;
        case CampaignSocialType.twitter:
          children = <Widget>[
            ...campaign.twitterTag!
                .map(
                  (tag) => RTags(
                    key: ValueKey(tag),
                    tag: tag,
                    backgroundColor: Color(0xffF2F2F2),
                    tagColor: Colors.black,
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    onPressed: () {
                      _textEditingController.text =
                          _textEditingController.text + tag;

                      // setState(() {
                      //   children.removeWhere(
                      //       (element) => element.key == ValueKey(tag));
                      // });
                    },
                  ),
                )
                .toList()
          ];
          break;
      }
    });

    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RText(
            "Requried tags",
            variant: TypographyVariant.h1,
            style: TextStyle(color: RColors.disableColor),
          ),
          SizedBox(height: 10),
          SizedBox(
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              children: children,
            ),
          )
        ],
      ),
    );
  }
}
