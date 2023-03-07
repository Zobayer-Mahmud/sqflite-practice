import 'package:flutter/material.dart';
import 'package:sqflite_practice/controller/home_provider.dart';
import 'package:sqflite_practice/helper/sqfhelper.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  
     List<Map<String, dynamic>> journal = [];
  bool isLoading = false;

  void refreshJournals() async {
    isLoading = true;
    
    final data = await SqlHelper.getItems();
    journal = data;
    isLoading = false;
    print(">>> Number of items in list ${journal.length}");
    
  }

  @override void initState() {
refreshJournals();
    super.initState();
   refreshJournals();
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("Sqlite Practice"),
        centerTitle: true,
        backgroundColor: Colors.purple,
      ),
      body: RefreshIndicator(
          displacement: 250,
          backgroundColor: Colors.yellow,
          color: Colors.red,
          strokeWidth: 3,
          triggerMode: RefreshIndicatorTriggerMode.onEdge,
          onRefresh: () async {
            await Future.delayed(const Duration(milliseconds: 1500));

       refreshJournals();
          },
          child: Container(
            height:MediaQuery.of(context).size.height,
            color: Colors.yellow[200],
          )),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.purple,
        child: const Icon(Icons.add),
      ),
    );
  }
}
