import 'package:flutter/material.dart';
import '../screens/new_task.dart';
import 'dart:async';
import '../models/task.dart';
import '../utilities/database_helper.dart';
import 'package:sqflite/sqflite.dart';
import '../custom widgets/CustomWidget.dart';
import '../utilities/utils.dart';

class todo extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return todo_state();
  }
}

class todo_state extends State<todo> {

  Icon cusIcon = Icon(Icons.search,size: 25,);
  Widget cusSearchBar = Text('ToDoList',style: TextStyle(fontSize: 25),);

  DatabaseHelper databaseHelper = DatabaseHelper();
  Utils utility = new Utils();
  List<Task> taskList;
  int count = 0;
  final homeScaffold = GlobalKey<ScaffoldState>();

  TextEditingController editingController = TextEditingController();
  String query="";


  @override
  Widget build(BuildContext context) {
    if (taskList == null) {
      taskList = List<Task>();
      updateListView();
    }

    return DefaultTabController(
        length: 2,
        child: Scaffold(
          key: homeScaffold,
          appBar: AppBar(
            title: cusSearchBar,
            /*actions: <Widget>[
              PopupMenuButton<bool>(
                onSelected: (res) {
                  bloc.changeTheme(res);
                  _setPref(res);
                  setState(() {
                    if (_themeType == 'Dark Theme') {
                      _themeType = 'Light Theme';
                    } else {
                      _themeType = 'Dark Theme';
                    }
                  });
                },
                itemBuilder: (context) {
                  return <PopupMenuEntry<bool>>[
                    PopupMenuItem<bool>(
                      value: !widget.darkThemeEnabled,
                      child: Text(_themeType),
                    )
                  ];
                },
              )
            ],*/
            actions: <Widget>[
              IconButton(
                  icon: cusIcon,
                  onPressed: () {
                    setState(() {
                      if(this.cusIcon.icon == Icons.search){
                        this.cusIcon = Icon(Icons.cancel);
                        this.cusSearchBar = TextField(
                          onChanged: (value) {
                            setState(() {
                              query = value.toLowerCase();
                            });
                          },
                          controller: editingController,
                          textInputAction: TextInputAction.go,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.0,
                          ),
                        );
                      } else {
                        setState(() {
                          editingController.text="";
                          query="";
                        });
                        this.cusIcon = Icon(Icons.search);
                        this.cusSearchBar = Text('ToDoList',style: TextStyle(fontSize: 25),);
                      }
                    });
                  },
              ),
            ],
            bottom: TabBar(tabs: [
              Tab(
                icon: Icon(Icons.format_list_numbered_rtl),
              ),
              Tab(
                icon: Icon(Icons.playlist_add_check),
              )
            ]),
          ), //AppBar
          body: TabBarView(children: [
            new Container(
              padding: EdgeInsets.all(8.0),
              child: ListView(
                children: <Widget>[
                  SizedBox(
                    height: MediaQuery.of(context).size.height,
                    child: FutureBuilder(
                      future: databaseHelper.getInCompleteTaskList(),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (snapshot.data == null) {
                          return Text("Loading");
                        } else {
                          if (snapshot.data.length < 1) {
                            return Center(
                              child: Text(
                                'No Tasks Added',
                                style: TextStyle(fontSize: 20),
                              ),
                            );
                          }
                          return ListView.builder(
                              itemCount: snapshot.data.length,
                              itemBuilder:
                                  (BuildContext context, int position) {
                                return new GestureDetector(
                                    onTap: () {
                                      if (snapshot.data[position].status !=
                                          "Task Completed")
                                        navigateToTask(snapshot.data[position],
                                            "Edit Task", this);
                                    },
                                    child: Card(
                                      margin: EdgeInsets.all(1.0),
                                      elevation: 2.0,
                                      shape: RoundedRectangleBorder(
                                        side: BorderSide(
                                          color: Theme.of(context).primaryColor,
                                          width: 5,
                                        ),
                                        borderRadius: BorderRadius.circular(20.0)
                                      ),
                                      child: (snapshot.data[position].task).toLowerCase().contains(query) ? CustomWidget(
                                        title: snapshot.data[position].task,
                                        sub1: snapshot.data[position].date,
                                        sub2: snapshot.data[position].time,
                                        status: snapshot.data[position].status,
                                        delete:
                                          snapshot.data[position].status ==
                                                    "Task Completed"
                                                ? IconButton(
                                                    icon: Icon(Icons.delete),
                                                    onPressed: null,
                                                  )
                                                : Container(),
                                        trailing: Icon(
                                          Icons.edit,
                                          color: Theme.of(context).primaryColor,
                                          size: 28,
                                        ),
                                      )
                                      : Container(),
                                    )
                                    );
                              });
                        }
                      },
                    ),
                  )
                ],
              ),
            ),//Container
            new Container(
              padding: EdgeInsets.all(8.0),
              child: ListView(
                children: <Widget>[
                  SizedBox(
                    height: MediaQuery.of(context).size.height,
                    child: FutureBuilder(
                      future: databaseHelper.getCompleteTaskList(),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (snapshot.data == null) {
                          return Text("Loading");
                        } else {
                          if (snapshot.data.length < 1) {
                            return Center(
                              child: Text(
                                'No Tasks Completed',
                                style: TextStyle(fontSize: 20),
                              ),
                            );
                          }
                          return ListView.builder(
                              itemCount: snapshot.data.length,
                              itemBuilder:
                                  (BuildContext context, int position) {
                                return new GestureDetector(
                                    onTap: () {
                                      if (snapshot.data[position].status !=
                                          "Task Completed")
                                        navigateToTask(snapshot.data[position],
                                            "Edit Task", this);
                                    },
                                    onLongPress: () {
                                      if (snapshot.data[position].status ==
                                          "Task Completed")
                                        navigateToTask(snapshot.data[position],
                                            "Edit Task", this);
                                    },
                                    child: Card(
                                      margin: EdgeInsets.all(1.0),
                                      elevation: 2.0,
                                      shape: RoundedRectangleBorder(
                                        side: BorderSide(
                                          color: Theme.of(context).primaryColor,
                                          width: 5,
                                        ),
                                        borderRadius: BorderRadius.circular(20.0)
                                      ),
                                      child: (snapshot.data[position].task).toLowerCase().contains(query) ? CustomWidget(
                                        title: snapshot.data[position].task,
                                        sub1: snapshot.data[position].date,
                                        sub2: snapshot.data[position].time,
                                        status: snapshot.data[position].status,
                                        delete:
                                        snapshot.data[position].status ==
                                            "Task Completed"
                                            ? IconButton(
                                          icon: Icon(Icons.delete,
                                          color: Theme.of(context).primaryColor,
                                          size: 28),
                                          onPressed: (){
                                            delete(snapshot.data[position].id);
                                          },
                                        )
                                            : Container(),
                                        trailing: Container()
//                                    Icon(
//                                          Icons.edit,
//                                          color: Theme.of(context).primaryColor,
//                                          size: 28,
//                                        ),
                                      )
                                      :Container(),
                                    ) //Card
                                );
                              });
                        }
                      },
                    ),
                  )
                ],
              ),
            ),//Container
          ]

          ),
          floatingActionButton: FloatingActionButton(
              tooltip: "Add Task",
              child: Icon(Icons.add),
              onPressed: () {
                navigateToTask(Task('', '','', '', ''), "Add Task", this);
              }), //FloatingActionButton
        ));
  } //build()


  void navigateToTask(Task task, String title, todo_state obj) async {
    bool result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => new_task(task, title, obj)),
    );
    if (result == true) {
      updateListView();
    }
  }

  void updateListView() {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();

    dbFuture.then((database) {
      Future<List<Task>> taskListFuture = databaseHelper.getTaskList();
      taskListFuture.then((taskList) {
        setState(() {
          this.taskList = taskList;
          this.count = taskList.length;
        });
      });
    });
  } //updateListView()

  void delete(int id) async {
      await databaseHelper.deleteTask(id);
      updateListView();
      //Navigator.pop(context);
    utility.showSnackBar(homeScaffold, 'Task Deleted Successfully');
  }
}
