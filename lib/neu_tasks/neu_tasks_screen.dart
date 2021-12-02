import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app2/components/components.dart';
import 'package:todo_app2/cubit/cubit.dart';
import 'package:todo_app2/cubit/states.dart';

class NewTasksScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var tasks = AppCubit.get(context).newTasks;
        return AppCubit.get(context).newTasks.length == 0
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.add_to_photos_sharp,
                      size: 70,
                      color: Colors.grey,
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      "Add New Task",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              )
            : ListView.separated(
                itemBuilder: (context, index) =>
                    buildTaskItem(tasks[index], context),
                separatorBuilder: (context, index) => Container(
                  width: double.infinity,
                  height: 1,
                  color: Colors.grey[300],
                ),
                itemCount: tasks.length,
              );
      },
    );
  }
}
