import 'package:flutter/material.dart';
import 'package:rasooc/presentation/common-widgets/custom_text_field.dart';

class RValidators {
  RValidators._();

  static String? Function(String?) buildValidators(
      BuildContext context, Choice choice) {
    String? emailValidators(String? value) {
      if (value!.isEmpty) {
        return "This field can't be empty";
      }
      if (!RegExp(
              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
          .hasMatch(value)) {
        return "Please enter a valid email";
      }

      if (!value.startsWith(RegExp(r"[A-Za-z]"))) {
        return "Please enter a valid email";
      }
      if (value.length > 32) {
        return "Email should be less than 32 characters";
      }
      if (value.length < 6) {
        return "Email should be of atleast 6 letters";
      }
      return null;
    }

    String? nameValidators(String? value) {
      if (value!.isEmpty) {
        return "This field can't be empty";
      }
      if (value.length > 32) {
        return "Name should be less than 32 characters";
      }
      if (!value.startsWith(RegExp(r'[A-za-z]'))) {
        return "Please enter a valid name";
      }
      if (value.length < 3) {
        return "Name should be of atleast 3 letters";
      }
      if (value.contains(RegExp(r'[0-9]'))) {
        return "Please enter a valid name";
      }
      if (RegExp(r'[!@#<>?":_`~;[\]\\|=+)(*&^%0-9-]').hasMatch(value)) {
        return "Please enter a valid name";
      }
      return null;
    }

    String? phoneValidtors(String? value) {
      if (value!.isEmpty) {
        return "This field can't be empty";
      }

      // if (value.length < 10) {
      //   return "Phone number can't be less than 10 digits";
      // }
      // if (value.contains(RegExp(r'[A-Z]')) ||
      //     value.contains(RegExp(r'[a-z]')) ||
      //     value.contains(".com")) {
      //   return locale.getTranslatedValue!(KeyConstants.onlyTenDigits);
      // }
      // if (value!.length > 10) {
      //   return locale.getTranslatedValue!(KeyConstants.invalidPhoneNumber);
      // }
      if (!RegExp(r"[0-9]{10}").hasMatch(value)) {
        return "Please enter a valid number";
      }

      return null;
    }

    String? passwordValidators(String? value) {
      if (value!.isEmpty) {
        return "This field can't be empty";
      }

      return null;
    }

    String? confirmPasswordValidators(String? value) {
      if (value!.isEmpty) {
        return "This field can't be empty";
      }
      // else if (value!.length < 8) {
      //   return locale.getTranslatedValue!(KeyConstants.passwordLessThan);
      // }

      return null;
    }

    String? textValidator(String? value) {
      if (value!.isEmpty) {
        return "This field can't be empty";
      }

      return null;
    }

    String? addressValidator(String? value) {
      if (value!.isEmpty) {
        return "This field can't be empty";
      }
      // if (value!.length > 46) {
      //   return locale.getTranslatedValue!(KeyConstants.textCantBeMore);
      // }

      return null;
    }

    String? forgotPasswordValidators(String? value) {
      if (value!.isEmpty) {
        return "This field can't be empty";
      }
      // //For Number
      // if (value!.startsWith(RegExp(r"[0-9]"))) {
      //   if (!RegExp(r"^[0-9]{10}").hasMatch(value!)) {
      //     return locale.getTranslatedValue!(KeyConstants.invalidPhoneNumber);
      //   }
      //   if (value!.length < 10) {
      //     return locale.getTranslatedValue!(KeyConstants.phoneNumberMustBeLess);
      //   }
      //   if (value!.length > 10) {
      //     return locale.getTranslatedValue!(KeyConstants.invalidPhoneNumber);
      //   }

      //   if (value!.contains(RegExp(r'[A-Z]')) ||
      //       value!.contains(RegExp(r'[a-z]')) ||
      //       value!.contains(".com")) {
      //     return locale.getTranslatedValue!(KeyConstants.onlyTenDigits);
      //   }

      //   return null;
      // }

      //for email
      // if (!value!.startsWith(RegExp(r'[A-Z][a-z]'))) {
      //   if (!RegExp(
      //           r"^([a-zA-Z0-9_\-\.]+)@([a-zA-Z0-9_\-\.]+)\.([a-zA-Z]{2,5})$")
      //       .hasMatch(value!)) {
      //     return locale.getTranslatedValue!(KeyConstants.invalidEmail);
      //   }
      //   if (value!.length > 32) {
      //     return locale.getTranslatedValue!(KeyConstants.emailMustBeLessThan);
      //   }
      //   if (value!.length < 6) {
      //     return locale.getTranslatedValue!(KeyConstants.emailIsShort);
      //   }

      //   return null;
      // }

      return null;
    }

    String? ageValidator(String? value) {
      if (value!.isEmpty) {
        return "This field can't be empty";
      }
      if (!RegExp(r"^[1-9]{1}[0-9]{0,1}").hasMatch(value)) {
        return "Please enter a valid age";
      }
      if (value.length > 2 || int.tryParse(value)! > 100) {
        return "Please enter a valid age";
      }

      return null;
    }

    String? optionalValidators(String? value) {
      return null;
    }

    if (choice == Choice.name) return nameValidators;
    if (choice == Choice.email) return emailValidators;
    if (choice == Choice.password) return passwordValidators;
    if (choice == Choice.phone) return phoneValidtors;
    if (choice == Choice.confirmPassword) return confirmPasswordValidators;
    if (choice == Choice.reset) return forgotPasswordValidators;
    if (choice == Choice.text) return textValidator;
    if (choice == Choice.age) return ageValidator;
    if (choice == Choice.optionalText) return optionalValidators;

    if (choice == Choice.address) return addressValidator;

    return nameValidators;
  }

  String? otpValidators(String? value) {
    if (value!.isEmpty) {
      return "";
    }
  }
}
