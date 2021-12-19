import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
// My own imports
import 'package:todo_list/shared/cubit/cubit.dart';
import 'package:todo_list/shared/cubit/states.dart';

import '../shared/components/components.dart';

class HomeLayout extends StatelessWidget {
  HomeLayout({Key? key}) : super(key: key);

  TimeOfDay? picked;
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
  TextEditingController timeController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (BuildContext context, AppStates state) {
          if (state is AppInsertDatabaseState) {
            Navigator.pop(context);
          }
        },
        builder: (BuildContext context, AppStates state) {
          AppCubit cubit = AppCubit.get(context);
          return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              title: Text(
                cubit.titles[cubit.currentIndex],
              ),
            ),
            body:
                /*cubit.newTasks.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : */
                cubit.screens[cubit.currentIndex],
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                if (cubit.isBottomSheetShown) {
                  if (formKey.currentState!.validate()) {
                    cubit.insertToDatabase(
                      title: titleController.text,
                      time: timeController.text,
                      date: dateController.text,
                    );
                  }
                } else {
                  scaffoldKey.currentState!
                      .showBottomSheet(
                        (context) => SizedBox(
                          height: 300.0,
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Form(
                              key: formKey,
                              child: SingleChildScrollView(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    // **************** Title TextFormField *******************
                                    defaultTextField(
                                      onTap: () {},
                                      validate: (String? value) {
                                        if (value!.isEmpty) {
                                          return 'Title must not be empty';
                                        }
                                        return null;
                                      },
                                      controller: titleController,
                                      keyboardType: TextInputType.text,
                                      prefix: Icons.title,
                                      lable: 'Task Title',
                                    ),

                                    const SizedBox(
                                      height: 20.0,
                                    ),
                                    // **************** Time TextFormField *******************
                                    defaultTextField(
                                      controller: timeController,
                                      onTap: () {
                                        showTimePicker(
                                          context: context,
                                          initialTime: TimeOfDay.now(),
                                        ).then(
                                          (value) {
                                            timeController.text = value!
                                                .format(context)
                                                .toString();
                                          },
                                        );
                                      },
                                      validate: (String? value) {
                                        if (value!.isEmpty) {
                                          return 'Time must mot be empty';
                                        }
                                        return null;
                                      },
                                      keyboardType: TextInputType.datetime,
                                      prefix: Icons.watch_later_outlined,
                                      lable: 'Task Time',
                                    ),

                                    const SizedBox(
                                      height: 20.0,
                                    ),

                                    // **************** Date TextFormField *******************
                                    defaultTextField(
                                      controller: dateController,
                                      onTap: () {
                                        showDatePicker(
                                          context: context,
                                          initialDate: DateTime.now(),
                                          firstDate: DateTime.now(),
                                          lastDate:
                                              DateTime.parse('2022-02-21'),
                                        ).then((date) {
                                          dateController.text =
                                              DateFormat.yMMMd().format(date!);
                                        });
                                      },
                                      validate: (String? value) {
                                        if (value!.isEmpty) {
                                          return 'Date must mot be empty';
                                        }
                                        return null;
                                      },
                                      keyboardType: TextInputType.datetime,
                                      prefix: Icons.calendar_today,
                                      lable: 'Task Date',
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        elevation: 20.0,
                      )
                      .closed
                      .then((value) {
                    cubit.changeBottomCheet(isShow: false, icon: Icons.edit);
                  });
                  cubit.changeBottomCheet(isShow: true, icon: Icons.add);
                }
              },
              child: Icon(
                cubit.fabIcon,
              ),
            ),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: AppCubit.get(context).currentIndex,
              onTap: (index) {
                cubit.changeIndex(index);
              },
              items: const [
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.menu,
                    ),
                    label: 'Tasks'),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.check_circle_outline,
                  ),
                  label: 'Done',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.archive_outlined,
                  ),
                  label: 'Archived',
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
