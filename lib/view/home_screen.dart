

import 'package:flutter/material.dart';

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
  }

  Future<void> addItem() async {
    await SqlHelper.createItems(
        title: textController.text, description: descriptionController.text);
    refreshJournals();
  }  Future<void> deleteItem({required int id}) async {
    await SqlHelper.deleteItem(id: id);
setState(() {
  refreshJournals();
});
  }

  Future<void> updateItem({required int id}) async {
    await SqlHelper.updateItem(
        id: id,
        title: textController.text,
        description: descriptionController.text);
    setState(() {
      refreshJournals();
    });
  }

  void showForm({int? id}) async {
    if (id != null) {
      final exitistingJournal =
          journal.firstWhere((element) => element['id'] == id);

      textController.text = exitistingJournal['title'];
      descriptionController.text = exitistingJournal['description'];
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
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(hintText: "Text"),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              controller: descriptionController,
              textInputAction: TextInputAction.done,
              decoration: const InputDecoration(hintText: "Description"),
            ),
            const SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () async {
                id == null ? await addItem() : await updateItem(id: id);
                textController.clear();
                descriptionController.clear();
                setState(() {
                  refreshJournals();
                });
                Navigator.pop(context);
              },
              child: Center(
                child: Container(
                  color: Colors.black,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Text(
                    id == null ? "Create New" : "Update",
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  initState() {
    setState(() {
      refreshJournals();
    });
    super.initState();
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

          setState(() {
            refreshJournals();
          });
        },
        child: ListView.builder(
            itemCount: journal.length,
            itemBuilder: (contextcontext, index) {
              return Card(
                color: Colors.orange[200],
                margin: const EdgeInsets.all(15),
                child: ListTile(
                  title: Text(journal[index]['title']),
                  subtitle: Column(
                    children: [
                      Text("${journal[index]['description']}"),
                      Text("${journal[index]['created_at']}"),
                    ],
                  ),
                  trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
deleteItem(id: journal[index]['id']);


                      }),
                  leading: IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        setState(() {
                          print("edit button pressed");
                          showForm(id: journal[index]['id']);
                        });
                      }),
                ),
              );
            }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showForm();
        },
        backgroundColor: Colors.purple,
        child: const Icon(Icons.add),
      ),
    );
  }
}
