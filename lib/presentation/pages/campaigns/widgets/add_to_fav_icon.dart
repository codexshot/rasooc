import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rasooc/domain/helper/utility.dart';
import 'package:rasooc/domain/providers/campaign_state.dart';
import 'package:rasooc/presentation/themes/colors.dart';

class AddToFavIcon extends StatefulWidget {
  final double? minHeight;
  final double? maxHeight;
  final int? campaignId;
  final bool? isFavCampaign;
  final Color? color;

  const AddToFavIcon({
    Key? key,
    required this.minHeight,
    required this.maxHeight,
    this.campaignId,
    this.isFavCampaign,
    this.color,
  }) : super(key: key);

  @override
  _AddToFavIconState createState() => _AddToFavIconState();
}

class _AddToFavIconState extends State<AddToFavIcon>
    with SingleTickerProviderStateMixin {
  // late AnimationController _controller;
  // late Animation _colorAnimation;
  // late Animation<double> _sizeAnimation;
  late bool isFav;

  @override
  void initState() {
    super.initState();
    isFav = widget.isFavCampaign ?? false;
    // _controller = AnimationController(
    //   duration: Duration(milliseconds: 250),
    //   vsync: this,
    // );
    // _colorAnimation = isFav
    //     ? ColorTween(begin: RColors.redColor, end: Colors.white)
    //         .animate(_controller)
    //     : ColorTween(begin: Colors.white, end: RColors.redColor)
    //         .animate(_controller);

    // _sizeAnimation = TweenSequence(<TweenSequenceItem<double>>[
    //   TweenSequenceItem<double>(
    //       tween: Tween<double>(begin: widget.minHeight, end: widget.maxHeight),
    //       weight: 50),
    //   TweenSequenceItem<double>(
    //       tween: Tween<double>(begin: widget.maxHeight, end: widget.minHeight),
    //       weight: 50),
    // ]).animate(_controller);

    // _controller.addStatusListener((status) async {
    //   print(status);
    //   if (status == AnimationStatus.dismissed) {
    //     setState(() {
    //       isFav = false;
    //       // state.toggleFavoriteCampaign(isFav, widget.campaignId ?? 0);
    //     });
    //   }
    //   if (status == AnimationStatus.completed) {
    //     setState(() {
    //       isFav = true;
    //       // state.toggleFavoriteCampaign(isFav, widget.campaignId ?? 0);
    //     });
    //   }
    // });
  }

  @override
  void dispose() {
    // _controller.dispose();
    super.dispose();
  }

  void toggleFavIcon() async {
    final state = Provider.of<CampaignState>(context, listen: false);

    setState(() {
      isFav = !isFav;
    });

    await state.toggleFavoriteCampaign(isFav, widget.campaignId ?? 0);

    if (state.error.isNotEmpty) {
      setState(() {
        isFav = !isFav;
      });
      Utility.displaySnackbar(context,
          msg: "Some unexpected error occured. Please try again later");
    }

    print(isFav);
  }

  @override
  Widget build(BuildContext context) {
    print("IS FAV -< ${widget.isFavCampaign}");

    return GestureDetector(
      onTap: toggleFavIcon,
      child: Icon(
        isFav ? Icons.star : Icons.star_border_outlined,
        // color: _colorAnimation.value,
        // size: _sizeAnimation.value,
        size: widget.minHeight,
        color: isFav ? RColors.favColor : widget.color ?? Colors.white,
      ),
    );
  }
}
