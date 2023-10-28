import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EditScreenCheckbox extends StatelessWidget {
  const EditScreenCheckbox({super.key, required this.value, required this.color,});

  final bool value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);

    return Container(
      width: 16,
      height: 16,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: color,
      ),
      child: value
          ? Icon(
              CupertinoIcons.check_mark,
              color: themeData.colorScheme.onPrimary,
              size: 12,
            )
          : null,
    );
  }
}
