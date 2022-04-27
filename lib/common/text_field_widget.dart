import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:tc_app/util/util.dart';

class TextFieldWidget extends StatelessWidget {
  const TextFieldWidget({
    Key? key,
    required this.label,
    required this.changed,
    this.controller,
    this.inputContentPadding,
  }) : super(key: key);

  final String label;
  final ValueChanged changed;
  final TextEditingController? controller;
  final EdgeInsets? inputContentPadding;
  @override
  Widget build(BuildContext context) {
    return KeyboardDismissOnTap(
      dismissOnCapturedTaps: false,
      child: TextField(
        controller: controller,
        textAlignVertical: TextAlignVertical.top,
        keyboardType: TextInputType.multiline,
        maxLines: null,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.black12,
          hintText: label,
          hintStyle: TextStyle(
            color: Colors.white.withOpacity(0.7),
            fontWeight: FontWeight.w600,
          ),
          focusedBorder: kInputDecoration,
          enabledBorder: kInputDecoration,
          contentPadding: inputContentPadding,
        ),
        onChanged: changed,
      ),
    );
  }
}
