import 'package:flutter/material.dart';
import 'package:sqflite_practice/controller/home_provider.dart';
import 'package:sqflite_practice/helper/sqfhelper.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController textController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  List<Map<String, dynamic>> journal = [];
  bool isLoading = false;

  void refreshJournals() async {
    isLoading = true;

    final data = await SqlHelper.getItems();
    journal = data;
    isLoading = false;
    print(">>> Number of items in list ${journal.length}");
  }addItem(){}
  updatItem(){}

  void showForm({int? id}) async {
    if (id != null) {
      final exitistingJournal =
          journal.firstWhere((element) => element['id'] == id);
      textController = exitistingJournal['title'];
      descriptionController = exitistingJournal['description'];
    }
    showModalBottomSheet(
      context: context,
      elevation: 5,
      isScrollControlled: true,
      builder: (context) => Container(
        padding:
            const EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 300),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            TextField(
              controller: textController,
              decoration: const InputDecoration(hintText: "Text"),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              controller: descriptionController,
             
              decoration: const InputDecoration(hintText: "Description"),
            ),  const SizedBox(
              height: 20,
            ),
            GestureDetector(
          
              onTap:()async{ 
                
                id== null ? await addItem():updatItem(); 
                    Navigator.pop(context);} ,
              child: Center(
                child: Container(
                  color: Colors.black,
                  padding:const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                  child:Text(id== null? "Create New" : "Update",style: TextStyle(color: Colors.white,fontSize: 16),),),
              ),
            ),
            
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    refreshJournals();
    super.initState();
    refreshJournals();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
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
            height: MediaQuery.of(context).size.height,
         
          )),
      floatingActionButton: FloatingActionButton(
        onPressed: () {showForm();},
        backgroundColor: Colors.purple,
        child: const Icon(Icons.add),
      ),
    );
  }
}
