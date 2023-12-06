import 'package:flutter/material.dart';

class myTextField extends StatefulWidget {
  final TextEditingController textEditingController;
  final String hintText;
  const myTextField(
      {super.key, required this.textEditingController, required this.hintText});

  @override
  State<myTextField> createState() => _myTextFieldState();
}

class _myTextFieldState extends State<myTextField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(0, 15, 0, 5),
      child: TextField(
        controller: widget.textEditingController,
        decoration: InputDecoration(
            hintText: widget.hintText,
            contentPadding: const EdgeInsets.only(left: 20),
            filled: true,
            fillColor: Colors.grey[200],
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(30)),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(30))),
      ),
    );
  }
}
