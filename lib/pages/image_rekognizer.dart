import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class ImageRecognizer extends StatefulWidget {
  @override
  _ImageRecognizerState createState() => _ImageRecognizerState();
}

class _ImageRecognizerState extends State<ImageRecognizer> {
  File? _image;
  bool _loading = false;
  String? _result;

  Future<void> _getImage(ImageSource source) async {
    final pickedImage = await ImagePicker().pickImage(source: source);
    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
        _result = null; // Reset result when a new image is selected
      });
    }
  }

  Future<void> _uploadImage() async {
    setState(() {
      _loading = true;
    });

    final url = Uri.parse('https://4d64-115-98-232-52.ngrok-free.app/predict');
    final request = http.MultipartRequest('POST', url)
      ..fields['save_txt'] = 'T'
      ..files.add(await http.MultipartFile.fromPath('myfile', _image!.path));

    try {
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      print(response.body);
      setState(() {
        _result = response.body;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _result = 'Error: $e';
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Recognition'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (_loading)
              Center(child: CircularProgressIndicator())
            else
              _image == null
                  ? Text(
                      'UPLOAD IMAGE',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18),
                    )
                  : Column(
                      children: [
                        Image.file(_image!),
                        SizedBox(height: 10),
                        _result != null
                            ? Text(
                                _result!,
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 18),
                              )
                            : SizedBox.shrink(),
                      ],
                    ),
            ElevatedButton(
              onPressed: () => _getImage(ImageSource.camera),
              child: Text('Take Picture'),
            ),
            ElevatedButton(
              onPressed: () => _getImage(ImageSource.gallery),
              child: Text('Choose from Gallery'),
            ),
            ElevatedButton(
              onPressed: _image != null ? _uploadImage : null,
              child: Text('Recognize Image'),
            ),
          ],
        ),
      ),
    );
  }
}
