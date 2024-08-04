import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rasooc/domain/helper/enums.dart';
import 'package:rasooc/domain/helper/utility.dart';
import 'package:rasooc/domain/models/post_submissions_model.dart';
import 'package:rasooc/domain/providers/post_state.dart';
import 'package:rasooc/presentation/common-widgets/common.dart';
import 'package:rasooc/presentation/common-widgets/custom_divider.dart';
import 'package:rasooc/presentation/common-widgets/custom_loader.dart';
import 'package:rasooc/presentation/common-widgets/custom_no_data_container.dart';
import 'package:rasooc/presentation/pages/posts/widgets/post_app_bar.dart';
import 'package:rasooc/presentation/pages/posts/widgets/post_view_tile.dart';
import 'package:rasooc/presentation/themes/common_themes.dart';

class PublishedPostScreen extends StatefulWidget {
  @override
  _PublishedPostScreenState createState() => _PublishedPostScreenState();
}

class _PublishedPostScreenState extends State<PublishedPostScreen> {
  ValueNotifier<bool> _isLoading = ValueNotifier<bool>(false);

  @override
  void dispose() {
    _isLoading.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    getPublishedSubmissions();
  }

  Future<void> getPublishedSubmissions() async {
    _isLoading.value = true;
    final state = Provider.of<PostState>(context, listen: false);
    await state.getSubmissionList(SubmissionStatus.published);
    _isLoading.value = false;
    if (state.error.isNotEmpty) {
      Utility.displaySnackbar(context,
          msg: "Some unexpected error occured. Please try again later");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PostAppBar(
        title: "Published Post",
        onLeadingPress: () {
          Navigator.of(context).pop();
        },
      ),
      body: ValueListenableBuilder<bool>(
        valueListenable: _isLoading,
        builder: (context, isLoading, _) => isLoading
            ? Center(child: RLoader())
            : Consumer<PostState>(
                builder: (context, state, _) =>
                    state.listOfSubmissions.isNotEmpty
                        ? SingleChildScrollView(
                            child: Column(
                                children: state.listOfSubmissions
                                    .map(
                                      (model) => PostViewTile(
                                        postSubmissionsModel: model,
                                      ),
                                    )
                                    .toList()),
                          )
                        : Center(
                            child: RNoDataContainer(
                              headingTitle: "No Published Posts",
                              subHeading:
                                  "Your published posts will be available here",
                            ),
                          ),
              ),
      ),
    );
  }
}
