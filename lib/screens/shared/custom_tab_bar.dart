import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:plant_application/theme.dart';

class CustomTabBar extends StatelessWidget implements PreferredSizeWidget {
  final List<String> tabs;
  final TabController controller;
  final double height;
  final bool reverse;

  const CustomTabBar({
    super.key,
    required this.tabs,
    required this.controller,
    this.height = 40,
    this.reverse = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: reverse ? AppColors.primaryGreen : AppColors.secondaryGreen,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(8),
          bottom: Radius.zero,
        ),
      ),
      // padding: const EdgeInsets.all(2),
      child: TabBar(
        controller: controller,
        labelPadding: EdgeInsets.zero,
        indicator: BoxDecoration(
          color: reverse ? AppColors.secondaryGreen : AppColors.primaryGreen,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(8),
            bottom: Radius.zero,
          ),
        ),
        labelColor:
            reverse ? AppColors.darkTextGreen : AppColors.lightTextGreen,
        unselectedLabelColor:
            reverse ? AppColors.lightTextGreen : AppColors.darkTextGreen,
        tabs:
            tabs
                .map(
                  (t) => Center(
                    child: Text(
                      t,
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ),
                )
                .toList(),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}
