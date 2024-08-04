// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:rasooc/domain/providers/auth_state.dart';
// import 'package:rasooc/presentation/common-widgets/custom_text.dart';
// import 'package:rasooc/presentation/common-widgets/custom_text_field.dart';
// import 'package:rasooc/presentation/common-widgets/top_icon.dart';
// import 'package:rasooc/presentation/themes/extensions.dart';
// import 'package:rasooc/presentation/themes/images.dart';

// class SelectCity extends StatefulWidget {
//   @override
//   _SelectCityState createState() => _SelectCityState();
// }

// class _SelectCityState extends State<SelectCity> {
//   late TextEditingController _cityNameController;

//   @override
//   void dispose() {
//     _cityNameController.dispose();
//     super.dispose();
//   }

//   @override
//   void initState() {
//     super.initState();

//     _cityNameController = TextEditingController();
//   }

//   Widget _buildTopIcon() {
//     return TopIcon(
//       imagePath: RImages.coronaVirusImage,
//       title: "Select City",
//     );
//   }

// //TODO: ADD CONTROLLER
//   Widget _buildTextField() {
//     final state = Provider.of<AuthState>(context, listen: false);

//     return RTextField(
//       controller: _cityNameController,
//       choice: Choice.optionalText,
//       labelText: "Search city",
//       labelStyle: TextStyle(fontSize: 16),
//       onChanged: (String? value) {
//         state.setCitySearchList(value);
//       },
//     ).pH(12);
//   }

//   Widget _buildCountryList() {
//     return Consumer<AuthState>(builder: (context, state, _) {
//       return ListView.builder(
//         padding: EdgeInsets.symmetric(vertical: 20),
//         shrinkWrap: true,
//         itemCount: state.displayCityList.length,
//         itemBuilder: (context, index) {
//           return GestureDetector(
//             onTap: () {
//               Provider.of<AuthState>(context, listen: false)
//                   .setSelectedCity(state.displayCityList[index]);
//               Navigator.of(context).pop();
//             },
//             child: Container(
//               padding: EdgeInsets.symmetric(vertical: 2),
//               child: RText(
//                 state.displayCityList[index].name!,
//                 variant: TypographyVariant.h1,
//                 style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
//               ),
//               margin: EdgeInsets.symmetric(vertical: 10),
//             ),
//           );
//         },
//       ).pH(20);
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         automaticallyImplyLeading: false,
//         elevation: 0.0,
//         actions: [
//           IconButton(
//             icon: Icon(
//               Icons.clear,
//               size: 30,
//               color: Colors.grey,
//             ),
//             onPressed: () => Navigator.of(context).pop(),
//           ).pH(20),
//         ],
//       ),
//       body: SafeArea(
//         child: Column(
//           children: [
//             _buildTopIcon(),
//             SizedBox(height: 40),
//             _buildTextField(),
//             Expanded(child: _buildCountryList()),
//           ],
//         ),
//       ),
//     );
//   }
// }
