import 'package:flutter/material.dart';

class UiHelper {
  static Widget customTextField({
    required TextEditingController controller,
    required String text,
    required TextInputType textInputType,
    required String? Function(String?)? validator,
    bool isPassword = false,
  }) {
    return TextFormField(
      keyboardType: textInputType,
      controller: controller,
      obscureText: isPassword,
      validator: validator,
      decoration: InputDecoration(
        hint: Text(text),
        border: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
      ),
    );
  }

  static Widget customImage({required String imageUrl}) {
    return Image.asset('assets/images/$imageUrl');
  }

  static Widget customTextBtn({
    required VoidCallback callback,
    required String text,
  }) {
    return SizedBox(
      child: TextButton(
        onPressed: () => {callback()},
        child: Text(text, style: TextStyle(color: Colors.blue, fontSize: 15)),
      ),
    );
  }

  static Widget customBtn({
    required VoidCallback callback,
    required String text,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          shape: RoundedRectangleBorder(borderRadius: .circular(3)),
        ),
        onPressed: () => {callback()},
        child: Text(text, style: TextStyle(color: Colors.white)),
      ),
    );
  }
}
