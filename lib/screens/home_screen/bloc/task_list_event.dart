part of 'task_list_bloc.dart';

@immutable
abstract class TaskListEvent {}

class TaskListStarted extends TaskListEvent {}

class TaskListSearch extends TaskListEvent {

  TaskListSearch(this.searchKeyword);

  final String searchKeyword;
}

class TaskListDeleteAll extends TaskListEvent {}
