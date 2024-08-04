// import 'package:flutter/material.dart';
// import 'package:page_view_indicators/page_view_indicators.dart';
// import 'package:provider/provider.dart';
// import 'package:rasooc/domain/data/dummy_data.dart';
// import 'package:rasooc/domain/models/location_response_model.dart';
// import 'package:rasooc/domain/models/user_dependant_models.dart';
// import 'package:rasooc/domain/providers/auth_state.dart';
// import 'package:rasooc/presentation/common-widgets/custom_cached_image.dart';
// import 'package:rasooc/presentation/common-widgets/custom_loader.dart';
// import 'package:rasooc/presentation/common-widgets/custom_text.dart';
// import 'package:rasooc/presentation/common-widgets/custom_text_field.dart';
// import 'package:rasooc/presentation/common-widgets/overlay_loader.dart';
// import 'package:rasooc/presentation/common-widgets/top_icon.dart';
// import 'package:rasooc/presentation/themes/extensions.dart';
// import 'package:rasooc/presentation/themes/images.dart';

// class SelectState extends StatefulWidget {
//   @override
//   _SelectStateState createState() => _SelectStateState();
// }

// class _SelectStateState extends State<SelectState> {
//   List<StateModel> _listOfStates = [];
//   late TextEditingController _stateController;
//   ValueNotifier<bool> _isLoading = ValueNotifier<bool>(false);

//   @override
//   void dispose() {
//     _stateController.dispose();
//     _isLoading.dispose();
//     super.dispose();
//   }

//   @override
//   void initState() {
//     super.initState();
//     _stateController = TextEditingController();
//   }

//   Widget _buildTopIcon() {
//     return TopIcon(
//       imagePath: RImages.coronaVirusImage,
//       title: "Select State",
//     );
//   }

//   Widget _buildTextField() {
//     return RTextField(
//       choice: Choice.optionalText,
//       labelText: "Search State",
//     ).pH(12);
//   }

//   Widget _buildCountryList() {
//     return GridView.builder(
//       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: 2,
//         crossAxisSpacing: 10,
//       ),
//       padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
//       shrinkWrap: true,
//       itemCount: _listOfStates.length,
//       itemBuilder: (context, index) {
//         return GestureDetector(
//           onTap: () {
//             Provider.of<AuthState>(context, listen: false)
//                 .setSelectedState(_listOfStates[index]);
//             Navigator.of(context).pop();
//           },
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.start,
//             children: [
//               Container(
//                 height: 120,
//                 padding: EdgeInsets.all(10),
//                 decoration: BoxDecoration(
//                   boxShadow: [
//                     BoxShadow(
//                         color: Colors.black26,
//                         blurRadius: 2.0,
//                         offset: Offset(0.0, 0.0))
//                   ],
//                   borderRadius: BorderRadius.circular(12),
//                   color: Colors.white,
//                 ),
//                 child: ClipRRect(
//                   borderRadius: BorderRadius.circular(12),
//                   child: customNetworkImage(
//                     _listOfStates[index].imagePath,
//                     defaultHolder: Image.asset(RImages.balochistanImage),
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//               ),
//               SizedBox(height: 10),
//               RText(
//                 _listOfStates[index].name!,
//                 variant: TypographyVariant.h1,
//                 style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
//               ),
//             ],
//           ),
//         );
//       },
//     );
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
//             // _buildTextField(),
//             Expanded(
//               child: Consumer<AuthState>(
//                 builder: (context, state, child) {
//                   _listOfStates = state.listOfStates;
//                   return state.isLoading
//                       ? Center(
//                           child: RLoader(),
//                         )
//                       : _buildCountryList();
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
