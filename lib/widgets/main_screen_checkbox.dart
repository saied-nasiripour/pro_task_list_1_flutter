import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:task_list_flutter/main.dart';

class MainScreenCheckbox extends StatelessWidget {
  const MainScreenCheckbox({super.key, required this.value, required this.onTap});

  final bool value;
  final GestureTapCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);

    return InkWell(
      /*
      This function (nnTap) indicates that when the checkbox is clicked, the task should be considered finished
       */
      onTap: onTap,
      child: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: !value
              ? Border.all(
                  color: secondaryTextColor,
                  width: 2,
                )
              : null,
          color: value ? primaryColor : null,
        ),
        child: value
            ? Icon(
                CupertinoIcons.check_mark,
                color: themeData.colorScheme.onPrimary,
                size: 16,
              )
            : null,
      ),
    );
  }
}
