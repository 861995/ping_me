import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AuthTextFieldWidget extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  const AuthTextFieldWidget(
      {required this.hintText, required this.controller, super.key});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(
          color: Colors.deepPurple,
          overflow: TextOverflow.ellipsis,
        ),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.red, width: 2),
          borderRadius: BorderRadius.circular(25),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.black, width: 2),
          borderRadius: BorderRadius.circular(25),
        ),
        contentPadding: const EdgeInsets.all(12),
      ),
    );
  }
}
