part of 'edit_task_cubit.dart';

@immutable
abstract class EditTaskState {
  const EditTaskState(this.task);
  final TaskModel task;
}

class EditTaskInitial extends EditTaskState {
  const EditTaskInitial(super.task);
}

class EditTaskPriorityChange extends EditTaskState {
  const EditTaskPriorityChange(super.task);
}
