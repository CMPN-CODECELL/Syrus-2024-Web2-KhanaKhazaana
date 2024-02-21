import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:syrus24/models/user_model.dart';

import '../../services/authService.dart';

class ChatScreen extends StatefulWidget {
  static const routeName = '/chatscreen';
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _firebasefirestore = FirebaseFirestore.instance;
  ModelUser user = ModelUser(
      username: '',
      flatnumber: '',
      doctorAddress: '',
      doctorName: '',
      buildingName: '',
      streetName: '',
      city: '',
      doctorPhoto: '',
      doctorPhone: '',
      userid: '',
      phoneNumber: '',
      relationImage: [],
      relationName: []);
  String message = '';
  bool isLoading = false;
  final messagecontroller = TextEditingController();
  @override
  @override
  void getMessages() async {
    await for (var snapshot
        in _firebasefirestore.collection('messages').snapshots()) {
      for (var messages in snapshot.docs.reversed) {
        print(messages.data());
      }
    }
  }

  void getUser() async {
    setState(() {
      isLoading = true;
    });
    user = await AuthService().getUserDetails();
    setState(() {
      isLoading = false;
    });
  }

  void initState() {
    super.initState();
    getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.deepPurple,
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: (isLoading)
          ? const Center(
              child: CircularProgressIndicator(
                color: Colors.deepPurple,
              ),
            )
          : Container(
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: StreamBuilder<QuerySnapshot>(
                      stream: _firebasefirestore
                          .collection('messages')
                          .orderBy('createdAt', descending: true)
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        }
                        return ListView.builder(
                            shrinkWrap: true,
                            reverse: true,
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (BuildContext context, int index) {
                              return MessageText(
                                sender: snapshot.data!.docs[index]['sender'],
                                text: snapshot.data!.docs[index]['text'],
                                currentuserid:
                                    FirebaseAuth.instance.currentUser!.uid,
                                uid: snapshot.data!.docs[index]['uid'],
                              );
                            });
                      },
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 5,
                        child: TextField(
                          controller: messagecontroller,
                          onChanged: (value) {
                            setState(() {
                              message = value;
                            });
                          },
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                              borderSide: BorderSide(
                                  width: 2, color: Colors.transparent),
                            ),
                            focusedBorder: (OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                              borderSide: BorderSide(
                                  width: 2, color: Colors.transparent),
                            )),
                            hintText: 'Type a message...',
                          ),
                        ),
                      ),
                      Expanded(
                        child: IconButton(
                          onPressed: message.trim().isEmpty
                              ? null
                              : () {
                                  messagecontroller.clear();
                                  _firebasefirestore
                                      .collection('messages')
                                      .add({
                                    'text': message,
                                    'sender': user.phoneNumber,
                                    'createdAt': Timestamp.now(),
                                    'uid': user.userid
                                  });
                                  getMessages();
                                  setState(() {
                                    message = '';
                                  });
                                },
                          icon: Icon(Icons.telegram),
                          iconSize: 40.0,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}

class MessageText extends StatelessWidget {
  MessageText(
      {required this.sender,
      required this.text,
      required this.currentuserid,
      required this.uid});
  final String sender;
  final String uid;
  final String text;
  final String currentuserid;
  @override
  Widget build(BuildContext context) {
    if (uid == currentuserid) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text('+91 ' + sender),
            Material(
              elevation: 15.0,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30.0),
                bottomLeft: Radius.circular(30.0),
                bottomRight: Radius.circular(30.0),
              ),
              color: Colors.deepPurple,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
                child: Text(
                  text,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(sender),
            Material(
              elevation: 15.0,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(30.0),
                bottomLeft: Radius.circular(30.0),
                bottomRight: Radius.circular(30.0),
              ),
              color: Colors.white,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
                child: Text(
                  text,
                  style: TextStyle(color: Colors.black, fontSize: 15.0),
                ),
              ),
            ),
          ],
        ),
      );
    }
  }
}
