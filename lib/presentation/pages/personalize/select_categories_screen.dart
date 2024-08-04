import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rasooc/domain/providers/auth_state.dart';
import 'package:rasooc/presentation/common-widgets/custom_loader.dart';
import 'package:rasooc/presentation/common-widgets/custom_text.dart';
import 'package:rasooc/presentation/common-widgets/top_icon.dart';
import 'package:rasooc/presentation/themes/common_themes.dart';
import 'package:rasooc/presentation/themes/images.dart';
import 'package:rasooc/presentation/themes/extensions.dart';

class SelectCategoriesScreen extends StatefulWidget {
  @override
  _SelectCategoriesScreenState createState() => _SelectCategoriesScreenState();
}

class _SelectCategoriesScreenState extends State<SelectCategoriesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        elevation: 0.0,
        leading: BackButton(
          color: Colors.black,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.check,
              size: 30,
              color: RColors.primaryColor,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ).pH(20),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            TopIcon(
              imagePath: RImages.categoryImage,
              title: "Select Categories",
            ),
            SizedBox(height: 20),
            Expanded(
              child: Container(
                child: Consumer<AuthState>(builder: (context, state, _) {
                  return state.isLoading
                      ? Center(
                          child: RLoader(),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          itemCount: state.allCategories.length,
                          itemBuilder: (BuildContext context, int index) {
                            return GestureDetector(
                              onTap: () {
                                state.toggleCategorySelection(
                                    state.allCategories[index].id!);
                              },
                              child: Container(
                                margin: EdgeInsets.symmetric(vertical: 10),
                                height: 30,
                                width: double.maxFinite,
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.check_circle,
                                      color:
                                          state.allCategories[index].isSelected
                                              ? Color(0xff27DEBF)
                                              : Color(0xffCCCCCC),
                                    ),
                                    SizedBox(width: 16),
                                    RText(
                                      state.allCategories[index].name!,
                                      variant: TypographyVariant.h1,
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w400),
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                }),
              ).pH(12),
            )
          ],
        ),
      ),
    );
  }
}
