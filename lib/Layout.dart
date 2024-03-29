import 'package:admission/Call.dart';
import 'package:admission/Share.dart';
import 'package:admission/helpers/common.dart';
import 'package:admission/widget/DisplayIconText.dart';
import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Layout extends StatefulWidget {
  const Layout({super.key});

  @override
  State<Layout> createState() => _LayoutState();
}

class _LayoutState extends State<Layout> {
  int likes = 40;
  bool isLiked = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MyWidget'),
      ),
      body: SingleChildScrollView(
        child: Center(
            child: Column(
          children: [
            SizedBox(height: 200, child: Image.asset('images/summer.png')),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Expanded(
                        child: Column(
                          children: [
                            Text(
                              'Title',
                              style: TextStyle(
                                  fontSize: 30, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'JSub Title',
                              style:
                                  TextStyle(fontSize: 20, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                          onTap: () {
                            setState(() {
                              if (!isLiked) {
                                likes++;
                              } else {
                                likes--;
                              }
                              isLiked = !isLiked;
                            });
                          },
                          child: Icon(Icons.star,
                              color: isLiked ? Colors.red : Colors.grey)),
                      Text(likes.toString())
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      DisplayIconText(
                        onPressed: () async {
                          final value = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const CallPage(
                                      title: 'Call',
                                    )),
                          );
                          CommonHelper.animatedSnackBar(context,
                              value.toString(), AnimatedSnackBarType.info);
                        },
                        icon: FontAwesomeIcons.phone,
                        title: 'Call',
                      ),
                      DisplayIconText(
                        onPressed: () => CommonHelper.animatedSnackBar(context,
                            "You click on route", AnimatedSnackBarType.success),
                        icon: FontAwesomeIcons.route,
                        title: 'Route',
                        color: Colors.green,
                      ),
                      DisplayIconText(
                        onPressed: () => CommonHelper.animatedSnackBar(
                            context, "Share", AnimatedSnackBarType.success),
                        icon: FontAwesomeIcons.shareNodes,
                        title: 'Share',
                      )
                    ],
                  ),
                  const Text(''' What is Lorem Ipsum?
      Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.
      What is Lorem Ipsum?
      Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.''')
                ],
              ),
            ),
          ],
        )),
      ),
    );
  }
}
