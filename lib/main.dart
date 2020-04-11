import 'package:flutter/material.dart';
import './screens/todo_list.dart';

final routeObserver = RouteObserver<PageRoute>();

void main() {
  runApp(
      new MyApp()
  );
}

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateTitle: (BuildContext context) =>
      'ToDoList',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Lato',
        brightness: Brightness.dark,
        accentColor: Colors.white,
        primaryColor: Colors.blueAccent,
        backgroundColor: Colors.blueAccent,
        cursorColor: Colors.white,
        cardColor: Color(0xff424242),
      ),
      navigatorObservers: [routeObserver],
      home: todo(),
    );
  }

}