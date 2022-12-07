import 'package:flutter/material.dart';

class Textfield extends StatelessWidget {
  final Function(String)? onChanged;
  final TextEditingController controller;
  final InputDecoration decoration;
  const Textfield({Key? key, required this.onChanged, required this.controller, required this.decoration,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
          decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25.0),),
              child: TextField(
        controller: controller,
        onChanged: onChanged,
        decoration: decoration
      ),
      ),
    );
  }
}
