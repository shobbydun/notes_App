import 'package:flutter/material.dart';
import 'package:notes_app/models/note.dart';
import 'package:notes_app/models/note_database.dart';
import 'package:provider/provider.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  // Text editing controller
  final textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // On app startup display current notes
    readNotes();
  }

  // Create a note
  void createNote() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: TextField(
          controller: textController,
          keyboardType: TextInputType.multiline,
          maxLines: null, // Allow unlimited lines
        ),
        actions: [
          // Create button
          MaterialButton(
            // Add to db
            onPressed: () {
              context.read<NoteDatabase>().addNote(textController.text);

              // Clear controller
              textController.clear();

              // Pop dialog box
              Navigator.pop(context);
            },
            child: const Text("Create"),
          ),
        ],
      ),
    );
  }

  // Read notes
  void readNotes() {
    context.read<NoteDatabase>().fectchNotes();
  }

  // Update a note
  void updateNote(Note note) {
    // Prefill the current note text so as to edit
    textController.text = note.text;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Update your Note"),
        content: TextField(
          controller: textController,
          keyboardType: TextInputType.multiline,
          maxLines: null, // Allow unlimited lines
        ),
        actions: [
          // Update button
          MaterialButton(
            onPressed: () {
              // Update note in db
              context
                  .read<NoteDatabase>()
                  .updateNote(note.id, textController.text);

              // Clear controller
              textController.clear();

              // Pop dialog box
              Navigator.pop(context);
            },
            child: const Text("Update"),
          ),
        ],
      ),
    );
  }

  // Delete a note
  void deleteNote(int id) {
    context.read<NoteDatabase>().deleteNotes(id);
  }

  @override
  Widget build(BuildContext context) {
    // Note database
    final noteDatabase = context.watch<NoteDatabase>();

    // Current notes
    List<Note> currentNotes = noteDatabase.currentNotes;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Notes🧾📚'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: createNote,
        child: const Icon(Icons.add),
      ),
      body: ListView.builder(
        itemCount: currentNotes.length,
        itemBuilder: (context, index) {
          // Get individual note
          final note = currentNotes[index];

          // List tile UI with shadow
          return Container(
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2), // Shadow color
                  spreadRadius: 2, // How much the shadow spreads
                  blurRadius: 8, // How blurred the shadow is
                  offset: const Offset(0, 4), // Shadow offset (x, y)
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Note text
                Expanded(
                  child: Text(
                    note.text,
                    overflow: TextOverflow.ellipsis, // Handle long text
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
                // Edit and delete buttons
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Edit button
                    IconButton(
                      onPressed: () => updateNote(note),
                      icon: const Icon(Icons.edit),
                    ),
                    // Delete button
                    IconButton(
                      onPressed: () => deleteNote(note.id),
                      icon: const Icon(Icons.clear),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
