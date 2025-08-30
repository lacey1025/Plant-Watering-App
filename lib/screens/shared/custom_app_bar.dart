import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onBack;
  final Color? backgroundColor;

  const CustomAppBar({
    super.key,
    required this.title,
    this.onBack,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final canPop = Navigator.of(context).canPop();

    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: backgroundColor ?? theme.appBarTheme.backgroundColor,
      elevation: theme.appBarTheme.elevation ?? 0,
      flexibleSpace: SafeArea(
        child: Stack(
          children: [
            // Bottom-right title using theme
            Positioned(
              right: 24,
              bottom: 8,
              child: Text(
                title,
                style:
                    theme.appBarTheme.titleTextStyle ??
                    theme.textTheme.headlineMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),

            // Optional subtle back button (auto-handled if route can pop)
            if (canPop)
              Positioned(
                left: 0,
                top: 0,
                bottom: 0,
                child: IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white70,
                    size: theme.iconTheme.size ?? 20,
                  ),
                  onPressed: onBack ?? () => Navigator.of(context).pop(),
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(80);
}
