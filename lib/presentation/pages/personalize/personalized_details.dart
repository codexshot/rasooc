import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rasooc/domain/helper/navigation_helper.dart';
import 'package:rasooc/domain/helper/utility.dart';
import 'package:rasooc/domain/providers/account_settings_state.dart';
import 'package:rasooc/domain/providers/auth_state.dart';
import 'package:rasooc/presentation/common-widgets/common.dart';
import 'package:rasooc/presentation/common-widgets/custom_text_field.dart';
import 'package:rasooc/presentation/common-widgets/top_icon.dart';
import 'package:rasooc/presentation/pages/bnb/bnb.dart';
import 'package:rasooc/presentation/pages/personalize/select_categories_screen.dart';
import 'package:rasooc/presentation/pages/personalize/select_gender_screen.dart';
import 'package:rasooc/presentation/themes/colors.dart';
import 'package:rasooc/presentation/themes/images.dart';
import 'package:rasooc/presentation/themes/extensions.dart';
import 'package:rasooc/presentation/themes/styles.dart';

class PersonalizedDetailsScreen extends StatefulWidget {
  @override
  _PersonalizedDetailsScreenState createState() =>
      _PersonalizedDetailsScreenState();
}

class _PersonalizedDetailsScreenState extends State<PersonalizedDetailsScreen> {
  late TextEditingController _ageController;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();
  ValueNotifier<bool> _isLoading = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();
    initalizeData();
  }

  void initalizeData() async {
    final state = Provider.of<AuthState>(context, listen: false);
    final age = state.userAge;
    _ageController = TextEditingController(text: age);
    if (state.allCategories.isEmpty) {
      await state.getCampaignCategories();
    }
  }

  @override
  void dispose() {
    _ageController.dispose();
    _isLoading.dispose();
    super.dispose();
  }

  void createAccount() async {
    _formKey.currentState!.save();
    final state = Provider.of<AuthState>(context, listen: false);
    final gender = state.selectedGender;
    final categories = state.userLikedCategories;

    bool isValidated = _formKey.currentState!.validate();
    if (isValidated && gender.id != 0 && categories.isNotEmpty) {
      _isLoading.value = true;
      await state.createAccount();
      final model = state.userProfile;
      if (model.fbAccessToken != null && state.error.isEmpty) {
        Provider.of<AccountSettingsState>(context, listen: false)
            .setUserProfile(model);
        NavigationHelpers.pushRemoveUntil(context, RasoocBNB());
        _isLoading.value = false;
      } else {
        _isLoading.value = false;

        Utility.displaySnackbar(context, key: _scaffoldKey, msg: state.error);
      }
    } else {
      if (isValidated) {
        if (gender.id == 0) {
          Utility.displaySnackbar(context,
              key: _scaffoldKey, msg: "Please select a gender to continue");
        } else {
          Utility.displaySnackbar(context,
              key: _scaffoldKey, msg: "Please select a categories to continue");
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Colors.white,
      //   elevation: 0,
      // ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.only(left: 12.0),
                  child: Row(
                    children: [
                      BackButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 12),
                TopIcon(
                  imagePath: RImages.userImage,
                  title: "Personalized Details",
                ),
                SizedBox(height: 20),
                RTextField(
                  choice: Choice.age, //TODO: AGE
                  labelText: "Age",
                  hintText: "eg: 23",
                  controller: _ageController,
                  onChanged: (String val) {
                    Provider.of<AuthState>(context, listen: false)
                        .setUserAge(val);
                  },
                ).pAll(12),
                Consumer<AuthState>(builder: (context, state, _) {
                  return GestureDetector(
                    onTap: () {
                      FocusScope.of(context).unfocus();
                      NavigationHelpers.push(context, SelectGenderScreen());
                    },
                    child: Container(
                      height: 50,
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      alignment: Alignment.centerLeft,
                      child: RText(
                        state.selectedGender.gender!.capitalize(),
                        variant: TypographyVariant.h2,
                        style: state.selectedGender.id == 0
                            ? RStyles.lableStyle
                            : TextStyle(
                                color: Colors.black,
                              ),
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(color: Colors.grey),
                      ),
                    ).pAll(12),
                  );
                }),
                Consumer<AuthState>(builder: (context, state, _) {
                  return GestureDetector(
                    onTap: () {
                      FocusScope.of(context).unfocus();
                      NavigationHelpers.push(context, SelectCategoriesScreen());
                    },
                    child: Container(
                      height: 50,
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      alignment: Alignment.centerLeft,
                      child: state.userLikedCategories.isNotEmpty
                          ? ListView.builder(
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              itemCount: state.userLikedCategories.length > 3
                                  ? 3
                                  : state.userLikedCategories.length,
                              padding: EdgeInsets.symmetric(vertical: 12),
                              itemBuilder: (context, index) => RText(
                                index == 2
                                    ? "${state.userLikedCategories[index].name}..."
                                    : "${state.userLikedCategories[index].name}, ",
                                variant: TypographyVariant.h2,
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            )
                          : Text(
                              "Select the categories you like",
                              style: RStyles.lableStyle,
                            ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(color: Colors.grey),
                      ),
                    ).pAll(12),
                  );
                }),
                //TODO: REMOVE THIS PROBABLY

                // Row(
                //   children: [
                //     Checkbox(value: false, onChanged: (val) => print(val)),
                //     Text(
                //       "District of Gilgit Balistan",
                //       style: RStyles.lableStyle,
                //     ),
                //   ],
                // ),

                SizedBox(height: 40),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 22.0),
                  child: Container(
                    height: 48,
                    width: 320,
                    child: ValueListenableBuilder<bool>(
                      valueListenable: _isLoading,
                      builder: (context, loading, child) => FlatButton(
                        color: loading
                            ? RColors.secondaryColor
                            : RColors.primaryColor,
                        textColor: Colors.white,
                        minWidth: double.infinity,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32.0)),
                        child: loading
                            ? SizedBox(
                                height: 15,
                                width: 15,
                                child: FittedBox(
                                  child: CircularProgressIndicator(
                                    valueColor:
                                        AlwaysStoppedAnimation(Colors.white),
                                  ),
                                ),
                              )
                            : Text("CREATE ACCOUNT"),
                        onPressed: loading ? () {} : createAccount,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                // RFlatButton(
                //   title: "DONE",
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
