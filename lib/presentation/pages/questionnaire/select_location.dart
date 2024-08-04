import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rasooc/domain/models/geographic_entity.dart';
import 'package:rasooc/domain/providers/auth_state.dart';
import 'package:rasooc/presentation/common-widgets/custom_loader.dart';
import 'package:rasooc/presentation/common-widgets/custom_text.dart';
import 'package:rasooc/presentation/common-widgets/custom_text_field.dart';
import 'package:rasooc/presentation/common-widgets/top_icon.dart';
import 'package:rasooc/presentation/themes/extensions.dart';
import 'package:rasooc/presentation/themes/images.dart';

typedef SetLocation = void Function(GeographicEntity);

class SelectLocation extends StatefulWidget {
  final SetLocation setLocationFn;
  final List<GeographicEntity> locations;
  final String title;
  final Function(String) onSearch;

  const SelectLocation(
      {Key? key,
      required this.setLocationFn,
      required this.title,
      required this.locations,
      required this.onSearch})
      : super(key: key);
  @override
  _SelectLocationState createState() => _SelectLocationState();
}

class _SelectLocationState extends State<SelectLocation> {
  List<GeographicEntity> _listOfLocations = [];
  late TextEditingController _locationController;
  ValueNotifier<bool> _isLoading = ValueNotifier<bool>(false);

  @override
  void dispose() {
    _locationController.dispose();
    _isLoading.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _locationController = TextEditingController();
  }

  Widget _buildTopIcon() {
    return TopIcon(
      imagePath: RImages.coronaVirusImage,
      title: "Select ${widget.title}",
    );
  }

  Widget _buildTextField() {
    return RTextField(
      onChanged: (value) {
        widget.onSearch(value);
      },
      choice: Choice.optionalText,
      labelText: "Search ${widget.title}",
    ).pH(12);
  }

  Widget _buildLocationList() {
    return ListView.separated(
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
            children: [
              ListTile(
                title: RText(
                  _listOfLocations[index].name,
                  variant: TypographyVariant.h1,
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
                ),
                trailing: Icon(Icons.chevron_right, color: Colors.grey),
              ),
            ],
          ),
        );
      },
      separatorBuilder: (BuildContext context, int index) => Divider(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AuthState>();
    return WillPopScope(
      onWillPop: () async {
        provider
          ..clearCountrySearchList()
          ..clearCitySearchList()
          ..clearStateSearchList();

        return true;
      },
      child: Scaffold(
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
              onPressed: () {
                provider
                  ..clearCountrySearchList()
                  ..clearCitySearchList()
                  ..clearStateSearchList();
                Navigator.of(context).pop();
              },
            ).pH(20),
          ],
        ),
        body: SafeArea(
          child: Column(
            children: [
              _buildTopIcon(),
              SizedBox(height: 24),
              _buildTextField(),
              // _buildTextField(),
              Expanded(
                child: Consumer<AuthState>(
                  builder: (context, state, child) {
                    _listOfLocations = widget.title.toLowerCase() == "country"
                        ? state.displayCountryList
                        : widget.title.toLowerCase() == "state"
                            ? state.displayStateList
                            : state.displayCityList;
                    return state.isLoading
                        ? Center(
                            child: RLoader(),
                          )
                        : _buildLocationList();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
