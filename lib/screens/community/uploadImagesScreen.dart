import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:syrus24/constants.dart';
import 'package:syrus24/screens/home/exportHomeScreen.dart';

import '../../services/uploadPost.dart';
import '../../widgets/custombutton.dart';
import '../../widgets/selectImage.dart';

class AddPostScreen extends StatefulWidget {
  static const routeName = '/addpostScreen';
  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  bool _isLoading = false;
  final _descriptionController = TextEditingController();
  Uint8List? img;

  void uploadPost({
    required String description,
    required Uint8List image,
  }) async {
    setState(() {
      _isLoading = true;
    });

    if (_descriptionController.text.isEmpty) {
      setState(() {
        _isLoading = false;
      });
      displaySnackbar(context: context, content: 'Caption can\'t be empty!!');
    } else {
      try {
        String res = await FirestoreMethods().uploadPost(
          description: description,
          image: image,
        );
        setState(() {
          _isLoading = false;
        });
        if (res == 'Success') {
          displaySnackbar(
              context: context, content: 'Post Uploaded Successfully');
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) {
            return HomeScreen();
          }));
        } else {
          displaySnackbar(context: context, content: res);
        }
      } catch (e) {
        displaySnackbar(context: context, content: e.toString());
      }
    }
  }

  _selectImage(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: Text('Select Image'),
            children: [
              SimpleDialogOption(
                onPressed: () async {
                  Uint8List _img = await getImage(source: ImageSource.camera);
                  setState(() {
                    img = _img;
                  });
                  Navigator.of(context).pop();
                },
                child: Container(
                    padding: EdgeInsets.all(10),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: Center(child: Text('Upload from camera'))),
              ),
              SimpleDialogOption(
                onPressed: () async {
                  Uint8List _img = await getImage(source: ImageSource.gallery);
                  setState(() {
                    img = _img;
                  });
                  Navigator.of(context).pop();
                },
                child: Container(
                    padding: EdgeInsets.all(10),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: Center(child: Text('Upload from gallery'))),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Container(
                    padding: EdgeInsets.all(10),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: Center(child: Text('Cancel'))),
              ),
            ],
          );
        });
  }

  void clearImage() {
    setState(() {
      img = null;
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _descriptionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          automaticallyImplyLeading: false,
          backgroundColor: Colors.deepPurple,
          title: Text(
            'Create Post',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
          leading: (img != null)
              ? null
              : IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white,
                  ),
                  onPressed: clearImage,
                ),
        ),
        body: (img == null)
            ? Center(
                child: TextButton(
                  onPressed: () {
                    _selectImage(context);
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.upload,
                        size: 40,
                        color: Colors.deepPurple[200],
                      ),
                      Text(
                        'Upload Image',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      )
                    ],
                  ),
                ),
              )
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        child: Text(
                          'Retake photo',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ),
                        onPressed: () {
                          _selectImage(context);
                        },
                      ),
                    ),
                    Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                      height: MediaQuery.of(context).size.height * 0.3,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: MemoryImage(img!), fit: BoxFit.contain)),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 10.0, bottom: 10),
                              child: TextField(
                                controller: _descriptionController,
                                textCapitalization:
                                    TextCapitalization.sentences,
                                maxLength: 100,
                                maxLines: 3,
                                decoration: InputDecoration(
                                  hintText: 'Write a caption...',
                                  labelStyle: TextStyle(color: Colors.white),
                                  contentPadding: EdgeInsets.all(10),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: Divider.createBorderSide(
                                          context,
                                          color: Colors.deepPurple)),
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: Divider.createBorderSide(
                                          context,
                                          color: Colors.grey)),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    _isLoading
                        ? Container(
                            width: double.infinity,
                            margin: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.deepPurple,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Center(
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            ),
                          )
                        : Container(
                            width: double.infinity,
                            margin: EdgeInsets.all(10),
                            child: CustomTextButton(
                                color: Colors.deepPurple,
                                buttonTitle: 'Share',
                                callback: () => uploadPost(
                                      description:
                                          _descriptionController.text.trim(),
                                      image: img!,
                                    )),
                          )
                  ],
                ),
              ));
  }
}
