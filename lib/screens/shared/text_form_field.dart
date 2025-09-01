import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ThemedTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String? label;
  final String? hint;
  final Color fillColor;
  final Color textColor;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;

  const ThemedTextFormField({
    super.key,
    required this.controller,
    this.label,
    this.hint,
    required this.fillColor,
    required this.textColor,
    this.keyboardType = TextInputType.text,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: textColor,
          selectionColor: textColor.withAlpha(70),
          selectionHandleColor: textColor,
        ),
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        validator: validator,
        style: Theme.of(
          context,
        ).textTheme.bodyMedium?.copyWith(color: textColor),
        minLines: 1,
        maxLines: 6,
        decoration: InputDecoration(
          filled: true,
          fillColor: fillColor,
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: textColor, width: 1),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: textColor, width: 2),
          ),
          labelText: label,
          hintText: hint,
          hintStyle: GoogleFonts.inter(
            color: textColor.withAlpha(180),
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.normal,
            fontSize: 16,
          ),
          labelStyle: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: textColor, fontSize: 16),
        ),
      ),
    );
  }
}
