import 'package:basic_todo/components/pallete.dart';
import 'package:basic_todo/database/dbhelper.dart';
import 'package:basic_todo/models/todo_model.dart';
import 'package:flutter/material.dart';

import '../components/widgets.dart';

class AddTodo extends StatefulWidget {
  final bool isEdit;
  final TodoModel? model;
  const AddTodo({super.key, required this.isEdit, this.model});

  @override
  State<AddTodo> createState() => _AddTodoState();
}

class _AddTodoState extends State<AddTodo> {
  late TextEditingController titleController;
  late TextEditingController descController;
  final FocusNode focusNode = FocusNode();

  late DataBaseHelper dataBaseHelper;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController();
    descController = TextEditingController();
    if (widget.isEdit) {
      titleController.text = widget.model!.title;
      descController.text = widget.model!.desc;
      dropdownvalue = priorityColor(widget.model!.priorities);
    }
  }

  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
    descController.dispose();
    focusNode.dispose();
  }

  Color dropdownvalue = urgent1;

  List<Color> items = [
    urgent1,
    urgent2,
    urgent3,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: background,
        title: Text(
          widget.isEdit ? 'Edit Todo' : 'New Todo',
          style: headText,
        ),
        centerTitle: true,
        elevation: 5,
        actions: [
          DropdownButton(
            value: dropdownvalue,
            dropdownColor: background,
            items: items.map((Color color) {
              return DropdownMenuItem(
                value: color,
                child: Container(
                  height: 15,
                  width: 15,
                  decoration:
                      BoxDecoration(color: color, shape: BoxShape.circle),
                ),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                dropdownvalue = value!;
              });
            },
          ),
          if (widget.isEdit)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                  onPressed: () {
                    DataBaseHelper.getDatabaseHelper
                        .deleteDataBase(widget.model!.id!)
                        .then((value) {
                      Navigator.pop(context);
                      return value;
                    });
                  },
                  icon: const Icon(
                    Icons.delete,
                    color: Colors.white,
                  )),
            )
        ],
      ),
      body: Focus(
        focusNode: focusNode,
        child: GestureDetector(
          onTap: () {
            focusNode.unfocus();
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 13, right: 13),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 25),
                    CommonField(
                      hintText: 'Title',
                      controller: titleController,
                      type: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 25),
                    CommonField(
                      hintText: 'Description',
                      controller: descController,
                      isMulti: true,
                    ),
                    const SizedBox(height: 25),
                  ],
                ),
              ),
              Expanded(child: Container()),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 13, vertical: 30),
                child: CommonBtn(
                  isLoading: false,
                  text: 'Save',
                  height: 50,
                  callback: () async {
                    if (widget.isEdit) {
                      // User wants to edit
                      await DataBaseHelper.getDatabaseHelper
                          .updateDataBase(widget.model!);
                    } else {
                      // creating new db
                      await DataBaseHelper.getDatabaseHelper
                          .insertDataBase(
                        TodoModel(
                          title: titleController.text,
                          desc: descController.text,
                          priorities: fromColor(dropdownvalue),
                          createdAt: DateTime.now().toString(),
                        ),
                      )
                          .then((value) {
                        Navigator.pop(context);
                        return value;
                      });
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  int fromColor(Color color) {
    if (color == const Color(0xffe74533)) {
      return 0;
    } else if (color == const Color(0xff6fb6f8)) {
      return 1;
    } else if (color == const Color(0xff5dcb9a)) {
      return 2;
    } else {
      return 4;
    }
  }
}
