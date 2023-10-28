import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_list_flutter/data/model/task_model.dart';
import 'package:task_list_flutter/data/repository/repository.dart';
import 'package:task_list_flutter/screens/edit_screen/cubit/edit_task_cubit.dart';
import 'package:task_list_flutter/screens/edit_screen/edit_task_screen.dart';
import 'package:task_list_flutter/main.dart';
import 'package:task_list_flutter/widgets/main_screen_checkbox.dart';

class TaskItem extends StatefulWidget {
  const TaskItem({super.key, required this.task});

  final TaskModel task;
  static const double taskItemHeight = 74;
  static const double taskItemBorderRadius = 8.0;

  @override
  State<TaskItem> createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> {
  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final Color priorityColor;

    switch (widget.task.priority) {
      case Priority.low:
        priorityColor = lowPriorityColor;
      case Priority.normal:
        priorityColor = normalPriorityColor;
      case Priority.high:
        priorityColor = highPriorityColor;
    }

    return InkWell(
      onTap: () {
        // setState(() {
        //   widget.task.isCompleted = !widget.task.isCompleted;
        // });
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) =>
                BlocProvider<EditTaskCubit>(
                  create: (context) => EditTaskCubit(widget.task, context.read<Repository<TaskModel>>()),
                  child: EditTaskScreen(taskBoxName: taskBoxName),
                ),
          ),
        );
      },
      onLongPress: () {
        widget.task.delete();
      },
      child: Container(
        height: TaskItem.taskItemHeight,
        margin: const EdgeInsets.only(top: 8.0),
        padding: const EdgeInsets.only(left: 16.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(TaskItem.taskItemBorderRadius),
          color: themeData.colorScheme.surface,
          // boxShadow: [
          //   BoxShadow(
          //     color: Colors.black.withOpacity(0.2),
          //     blurRadius: 20,
          //   ),
          // ],
        ),
        child: Row(
          children: [
            // --------------------- Circular CheckBox ---------------------
            MainScreenCheckbox(
              value: widget.task.isCompleted,
              onTap: () {
                setState(() {
                  widget.task.isCompleted = !widget.task.isCompleted;
                });
              },
            ),
            const SizedBox(width: 16),
            // --------------------- task item text ---------------------
            Expanded(
              child: Text(
                widget.task.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 20,
                  decoration: widget.task.isCompleted
                      ? TextDecoration.lineThrough
                      : null,
                ),
              ),
            ),
            const SizedBox(width: 8.0),
            // --------------------- The colored vertical bar indicates priority on the right side ---------------------
            Container(
              width: 5,
              height: TaskItem.taskItemHeight,
              decoration: BoxDecoration(
                color: priorityColor,
                borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(TaskItem.taskItemBorderRadius),
                    bottomRight:
                    Radius.circular(TaskItem.taskItemBorderRadius)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
