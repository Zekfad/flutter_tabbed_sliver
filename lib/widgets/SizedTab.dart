import 'package:flutter/material.dart';


/// Tab with predefined minimum size
class SizedTab extends StatelessWidget {
  const SizedTab(
    this.text,
    {
      super.key,
      this.minWidth = 0,
    }
  ) : super();

  final String text;
  final double minWidth;

  @override
  Widget build(BuildContext context) =>
    Tooltip(
      preferBelow: true,
      verticalOffset: 35,
      message: text,
      child: Tab(
        child: Container(
          constraints: BoxConstraints(
            minWidth: minWidth,
          ),
          child: Center(
            child: Text(text),
          ),
        ),
      ),
    );
}
