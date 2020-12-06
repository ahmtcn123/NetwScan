import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

SharedPreferences appPrefences;

class AppSettings with ChangeNotifier {
  Future<bool> init() async {
    appPrefences = await SharedPreferences.getInstance();
    return true;
  }
}
