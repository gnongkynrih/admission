import 'dart:convert';
import 'dart:io';

import 'package:admission/helpers/common.dart';
import 'package:admission/provider/admission_provider.dart';
import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class SelectImage extends StatefulWidget {
  const SelectImage({super.key, required this.title, required this.field});
  final String title;
  final String field;
  @override
  State<SelectImage> createState() => _SelectImageState();
}

class _SelectImageState extends State<SelectImage> {
  String imagePath = '';
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
        imagePath != ''
            ? SizedBox(
                height: 40,
                child: Image.network(imagePath),
              )
            : const SizedBox(),
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

      img = await CropImage(img);

      var request = http.MultipartRequest('POST', Uri.parse(url));
      request.fields['source'] = widget.field;
      var pic = await http.MultipartFile.fromPath('image', img!.path);
      request.files.add(pic);

      var response = await request.send();
      var data = await response.stream.bytesToString();
      var responseData = jsonDecode(data);
      if (response.statusCode == 201) {
        CommonHelper.animatedSnackBar(context, 'Document uploaded successfully',
            AnimatedSnackBarType.success);
        if (Platform.isAndroid) {
          setState(() {
            imagePath =
                'http://10.0.2.2:8000${responseData['message']['path']}';
          });
        } else {
          setState(() {
            imagePath =
                'http://localhost:8000${responseData['message']['path']}';
          });
        }
      } else {
        setState(() {
          imagePath = '';
        });
      }
    } catch (e) {
      CommonHelper.animatedSnackBar(
          context, 'Document not uploaded', AnimatedSnackBarType.error);
      Navigator.pop(context);
    }
  }

  Future<File?> CropImage(File imageFile) async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: imageFile.path,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9
      ],
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        IOSUiSettings(
          title: 'Cropper',
        ),
        WebUiSettings(
          context: context,
        ),
      ],
    );
    if (croppedFile == null) {
      return null;
    }
    return File(croppedFile.path);
  }
}
