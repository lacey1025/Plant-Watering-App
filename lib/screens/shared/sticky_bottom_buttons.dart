import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:plant_application/theme.dart';

class StickyBottomButtons extends StatelessWidget {
  const StickyBottomButtons({
    super.key,
    required this.onSubmit,
    required this.onCancel,
    this.isHorizontal = false,
  });

  final VoidCallback onSubmit;
  final VoidCallback onCancel;
  final bool isHorizontal;

  @override
  Widget build(BuildContext context) {
    final colors = SelectionColorScheme.blue;

    return SliverFillRemaining(
      hasScrollBody: false,
      child: Column(
        children: [
          Spacer(),
          Padding(
            padding: EdgeInsets.all(isHorizontal ? 8 : 16),
            child:
                isHorizontal
                    ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _horizontalButton(false, colors),
                        const SizedBox(width: 8),
                        _horizontalButton(true, colors),
                      ],
                    )
                    : Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _verticalButton(true, colors),
                        const SizedBox(height: 4),
                        _verticalButton(false, colors),
                      ],
                    ),
          ),
        ],
      ),
    );
  }

  Widget _verticalButton(bool isSubmit, SelectionColorScheme colors) {
    return SizedBox(
      width: double.infinity,
      child: FilledButton(
        onPressed: isSubmit ? onSubmit : onCancel,
        style: FilledButton.styleFrom(
          backgroundColor:
              isSubmit ? colors.primaryColor : colors.secondaryColor,
          foregroundColor: isSubmit ? Colors.white : colors.textColor,
        ),
        child: Text(
          isSubmit ? "submit" : "cancel",
          style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _horizontalButton(bool isSubmit, SelectionColorScheme colors) {
    return Expanded(
      child: FilledButton(
        onPressed: isSubmit ? onSubmit : onCancel,
        style: FilledButton.styleFrom(
          backgroundColor:
              isSubmit ? colors.primaryColor : colors.secondaryColor,
          foregroundColor: isSubmit ? Colors.white : colors.textColor,
        ),
        child: Text(
          isSubmit ? "submit" : "cancel",
          style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
