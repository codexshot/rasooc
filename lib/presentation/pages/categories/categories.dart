import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rasooc/domain/helper/enums.dart';
import 'package:rasooc/domain/helper/size_configs.dart';
import 'package:rasooc/domain/providers/auth_state.dart';
import 'package:rasooc/domain/providers/campaign_state.dart';
import 'package:rasooc/presentation/common-widgets/common.dart';
import 'package:rasooc/presentation/common-widgets/custom_divider.dart';
import 'package:rasooc/presentation/common-widgets/custom_loader.dart';
import 'package:rasooc/presentation/themes/colors.dart';
import 'package:rasooc/presentation/themes/extensions.dart';

class CategoriesScreen extends StatefulWidget {
  @override
  _CategoriesScreenState createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  final List<CampaignCategoryType> types = [
    CampaignCategoryType.all,
    CampaignCategoryType.relevant,
    CampaignCategoryType.favorite,
  ];
  @override
  void initState() {
    super.initState();
    getCategories();
  }

  Future<void> getCategories() async {
    final state = Provider.of<CampaignState>(context, listen: false);
    if (state.allCategories.isEmpty) {
      await state.getCampaignCategories();
    }
  }

  @override
  Widget build(BuildContext context) {
    sizeConfig.init(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () async {
            Navigator.of(context).pop();
          },
        ),
        title: RText("Categories", variant: TypographyVariant.titleSmall),
        centerTitle: true,
      ),
      body: Consumer<CampaignState>(
        builder: (context, state, child) => state.isLoading
            ? Center(child: RLoader())
            : SingleChildScrollView(
                padding: EdgeInsets.only(bottom: 40),
                child: Column(
                  children: [
                    _buildTypes(state).pH(20),
                    RDivider(),
                    _buildUserCategories(state).pH(20),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildTypes(CampaignState state) {
    return Column(
      children: types
          .map(
            (type) => GestureDetector(
              onTap: () {
                state.setCategoryType(type);
                state.getCampaigns();
                Navigator.of(context).pop();
              },
              child: Container(
                width: sizeConfig.safeWidth! * 100,
                margin: EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        if (type == CampaignCategoryType.favorite)
                          Icon(
                            Icons.favorite,
                            color: RColors.primaryColor,
                          )
                        else
                          SizedBox(),
                        if (type == CampaignCategoryType.favorite)
                          SizedBox(width: 20)
                        else
                          SizedBox(),
                        RText(
                          type.asString()!,
                          variant: TypographyVariant.h1,
                          style: TextStyle(fontSize: 15),
                        ),
                      ],
                    ),
                    Icon(
                      state.categoryType == type
                          ? Icons.check
                          : Icons.arrow_forward_ios,
                      color: Colors.black,
                      size: 20,
                    )
                  ],
                ),
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _buildUserCategories(CampaignState state) {
    return Column(
      children: state.allCategories
          .map((category) => Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                height: 30,
                width: double.maxFinite,
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        //TODO: ADD TO SHAREDPREF
                      },
                      child: Icon(
                        Icons.check_circle,
                        color: category.isSelected
                            ? RColors.primaryColor
                            : Color(0xffCCCCCC),
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          state.setAppBarTitle(category.name!.capitalize());
                          state.getCampaigns(categoryId: category.id!);
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          child: RText(
                            category.name!,
                            variant: TypographyVariant.h1,
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ))
          .toList(),
    );
  }
}
