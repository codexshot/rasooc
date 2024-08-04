import 'package:flutter/material.dart';
import 'package:rasooc/presentation/pages/auth/validators.dart';
import 'package:rasooc/presentation/themes/styles.dart';

class RTextField extends StatelessWidget {
  ///[hintText] to define the hint text in `TextField`
  final String? hintText;

  ///[labelText] to display the label text in `TextField`
  final String? labelText;

  ///[lableStyle] is if there is any change to label style
  ///if `null` it will merge empty `TextStyle`
  final TextStyle? labelStyle;

  final TextEditingController? controller;

  final Choice choice;

  final TextInputAction textInputAction;

  final Function(String)? onChanged;

  const RTextField({
    Key? key,
    required this.choice,
    this.hintText,
    this.labelText,
    this.labelStyle,
    this.controller,
    this.textInputAction = TextInputAction.next,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: TextFormField(
        autocorrect: false,
        controller: controller,
        style: RStyles.inputText,
        keyboardType: getKeyboardType(choice),
        textInputAction: textInputAction,
        decoration: InputDecoration(
          hintText: hintText ?? "",
          labelText: labelText ?? "",
          labelStyle: RStyles.lableStyle.merge(labelStyle ?? TextStyle()),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            borderSide: BorderSide(color: Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            borderSide: BorderSide(color: Colors.grey),
          ),
        ),
        onTap: () {},
        onChanged: onChanged,
        validator: validators(choice, context),
        // autovalidateMode: AutovalidateMode.onUserInteraction,
      ),
    );
  }

  TextInputType getKeyboardType(Choice choice) {
    switch (choice) {
      case Choice.name:
        return TextInputType.text;
      case Choice.age:
        return TextInputType.numberWithOptions();
      case Choice.email:
        return TextInputType.emailAddress;
      case Choice.password:
        return TextInputType.visiblePassword;
      case Choice.confirmPassword:
        return TextInputType.visiblePassword;
      case Choice.phone:
        return TextInputType.phone;
      case Choice.reset:
        return TextInputType.emailAddress;
      case Choice.address:
        return TextInputType.streetAddress;
      default:
        return TextInputType.text;
    }
  }

  String? Function(String?) validators(Choice? choice, BuildContext? context) {
    return RValidators.buildValidators(context!, choice!);
  }
}

enum Choice {
  name,
  email,
  phone,
  password,
  confirmPassword,
  reset,
  text,
  optionalText,
  age,
  address
}
