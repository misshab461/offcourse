import 'package:flutter/material.dart';

class TextForm extends StatefulWidget {
  const TextForm({
    required this.controller,
    required this.hint,
    this.keytype = TextInputType.text,
    this.obscureText = false,
    this.validator,
    this.maxLength,
    this.initial,
    this.label,
  });

  final TextEditingController controller;
  final String hint;
  final TextInputType? keytype;
  final bool obscureText;
  final String? Function(String? value)? validator;
  final int? maxLength;
  final String? initial;
  final String? label;

  @override
  State<TextForm> createState() => _TextFormState();
}

class _TextFormState extends State<TextForm> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: widget.initial,
      maxLength: widget.maxLength,
      validator: widget.validator,
      obscureText: widget.obscureText,
      keyboardType: widget.keytype,
      controller: widget.controller,
      decoration: InputDecoration(
        hintText: widget.hint,
        hintStyle: const TextStyle(color: Colors.black45),
        hintFadeDuration: const Duration(milliseconds: 300),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide: BorderSide.none,
        ),
        fillColor: Colors.teal.withOpacity(.1),
        filled: true,
      ),
    );
  }
}
