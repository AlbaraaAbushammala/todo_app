import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app2/components/components.dart';
import 'package:todo_app2/cubit/cubit.dart';
import 'package:todo_app2/cubit/states.dart';


class HomeLayout extends StatelessWidget
  {

  Database? database;
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();




  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) =>  AppCubit()..createDatabase(),

      child: BlocConsumer<AppCubit, AppStates>(

        listener: (BuildContext context, AppStates state) {
          if(state is AppInsertDatabaseState)
          {
            Navigator.pop(context);
          }
        },
        builder: (BuildContext context, AppStates state)
        {
          AppCubit cubit = AppCubit.get(context);
          return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              title: Text(
                cubit.titles[cubit.currentIndex],
              ),
            ),
            body: state is AppGetDatabaseLoadingState ? Center(child: CircularProgressIndicator()) : cubit.screens[cubit.currentIndex],
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                if (cubit.isBottomSheetShown) {
                  if (formKey.currentState!.validate()) {
                    cubit.insertToDatabase(
                      title: titleController.text,
                      date:  dateController.text,
                      time:  timeController.text,
                    );

                  }
                } else {
                  scaffoldKey.currentState!.showBottomSheet(
                        (context) => Container(
                      color: Colors.grey[200],
                      padding: const EdgeInsets.all(20.0),
                      child: Form(
                        key: formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              color: Colors.white,
                              child: defaultFormField(
                                controller: titleController,
                                type: TextInputType.text,
                                validate: (String value) {
                                  if (value.isEmpty) {
                                    return "title must not be Empty";
                                  }
                                  return null;
                                },
                                label: " Task Title",
                                prefixIcon: Icons.title,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              color: Colors.white,
                              child: defaultFormField(
                                onTap: () {
                                  showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay.now(),
                                  ).then((value) {
                                    timeController.text = value!.format(context);
                                  });
                                },
                                controller: timeController,
                                type: TextInputType.datetime,
                                validate: (String value) {
                                  if (value.isEmpty) {
                                    return "time must not be Empty";
                                  }
                                  return null;
                                },
                                label: " Task Time",
                                prefixIcon: Icons.access_time_rounded,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              color: Colors.white,
                              child: defaultFormField(
                                onTap: () {
                                  showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    lastDate: DateTime.parse("2022-12-10"),
                                    firstDate: DateTime.now(),
                                  ).then((value) {
                                    dateController.text =
                                        DateFormat.yMMMd().format(value!);
                                  });
                                },
                                controller: dateController,
                                type: TextInputType.datetime,
                                validate: (String value) {
                                  if (value.isEmpty) {
                                    return "Date must not be Empty";
                                  }
                                  return null;
                                },
                                label: " Task Date",
                                prefixIcon: Icons.date_range,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ).closed.then((value)
                  {
                    cubit.changeBottomSheetState(
                        isShow: false,
                        icon: Icons.edit,
                        );
                  });
                  cubit.changeBottomSheetState(
                      icon: Icons.add,
                      isShow: true,
                  );

                }
              },
              child: Icon(
                cubit.fabIcon,
              ),
            ),
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: cubit.currentIndex,
              onTap: (index) {

                cubit.changeIndex(index);
              },
              items: [
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.menu,
                    ),
                    label: "New"),
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.check_circle_outline,
                    ),
                    label: "Done"),
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.archive_outlined,
                    ),
                    label: "Archived"),
              ],
            ),
          );
        },


      ),
    );
  }









}


