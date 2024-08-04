import 'package:flutter/material.dart';
import 'package:rasooc/domain/helper/size_configs.dart';
import 'package:rasooc/presentation/common-widgets/common.dart';
import 'package:rasooc/presentation/common-widgets/custom_cached_image.dart';
import 'package:rasooc/presentation/themes/common_themes.dart';

class Moodboard extends StatefulWidget {
  final List<String>? visualImages;

  const Moodboard({Key? key, this.visualImages}) : super(key: key);

  @override
  _MoodboardState createState() => _MoodboardState();
}

class _MoodboardState extends State<Moodboard> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final list = widget.visualImages;
    sizeConfig.init(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20),
        RText("MOODBOARD", variant: TypographyVariant.h1).pH(20),
        SizedBox(height: 10),
        Column(
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: PageView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: list!.isEmpty ? 1 : list.length,
                onPageChanged: (int val) {
                  setState(() {
                    _selectedIndex = val;
                  });
                },
                itemBuilder: (context, index) => customNetworkImage(
                  list.isEmpty
                      ? "https://cdn.pixabay.com/photo/2021/03/11/02/57/mountain-6086083__480.jpg"
                      : list[index],
                  fit: BoxFit.fill,
                  defaultHolder: Image.asset(
                    RImages.islamabadImage,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: list.isEmpty
                  ? [
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 2),
                        child: CircleAvatar(
                          radius: 4,
                          backgroundColor: RColors.primaryColor,
                        ),
                      ),
                    ]
                  : list
                      .asMap()
                      .entries
                      .map(
                        (mE) => Container(
                          margin: EdgeInsets.symmetric(horizontal: 2),
                          child: CircleAvatar(
                            radius: 4,
                            backgroundColor: mE.key == _selectedIndex
                                ? RColors.primaryColor
                                : RColors.secondaryColor,
                          ),
                        ),
                      )
                      .toList(),
            )
          ],
        ),
        SizedBox(height: 20),
      ],
    );
  }
}
