import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:rasooc/domain/helper/navigation_helper.dart';
import 'package:rasooc/domain/helper/shared_pref_helper.dart';
import 'package:rasooc/domain/helper/size_configs.dart';
import 'package:rasooc/domain/models/campaign_short_model.dart';
import 'package:rasooc/domain/models/user_dependant_models.dart';
import 'package:rasooc/domain/providers/auth_state.dart';
import 'package:rasooc/domain/providers/campaign_state.dart';
import 'package:rasooc/domain/providers/social_account_state.dart';
import 'package:rasooc/presentation/common-widgets/common.dart';
import 'package:rasooc/presentation/common-widgets/custom_loader.dart';
import 'package:rasooc/presentation/common-widgets/custom_no_data_container.dart';
import 'package:rasooc/presentation/common-widgets/custom_refresh_indicator.dart';
import 'package:rasooc/presentation/pages/campaigns/campaigns_search_screen.dart';
import 'package:rasooc/presentation/pages/campaigns/widgets/campaign_item.dart';
import 'package:rasooc/presentation/pages/categories/categories.dart';

class CampaignsScreen extends StatefulWidget {
  @override
  _CampaignsScreenState createState() => _CampaignsScreenState();
}

class _CampaignsScreenState extends State<CampaignsScreen> {
  late ScrollController _scrollController;
  final ValueNotifier<bool> _isFetching = ValueNotifier<bool>(false);
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();
  int pageId = 1;

  @override
  void dispose() {
    _scrollController.dispose();
    _isFetching.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    getCampagins();
    getConnectedAccounts();
    _scrollController = ScrollController()..addListener(listener);
  }

  Future<void> listener() async {
    if (_scrollController.position.maxScrollExtent - _scrollController.offset <
            100 &&
        !_scrollController.position.outOfRange) {
      await getMoreCampaigns();
    }
  }

  Future<void> getMoreCampaigns() async {
    _isFetching.value = true;
    final state = Provider.of<CampaignState>(context, listen: false);
// await state.getCampaigns()  //TODO: ADD LOGIC
    _isFetching.value = false;
  }

  Future<void> getConnectedAccounts() async {
    final state = Provider.of<SocialAccountState>(context, listen: false);
    if ((state.socialAccountsModel.facebookDetails != null &&
            state.socialAccountsModel.facebookDetails!.isNotEmpty) ||
        (state.socialAccountsModel.instaDetails != null &&
            state.socialAccountsModel.instaDetails!.instagramId != null) ||
        (state.socialAccountsModel.twitterDetails != null &&
            state.socialAccountsModel.twitterDetails!.isNotEmpty)) {
      return;
    } else {
      await state.getConnectedAccounts();
    }
  }

  Future<void> getCampagins() async {
    final state = Provider.of<CampaignState>(context, listen: false);
    if (state.listOfCampaigns.isEmpty) {
      await state.getCampaigns();
    }

    final pref = GetIt.instance<SharedPreferenceHelper>();
    List<CategoryModel> categories;
    categories = await pref.getCategories();
    if (categories.isEmpty) {
      await Provider.of<AuthState>(context, listen: false)
          .getCampaignCategories();
      categories = await pref.getCategories();
    }
    state.setAllCategories(categories);
  }

  @override
  Widget build(BuildContext context) {
    sizeConfig.init(context);
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(Icons.sort, color: Colors.black),
          onPressed: () {
            NavigationHelpers.push(context, CategoriesScreen());
          },
        ),
        title: Consumer<CampaignState>(
          builder: (context, state, _) =>
              RText(state.appBarTitle, variant: TypographyVariant.titleSmall),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: Colors.black),
            onPressed: () {
              NavigationHelpers.push(context, CampaignsSearchScreen());
            },
          ),
          SizedBox(width: 10),
        ],
      ),
      body: Consumer<CampaignState>(
        builder: (context, state, child) => state.isLoading
            ? Center(child: RLoader())
            : state.listOfCampaigns.isEmpty
                ? Center(
                    child: RNoDataContainer(
                      headingTitle: "Campaign for this category",
                      subHeading: "Currently there are none active",
                    ),
                  )
                : SingleChildScrollView(
                    controller: _scrollController,
                    padding: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                    child: Stack(
                      children: [
                        Column(
                          children: state.listOfCampaigns
                              .map((model) => _buildCampaigns(model))
                              .toList(),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: ValueListenableBuilder<bool>(
                            valueListenable: _isFetching,
                            builder: (context, value, child) => value
                                ? CircularProgressIndicator()
                                : SizedBox(),
                          ),
                        ),
                      ],
                    ),
                  ),
      ),
    );
  }

  Widget _buildCampaigns(CampaignShortModel model) {
    return CampaignItem(
      campaignShortModel: model,
      scaffoldKey: _scaffoldKey,
    );
  }
}
