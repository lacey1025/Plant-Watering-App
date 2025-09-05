import 'package:flutter/material.dart';
import 'package:plant_application/screens/shared/text_widgets.dart';
import 'package:plant_application/theme.dart';

class SelectionSection<T> extends StatelessWidget {
  const SelectionSection({
    super.key,
    required this.title,
    required this.items,
    required this.isSelected,
    required this.onItemPressed,
    required this.getItemName,
    required this.colorScheme,
    this.onAddNew,
    this.onRemoveToggle,
    this.isRemoveMode = false,
    this.canRemove = false,
    this.removeIcon,
    this.customItemBuilder,
    this.errorMessage,
    this.spacing = 0,
  });

  final String title;
  final List<T> items;
  final bool Function(T item) isSelected;
  final void Function(T item) onItemPressed;
  final String Function(T item) getItemName;
  final SelectionColorScheme colorScheme;
  final VoidCallback? onAddNew;
  final VoidCallback? onRemoveToggle;
  final bool isRemoveMode;
  final bool canRemove;
  final IconData? removeIcon;
  final Widget Function(T item, bool isSelected, bool isRemoveMode)?
  customItemBuilder;
  final String? errorMessage;
  final double spacing;

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: spacing,
      children: [
        // Title
        Align(
          alignment: Alignment.centerLeft,
          child: SectionTitleText(title, color: colorScheme.textColor),
        ),

        // Items
        ...items.map((item) {
          final selected = isSelected(item);

          if (customItemBuilder != null) {
            return customItemBuilder!(item, selected, isRemoveMode);
          }

          return SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              icon: isRemoveMode ? Icon(removeIcon ?? Icons.close) : null,
              style: ElevatedButton.styleFrom(
                foregroundColor:
                    (selected || isRemoveMode)
                        ? colorScheme.selectedTextColor
                        : colorScheme.textColor,
                backgroundColor:
                    isRemoveMode
                        ? AppColors.error
                        : selected
                        ? colorScheme.primaryColor
                        : colorScheme.secondaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () => onItemPressed(item),
              label: Text(getItemName(item)),
            ),
          );
        }),

        // Action buttons row
        if (onAddNew != null || (canRemove && items.isNotEmpty))
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              if (!isRemoveMode && onAddNew != null)
                TextButton.icon(
                  icon: Icon(Icons.add),
                  style: TextButton.styleFrom(
                    foregroundColor: colorScheme.textColor,
                    backgroundColor: null,
                  ),
                  onPressed: onAddNew,
                  label: Text('add new'),
                ),
              if (canRemove && items.isNotEmpty)
                TextButton.icon(
                  icon: isRemoveMode ? Icon(Icons.done) : Icon(Icons.remove),
                  style: TextButton.styleFrom(
                    foregroundColor: colorScheme.textColor,
                    backgroundColor: null,
                  ),
                  onPressed: onRemoveToggle,
                  label: Text(isRemoveMode ? "done" : 'remove'),
                ),
            ],
          ),

        // Error message
        if (errorMessage != null) ...[
          Text(errorMessage!, style: TextStyle(color: AppColors.error)),
          SizedBox(height: 8),
        ],
      ],
    );
  }
}
