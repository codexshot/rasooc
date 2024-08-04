import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rasooc/domain/helper/constants.dart';
import 'package:rasooc/domain/models/icon_model.dart';
import 'package:rasooc/domain/providers/auth_state.dart';
import 'package:rasooc/presentation/common-widgets/common.dart';
import 'package:rasooc/presentation/common-widgets/custom_icon_tile.dart';
import 'package:rasooc/presentation/pages/profile-settings/screens/chat_with_us.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileSupportSettings extends StatefulWidget {
  @override
  _ProfileSupportSettingsState createState() => _ProfileSupportSettingsState();
}

class _ProfileSupportSettingsState extends State<ProfileSupportSettings> {
  List<IconModel> _supportLists = [];

  @override
  void initState() {
    super.initState();
    intializeList();
  }

  void intializeList() {
    _supportLists = [
      IconModel(
        iconData: Icons.sms_outlined,
        title: "Contact us",
        onPressed: () {
          Navigator.of(context)
              .push(CupertinoPageRoute(builder: (_) => ContactUs()));
        },
      ),
      IconModel(
        iconData: Icons.question_answer_outlined,
        title: "FAQs",
        onPressed: () {},
      ),
      IconModel(
        iconData: Icons.help_outlined,
        title: "Help Center",
        onPressed: () {},
      ),
      IconModel(
        iconData: Icons.privacy_tip,
        title: "Privacy Policy",
        onPressed: () {
          launch(Constants.privacyPolicy);
        },
      ),
      IconModel(
        iconData: Icons.menu_open_outlined,
        title: "Terms & Conditions",
        onPressed: () {
          launch(Constants.termsAndConditions);
        },
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 10),
        RText(
          "Support",
          variant: TypographyVariant.h1,
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        SizedBox(height: 20),
        ..._supportLists.map(
          (setting) => RIconTile(
            iconData: setting.iconData!,
            title: setting.title!,
            onPressed: setting.onPressed,
          ),
        ),
      ],
    );
  }
}
