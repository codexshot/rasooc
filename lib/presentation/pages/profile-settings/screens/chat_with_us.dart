import 'package:flutter/material.dart';
import 'package:rasooc/domain/helper/size_configs.dart';
import 'package:rasooc/presentation/common-widgets/common.dart';
import 'package:rasooc/presentation/themes/colors.dart';
import 'package:rasooc/presentation/themes/images.dart';

class ContactUs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    sizeConfig.init(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          color: Colors.black,
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 0.0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        centerTitle: true,
        title: RText(
          "Contact us",
          variant: TypographyVariant.titleSmall,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
        child: SizedBox(
          child: Column(
            children: [
              SizedBox(height: sizeConfig.safeHeight! * 12),
              RText(
                "Have a query or some feedback for us? Contact our team.",
                variant: TypographyVariant.titleSmall,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: sizeConfig.safeHeight! * 2),
              RText(
                "info@rasooc.com",
                variant: TypographyVariant.h1,
                style: TextStyle(color: RColors.primaryColor),
              ),
              SizedBox(height: sizeConfig.safeHeight! * 6),
              Expanded(
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Image.asset(
                    RImages.contactSupportImage,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
