import 'package:flutter/material.dart';
import 'package:task_list_flutter/widgets/edit_screen_checkbox.dart';
import 'package:task_list_flutter/main.dart';

class PriorityCheckBox extends StatelessWidget {
  const PriorityCheckBox({
    super.key,
    required this.label,
    required this.color,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final Color color;
  final bool isSelected;
  final GestureTapCallback onTap;

  @override
  Widget build(BuildContext context) {

    return InkWell(
      onTap: onTap,
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            width: 2,
            color: secondaryTextColor.withOpacity(0.2),
          ),
        ),
        child: Stack(
          children: [
            Center(
              child: Text(label),
            ),
            Positioned(
                right: 8,
                top: 0,
                bottom: 0,
                child: Center(
                  child: EditScreenCheckbox(
                    value: isSelected,
                    color: color,
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
