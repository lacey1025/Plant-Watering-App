import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:plant_application/theme.dart';

class DateCard extends StatelessWidget {
  final SelectionColorScheme colors;
  final String? titleText;
  final void Function() onTap;
  final String dateText;

  const DateCard({
    super.key,
    required this.colors,
    this.titleText,
    required this.onTap,
    required this.dateText,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: colors.secondaryColor,
      child: Padding(
        padding:
            (titleText != null)
                ? const EdgeInsets.all(12)
                : const EdgeInsets.all(0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (titleText != null) ...[
              Text(
                titleText!,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: colors.textColor,
                ),
              ),
              SizedBox(height: 2),
            ],
            InkWell(
              onTap: onTap,
              splashColor: colors.primaryColor.withAlpha(80),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: colors.textColor.withAlpha(200),
                    width: 1.5,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.calendar_month,
                      color: colors.textColor.withAlpha(200),
                    ),
                    SizedBox(width: 12),
                    Text(
                      dateText,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: colors.textColor.withAlpha(200),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
