import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rasooc/domain/providers/auth_state.dart';
import 'package:rasooc/presentation/common-widgets/custom_text.dart';
import 'package:rasooc/presentation/common-widgets/top_icon.dart';
import 'package:rasooc/presentation/themes/images.dart';
import 'package:rasooc/presentation/themes/extensions.dart';

class SelectGenderScreen extends StatefulWidget {
  @override
  _SelectGenderScreenState createState() => _SelectGenderScreenState();
}

class _SelectGenderScreenState extends State<SelectGenderScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        elevation: 0.0,
        actions: [
          IconButton(
            icon: Icon(
              Icons.clear,
              size: 30,
              color: Colors.grey,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ).pH(20),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            TopIcon(
              imagePath: RImages.userImage,
              title: "Gender",
            ),
            SizedBox(height: 20),
            Expanded(
              child: Container(
                child: Consumer<AuthState>(builder: (context, state, _) {
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: state.allGenders.length,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: () {
                          state.setSelectedgender(state.allGenders[index].id!);
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(vertical: 10),
                          height: 30,
                          width: double.maxFinite,
                          child: Row(
                            children: [
                              Icon(
                                Icons.check_circle,
                                color: state.allGenders[index].isSelected
                                    ? Color(0xff27DEBF)
                                    : Color(0xffCCCCCC),
                              ),
                              SizedBox(width: 16),
                              RText(
                                state.allGenders[index].gender!,
                                variant: TypographyVariant.h1,
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w400),
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
