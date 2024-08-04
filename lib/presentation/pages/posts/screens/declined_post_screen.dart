import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rasooc/domain/helper/enums.dart';
import 'package:rasooc/domain/helper/utility.dart';
import 'package:rasooc/domain/providers/post_state.dart';
import 'package:rasooc/presentation/common-widgets/custom_loader.dart';
import 'package:rasooc/presentation/common-widgets/custom_no_data_container.dart';
import 'package:rasooc/presentation/pages/posts/widgets/post_app_bar.dart';
import 'package:rasooc/presentation/pages/posts/widgets/post_view_tile.dart';

class DeclinedPostScreen extends StatefulWidget {
  @override
  _DeclinedPostScreenState createState() => _DeclinedPostScreenState();
}

class _DeclinedPostScreenState extends State<DeclinedPostScreen> {
  ValueNotifier<bool> _isLoading = ValueNotifier<bool>(false);

  @override
  void dispose() {
    _isLoading.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    getDeclinedSubmissions();
  }

  Future<void> getDeclinedSubmissions() async {
    _isLoading.value = true;
    final state = Provider.of<PostState>(context, listen: false);
    await state.getSubmissionList(SubmissionStatus.declined);
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
        title: "Declined Post",
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
                              headingTitle: "No Declined Posts",
                              subHeading:
                                  "Your declined posts will be available here",
                            ),
                          ),
              ),
      ),
    );
  }
}
