import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomTextfiled extends StatelessWidget {
  CustomTextfiled({super.key, 
    required this.text,
    required this.controller,
    required this.obscureText,
    this.onTap,
  });

  final String text;
  final bool obscureText;
  final controller;
  Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: TextFormField(
        validator: (data) {
          if (data!.isEmpty) {
            return 'data field';
          }
          return null;
        },
        obscureText: obscureText,
        controller: controller,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          enabledBorder:
              const OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
          hintStyle: const TextStyle(color: Colors.white),
          hintText: text,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}
