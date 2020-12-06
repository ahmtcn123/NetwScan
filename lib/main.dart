import 'package:flutter/material.dart';
import './pages/main.dart';
import 'utils/theme.dart';

void main() {
  
  runApp(NetwScan());
}
//192.168.1.100,192.168.1.200

class NetwScan extends StatefulWidget {
  const NetwScan({Key key}) : super(key: key);
  NetwScanState createState() => NetwScanState();
}

class NetwScanState extends State<StatefulWidget> {
  AppTheme currentTheme = AppTheme();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'NetwScan', //FF9C27B0
        themeMode: theme == 0 ? ThemeMode.system : theme == 1 ? ThemeMode.light : ThemeMode.dark,
        darkTheme: ThemeData(
          backgroundColor: Colors.grey.shade600,
          primaryColorDark: Colors.white,
          primaryColorLight: Colors.black87,
          primaryColor: Colors.black87,
          primaryTextTheme: TextTheme(
            headline1: TextStyle(color: Colors.white),
            headline2: TextStyle(color: Colors.white),
            headline3: TextStyle(color: Colors.white),
            headline4: TextStyle(color: Colors.white),
            headline5: TextStyle(color: Colors.white),
            headline6: TextStyle(color: Colors.white),
            subtitle1: TextStyle(color: Colors.white),
            subtitle2: TextStyle(color: Colors.white),
            bodyText1: TextStyle(color: Colors.white),
            bodyText2: TextStyle(color: Colors.white),
          ),
          secondaryHeaderColor: Colors.white,
        ),
        theme: ThemeData(
          backgroundColor: Colors.white,
          primaryColorDark: Color.fromRGBO(48, 63, 159, 1.0),
          primaryColorLight: Color.fromRGBO(197, 202, 233, 1.0),
          primaryColor: Color.fromRGBO(63, 81, 181, 1.0),
          secondaryHeaderColor: Colors.grey.shade600,
          primaryTextTheme: TextTheme(
            headline1: TextStyle(color: Colors.white),
            headline2: TextStyle(color: Colors.white),
            headline3: TextStyle(color: Colors.white),
            headline4: TextStyle(color: Colors.black),
            headline5: TextStyle(color: Colors.black),
            headline6: TextStyle(color: Colors.white),
            subtitle1: TextStyle(color: Colors.white),
            subtitle2: TextStyle(color: Colors.white),
            bodyText1: TextStyle(color: Colors.white),
            bodyText2: TextStyle(color: Colors.white),
          ),
        ),
        debugShowCheckedModeBanner: false,
        home: HomePage(mainStateSet: setState,));
  }
}
