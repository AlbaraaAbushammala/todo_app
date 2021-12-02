import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app2/archived_tasks/archived_tasks_screen.dart';
import 'package:todo_app2/cubit/states.dart';
import 'package:todo_app2/done_tasks/done_tasks_screen.dart';
import 'package:todo_app2/neu_tasks/neu_tasks_screen.dart';

class AppCubit extends Cubit<AppStates>
{

  AppCubit() : super(AppInitialState());
  static AppCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;

  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archiTasks = [];

  List<Widget> screens = [
    NewTasksScreen(),
    DoneTasksScreen(),
    ArchivedTasksScreen(),
  ];

  List<String> titles = [
    "New Task",
    "Done Task",
    "Archived Task",
  ];
  Database? database;


  void changeIndex (int index){
    currentIndex = index;
    emit(AppChangeBottomNavBarState());
  }

  void createDatabase()  {
    openDatabase(
      "todo.db",
      version: 1,
      onCreate: (database, version) {
        print("Database created");
        database
            .execute(
            "CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT, status TEXT)")
            .then((value) {
          print("Table created");
        }).catchError((error) {
          print("Error When Creating Table ${error.toString()}");
        });
      },
      onOpen: (database) {
        getDataFromDatabase(database);

        print("Database opned");

      },
    ).then((value) {
      database = value;
      emit(AppCreateDatabaseState());
    });
  }



  insertToDatabase({
    required String title,
    required String date,
    required String time,
  }) async {
    await database!.transaction((txn) async {
      txn
          .rawInsert(
          "INSERT INTO tasks(title, date, time, status) VALUES('$title', '$date', '$time', 'new')")
          .then((value) {
        print("$value inserted successfully");
        emit(AppInsertDatabaseState());
        getDataFromDatabase(database);
      }).catchError((error) {
        print(" Error When Inserting  New Record");
      });
    });
  }







  void getDataFromDatabase(database)
  {
    emit(AppGetDatabaseLoadingState());
   database!.rawQuery("SELECT * FROM tasks").then((value)
    {
      newTasks = [];
      doneTasks = [];
      archiTasks = [];

      value.forEach((element) {
        if(element["status"]== "new")
          newTasks.add(element);
        else   if(element["status"]== "Done")
          doneTasks.add(element);
        else  archiTasks.add(element);
      });

      print(archiTasks);
      emit(AppGetDatabaseState());

    });

  }




  void updateData({
  required String status,
  required int id,
})async
  {
     database!.rawUpdate(
        'UPDATE tasks SET status = ? WHERE id = ?',
        ['$status', '$id ']).then((value)
     {
       getDataFromDatabase(database);
       emit(AppUpdateDatabaseLoadingState());
     });
  }


  void deleteData({
    required int id,
  })async
  {
    database!.rawDelete(
        'DELETE FROM tasks WHERE id = ?', [id]).then((value)
    {
      getDataFromDatabase(database);
      emit(AppDeleteDatabaseLoadingState());
    });
  }


  bool isBottomSheetShown = false;
  IconData fabIcon = Icons.edit;

  void changeBottomSheetState({
  required bool isShow,
  required IconData icon,
})
  {
    isBottomSheetShown = isShow;
    fabIcon = icon;
    emit(AppChangeBottomSheetState());
  }




}