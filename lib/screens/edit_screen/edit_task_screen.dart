import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';
import 'package:task_list_flutter/data/model/task_model.dart';
import 'package:task_list_flutter/data/repository/repository.dart';
import 'package:task_list_flutter/main.dart';
import 'package:task_list_flutter/screens/edit_screen/cubit/edit_task_cubit.dart';
import 'package:task_list_flutter/screens/edit_screen/priority_checkbox.dart';


class EditTaskScreen extends StatefulWidget {
  const EditTaskScreen({
    super.key,
    required this.taskBoxName,
  });

  final String taskBoxName;

  @override
  State<EditTaskScreen> createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  late final TextEditingController _controller;

  @override
    void initState() {
    _controller = TextEditingController(text: context.read<EditTaskCubit>().state.task.name);
      super.initState();
    }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);

    return Scaffold(
      backgroundColor: themeData.colorScheme.surface,
      // ---------------------appBar---------------------
      appBar: AppBar(
        elevation: 0,
        backgroundColor: themeData.colorScheme.surface,
        foregroundColor: themeData.colorScheme.onSurface,
        title: const Text('Edit Task'),
      ),
      // ---------------------Location of floating Action Button on the body---------------------
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      // ---------------------floating Action Button---------------------
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          context.read<EditTaskCubit>().onSaveChangeClick();
          Navigator.of(context).pop();
        },
        label: const Row(
          children: [
            Text('Save Changes'),
            SizedBox(width: 6),
            Icon(
              CupertinoIcons.check_mark_circled_solid,
              size: 20,
            ),
          ],
        ),
      ),
      // ---------------------Body---------------------
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            BlocBuilder<EditTaskCubit, EditTaskState>(
              builder: (context, state) {
                final priority = state.task.priority;
                return Flex(
                          direction: Axis.horizontal,
                          children: [
                            Flexible(
                              flex: 1,
                              child: PriorityCheckBox(
                                label: 'High',
                                color: highPriorityColor,
                                isSelected: priority == Priority.high,
                                onTap: () {
                                  context.read<EditTaskCubit>().onPriorityChanged(Priority.high);
                                },
                              ),
                            ),
                            const SizedBox(width: 8),
                            Flexible(
                              flex: 1,
                              child: PriorityCheckBox(
                                label: 'Normal',
                                color: normalPriorityColor,
                                isSelected: priority == Priority.normal,
                                onTap: () {
                                  context.read<EditTaskCubit>().onPriorityChanged(Priority.normal);
                                },
                              ),
                            ),
                            const SizedBox(width: 8),
                            Flexible(
                              flex: 1,
                              child: PriorityCheckBox(
                                label: 'Low',
                                color: lowPriorityColor,
                                isSelected: priority == Priority.low,
                                onTap: () {
                                  context.read<EditTaskCubit>().onPriorityChanged(Priority.low);
                                },
                              ),
                            ),
                          ],
                        );
              },
            ),
            TextField(
              controller: _controller,
              onChanged: (value){
                context.read<EditTaskCubit>().onTextChanged(value);
              },
              decoration: InputDecoration(
                label: Text(
                  'Add a task...',
                  style:
                      themeData.textTheme.bodyLarge!.apply(fontSizeFactor: 1.2),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
