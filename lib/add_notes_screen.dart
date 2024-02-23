import 'package:flutter/material.dart';
import 'package:notes_app_sqflite/notes_model.dart';

class AddNotesScreen extends StatefulWidget {
  const AddNotesScreen({super.key, this.model});

  final NoteModel? model;

  @override
  State<AddNotesScreen> createState() => _AddNotesScreenState();
}

class _AddNotesScreenState extends State<AddNotesScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    initialValues();
  }

  void initialValues() {
    if (widget.model != null) {
      titleController.text = widget.model!.title!;
      descriptionController.text = widget.model!.description!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
              size: 30,
            )),
        backgroundColor: Colors.black87,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Add Note',
          style: TextStyle(
              fontSize: 35, color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: TextField(
              controller: titleController,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  hintText: 'Enter Title'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              maxLines: 7,
              controller: descriptionController,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  hintText: 'Enter Description'),
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
              onPressed: () {
                if (widget.model == null) {
                  // There no data (no title and no description)
                  final map = {
                    'title': titleController.text,
                    'description': descriptionController.text,
                    'time': DateTime.now().millisecondsSinceEpoch
                  };

                  final notesmodel = NoteModel.fromJson(map);

                  Navigator.pop(context, notesmodel);

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text(
                        'Note Added Successfully',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      duration: Duration(
                          seconds: 2), // You can customize the duration
                      action: SnackBarAction(
                        label: 'OK',
                        onPressed: () {
                          // Do something when the action button is pressed
                        },
                      ),
                    ),
                  );
                } else {
                  final map = {
                    'title': titleController.text,
                    'description': descriptionController.text,
                    'time': widget.model!.time!
                  };
                  final notesmodel = NoteModel.fromJson(map);
                  Navigator.pop(context, notesmodel);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text(
                        'Note Updated Successfully',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      duration: Duration(
                          seconds: 2), // You can customize the duration
                      action: SnackBarAction(
                        label: 'OK',
                        onPressed: () {},
                      ),
                    ),
                  );
                }
              },
              child: const Padding(
                padding: EdgeInsets.all(5),
                child: Text(
                  'Add',
                  style: TextStyle(fontSize: 30, color: Colors.white),
                ),
              ))
        ],
      ),
    );
  }
}
