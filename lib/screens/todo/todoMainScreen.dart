import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:record/record.dart';

class Note {
  final String title;
  final String description;
  final DateTime timestamp;
  final String audioPath;

  Note({
    required this.title,
    required this.description,
    required this.timestamp,
    required this.audioPath,
  });
}

class AllView extends StatefulWidget {
  const AllView({Key? key}) : super(key: key);
  @override
  _AllViewState createState() => _AllViewState();
}

class _AllViewState extends State<AllView> {
  bool isRecording = false;
  bool hasRecorded = false;
  late Record audioRecord;
  late AudioPlayer audioPlayer;
  String audioPath = '';
  List<Note> notes = [];
  bool isPlaying = false;
  @override
  void initState() {
    audioRecord = Record();
    audioPlayer = AudioPlayer(); // Load saved notes
    super.initState();
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    audioRecord.dispose();
    super.dispose();
  }

  Future<void> startRecording() async {
    try {
      if (await audioRecord.hasPermission()) {
        await audioRecord.start();
        setState(() {
          isRecording = true;
        });
      }
    } catch (e) {
      throw ("Error in recording : $e");
    }
  }

  Future<void> stopRecording() async {
    try {
      String? path = await audioRecord.stop();
      setState(() {
        isRecording = false;
        audioPath = path!;
      });
    } catch (e) {
      throw ("Error : $e");
    }
  }

  Future<void> playRecording(String path) async {
    try {
      Source urlSource = UrlSource(path);
      setState(() {
        isPlaying = true;
      });
      await audioPlayer.play(urlSource);
    } catch (e) {
      throw ("Error : $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.topLeft,
              child: Text(
                'Notes',
                style: GoogleFonts.getFont('Poppins', color: Colors.black),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: notes.length,
              itemBuilder: (context, index) {
                final note = notes[index];
                return Dismissible(
                  direction: DismissDirection.endToStart,
                  key: UniqueKey(), // Unique key for each Dismissible widget
                  onDismissed: (direction) {
                    setState(() {
                      // Remove the dismissed item from the notes list
                      notes.removeAt(index);
                    });
                  },
                  background: Container(
                    color: Colors.red, // Background color when swiping
                    child: const Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: EdgeInsets.only(right: 20.0),
                        child: Icon(
                          Icons.delete,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.black, width: 1),
                      ),
                      child: ListTile(
                        title: Text(
                          note.title,
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w700,
                            fontSize: 30,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              note.description,
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            if (note.audioPath.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ElevatedButton(
                                  onPressed: () async {
                                    await playRecording(note.audioPath);
                                  },
                                  child: Icon((isPlaying)
                                      ? Icons.pause
                                      : Icons.play_arrow),
                                ),
                              ),
                            // Display URL if audioPath is not empty
                            if (note.audioPath.isNotEmpty)
                              Text(
                                "Recording URL: ${(note.audioPath)}",
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontSize: 16,
                                ),
                              ),
                          ],
                        ),
                        trailing: Text(
                          DateFormat('MMM dd, yyyy').format(note.timestamp),
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          hasRecorded = false;
          _addNote(context); // Add note while recording
        },
        child: const Icon(Iconsax.add),
      ),
    );
  }

  void _addNote(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String title = '';
        String description = '';
        final _addnoteKey = GlobalKey<FormState>();
        return AlertDialog(
          title: const Text('Add Note'),
          content: Form(
            key: _addnoteKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Title'),
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return 'Enter your title';
                    }
                    return null;
                  },
                  onChanged: (value) => title = value,
                ),
                TextFormField(
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return 'Enter your Description';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(labelText: 'Description'),
                  onChanged: (value) => description = value,
                ),
                Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: ElevatedButton(
                                onPressed: () async {
                                  await startRecording();
                                  // await record();
                                },
                                child: const Text(
                                  'Start',
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: ElevatedButton(
                                onPressed: () async {
                                  hasRecorded = true;
                                  await stopRecording();
                                  // await stop();
                                },
                                child: const Text(
                                  'Stop',
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: ElevatedButton(
                                child: const Text(
                                  'Cancel',
                                  style: TextStyle(color: Colors.black),
                                ),
                                onPressed: () {
                                  stopRecording(); // Stop recording if canceled
                                  Navigator.pop(context);
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: ElevatedButton(
                                onPressed: () {
                                  if (_addnoteKey.currentState!.validate()) {
                                    Note newNote = Note(
                                      title: title,
                                      description: description,
                                      timestamp: DateTime.now(),
                                      audioPath: hasRecorded ? audioPath : '',
                                    );

                                    setState(() {
                                      notes.add(newNote);
                                    });

                                    stopRecording(); // Stop recording
                                    Navigator.pop(context);
                                  } else {}

                                  // Close the dialog
                                },
                                child: const Text(
                                  'Add',
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
