import 'package:flutter/material.dart';
import 'package:rasooc/domain/models/campaign_detail_model.dart';
import 'package:rasooc/presentation/common-widgets/common.dart';
import 'package:rasooc/presentation/common-widgets/custom_tags.dart';
import 'package:rasooc/presentation/themes/common_themes.dart';

class AdditionalTags extends StatelessWidget {
  final CampaignDetailModel? campaign;

  const AdditionalTags({Key? key, this.campaign}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final instaTags = campaign!.instaTags;
    final fbTags = campaign!.fbTag;
    final twitterTags = campaign!.twitterTag;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        RText("ADDITIONAL TAGS", variant: TypographyVariant.h1),
        const SizedBox(height: 20),
        if (instaTags != null && instaTags.isNotEmpty)
          _buildTagContainer("Instagram", instaTags)
        else
          const SizedBox(),
        if (fbTags != null && fbTags.isNotEmpty)
          _buildTagContainer("Facebook", fbTags)
        else
          const SizedBox(),
        if (twitterTags != null && twitterTags.isNotEmpty)
          _buildTagContainer("Twitter", twitterTags)
        else
          const SizedBox(),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildTagContainer(String title, List<String> tags) {
    return tags.isNotEmpty
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RText(
                title,
                variant: TypographyVariant.h2,
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 10),
              Container(
                child: GridView.builder(
                  itemCount: tags.length,
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 5.0,
                    mainAxisSpacing: 5.0,
                    childAspectRatio: 5.5,
                  ),
                  itemBuilder: (context, index) => _buildTag(
                    tags[index],
                  ),
                ),
              ),
              SizedBox(height: 10),
            ],
          )
        : SizedBox();
  }

  Widget _buildTag(String tag) {
    return RTags(
      tag: tag,
    );
  }
}
