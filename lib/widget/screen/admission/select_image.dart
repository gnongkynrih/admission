import 'dart:convert';
import 'dart:io';

import 'package:admission/provider/admission_provider.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class SelectImage extends StatefulWidget {
  const SelectImage({super.key, required this.title});
  final String title;
  @override
  State<SelectImage> createState() => _SelectImageState();
}

class _SelectImageState extends State<SelectImage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        const SizedBox(
          height: 20,
        ),
        Text(
          'Upload ${widget.title}',
          style: const TextStyle(fontSize: 20),
        ),
        const SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () {
                takePhoto(ImageSource.camera);
              },
              child: const Row(children: [
                Icon(Icons.camera_alt),
                Text("Take Photo"),
              ]),
            ),
            ElevatedButton(
              onPressed: () {
                takePhoto(ImageSource.gallery);
              },
              child: const Row(children: [
                Icon(Icons.image),
                Text("Select Image"),
              ]),
            ),
          ],
        )
      ]),
    );
  }

  void takePhoto(ImageSource source) async {
    String applicantID =
        Provider.of<AdmissionProvider>(context, listen: false).applicantId!;
    String url = '';
    if (Platform.isAndroid) {
      url = 'http://10.0.2.2:8000/api/admission/upload/$applicantID';
    } else {
      url = 'http://localhost:8000/api/admission/upload/$applicantID';
    }

    try {
      final ImagePicker imgPicker = ImagePicker();
      final XFile? photo =
          await imgPicker.pickImage(source: source, imageQuality: 75);
      if (photo == null) {
        return;
      }
      File? img = File(photo.path);

      var request = http.MultipartRequest('POST', Uri.parse(url));
      // request.headers['Content-Type'] = 'multipart/form-data';
      // request.headers['Accept'] = 'application/json';
      request.fields['source'] = 'passport';
      var pic = await http.MultipartFile.fromPath('image', img.path);
      request.files.add(pic);

      var response = await request.send();
      var data = await response.stream.bytesToString();
      var responseData = jsonDecode(data);
      if (response.statusCode == 201) {
        print(responseData);
      } else {
        print('Error: $responseData');
      }
    } catch (e) {
      print('Error: $e');
    }
  }
}
