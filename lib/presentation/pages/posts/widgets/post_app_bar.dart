import 'package:flutter/material.dart';
import 'package:rasooc/presentation/common-widgets/common.dart';

class PostAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final IconData leadingIcon;
  final Function()? onLeadingPress;
  final Widget? actionIcon;

  const PostAppBar({
    Key? key,
    required this.title,
    this.leadingIcon = Icons.arrow_back_ios,
    this.onLeadingPress,
    this.actionIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      title: RText(
        title,
        variant: TypographyVariant.titleSmall,
      ),
      elevation: 0.0,
      centerTitle: true,
      leading: IconButton(
        color: Colors.black,
        icon: Icon(leadingIcon),
        onPressed: onLeadingPress,
      ),
      actions: [
        actionIcon ?? SizedBox(),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
