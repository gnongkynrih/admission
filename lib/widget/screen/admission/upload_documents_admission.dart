import 'package:admission/widget/screen/admission/select_image.dart';
import 'package:flutter/material.dart';

class UploadDocumentAdmissionScreen extends StatefulWidget {
  const UploadDocumentAdmissionScreen({super.key});

  @override
  State<UploadDocumentAdmissionScreen> createState() =>
      _UploadDocumentAdmissionScreenState();
}

class _UploadDocumentAdmissionScreenState
    extends State<UploadDocumentAdmissionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Document'),
      ),
      body: Center(
        child: Column(
          children: [
            const Text('Upload Documents'),
            const SizedBox(
              height: 10,
            ),
            ListTile(
              title: const Text('Passport'),
              trailing: IconButton(
                onPressed: () {
                  photoOption(context, 'Passport');
                  // Navigator.pushNamed(context, '/selectImage');
                },
                icon: const Icon(Icons.upload),
              ),
            ),
            ListTile(
              title: const Text('Birth Certificate'),
              trailing: IconButton(
                onPressed: () {
                  photoOption(context, 'Birth Certificate');
                  // Navigator.pushNamed(context, '/selectImage');
                },
                icon: const Icon(Icons.upload),
              ),
            ),
            ListTile(
              title: const Text('Father ID'),
              trailing: IconButton(
                onPressed: () {},
                icon: const Icon(Icons.upload),
              ),
            ),
            ListTile(
              title: const Text('Mother ID'),
              trailing: IconButton(
                onPressed: () {},
                icon: const Icon(Icons.upload),
              ),
            ),
            ListTile(
              title: const Text('Transfer Certificate'),
              trailing: IconButton(
                onPressed: () {},
                icon: const Icon(Icons.upload),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void photoOption(BuildContext context, String title) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return SizedBox(
              height: 350,
              child: SelectImage(
                title: title,
              ));
        });
  }
}
