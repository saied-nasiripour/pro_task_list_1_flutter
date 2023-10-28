import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:task_list_flutter/data/repository/repository.dart';
import 'package:task_list_flutter/data/source/hive_task_source.dart';
import 'data/model/task_model.dart';
import 'screens/home_screen/home_screen.dart';

// Global Constant's
const taskBoxName = 'tasks';
const Color primaryColor = Color(0xFF794CFF);
const Color primaryContainerColor = Color(0xFF5C0AFF);
const Color secondaryTextColor = Color(0xFFAFBED0);
const Color highPriorityColor = primaryColor;
const Color normalPriorityColor = Color(0xFFF09819);
const Color lowPriorityColor = Color(0xFF3BE1F1);

void main() async {
  /*
  `await Hive.initFlutter()`; is a line of code used to initialize the Hive database for Flutter applications.
  Hive is a local NoSQL database library for Flutter,
  and before you can use it to interact with data, you need to initialize it.

  Here's what's happening in that line of code:
  1- `Hive` is the main class provided by the Hive package, which you use to work with the database.
  2- `initFlutter()` is a method provided by Hive that initializes the Hive database for use in a Flutter application. It sets up the necessary configurations and prepares Hive to work with your Flutter project.
  3- `await` is used before the Hive.initFlutter() call because the initialization process may involve asynchronous tasks, such as setting up file storage or accessing platform-specific resources. Using await ensures that the initialization is completed before further code execution.

  Once you have initialized Hive using `Hive.initFlutter()`,
  you can open boxes, define data models,
  and perform read and write operations on your local database.
  It's a crucial step to set up Hive for managing and persisting data in your Flutter app.
  * */
  await Hive.initFlutter();
  /*
  `Hive.registerAdapter(TaskAdapter())`; is a line of code used to register a custom adapter for a Dart class when working with Hive in Flutter.
  Let's break down what this code does:

  1- `Hive`: This is the main class provided by the Hive package, used to interact with the Hive database, which is a local NoSQL database.
  2- `registerAdapter(TaskAdapter())`: This code registers a custom adapter for a specific Dart class, in this case, `Task`. An adapter is responsible for serializing and deserializing instances of the Dart class so that they can be stored and retrieved from the Hive database.
      --`TaskAdapter()`: This part of the code creates an instance of a custom adapter for the `Task` class. The adapter should be specifically designed to handle the serialization and deserialization of `Task` objects.


  By registering a custom adapter for a Dart class, you're telling Hive how to convert instances of that class into a format that can be stored in the database (serialization) and how to recreate instances from the stored format (deserialization).

  For example, if your `Task` class has complex data structures or non-primitive data types, you'll need to create a custom adapter to ensure that Hive can properly store and retrieve `Task` objects.
  * */
  Hive.registerAdapter(TaskModelAdapter());
  Hive.registerAdapter(PriorityAdapter());
  /*
  `await Hive.openBox<Task>('tasks')`; is a line of code used to open a Hive database box named 'tasks' for working with data of the type Task. Let's break down what this code does:

  1- `Hive`: This is the main class provided by the Hive package. It's used to interact with the Hive database, which is a local NoSQL database often used in Flutter applications.
  2- `openBox<Task>('tasks')`: This part of the code is calling the openBox method on the Hive class. It's used to create or open a database box with the specified name, in this case, 'tasks'.
    --`Task`: The angle brackets <Task> specify the type of data that will be stored in this box. In Hive, data is stored in boxes, and each box can hold a specific type of data. In this case, it's a Task type. This means you can store and retrieve objects of the Task class in this box.
    --`'tasks'`: This is the name of the box. It's like giving a name to a container where you'll store your data. You can choose any name you like.
  3- `await`: This keyword is used because opening a Hive box can be an asynchronous operation. It allows the program to wait until the box is fully opened and ready for use before proceeding with other code.

  Once you've executed this line of code,
  you'll have a Hive box named 'tasks' that's associated with the Task class.
  You can use this box to store and retrieve instances of the Task class,
  making it a convenient way to manage and persist data in your Flutter application.
  * */
  await Hive.openBox<TaskModel>(taskBoxName);

  // change background color of status bar.
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: primaryContainerColor,
  ));

  //runApp(const MyApp());
  runApp(
    ChangeNotifierProvider<Repository<TaskModel>>(
      create: (context) =>
          Repository<TaskModel>(HiveTaskDataSource(Hive.box(taskBoxName))),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    const primaryTextColor = Color(0xFF1D2830);

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a blue toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.

        textTheme: GoogleFonts.poppinsTextTheme(
          const TextTheme(
            // headline6 => titleLarge
            titleLarge: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),

        // colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        inputDecorationTheme: const InputDecorationTheme(
          labelStyle: TextStyle(color: secondaryTextColor),
          border: InputBorder.none,
          iconColor: secondaryTextColor,
          floatingLabelBehavior: FloatingLabelBehavior.never,
        ),
        colorScheme: const ColorScheme.light(
          primary: primaryColor,
          /*
          The primary color is used for the key components across the UI, such as the FAB, prominent buttons, and active states.
          It is the most important color in the color scheme and should be used sparingly to avoid making the UI too overwhelming.

          The primary color in Flutter is used for the key components across the UI, such as:
          • Floating action button (FAB)
          • Prominent buttons
          • Active states
          • Selected items
          • AppBar
          • ElevatedButton
          • FloatingActionButton
          • IconButton
          • ListView
          • Radio
          • Slider
          • Switch
          • TextButton
          • TextField
          • ToggleButtons

          You can also use the `primary` color to set the background color of a widget.
          The `primary` color is a powerful tool that can be used to create a cohesive and visually appealing UI.
          However, it is important to use it sparingly to avoid making the UI too overwhelming.
           */
          onPrimary: Colors.white,
          secondary: Color(0xFF794CFF),
          /*
          The secondary color is used for less prominent components in the UI, such as filter chips, while expanding the opportunity for color expression.
          It can be used to add a touch of personality to the UI and to make it more visually appealing.

          The secondary color in Flutter is used for less prominent components in the UI, such as:
          • Filter chips
          • Dividers
          • Text selection
          • Background colors for less prominent components
          • Chip
          • Divider
          • SelectionArea
          • DataTable
          • ExpansionPanel
          • LinearProgressIndicator
          • SnackBar

          You can also use the secondary color to set the background color of a widget.

          The secondary color is a powerful tool for adding visual interest and personality to your app's UI. It can also be used to create a cohesive and visually appealing design.
          However, it is important to use it sparingly to avoid making the UI too overwhelming.
           */
          primaryContainer: primaryContainerColor,
          background: Color(0xFFF3F5F8),
          /*
          Purpose: The background color is the primary color used for the overall background of your app or a particular screen.
          It sets the backdrop against which other content, such as text and icons, is displayed.
          It's the foundational color that defines the overall look and feel of your app's UI.
           */
          onSurface: primaryTextColor,
          onBackground: primaryTextColor,
        ),
        useMaterial3: true,
      ),
      home: HomeScreen(taskBoxName: taskBoxName),
    );
  }
}
