import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rasooc/domain/helper/enums.dart';
import 'package:rasooc/domain/helper/utility.dart';
import 'package:rasooc/domain/providers/post_state.dart';
import 'package:rasooc/presentation/common-widgets/custom_loader.dart';
import 'package:rasooc/presentation/common-widgets/custom_no_data_container.dart';
import 'package:rasooc/presentation/pages/posts/screens/pending/widgets/pending_tile.dart';
import 'package:rasooc/presentation/pages/posts/widgets/post_app_bar.dart';

class PendingPostScreen extends StatefulWidget {
  @override
  _PendingPostScreenState createState() => _PendingPostScreenState();
}

class _PendingPostScreenState extends State<PendingPostScreen> {
  final ValueNotifier<bool> _isLoading = ValueNotifier<bool>(false);

  @override
  void dispose() {
    _isLoading.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    getPendingSubmissions();
  }

  Future<void> getPendingSubmissions() async {
    _isLoading.value = true;
    final state = Provider.of<PostState>(context, listen: false);
    await state.getSubmissionList(SubmissionStatus.pending);
    if (state.error.isNotEmpty) {
      Utility.displaySnackbar(context,
          msg: "Some unexpected error occured. Please try again later");
    }
    _isLoading.value = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PostAppBar(
        title: "Pending Post",
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
                                      (model) => PendingTile(
                                        postSubmissionsModel: model,
                                        onWithDrawn: (bool val) {
                                          if (val) {
                                            if (state.error.isNotEmpty) {
                                              Utility.displaySnackbar(context,
                                                  msg: state.error);
                                            } else {
                                              Utility.displaySnackbar(context,
                                                  msg:
                                                      "Submission Withdrawn successfully");
                                            }
                                          }
                                        },
                                      ),
                                    )
                                    .toList()),
                          )
                        : Center(
                            child: RNoDataContainer(
                              headingTitle: "No Pending Posts",
                              subHeading:
                                  "Your pending posts will be available here",
                            ),
                          ),
              ),
      ),
    );
  }
}
