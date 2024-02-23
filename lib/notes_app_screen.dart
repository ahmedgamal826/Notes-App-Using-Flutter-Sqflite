import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:notes_app_sqflite/add_notes_screen.dart';
import 'package:notes_app_sqflite/database.dart';
import 'package:notes_app_sqflite/notes_model.dart';

enum OrderBy { Ascending, Descending }

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<NoteModel> notesItem = [];
  List<NoteModel> filteredNotes = [];
  OrderBy currentOrder = OrderBy.Descending;

  late AwesomeDialog _awesomeDialog;

  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    notesItem = await SqfliteDatabase.getDataFromDatabase();
    filteredNotes = List.from(notesItem);
    sortNotes();
  }

  void filterNotes(String query) {
    setState(() {
      if (query.isNotEmpty) {
        filteredNotes = notesItem
            .where((note) => note.title!.toLowerCase() == query.toLowerCase())
            .toList();
      } else {
        filteredNotes.clear();
      }
    });

    if (filteredNotes.isEmpty && query.isNotEmpty) {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.error,
        title: 'No notes found for "$query"',
        btnOkOnPress: () {},
      ).show();
    } else if (filteredNotes.isNotEmpty) {
      AwesomeDialog(
              context: context,
              dialogType: DialogType.success,
              title: ' Note ${filteredNotes[0].title!} is found',
              desc: 'Do you want to edit this note?',
              descTextStyle: const TextStyle(fontSize: 18),
              btnCancelOnPress: () async {
                final updatedNote = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddNotesScreen(
                      model: filteredNotes[
                          0], // Pass the found note to the edit screen
                    ),
                  ),
                );

                await SqfliteDatabase.updateDataInDatabase(
                  updatedNote,
                  updatedNote.time,
                );

                // Find the index of the updated note in the notesItem list
                final index = notesItem.indexWhere(
                  (note) => note.time == updatedNote.time,
                );

                // Update the note in the list
                if (index != -1) {
                  notesItem[index] = updatedNote;
                }

                sortNotes();
              },
              btnCancelText: 'Yes',
              btnOkOnPress: () {
                _awesomeDialog.dismiss();
              },
              btnOkText: 'No')
          .show();
    }
  }

  // sort notes according the last note added
  void sortNotes() {
    notesItem.sort((a, b) {
      if (currentOrder == OrderBy.Ascending) {
        return a.time!.compareTo(b.time!);
      } else {
        return b.time!.compareTo(a.time!);
      }
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.black87,
        title: const Text(
          'Notes',
          style: TextStyle(
              color: Colors.white, fontSize: 40, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                currentOrder = (currentOrder == OrderBy.Ascending)
                    ? OrderBy.Descending
                    : OrderBy.Ascending;
                sortNotes();
              });
            },
            icon: Icon(
              currentOrder == OrderBy.Ascending
                  ? Icons.arrow_upward
                  : Icons.arrow_downward,
              color: Colors.white,
              size: 30,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: () async {
          final result = await Navigator.push(context,
              MaterialPageRoute(builder: (context) => const AddNotesScreen()));

          print(result);
          if (result != null) {
            notesItem.add(result);
            await SqfliteDatabase.insertData(result);

            sortNotes();
          }
        },
        child: const Icon(
          Icons.add,
          size: 35,
          color: Colors.white,
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: TextField(
              onSubmitted: (query) {
                filterNotes(query);
              },
              controller: searchController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                hintText: 'Search',
                suffixIcon: IconButton(
                  onPressed: () {
                    filterNotes(searchController.text);
                  },
                  icon: const Icon(Icons.search),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              shrinkWrap: true,
              itemCount: notesItem.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddNotesScreen(
                          model: notesItem[index],
                        ),
                      ),
                    );

                    await SqfliteDatabase.updateDataInDatabase(
                        result, result.time);

                    notesItem[index] = result;
                    sortNotes();
                  },
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
                    child: Container(
                      height: 200,
                      width: 100,
                      decoration: BoxDecoration(
                          color: Colors.black87,
                          borderRadius: BorderRadius.circular(20)),
                      child: ListTile(
                        title: Text(
                          notesItem[index].title!,
                          style: const TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        subtitle: Text(
                          notesItem[index].description!,
                          style:
                              const TextStyle(color: Colors.grey, fontSize: 22),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              onPressed: () async {
                                final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AddNotesScreen(
                                      model: notesItem[index],
                                    ),
                                  ),
                                );

                                await SqfliteDatabase.updateDataInDatabase(
                                    result, result.time);

                                notesItem[index] = result;
                                sortNotes();
                              },
                              icon: const Icon(
                                Icons.edit,
                                size: 30,
                                color: Colors.white,
                              ),
                            ),
                            IconButton(
                              onPressed: () async {
                                showDialog(
                                    context: context,
                                    builder: (_) => Dialog(
                                          child: Container(
                                            width: 30,
                                            height: 200,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                const Center(
                                                  child: Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 20),
                                                    child: Text(
                                                      'Are you sure to delete this note?',
                                                      style: TextStyle(
                                                          fontSize: 25),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 20,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    ElevatedButton(
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                              backgroundColor:
                                                                  Colors.black),
                                                      onPressed: () async {
                                                        setState(() {
                                                          notesItem
                                                              .removeAt(index);
                                                          Navigator.pop(
                                                              context);

                                                          setState(() {
                                                            AwesomeDialog(
                                                              context: context,
                                                              dialogType:
                                                                  DialogType
                                                                      .success,
                                                              title:
                                                                  'Note Deleted Successfully',
                                                              btnOkOnPress: () {
                                                                Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                        builder:
                                                                            (_) =>
                                                                                const HomePage()));
                                                              },
                                                            ).show();
                                                          });
                                                        });
                                                      },
                                                      child: const Text(
                                                        'Yes',
                                                        style: TextStyle(
                                                            fontSize: 25,
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    ),
                                                    ElevatedButton(
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                              backgroundColor:
                                                                  Colors.black),
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                      child: const Text(
                                                        'No',
                                                        style: TextStyle(
                                                            fontSize: 25,
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ));
                                await SqfliteDatabase.deleteDataFromDatabase(
                                    notesItem[index].time!);

                                sortNotes();
                              },
                              icon: const Icon(
                                Icons.delete,
                                size: 30,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
