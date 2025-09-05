import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:plant_application/screens/add_plant/widgets/full_screen_image_page.dart';
import 'package:plant_application/screens/shared/image_source_sheet.dart';
import 'package:plant_application/screens/add_plant/plant_form_data.dart';
import 'package:plant_application/screens/add_plant/plant_form_notifier.dart';
import 'package:plant_application/screens/shared/background_scaffold.dart';
import 'package:plant_application/screens/shared/custom_app_bar.dart';
import 'package:plant_application/screens/shared/date_card.dart';
import 'package:plant_application/screens/shared/fake_blur.dart';
import 'package:plant_application/screens/shared/sticky_bottom_buttons.dart';
import 'package:plant_application/screens/shared/text_form_field.dart';
import 'package:plant_application/screens/shared/text_widgets.dart';
import 'package:plant_application/theme.dart';

class AddPlantScreen extends ConsumerStatefulWidget {
  const AddPlantScreen({super.key, this.form});

  final PlantFormData? form;

  @override
  ConsumerState<AddPlantScreen> createState() => _AddPlantScreenState();
}

class _AddPlantScreenState extends ConsumerState<AddPlantScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _notesController;
  late final TextEditingController _photoNotesController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    final form = ref.read(plantFormProvider(widget.form));
    _nameController = TextEditingController(text: form.name);
    _notesController = TextEditingController(text: form.notes);
    _photoNotesController = TextEditingController(text: form.photoNotes);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _notesController.dispose();
    _photoNotesController.dispose();
    super.dispose();
  }

  void _handleSubmit(bool isAdd) {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    final notifier = ref.read(plantFormProvider(widget.form).notifier);
    notifier.updateName(_nameController.text);
    notifier.updateNotes(_notesController.text);
    notifier.updatePhotoNotes(_photoNotesController.text);

    if (isAdd) {
      notifier.submit();
    } else {
      notifier.updatePlant();
    }

    Navigator.pop(context);
  }

  Future<void> _pickDate({
    required BuildContext context,
    DateTime? initialDate,
    required void Function(DateTime) onPicked,
  }) async {
    // final form = ref.watch(plantFormProvider(widget.form));

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      onPicked(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final form = ref.watch(plantFormProvider(widget.form));
    final notifier = ref.read(plantFormProvider(widget.form).notifier);
    final isAdd = widget.form == null;
    final aboutColors = SelectionColorScheme.pink;
    final waterColors = SelectionColorScheme.yellow;
    final photoColors = SelectionColorScheme.green;

    return BackgroundScaffold(
      appBar: CustomAppBar(title: isAdd ? "add plant" : "edit plant"),
      body: Form(
        key: _formKey,
        child: CustomScrollView(
          slivers: [
            // Main content
            SliverPadding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  // About section
                  FakeBlur(
                    borderRadius: BorderRadius.zero,
                    overlay: aboutColors.secondaryColor.withAlpha(200),
                    padding: EdgeInsets.fromLTRB(8, 8, 8, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SectionTitleText("about", color: aboutColors.textColor),

                        ThemedTextFormField(
                          controller: _nameController,
                          colorScheme: aboutColors,
                          hint: "choose a name for your plant",
                          label: "name",
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'name is required';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 8),
                        ThemedTextFormField(
                          controller: _notesController,
                          colorScheme: aboutColors,
                          label: "notes",
                          hint: "(optional)",
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 8),

                  // Watering info section
                  FakeBlur(
                    borderRadius: BorderRadius.zero,
                    overlay: waterColors.secondaryColor.withAlpha(200),
                    padding: EdgeInsets.fromLTRB(8, 8, 8, 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SectionTitleText(
                          "watering info",
                          color: waterColors.textColor,
                        ),

                        if (isAdd)
                          DateCard(
                            colors: waterColors,
                            titleText: "date last watered",
                            onTap:
                                () => _pickDate(
                                  context: context,
                                  initialDate: form.lastWatered,
                                  onPicked: (pickedDate) {
                                    notifier.updateLastWatered(pickedDate);
                                  },
                                ),
                            dateText:
                                form.lastWatered == null
                                    ? "choose a date"
                                    : "${form.lastWatered!.month}/${form.lastWatered!.day}/${form.lastWatered!.year}",
                          ),

                        Card(
                          color: waterColors.secondaryColor,
                          child: Padding(
                            padding: EdgeInsets.all(12),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "add to watering schedule",
                                      style: GoogleFonts.inter(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: waterColors.textColor,
                                      ),
                                    ),
                                    Switch(
                                      activeColor: const Color.fromARGB(
                                        255,
                                        168,
                                        136,
                                        53,
                                      ),
                                      inactiveTrackColor: waterColors
                                          .selectedTextColor
                                          .withAlpha(100),
                                      inactiveThumbColor:
                                          waterColors.primaryColor,
                                      trackOutlineColor:
                                          WidgetStateProperty.all(
                                            waterColors.primaryColor,
                                          ),
                                      value: form.inSchedule,
                                      onChanged:
                                          notifier.updateWateringSchedule,
                                    ),
                                  ],
                                ),
                                if (form.inSchedule) ...[
                                  Divider(color: waterColors.primaryColor),
                                  const SizedBox(height: 16),
                                  Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      "estimated watering frequency",
                                      style: GoogleFonts.inter(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: waterColors.textColor,
                                      ),
                                    ),
                                  ),
                                  Slider(
                                    value: form.frequency,
                                    min: 0,
                                    max: 30,
                                    divisions: 30,
                                    label: "${form.frequency}",
                                    onChanged: notifier.updateWateringFrequency,
                                  ),
                                  Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      'every ${form.frequency.toInt()} days',
                                      style: GoogleFonts.inter(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: waterColors.textColor,
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 8),

                  // Photo section
                  FakeBlur(
                    borderRadius: BorderRadius.zero,
                    overlay: photoColors.secondaryColor.withAlpha(200),
                    padding: EdgeInsets.fromLTRB(8, 8, 8, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SectionTitleText("photo", color: photoColors.textColor),

                        if (form.pickedImage != null)
                          Stack(
                            alignment: Alignment.topRight,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (_) => FullscreenImagePage(
                                            imagePath: form.pickedImage!.path,
                                          ),
                                    ),
                                  );
                                },
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.file(
                                    File(form.pickedImage!.path),
                                    width: double.infinity,
                                    height: 100,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 4,
                                right: 4,
                                child: GestureDetector(
                                  onTap: () {
                                    _photoNotesController.clear();
                                    notifier.updatePhotoDate(DateTime.now());
                                    notifier.updatePickedImage(null);
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.black54,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Padding(
                                      padding: EdgeInsets.all(4.0),
                                      child: Icon(
                                        Icons.close,
                                        color: Colors.white,
                                        size: 24,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: photoColors.primaryColor,
                              foregroundColor: Colors.white,
                            ),
                            onPressed: () async {
                              await ImageSourceSheet.show(
                                context,
                                onImageSelected: (image, date) {
                                  if (image != null) {
                                    final notifier =
                                        plantFormProvider(widget.form).notifier;
                                    ref.read(notifier).updatePickedImage(image);
                                    ref
                                        .read(notifier)
                                        .updatePhotoDate(
                                          date ?? DateTime.now(),
                                        );
                                  }
                                },
                              );
                            },
                            child:
                                (form.pickedImage == null)
                                    ? Text("add a photo")
                                    : Text("change photo"),
                          ),
                        ),
                        if (form.pickedImage != null) ...[
                          const SizedBox(height: 8),
                          DateCard(
                            colors: photoColors,
                            titleText: "photo date",
                            onTap: () async {
                              await _pickDate(
                                context: context,
                                initialDate: form.photoDate,
                                onPicked: (pickedPhoto) {
                                  notifier.updatePhotoDate(pickedPhoto);
                                },
                              );
                            },
                            dateText:
                                "${form.photoDate.month}/${form.photoDate.day}/${form.photoDate.year}",
                          ),
                          ThemedTextFormField(
                            controller: _photoNotesController,
                            colorScheme: photoColors,
                            label: "about this photo",
                          ),
                        ],
                      ],
                    ),
                  ),
                ]),
              ),
            ),

            StickyBottomButtons(
              onSubmit: () => _handleSubmit(isAdd),
              onCancel: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }
}
