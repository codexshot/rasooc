import 'package:flutter/material.dart';
import 'package:rasooc/presentation/themes/common_themes.dart';

class RLoader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation(RColors.primaryColor),
    );
  }
}
