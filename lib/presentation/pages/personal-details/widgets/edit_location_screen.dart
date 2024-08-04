import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rasooc/domain/models/geographic_entity.dart';
import 'package:rasooc/domain/providers/account_settings_state.dart';
import 'package:rasooc/presentation/common-widgets/custom_cached_image.dart';
import 'package:rasooc/presentation/common-widgets/custom_loader.dart';
import 'package:rasooc/presentation/common-widgets/custom_text.dart';
import 'package:rasooc/presentation/common-widgets/custom_text_field.dart';
import 'package:rasooc/presentation/common-widgets/top_icon.dart';
import 'package:rasooc/presentation/themes/extensions.dart';
import 'package:rasooc/presentation/themes/images.dart';

typedef SetLocation = void Function(GeographicEntity);

class EditLocationScreen extends StatefulWidget {
  final List<GeographicEntity> locations;
  final SetLocation setLocationFn;
  final String title;

  const EditLocationScreen(
      {Key? key,
      required this.locations,
      required this.setLocationFn,
      required this.title})
      : super(key: key);
  @override
  _EditLocationScreenState createState() => _EditLocationScreenState();
}

class _EditLocationScreenState extends State<EditLocationScreen> {
  List<GeographicEntity> _listOfLocations = [];
  late TextEditingController _stateController;

  @override
  void dispose() {
    _stateController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _stateController = TextEditingController();
    intializeData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setState(() {
      intializeData();
    });
  }

  void intializeData() {
    _listOfLocations = widget.locations;
  }

  Widget _buildTopIcon() {
    return TopIcon(
      imagePath: RImages.coronaVirusImage,
      title: "Select ${widget.title}",
    );
  }

  Widget _buildTextField() {
    return RTextField(
      choice: Choice.optionalText,
      labelText: "Search ${widget.title}",
    ).pH(12);
  }

  Widget _buildCountryList() {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
      ),
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      shrinkWrap: true,
      itemCount: _listOfLocations.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            widget.setLocationFn(_listOfLocations[index]);
            Navigator.of(context).pop();
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                height: 120,
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black26,
                        blurRadius: 2.0,
                        offset: Offset(0.0, 0.0))
                  ],
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: customNetworkImage("",
                      defaultHolder: Image.asset(RImages.balochistanImage),
                      fit: BoxFit.cover),
                ),
              ),
              SizedBox(height: 10),
              RText(
                _listOfLocations[index].name,
                variant: TypographyVariant.h1,
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        elevation: 0.0,
        actions: [
          IconButton(
            icon: Icon(
              Icons.clear,
              size: 30,
              color: Colors.grey,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ).pH(20),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            _buildTopIcon(),
            SizedBox(height: 40),
            // _buildTextField(),
            Expanded(
              child: Consumer<AccountSettingsState>(
                builder: (context, state, child) {
                  _listOfLocations = widget.locations;
                  return state.isLoading
                      ? Center(
                          child: RLoader(),
                        )
                      : _buildCountryList();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
