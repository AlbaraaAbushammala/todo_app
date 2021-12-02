import 'package:flutter/material.dart';
import 'package:todo_app2/cubit/cubit.dart';


Widget defaultButton({
  double width = double.infinity,
  Color background = Colors.blue,
  required Function() function,
  required String? text,
  bool isUpperCase = true,
  double radius = 0,
}) =>
    Container(
      width: width,
      child: MaterialButton(
        onPressed: function,
        height: 40,
        child: Text(
          isUpperCase ? text!.toUpperCase() : text!,
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        color: background,
      ),
    );

Widget defaultFormField({
  required TextEditingController? controller,
  required TextInputType? type,
  Function? onSubmit,
  VoidCallback? onTap,
  Function? onChange,
  final Function? validate,
  required String label,
  required IconData prefixIcon,
  IconData? sufixIcon,
  bool obscureText = false,
  Function? sufixpressed,
  bool isClickble = true,
}) =>
    TextFormField(
      controller: controller!,
      obscureText: obscureText,
      keyboardType: type!,
      validator: (s) {
        validate!(s);
      },
      onTap: onTap,
      enabled: isClickble,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
        prefixIcon: Icon(
          prefixIcon,
        ),
        suffixIcon: IconButton(
          icon: Icon(
            sufixIcon,
          ),
          onPressed: () {
            sufixpressed!();
          },
        ),
      ),
    );




Widget buildTaskItem(Map model, context) => Dismissible(
  key: Key(model["id"].toString()),

  onDismissed: (direction)
  {
    AppCubit.get(context).deleteData( id: model["id"]);

  },
  child:   Padding(
        padding: const EdgeInsets.all(15.0),
        child: SingleChildScrollView(
          child: Row(
            children: [
              CircleAvatar(
                radius: 40,
                child: Text("${model["time"]}"),
              ),
              SizedBox(
                width: 20,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${model["title"]}",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "${model["date"]}",
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 20,
              ),
              IconButton(
                onPressed: () {
                  AppCubit.get(context).updateData(
                    status: "Done",
                    id: model["id"],
                  );
                },
                icon: Icon(
                  Icons.check_box,
                  color: Colors.green,
                ),
              ),
              IconButton(
                onPressed: ()
                {
                  AppCubit.get(context).updateData(
                    status: "Archive ",
                    id: model["id"],
                  );
                },
                icon: Icon(
                  Icons.archive,
                  color: Colors.red,
                ),
              ),
            ],
          ),
        ),
      ),
);





