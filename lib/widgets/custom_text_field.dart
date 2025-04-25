import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final Icon? prefixIcon;
  final Icon? suffixIcon;
  final int maxLines;
  final Function()? ontap;
  final TextEditingController controller;
  const CustomTextField({
    super.key,
    required this.hintText,
    this.maxLines = 1,
    this.prefixIcon,
    required this.controller,
    this.suffixIcon,
    this.ontap,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hintText,
          prefixIcon: prefixIcon,
          fillColor: Color(0xffF0F1F2),
          filled: true,
          suffixIcon: suffixIcon,
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.transparent))),
    );
  }
}
