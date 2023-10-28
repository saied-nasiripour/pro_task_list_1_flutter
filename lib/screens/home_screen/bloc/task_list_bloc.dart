import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:task_list_flutter/data/model/task_model.dart';
import 'package:task_list_flutter/data/repository/repository.dart';

part 'task_list_event.dart';

part 'task_list_state.dart';

class TaskListBloc extends Bloc<TaskListEvent, TaskListState> {
  final Repository<TaskModel> repository;

  TaskListBloc(this.repository) : super(TaskListInitial()) {
    /*
    inject the repository dependency here, as parameter
    * */
    on<TaskListEvent>((event, emit) async {
      /*
      on method is similar to ValueListenableBuilder
      &
      send an state to screen using emit()
      */
      if (event is TaskListStarted || event is TaskListSearch) {
        final String searchTerm;
        emit(TaskListLoading());
        // await Future.delayed(const Duration(seconds: 2)); // In order to test the display of loading
        if (event is TaskListSearch) {
          searchTerm = event.searchKeyword;
        } else {
          searchTerm = '';
        }

        try {
          // throw Exception('error');  // In order to test the Error
          /*
          items == tasks
          * */
          final items = await repository.getAll(searchKeyword: searchTerm);
          if (items.isNotEmpty) {
            emit(TaskListSuccess(items));
          } else {
            emit(TaskListEmpty());
          }
        } catch (e) {
          emit(TaskListError('UnKnown Error'));
        }
      } else if (event is TaskListDeleteAll) {
        await repository.deleteAll();
        emit(TaskListEmpty());
      }
    });
  }
}
