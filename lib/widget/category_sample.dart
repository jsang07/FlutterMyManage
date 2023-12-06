import 'package:flutter/material.dart';

class categorySample extends StatefulWidget {
  final Function onTap;
  final String categoryText;
  const categorySample(
      {super.key, required this.onTap, required this.categoryText});

  @override
  State<categorySample> createState() => _categorySampleState();
}

class _categorySampleState extends State<categorySample> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 6),
      child: Container(
          decoration: BoxDecoration(
              color: Colors.grey.shade900,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.grey.shade100)),
          padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
          child: InkWell(
              onTap: () => widget.onTap,
              child: Text(
                widget.categoryText,
                style: TextStyle(color: Colors.white),
              ))),
    );
  }
}
