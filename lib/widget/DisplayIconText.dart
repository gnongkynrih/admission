import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DisplayIconText extends StatefulWidget {
  DisplayIconText(
      {super.key,
      required this.icon,
      required this.title,
      this.color,
      required this.onPressed});
  final IconData icon;
  final String title;
  Color? color = Colors.blueAccent;
  final GestureTapCallback onPressed;
  @override
  State<DisplayIconText> createState() => _DisplayIconTextState();
}

class _DisplayIconTextState extends State<DisplayIconText> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IconButton(
            onPressed: widget.onPressed,
            icon: FaIcon(widget.icon, size: 30, color: widget.color)),
        const SizedBox(height: 20),
        Text(
          widget.title,
          style: const TextStyle(fontSize: 20),
        ),
      ],
    );
  }
}
