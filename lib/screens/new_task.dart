import 'package:flutter/material.dart';
import '../utilities/database_helper.dart';
import '../models/task.dart';
import '../screens/todo_list.dart';
import '../utilities/utils.dart';

var globalDate = "Pick Date";

class new_task extends StatefulWidget {
  final String appBarTitle;
  final Task task;
  todo_state todoState;
  new_task(this.task, this.appBarTitle, this.todoState);
  bool _isEditable = false;

  @override
  State<StatefulWidget> createState() {
    return task_state(this.task, this.appBarTitle, this.todoState);
  }
}

class task_state extends State<new_task> {


  todo_state todoState;
  String appBarTitle;
  Task task;
  List<Widget> icons;
  task_state(this.task, this.appBarTitle, this.todoState);

  bool marked = false;

  @override
  void initState() {
    if(task.status == "Task Completed")
      marked = true;
    super.initState();
  }

  TextStyle titleStyle = new TextStyle(
    fontSize: 18,
    fontFamily: "Lato",
  );

  TextStyle buttonStyle =
      new TextStyle(fontSize: 18, fontFamily: "Lato", color: Colors.white);

  final scaffoldkey = GlobalKey<ScaffoldState>();

  DatabaseHelper helper = DatabaseHelper();
  Utils utility = new Utils();
  TextEditingController taskController = new TextEditingController();
  TextEditingController descriptionController = new TextEditingController();


  var formattedDate = "Pick Date";
  var formattedTime = "Select Time";
  var _minPadding = 10.0;
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay();



  @override
  Widget build(BuildContext context) {
    taskController.text = task.task;
    return Scaffold(
        key: scaffoldkey,
        appBar: AppBar(
          leading: new GestureDetector(
            child: Icon(Icons.arrow_back_ios, size: 30),
            onTap: () {
              Navigator.pop(context);
              todoState.updateListView();
            },
          ),
          title: Text(appBarTitle, style: TextStyle(fontSize: 25)),
        ),
        body: ListView(children: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 50.0),
            child: _isEditable() ?  CheckboxListTile(
                title: Text("Mark as Done", style: titleStyle),
                value: marked,
                onChanged: (bool value) {
                 setState(() {
                   marked = value;
                 });
                }
                )//CheckboxListTile
            : Container(height: 2,)
          ),



          Padding(
            padding: EdgeInsets.all(_minPadding),
            child: TextField(
              controller: taskController,
              decoration: InputDecoration(
                  labelText: "Task",
                  hintText: "Title for the task",
                  labelStyle: TextStyle(
                    fontSize: 20,
                    fontFamily: "Lato",
                    fontWeight: FontWeight.bold,
                  ),
                  hintStyle: TextStyle(
                      fontSize: 18,
                      fontFamily: "Lato",
                      fontStyle: FontStyle.italic,
                      color: Colors.grey)), //Input Decoration
              onChanged: (value) {
                updateTask();
              },
            ), //TextField
          ), //Padding

          Padding(
            padding: EdgeInsets.all(_minPadding),
            child: TextField(
              keyboardType: TextInputType.multiline,
              maxLines: null,
              controller: descriptionController,
              /*style: textStyle,
              onChanged: (value) {
                debugPrint('Something changed in Description Text Field');
                updateDescription();
              },
              decoration: InputDecoration(
                  labelText: 'Description',
                  labelStyle: TextStyle(color: Colors.green, fontSize: 25),
                  enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.green,width: 2),
                      borderRadius: BorderRadius.circular(5.0))),*/
              decoration: InputDecoration(
                  labelText: "Description",
                  hintText: "write about your task",
                  labelStyle: TextStyle(
                    fontSize: 20,
                    fontFamily: "Lato",
                    fontWeight: FontWeight.bold,
                  ),
                  hintStyle: TextStyle(
                      fontSize: 18,
                      fontFamily: "Lato",
                      fontStyle: FontStyle.italic,
                      color: Colors.grey)),
            ),
          ),

       ListTile(
            title: task.date.isEmpty
                ? Text(
                    "Pick Date",
                    style: titleStyle,
                  )
                : Text(task.date),
            subtitle: Text(""),
            trailing: Icon(Icons.calendar_today),
            onTap: () async {
              var pickedDate = await utility.selectDate(context, task.date);
              if (pickedDate != null && !pickedDate.isEmpty)
                setState(() {
                  this.formattedDate = pickedDate.toString();
                  task.date = formattedDate;
                });
            },
          ), //DateListTile

          ListTile(
            title: task.time.isEmpty
                ? Text(
                    "Select Time",
                    style: titleStyle,
                  )
                : Text(task.time),
            subtitle: Text(""),
            trailing: Icon(Icons.access_time),
            onTap: () async {
              var pickedTime = await utility.selectTime(context);
              if (pickedTime != null && !pickedTime.isEmpty)
                setState(() {
                  formattedTime = pickedTime;
                  task.time = formattedTime;
                });
            },
          ), //TimeListTile

          Padding(
            padding: EdgeInsets.all(_minPadding),
            child: RaisedButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50.0)),
              padding: EdgeInsets.all(_minPadding / 2),
              color: Theme.of(context).primaryColor,
              textColor: Colors.white,
              elevation: 5.0,
              child: Text(
                "Save",
                style: buttonStyle,
                textAlign: TextAlign.center,
                textScaleFactor: 1.2,
              ),
              onPressed: () {
                setState(() {
                  _save();
                });
              },
            ), //RaisedButton
          ), //Padding

          Padding(
            padding: EdgeInsets.all(_minPadding),
            child: _isEditable()
                ? RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50.0)),
                    padding: EdgeInsets.all(_minPadding / 2),
                    color: Theme.of(context).primaryColor,
                    textColor: Colors.white,
                    elevation: 5.0,
                    child: Text(
                      "Delete",
                      style: buttonStyle,
                      textAlign: TextAlign.center,
                      textScaleFactor: 1.2,
                    ),
                    onPressed: () {
                      setState(() {
                        _delete();
                      });
                    },
                  ) //RaisedButton
                : Container(),
          ) //Padding
        ]) //ListView

        ); //Scaffold
  } //build()

  void markedDone() {}

  bool _isEditable() {
    if (this.appBarTitle == "Add Task")
      return false;
    else {
      return true;
    }
  }

  void updateTask() {
    task.task = taskController.text;
    task.desc = descriptionController.text;
  }

  //InputConstraints
  bool _checkNotNull() {
    bool res;
    if (taskController.text.isEmpty) {
      utility.showSnackBar(scaffoldkey, 'Task cannot be empty');
      res = false;
    } else if (task.date.isEmpty) {
      utility.showSnackBar(scaffoldkey, 'Please select the Date');
      res = false;
    } else if (task.time.isEmpty) {
      utility.showSnackBar(scaffoldkey, 'Please select the Time');
      res = false;
    } else {
      res = true;
    }
    return res;
  }

  //Save data
  void _save() async {
    int result;
    if(_isEditable()) {
      if (marked) {
        task.status = "Task Completed";
      }
      else
        task.status = "";
    }
    //task.task = taskController.text;
    //task.date = formattedDate;


    if (_checkNotNull() == true) {
      if (task.id != null) {
        //Update Operation
        result = await helper.updateTask(task);
      } else {
        //Insert Operation
        result = await helper.insertTask(task);
      }

      todoState.updateListView();

      Navigator.pop(context);

      if (result != 0) {
        utility.showAlertDialog(context, 'Status', task.status == "Task Completed" ? 'Task completed successfully' : 'Task saved successfully');
      } else {
        utility.showAlertDialog(context, 'Status', 'Problem saving task.');
      }
    }
  } //_save()

  void _delete() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Are you sure, you want to delete this task?"),
            actions: <Widget>[
              RawMaterialButton(
                onPressed: () async {
                  await helper.deleteTask(task.id);
                  todoState.updateListView();
                  Navigator.pop(context);
                  Navigator.pop(context);
                  utility.showSnackBar(
                      scaffoldkey, 'Task Deleted Successfully.');
                },
                child: Text("Yes"),
              ),
              RawMaterialButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("No"),
              )
            ],
          );
        });
  }
} //class task_state
