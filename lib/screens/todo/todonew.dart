import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:record/record.dart';

class Note {
  final String title;
  final String description;
  final DateTime timestamp;
  final String audioPath;
  bool isPlaying; // Track the playing state

  Note({
    required this.title,
    required this.description,
    required this.timestamp,
    required this.audioPath,
    this.isPlaying = false, // Default to false
  });
}

class AllView2 extends StatefulWidget {
  const AllView2({Key? key}) : super(key: key);
  @override
  _AllView2State createState() => _AllView2State();
}

class _AllView2State extends State<AllView2> {
  late Record audioRecord;
  late AudioPlayer audioPlayer;
  String audioPath = '';
  List<Note> notes = [];
  bool isPlaying = false;
  int? currentlyPlayingIndex; // Track the index of the currently playing note
  bool isRecording = false;
  bool hasRecorded = false;
  @override
  void initState() {
    audioRecord = Record();
    audioPlayer = AudioPlayer();
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

  Future<void> playRecording(String path, int index) async {
    try {
      if (currentlyPlayingIndex != null && currentlyPlayingIndex != index) {
        // Stop the previously playing note if any
        await audioPlayer.stop();
        setState(() {
          // Update the UI for the previously playing note
          notes[currentlyPlayingIndex!].isPlaying = false;
          isPlaying = false;
        });
      }
      Source dataSource = UrlSource(path);
      // Start or resume playback
      if (!notes[index].isPlaying) {
        await audioPlayer.play(dataSource);

        audioPlayer.onPlayerComplete.listen((event) {
          setState(() {
            notes[index].isPlaying = false;
            isPlaying = false;
          });
        });
        setState(() {
          notes[index].isPlaying = true;
          isPlaying = true;
          currentlyPlayingIndex = index;
        });
      } else {
        await audioPlayer.pause();
        setState(() {
          notes[index].isPlaying = false;
          isPlaying = false;
        });
      }
    } catch (e) {
      print('Error playing recording: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Align(
              alignment: Alignment.topLeft,
              child: Text(
                'Notes',
                style: GoogleFonts.getFont('Poppins',
                    color: Colors.black, fontSize: 30),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: notes.length,
              itemBuilder: (context, index) {
                final note = notes[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.black, width: 1),
                    ),
                    child: ListTile(
                      title: Text(
                        note.title,
                        style: TextStyle(
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
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          if (note.audioPath.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ElevatedButton.icon(
                                onPressed: () async {
                                  await playRecording(note.audioPath, index);
                                },
                                icon: Icon(note.isPlaying
                                    ? Icons.pause
                                    : Icons.play_arrow),
                                label: Text(note.isPlaying ? 'Pause' : 'Play'),
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
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
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
        onPressed: () {
          _addNote(context); // Add note while recording
        },
        child: Icon(Icons.add),
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
