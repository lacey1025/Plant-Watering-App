import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:plant_application/theme.dart';

class ThemedTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String? label;
  final String? hint;
  final SelectionColorScheme colorScheme;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;

  ThemedTextFormField({
    super.key,
    required this.controller,
    this.label,
    this.hint,
    SelectionColorScheme? colorScheme,
    this.keyboardType = TextInputType.text,
    this.validator,
  }) : colorScheme = colorScheme ?? SelectionColorScheme.blue;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: colorScheme.textColor,
          selectionColor: colorScheme.textColor.withAlpha(70),
          selectionHandleColor: colorScheme.textColor,
        ),
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        validator: validator,
        style: Theme.of(
          context,
        ).textTheme.bodyMedium?.copyWith(color: colorScheme.textColor),
        minLines: 1,
        maxLines: 6,
        cursorErrorColor: colorScheme.textColor,
        decoration: InputDecoration(
          filled: true,
          fillColor: colorScheme.secondaryColor,
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: colorScheme.textColor, width: 1),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: colorScheme.textColor, width: 2),
          ),
          labelText: label,
          hintText: hint,
          hintStyle: GoogleFonts.inter(
            color: colorScheme.textColor.withAlpha(180),
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.normal,
            fontSize: 16,
          ),
          labelStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: colorScheme.textColor,
            fontSize: 16,
          ),
          errorStyle: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: AppColors.error),
          errorBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: AppColors.error, width: 1),
          ),
          focusedErrorBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: AppColors.error, width: 1),
          ),
        ),
      ),
    );
  }
}
