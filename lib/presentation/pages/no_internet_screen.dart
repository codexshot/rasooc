import 'package:flutter/material.dart';
import 'package:rasooc/presentation/common-widgets/common.dart';

class NoInternetConnection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: RText(
          "No Internet connection",
          variant: TypographyVariant.h1,
        ),
      ),
    );
  }
}
