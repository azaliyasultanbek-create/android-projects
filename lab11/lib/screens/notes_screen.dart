import 'package:flutter/material.dart';
import '../models/note_item.dart';
import '../services/storage_service.dart';
class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});
  @override
  State<NotesScreen> createState() => _NotesScreenState();
}
class _NotesScreenState extends State<NotesScreen> {
  List<NoteItem> notes = [];
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    loadNotes();
  }
  Future<void> loadNotes() async {
    final savedNotes = await StorageService.loadNotes();
    if (!mounted) return;
    setState(() {
      notes = savedNotes;
      isLoading = false;
    });
  }
  Future<void> addNote(String title) async {
    final now = DateTime.now();
    final note = NoteItem(
      id: now.microsecondsSinceEpoch.toString(),
      title: title,
      dateText:
          '${now.day.toString().padLeft(2, '0')}.'
          '${now.month.toString().padLeft(2, '0')}.'
          '${now.year}',
    );
    setState(() {
      notes.insert(0, note);
    });
    await StorageService.saveNotes(notes);
  }
  Future<void> toggleNote(NoteItem note) async {
    setState(() {
      note.isCompleted = !note.isCompleted;
    });
    await StorageService.saveNotes(notes);
  }
  Future<void> deleteNote(NoteItem note) async {
    setState(() {
      notes.removeWhere((item) => item.id == note.id);
    });
    await StorageService.saveNotes(notes);
  }
  Future<void> showAddNoteDialog() async {
    final controller = TextEditingController();
    final title = await showDialog<String>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('New Note'),
          content: TextField(
            controller: controller,
            autofocus: true,
            decoration: const InputDecoration(
              hintText: 'Enter note title',
              border: OutlineInputBorder(),
            ),
            maxLength: 100,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final value = controller.text.trim();
                if (value.isNotEmpty) {
                  Navigator.pop(dialogContext, value);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFB76E79),
                foregroundColor: Colors.white,
              ),
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
    controller.dispose();
    if (title != null && title.isNotEmpty) {
      await addNote(title);
    }
  }
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Notes'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: showAddNoteDialog,
        backgroundColor: const Color(0xFFB76E79),
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Color(0xFFB76E79),
              ),
            )
          : notes.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.note_alt_outlined,
                        size: 75,
                        color: colors.onSurfaceVariant,
                      ),
                      const SizedBox(height: 15),
                      const Text(
                        'No notes yet',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Tap + to create your first note',
                        style: TextStyle(
                          color: colors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: notes.length,
                  itemBuilder: (context, index) {
                    final note = notes[index];

                    return Card(
                      color: theme.cardColor,
                      margin: const EdgeInsets.only(bottom: 10),
                      child: ListTile(
                        leading: Checkbox(
                          value: note.isCompleted,
                          activeColor: const Color(0xFFB76E79),
                          onChanged: (value) {
                            toggleNote(note);
                          },
                        ),
                        title: Text(
                          note.title,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            decoration: note.isCompleted
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                            color: note.isCompleted
                                ? colors.onSurfaceVariant
                                : colors.onSurface,
                          ),
                        ),
                        subtitle: Text(note.dateText),
                        trailing: IconButton(
                          onPressed: () {
                            deleteNote(note);
                          },
                          icon: const Icon(
                            Icons.delete_outline,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
