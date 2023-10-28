part of 'task_list_bloc.dart';

@immutable
abstract class TaskListState {}

class TaskListInitial extends TaskListState {}

class TaskListLoading extends TaskListState {}

class TaskListSuccess extends TaskListState {

  TaskListSuccess(this.items);

  final List<TaskModel> items;

}

class TaskListEmpty extends TaskListState {}

class TaskListError extends TaskListState {
  TaskListError(this.errorMessage);

  final String errorMessage;
}