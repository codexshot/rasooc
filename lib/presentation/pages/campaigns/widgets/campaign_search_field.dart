import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rasooc/domain/helper/size_configs.dart';
import 'package:rasooc/domain/providers/campaign_state.dart';

class CampaignSearchField extends StatefulWidget {
  @override
  _CampaignSearchFieldState createState() => _CampaignSearchFieldState();
}

class _CampaignSearchFieldState extends State<CampaignSearchField> {
  late TextEditingController _searchController;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    sizeConfig.init(context);
    final state = Provider.of<CampaignState>(context, listen: false);
    return Container(
      alignment: Alignment.center,
      height: sizeConfig.safeHeight! * 6,
      width: sizeConfig.safeWidth! * 100,
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.black),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _searchController,
              onChanged: (String query) {
                state.searchCampaignQuery(query);
              },
              toolbarOptions: ToolbarOptions(
                paste: true,
                copy: true,
                cut: true,
                selectAll: true,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "Search...",
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.clear),
            onPressed: () {
              _searchController.clear();
              state.clearQuery();
            },
          )
        ],
      ),
    );
  }
}
