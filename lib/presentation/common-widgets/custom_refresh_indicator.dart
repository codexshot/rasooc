import 'package:flutter/material.dart';
import 'package:rasooc/presentation/themes/colors.dart';

class RRefreshIndicator extends StatefulWidget {
  final Widget child;
  final Future<void> Function() onRefresh;

  const RRefreshIndicator(
      {Key? key, required this.child, required this.onRefresh})
      : super(key: key);

  @override
  _RRefreshIndicatorState createState() => _RRefreshIndicatorState();
}

class _RRefreshIndicatorState extends State<RRefreshIndicator> {
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: widget.onRefresh,
      backgroundColor: Colors.white,
      color: RColors.primaryColor,
      child: widget.child,
    );
  }
}
