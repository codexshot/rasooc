import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:rasooc/domain/helper/navigation_helper.dart';
import 'package:rasooc/domain/providers/account_settings_state.dart';
import 'package:rasooc/presentation/common-widgets/common.dart';
import 'package:rasooc/presentation/common-widgets/custom_cached_image.dart';
import 'package:rasooc/presentation/pages/personal-details/edit_personal_details.dart';
import 'package:rasooc/presentation/themes/common_themes.dart';

class PersonalDetailsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final accountState =
        Provider.of<AccountSettingsState>(context, listen: false);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        leading: GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Icon(
            Icons.arrow_back_ios,
            color: RColors.secondaryColor,
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              accountState.setEditProfile();
              NavigationHelpers.push(context, EditPersonalDetails());
            },
            child: Icon(
              Icons.edit,
              color: Colors.black,
            ).pH(10),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.maxFinite,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(40),
                      child: customNetworkImage(
                        accountState.userProfile.profilePic!,
                        height: 80,
                        width: 80,
                        defaultHolder: SvgPicture.asset(
                          RImages.userImage,
                          height: 80,
                          width: 80,
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    RText(
                      "Personal Details",
                      variant: TypographyVariant.title,
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Consumer<AccountSettingsState>(builder: (context, state, _) {
                final user = state.userProfile;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildItemContainer("First name", user.firstName ?? ""),
                    _buildItemContainer("Last name", user.lastName ?? ""),
                    _buildItemContainer(
                        "Contact cell", user.contactNumber ?? ""),
                    _buildItemContainer("Contact email", user.email ?? ""),
                    _buildItemContainer("Gender", user.gender ?? ""),
                    _buildItemContainer("Date of birth", user.birthday ?? ""),
                    _buildItemContainer(
                        "Residential area", user.residentialArea ?? ""),
                    _buildItemContainer("Country", user.country?.name ?? ""),
                    _buildItemContainer("State", user.state?.name ?? ""),
                    _buildItemContainer("City", user.city?.name ?? ""),
                    _buildItemContainer("Street", user.street ?? ""),
                    _buildItemContainer("Postal code", user.postalCode ?? ""),
                    SizedBox(height: 30),
                  ],
                ).pH(20);
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildItemContainer(String label, String value) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5),
      margin: EdgeInsets.symmetric(vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RText(
            label,
            variant: TypographyVariant.h2,
            style: TextStyle(fontSize: 14),
          ),
          SizedBox(height: 5),
          RText(
            value.isEmpty ? "N.A" : value.toString(),
            variant: TypographyVariant.h1,
            style: TextStyle(fontSize: 15),
          ),
        ],
      ),
    );
  }
}
