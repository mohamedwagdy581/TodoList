import 'package:flutter/material.dart';
import 'package:todo_list/shared/cubit/cubit.dart';

Widget defaultTextField({
  required IconData prefix,
  required String lable,
  required Function() onTap,
  String? Function(String?)? validate,
  TextEditingController? controller,
  TextInputType? keyboardType,
  bool isClickable = true,
}) =>
    TextFormField(
      controller: controller,
      validator: validate,
      keyboardType: keyboardType,
      onTap: onTap,
      enabled: isClickable,
      decoration: InputDecoration(
        labelText: lable,
        prefixIcon: Icon(prefix),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
      ),
    );

// Task item
Widget buildTaskItem(Map model, context) {
  return Dismissible(
    key: Key(model['id'].toString()),
    child: Padding(
      padding: const EdgeInsets.all(15),
      child: Row(
        children: [
          CircleAvatar(
            radius: 40.0,
            child: Text(
              '${model['time']}',
            ),
          ),
          const SizedBox(
            width: 30,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${model['title']}',
                  style: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${model['date']}',
                  style: const TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            width: 30,
          ),
          IconButton(
            onPressed: () {
              AppCubit.get(context).updateData(status: 'done', id: model['id']);
            },
            icon: const Icon(
              Icons.check_box,
              color: Colors.green,
            ),
          ),
          IconButton(
            onPressed: () {
              AppCubit.get(context)
                  .updateData(status: 'archive', id: model['id']);
            },
            icon: const Icon(
              Icons.archive,
              color: Colors.black45,
            ),
          ),
        ],
      ),
    ),
    onDismissed: (direction) {
      AppCubit.get(context).deleteData(id: model['id']);
    },
  );
}
