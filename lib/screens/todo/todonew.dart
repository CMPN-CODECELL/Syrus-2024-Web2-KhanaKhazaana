import 'dart:io';

import 'package:audioplayers/audioplayers.dart' as audioplayer;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:record/record.dart';
import 'package:uuid/uuid.dart';

import '../../models/notes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(AllView2());
}

class AllView2 extends StatefulWidget {
  const AllView2({Key? key}) : super(key: key);
  @override
  _AllView2State createState() => _AllView2State();
}

class _AllView2State extends State<AllView2> {
  bool isRecording = false;
  bool hasRecorded = false;
  late Record audioRecord;
  late audioplayer.AudioPlayer audioPlayer;
  String audioPath = '';
  bool isLoading = false;
  bool isPlaying = false;
  @override
  void initState() {
    audioRecord = Record();
    audioPlayer = audioplayer.AudioPlayer(); // Initialize Firebase
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
      audioplayer.Source audioUri = audioplayer.UrlSource(path);
      setState(() {
        isPlaying = true;
      });
      audioPlayer.play(audioUri);
      audioPlayer.onPlayerComplete.listen((event) {
        // Execute the onComplete function when playback completes
        setState(() {
          isPlaying = false;
        });

        // Dispose the AudioPlayer instance to release resources
        audioPlayer.dispose();
      });
    } catch (e) {
      throw ("Error : $e");
    }
  }

  Future<void> uploadRecording(
      String audioPath, String title, String description) async {
    try {
      String downloadUrl = '';
      if (audioPath.isNotEmpty) {
        File audioFile = File(audioPath);
        String fileName =
            DateTime.now().millisecondsSinceEpoch.toString(); // Unique filename
        firebase_storage.Reference ref = firebase_storage
            .FirebaseStorage.instance
            .ref()
            .child('recordings')
            .child(FirebaseAuth.instance.currentUser!.uid)
            .child(
                '$fileName.wav'); // Change the extension according to your audio format
        await ref.putFile(audioFile);
        downloadUrl = await ref.getDownloadURL();
      }
      setState(() {});

      String id = Uuid().v4();
      // Create a Note object with the download URL
      Note newNote = Note(
        uid: FirebaseAuth.instance.currentUser!.uid,
        title: title,
        description: description,
        timestamp: Timestamp.now(),
        audioPath: downloadUrl,
        id: id,
      );

      // Store the Note object in Firestore
      await FirebaseFirestore.instance.collection('notes').add({
        'title': newNote.title,
        'description': newNote.description,
        'timestamp': newNote.timestamp,
        'audioPath': newNote.audioPath,
        'userid': FirebaseAuth.instance.currentUser!.uid,
        'id': id
      });
    } catch (e) {
      print('Error uploading recording: $e');
      // Handle error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final note = Note.fromSnap(snapshot.data!.docs[index]);
                String date =
                    DateFormat('MMMM').format(note.timestamp.toDate()) +
                        ' ' +
                        note.timestamp.toDate().day.toString() +
                        ', ' +
                        note.timestamp.toDate().year.toString();
                return Dismissible(
                  key: UniqueKey(), // Unique key for each Dismissible widget
                  onDismissed: (direction) {},
                  background: Container(
                    color: Colors.red, // Background color when swiping
                    child: const Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.only(left: 20.0),
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
                                  child: (isPlaying)
                                      ? Icon(Icons.pause)
                                      : Icon(Icons.play_arrow),
                                ),
                              ),
                            // Display URL if audioPath is not empty
                          ],
                        ),
                        trailing: Text(
                          date,
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
              });
        },
        stream: FirebaseFirestore.instance
            .collection('notes')
            .where('userid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
            .snapshots(),
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
                                    stopRecording();
                                    uploadRecording(audioPath, title,
                                        description); // Stop recording
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
