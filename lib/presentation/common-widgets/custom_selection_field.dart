import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rasooc/presentation/themes/common_themes.dart';

class RSelectionField extends StatelessWidget {
  final String text;
  final Function? onpressed;
  final bool isEmpty;

  const RSelectionField(
      {Key? key, this.text = "N.A", this.onpressed, this.isEmpty = false})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onpressed!();
      },
      child: Container(
        height: 50,
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 10),
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(color: Colors.grey),
        ),
        child: Text(
          text,
          style: isEmpty ? RStyles.lableStyle : RStyles.inputText,
        ),
      ),
    );
  }
}
