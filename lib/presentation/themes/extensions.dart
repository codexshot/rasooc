import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:rasooc/presentation/themes/common_themes.dart';

///This file contains all the [extensions] which will
///help us to remove extra line of code

extension PaddingHelper on Widget {
  ///[Padding] for `horrizontal` on any Widget
  Padding pH(double padding) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: padding),
      child: this,
    );
  }

  ///[Padding] for `all` the sides on any Widget
  Padding pAll(double padding) {
    return Padding(
      padding: EdgeInsets.all(padding),
      child: this,
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}

extension DateHelper on DateTime {
  ///Convert date from the date picker or system dates
  String dateConvertFromSystem() {
    final date1 = DateFormat("yyyy-mm-dd").parse(toString());
    final finalDate = DateFormat("dd-MM-yyyy").format(date1);
    return finalDate;
  }

  String getMemberSinceFromDate() {
    final date = DateFormat("dd MMM yyyy").format(this);
    print(date);
    return date;
  }
}

extension LogoHelper on List<String> {
  List<Widget> getLogosFromList() {
    final List<Widget> list = [];

    forEach((name) {
      switch (name.toLowerCase()) {
        case "instagram":
          list.add(SvgPicture.asset(RImages.instaCamp));
          list.add(SizedBox(width: 5.0));
          break;
        case "facebook":
          list.add(SvgPicture.asset(RImages.facebookCamp));
          list.add(SizedBox(width: 5.0));
          break;
        case "twitter":
          list.add(SvgPicture.asset(RImages.twitterCamp));
          list.add(SizedBox(width: 5.0));
          break;
      }
    });

    return list;
  }
}

extension FollowersNumber on int {
  String? getFollowers() {
    var _formattedNumber = NumberFormat.compactLong().format(this);
    if (this < 1000) {
      return toString();
    } else {
      switch (_formattedNumber.split(" ")[1]) {
        case "thousand":
          _formattedNumber = _formattedNumber.replaceAll(" thousand", "k");
          break;
        case "million":
          _formattedNumber = _formattedNumber.replaceAll(" million", "m");
          break;
        case "billion":
          _formattedNumber = _formattedNumber.replaceAll(" billion", "B");
          break;
      }
      return _formattedNumber;
    }
  }
}
