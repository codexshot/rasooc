import 'package:flutter/material.dart';
import 'package:rasooc/domain/helper/navigation_helper.dart';
import 'package:rasooc/domain/models/icon_model.dart';
import 'package:rasooc/presentation/common-widgets/common.dart';
import 'package:rasooc/presentation/common-widgets/custom_icon_tile.dart';
import 'package:rasooc/presentation/pages/personal-details/personal_details_screen.dart';

class ProfileAccountSettings extends StatefulWidget {
  @override
  _ProfileAccountSettingsState createState() => _ProfileAccountSettingsState();
}

class _ProfileAccountSettingsState extends State<ProfileAccountSettings> {
  List<IconModel> _settingsList = [];

  @override
  void initState() {
    super.initState();
    intializeList();
  }

  void intializeList() {
    _settingsList = [
      IconModel(
        iconData: Icons.person_outline,
        title: "Personal Details",
        onPressed: () {
          NavigationHelpers.push(context, PersonalDetailsScreen());
        },
      ),
      // IconModel(
      //   iconData: Icons.payments_outlined,
      //   title: "Payments",
      //   onPressed: () {},
      // ),
      // IconModel(
      //   iconData: Icons.money_outlined,
      //   title: "Payment Preference",
      //   onPressed: () {},
      // ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 10),
        RText(
          "Account Settings",
          variant: TypographyVariant.h1,
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        SizedBox(height: 20),
        ..._settingsList.map(
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
