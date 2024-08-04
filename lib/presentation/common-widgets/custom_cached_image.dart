import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:rasooc/presentation/themes/images.dart';

Widget customNetworkImage(
  String? path, {
  BoxFit fit = BoxFit.contain,
  Widget? placeholder,
  double? height,
  double? width,
  Widget? defaultHolder,
}) {
  // assert(path != null);
  if (path == null || path.isEmpty) {
    return defaultHolder ??
        Image.asset(
          RImages.dashboardNoCampaignImage,
          height: 50,
          width: 50,
        );
  }
  return CachedNetworkImage(
    fit: fit,
    imageUrl: path,
    placeholderFadeInDuration: Duration(milliseconds: 500),
    placeholder: placeholder != null
        ? (context, url) => placeholder
        : (context, url) => Container(
              color: Colors.grey[300],
            ),
    errorWidget: (context, url, error) => defaultHolder ?? Icon(Icons.error),
    height: height,
    width: width,
  );
}
