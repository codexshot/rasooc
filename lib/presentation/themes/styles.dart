import 'package:flutter/material.dart';
import 'package:rasooc/presentation/themes/colors.dart';

///This file contains all the [TextStyle] that are
///being used in the application

class RStyles {
  RStyles._();

  static const TextStyle lableStyle = TextStyle(
    color: Colors.grey,
    fontWeight: FontWeight.normal,
    fontSize: 13,
    fontFamily: 'Roboto',
  );

  static const TextStyle inputText = TextStyle(
    color: Colors.black,
    fontWeight: FontWeight.normal,
    fontSize: 15,
    fontFamily: 'Roboto',
  );

  static const TextStyle selectedLabelStyle = TextStyle(
    color: RColors.primaryColor,
    fontWeight: FontWeight.w400,
    fontSize: 10,
    fontFamily: 'Roboto',
    height: 1.5,
  );

  static const TextStyle unSelectedLabelStyle = TextStyle(
    color: RColors.secondaryColor,
    fontWeight: FontWeight.w400,
    fontSize: 10,
    fontFamily: 'Roboto',
    height: 1.5,
  );

  static const IconThemeData selectedIconTheme = IconThemeData(
    color: RColors.primaryColor,
    size: 30,
  );

  static const IconThemeData unSelectedIconTheme = IconThemeData(
    color: RColors.secondaryColor,
    size: 30,
  );

  static const TextStyle hintTextStyle = TextStyle(
    color: Color(0xffCCCCCC),
    fontWeight: FontWeight.w400,
    fontSize: 13,
    height: 1,
    fontFamily: 'Roboto',
  );

  static const TextStyle inFeedTextStyle = TextStyle(
    color: RColors.secondaryColor,
    fontWeight: FontWeight.w500,
    fontSize: 15,
    height: 1,
    fontFamily: 'Roboto',
  );

  static const TextStyle priceTextStyle = TextStyle(
    color: Colors.black,
    fontWeight: FontWeight.w500,
    fontSize: 20,
    height: 1,
    fontFamily: 'Roboto',
  );
}
