import 'package:basic_todo/components/pallete.dart';
import 'package:basic_todo/database/dbhelper.dart';
import 'package:basic_todo/screens/add_todoPage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../components/widgets.dart';
import '../models/todo_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late ScrollController scrollController;

  List<TodoModel> items = [];
  bool loading = false;

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
    dbInitialization();
    initial(true, 0);
  }

  Future<void> dbInitialization() async {
    DataBaseHelper.getDatabaseHelper.setDataBaseName = 'MyTODO';
    await DataBaseHelper.getDatabaseHelper.getDatabase;
  }

  Future<void> initial(bool isLoad, int value) async {
    selectedIndex = value;
    if (isLoad) {
      setState(() {
        loading = true;
      });
    }
    items = items = selectedIndex == 0
        ? await DataBaseHelper.getDatabaseHelper.getDBItems()
        : await DataBaseHelper.getDatabaseHelper
            .getDBItemsBasedOnPriorities(selectedIndex - 1);

    if (isLoad) {
      setState(() {
        loading = false;
      });
    }
  }

  Map<String, Color> priorities = {
    'Very Urgent': urgent1,
    'Urgent': urgent2,
    'Normal': urgent3,
  };

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
  }

  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: background,
        title: Text(
          'Todo',
          style: headText,
        ),
        centerTitle: true,
        elevation: 5,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: DefaultTabController(
          length: 4,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ShadowContainer(
                radius: 5,
                color: Colors.white,
                child: TabBar(
                  indicatorSize: TabBarIndicatorSize.tab,
                  isScrollable: true,
                  tabAlignment: TabAlignment.center,
                  indicator: BoxDecoration(
                    color: priorityColor(
                        selectedIndex == 0 ? 4 : selectedIndex - 1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  dividerColor: Colors.transparent,
                  unselectedLabelColor: Colors.white,
                  tabs: [
                    SizedBox(
                      height: 40,
                      child: Center(
                        child: buildText('All', 0),
                      ),
                    ),
                    buildText('Very Urgent', 1),
                    buildText('Urgent', 2),
                    buildText('Normal', 3),
                  ],
                  onTap: (value) {
                    initial(true, value);
                  },
                ),
              ),
              Expanded(
                child: loading
                    ? const CircularProgressIndicator()
                    : SingleChildScrollView(
                        child: Column(
                          children: [
                            totoList(),
                          ],
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddTodo(
                isEdit: false,
              ),
            ),
          ).then((value) {
            setState(() {
              initial(false, selectedIndex);
            });
          });
        },
        child: const Icon(
          Icons.add_circle,
          size: 30,
        ),
      ),
    );
  }

  Text buildText(String text, int index) {
    return Text(
      text,
      style: headText.copyWith(
        color: selectedIndex == index ? Colors.white : Colors.black,
        fontSize: 16,
      ),
    );
  }

  Container totoList() {
    return Container(
      height: (height + 11) * items.length,
      margin: const EdgeInsets.only(top: 10),
      child: ListView.builder(
        itemCount: items.length,
        controller: scrollController,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.only(top: 10, left: 13, right: 13),
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      AddTodo(isEdit: true, model: items[index]),
                ),
              ).then((value) {
                setState(() {
                  initial(false, selectedIndex);
                });
              });
            },
            child: TodoCard(
              title: items[index].title,
              description: items[index].desc,
              createdAt: DateFormat.yMMMd().format(DateTime.parse(items[index].createdAt)),
              urgencyColor: priorityColor(items[index].priorities),
            ),
          );
        },
      ),
    );
  }
}
