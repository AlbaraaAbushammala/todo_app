import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app2/components/components.dart';
import 'package:todo_app2/cubit/cubit.dart';
import 'package:todo_app2/cubit/states.dart';



class ArchivedTasksScreen extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener:(context, state){} ,
      builder:(context, state){
        var tasks = AppCubit.get(context).archiTasks;
        return ListView.separated(
          itemBuilder:(context, index) => buildTaskItem(tasks[index], context) ,
          separatorBuilder: (context, index) => Container(
            width: double.infinity,
            height: 1,
            color: Colors.grey[300],
          ) ,
          itemCount: tasks.length,
        );
      } ,
    );
  }
}


