import 'package:flutter/cupertino.dart';
import 'package:sqflite_practice/helper/sqfhelper.dart';

class HomeProvider with ChangeNotifier {
  List<Map<String, dynamic>> journal = [];
  bool isLoading = false;

  void refreshJournals() async {
    isLoading = true;
    notifyListeners();
    final data = await SqlHelper.getItems();
    journal = data;
    isLoading = false;
    print(">>> Number of items in list ${journal.length}");
    notifyListeners();
  }
}
