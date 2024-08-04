import 'package:flutter/material.dart';
import 'package:rasooc/domain/helper/size_configs.dart';
import 'package:rasooc/presentation/common-widgets/custom_cached_image.dart';

class CampaignDetailImage extends StatelessWidget {
  final String? coverImage;
  final String? brandLogo;

  const CampaignDetailImage({Key? key, this.coverImage, this.brandLogo})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    sizeConfig.init(context);
    return Stack(
      children: [
        customNetworkImage(
          coverImage ??
              "https://cdn.pixabay.com/photo/2020/12/13/16/21/stork-5828727_1280.jpg",
          height: sizeConfig.safeHeight! * 25,
          fit: BoxFit.cover,
          width: double.infinity,
          defaultHolder: Container(),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: customNetworkImage(
              brandLogo ??
                  "https://cdn.pixabay.com/photo/2021/02/08/16/03/dinosaur-5995333_1280.png",
              height: sizeConfig.safeHeight! * 10,
              width: sizeConfig.safeWidth! * 22,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ],
    );
  }
}
