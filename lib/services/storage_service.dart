import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async' show Future;

class StorageService {
  getPaper(type) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(type)
        ? prefs.getString(type)
        : "0";
  }

  Future<bool> setPaper(type, String indexPaper) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(type, indexPaper);
    return true;
  }
}
