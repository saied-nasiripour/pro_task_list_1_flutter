import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';
import 'package:task_list_flutter/data/model/task_model.dart';
import 'package:task_list_flutter/data/repository/repository.dart';
import 'package:task_list_flutter/screens/edit_screen/cubit/edit_task_cubit.dart';
import 'package:task_list_flutter/screens/home_screen/task_item.dart';
import 'package:task_list_flutter/widgets/empty_list.dart';
import 'package:task_list_flutter/main.dart';
import '../edit_screen/edit_task_screen.dart';
import 'bloc/task_list_bloc.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key, required this.taskBoxName});

  final String taskBoxName;
  final TextEditingController controller = TextEditingController();

  /*
  // Since we want to use BLoC, we don't need this part anymore
  final ValueNotifier<String> searchKeyboardNotifier = ValueNotifier('');
   */

  @override
  Widget build(BuildContext context) {
    /*
    In Hive, data is stored in containers called "boxes."
    Each box is like a separate storage unit where you can store and query data.
    You can have multiple boxes for different types of data.
    */
    //final box = Hive.box<TaskModel>(taskBoxName);
    /*
    Use `repository` instead of `box`
    */

    final themeData = Theme.of(context);

    return Scaffold(
      // disable default appBar
      // appBar: AppBar(
      //   title: const Text('To Do List'),
      // ),
      // ---------------------Location of floating Action Button on the body---------------------
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      // ---------------------floating Action Button---------------------
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) =>
                  BlocProvider(
                    create: (context) => EditTaskCubit(TaskModel(), context.read<Repository<TaskModel>>()),
                    child: EditTaskScreen(
                      taskBoxName: taskBoxName),
                  ),
            ),
          );
        },
        label: const Row(
          children: [
            Text('Add New Task'),
            SizedBox(width: 6),
            Icon(CupertinoIcons.add_circled_solid),
          ],
        ),
      ),
      // ---------------------Body---------------------
      body: BlocProvider<TaskListBloc>(
        create: (context) =>
            TaskListBloc(context.read<Repository<TaskModel>>()),
        child: SafeArea(
          child: Column(
            children: [
              // ---------------------Header---------------------
              Container(
                height: 110,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      themeData.colorScheme.primary,
                      themeData.colorScheme.primaryContainer,
                    ],
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    children: [
                      // ---------------------Header : Title & Icon---------------------
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'To Do List',
                            style: themeData.textTheme.titleLarge?.apply(
                              color: themeData.colorScheme.onPrimary,
                            ),
                          ),
                          Icon(
                            CupertinoIcons.share,
                            color: themeData.colorScheme.onPrimary,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      // ---------------------Header : Search Box---------------------
                      Container(
                        height: 38,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(19),
                          color: themeData.colorScheme.onPrimary,
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 20)
                          ],
                        ),
                        child: TextField(
                          controller: controller,
                          onChanged: (value) {
                            /*searchKeyboardNotifier.value = controller.text;*/
                            context.read<TaskListBloc>().add(
                                TaskListSearch(value));
                          },
                          decoration: InputDecoration(
                            // The bottom line is set in the theme section (`inputDecorationTheme`)
                            /*border: InputBorder.none,*/
                            prefixIcon: Icon(
                              CupertinoIcons.search,
                              color: themeData.inputDecorationTheme.iconColor,
                            ),
                            label: Text(
                              'Search Tasks...',
                              style: themeData.inputDecorationTheme.labelStyle,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // ---------------------List---------------------
              Expanded(
                /*
              // Due to the use of the `BLoC`, we no longer need to use this section
              child: ValueListenableBuilder<String>(
                // Listener for search-field changes
                // If the value of valueListenable (searchKeyboardNotifier) changes, the builder will also be re-rendered.
                valueListenable: searchKeyboardNotifier,
                builder: (context, value, child) {

                  /*
                  // Due to the use of the `provider`, we no longer need to use this section

                  return ValueListenableBuilder<Box<TaskModel>>(
                    // Listener for box changes
                    // Note that `ValueListenableBuilder` is a flutter Widget
                    /*
                      `ValueListenableBuilder` is a Flutter widget that allows you to build a part of your user interface based on changes to a `ValueListenable` object.
                      It's a useful tool for creating reactive UI components that automatically update when the underlying data changes.

                      Here's how ValueListenableBuilder works:
                      1- `ValueListenable`: You provide a ValueListenable object, typically a ValueNotifier or any other class that implements the ValueListenable interface. This object holds some value, and when that value changes, it notifies the ValueListenableBuilder.
                      2- `Builder Function`: You specify a builder function that takes two arguments: the current BuildContext and the current value of the ValueListenable. This builder function is called whenever the value of the ValueListenable changes. Inside this function, you define the UI components that should be built based on the current value.
                      3- `Reactive UI`: The ValueListenableBuilder automatically rebuilds its UI whenever the value inside the ValueListenable changes. This allows you to create responsive UI components that update themselves when the data they depend on changes.

                      • `ValueListenableBuilder` listens to changes in `box.listenable()` and rebuilds the UI when the `box` changes
                      • `ValueListenableBuilder` is a convenient way to create reactive UI components that respond to changes in data without needing to manage state manually.
                    **/
                    valueListenable: box.listenable(),
                    builder: (context, value, child) {
                      final List<TaskModel> items;
                      if (controller.text.isEmpty) {
                        // If the search field is empty
                        items = box.values.toList();
                      } else {
                        items = box.values.where((element) => element.name.contains(controller.text)).toList();
                        // element == item == task
                      }

                      if (items.isNotEmpty) {
                        return _TasksList(items: items, themeData: themeData);
                      } else {
                        return const EmptyList();
                      }
                    },
                  );
                   */

                  // final List<TaskModel> items;
                  // final Repository<TaskModel> repository = Provider.of<Repository<TaskModel>>(context);
                  return Consumer<Repository<TaskModel>>(
                    builder: (context, value, child){
                      // value == repository
                      return FutureBuilder<List<TaskModel>>(
                        future: value.getAll(searchKeyword: controller.text),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            if (snapshot.data!.isNotEmpty) {
                              return _TasksList(
                                  items: snapshot.data!, themeData: themeData);
                            } else {
                              return const EmptyList();
                            }
                          } else {
                            return const CircularProgressIndicator();
                          }
                        },
                      );
                    },
                  );
                },
              ),

               */

                child: Consumer<Repository<TaskModel>>(
                  // Whenever the `Repository` changes, this function (`builder`) is called
                    builder: (context, model, child) {
                      context.read<TaskListBloc>().add(TaskListStarted());
                      // using `BLoC` instead of `ValueListenableBuilder` & `provider`
                      return BlocBuilder<TaskListBloc, TaskListState>(
                        // Whenever the BLoC state changes, this function (`BlocBuilder`) is called, and returns the state and context to you
                        builder: (context, state) {
                          if (state is TaskListSuccess) {
                            return _TasksList(
                                items: state.items, themeData: themeData);
                          } else if (state is TaskListEmpty) {
                            return const EmptyList();
                          } else if (state is TaskListLoading ||
                              state is TaskListInitial) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          } else if (state is TaskListError) {
                            return Center(
                              child: Text(state.errorMessage),
                            );
                          } else {
                            throw Exception('state is not valid...');
                          }
                        },
                      );
                    }
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TasksList extends StatelessWidget {
  const _TasksList({
    super.key,
    required this.items,
    required this.themeData,
  });

  final List<TaskModel> items;
  final ThemeData themeData;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 100.0),
      // itemCount: box.values.length,
      // Note : box == value
      // itemCount: value.values.length + 1,
      itemCount: items.length + 1,
      /*
        inside of itemCount, +1 is added for when: index==0
      */
      itemBuilder: (context, index) {
        // index: row number
        // Retrieving tasks
        if (index == 0) {
          // first Row
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Today',
                    style: themeData.textTheme.titleLarge
                        ?.apply(fontSizeFactor: 0.9),
                  ),
                  Container(
                    width: 80,
                    height: 3,
                    margin: const EdgeInsets.only(top: 4),
                    decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.circular(1.5),
                    ),
                  ),
                ],
              ),
              // ---------------------Delete All Button---------------------
              MaterialButton(
                color: const Color(0xFFEAEFF5),
                textColor: secondaryTextColor,
                elevation: 0,
                onPressed: () {
                  /*
                  // use Provider
                  final taskRepository = Provider.of<Repository<TaskModel>>(
                      context,
                      listen: false);
                  taskRepository.deleteAll();
                   */
                  context.read<TaskListBloc>().add(TaskListDeleteAll());
                },
                child: const Row(
                  children: [
                    Text('Delete All'),
                    SizedBox(width: 4),
                    Icon(
                      CupertinoIcons.delete_solid,
                      size: 18,
                    ),
                  ],
                ),
              ),
            ],
          );
        } else {
          // final Task task = box.values.toList()[index]
          // Note : box == value
          // final TaskModel task = value.values.toList()[index - 1];
          final TaskModel task = items[index - 1];
          return TaskItem(task: task);
        }
      },
    );
  }
}
