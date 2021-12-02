import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app2/cubit/bloc_observer.dart';

import 'layout/todo_app/todo_layout.dart';


void main() {

  BlocOverrides.runZoned(
        () {  runApp(MyApp());
      // Use cubits...
    },
    blocObserver: MyBlocObserver(),
  );


}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeLayout(),
    );
  }
}
