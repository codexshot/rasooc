import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rasooc/domain/helper/size_configs.dart';
import 'package:rasooc/presentation/common-widgets/common.dart';
import 'package:rasooc/presentation/pages/bnb/bnb.dart';
import 'package:rasooc/presentation/themes/colors.dart';
import 'package:rasooc/presentation/themes/images.dart';

class CompleteSubmissionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    sizeConfig.init(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(
              Icons.clear,
              color: RColors.secondaryColor,
              size: 30,
            ),
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                  CupertinoPageRoute(builder: (_) => RasoocBNB()),
                  (route) => false);
            },
          ),
        ],
        elevation: 0.0,
      ),
      body: Container(
        width: sizeConfig.safeWidth! * 100,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: sizeConfig.safeWidth! * 60,
              child: RText(
                "You submitted successfully..",
                variant: TypographyVariant.title,
                textAlign: TextAlign.center,
                style:
                    TextStyle(fontWeight: FontWeight.w300, color: Colors.black),
              ),
            ),
            SvgPicture.asset(RImages.submitPostThanks),
            SizedBox(
              height: 48,
              width: 320,
              child: FlatButton(
                color: const Color(0xff27DEBF),
                textColor: Colors.white,
                minWidth: double.maxFinite,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32.0)),
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(
                      CupertinoPageRoute(builder: (_) => RasoocBNB()),
                      (route) => false);
                },
                child: RText(
                  "EXPLORE",
                  variant: TypographyVariant.h1,
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
