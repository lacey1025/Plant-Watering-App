import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plant_application/screens/add_plant/widgets/full_screen_image_page.dart';
import 'package:plant_application/screens/add_plant/widgets/image_source_sheet.dart';
import 'package:plant_application/screens/add_plant/plant_form_data.dart';
import 'package:plant_application/screens/add_plant/plant_form_notifier.dart';
import 'package:plant_application/screens/home/home_screen.dart';

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

    Navigator.of(
      context,
    ).pushReplacement(MaterialPageRoute(builder: (_) => const HomeScreen()));
  }

  Future<void> _pickDate({
    required BuildContext context,
    DateTime? initialDate,
    required void Function(DateTime) onPicked,
  }) async {
    final form = ref.watch(plantFormProvider(widget.form));
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != form.lastWatered) {
      onPicked(picked);
    }
  }

  Future<void> _showImageSourceActionSheet(BuildContext context) async {
    showModalBottomSheet(
      context: context,
      builder:
          (context) => ImageSourceSheet(
            onImageSelected: (image) {
              Navigator.of(context).pop();
              if (image != null) {
                ref
                    .read(plantFormProvider(widget.form).notifier)
                    .updatePickedImage(image);
              }
            },
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final form = ref.watch(plantFormProvider(widget.form));
    final notifier = ref.read(plantFormProvider(widget.form).notifier);
    final isAdd = widget.form == null;

    return Scaffold(
      appBar: AppBar(title: Text(isAdd ? "Add Plant" : "Edit Plant")),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: "Name"),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Name is required';
                  }
                  return null;
                },
              ),
              Row(
                children: [
                  const Text("Add to watering schedule"),
                  Switch(
                    value: form.inSchedule,
                    onChanged: notifier.updateWateringSchedule,
                  ),
                ],
              ),
              if (form.inSchedule) ...[
                const SizedBox(height: 8),
                const Text("Estimated Watering Frequency"),
                Slider(
                  value: form.frequency,
                  min: 0,
                  max: 30,
                  divisions: 30,
                  label: "${form.frequency}",
                  onChanged: notifier.updateWateringFrequency,
                ),
                Text('Every ${form.frequency.toInt()} days'),
              ],
              const SizedBox(height: 8),
              if (isAdd)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text("Date last watered"),
                    ElevatedButton.icon(
                      onPressed:
                          () => _pickDate(
                            context: context,
                            initialDate: form.lastWatered,
                            onPicked: (pickedPhoto) {
                              notifier.updateLastWatered(pickedPhoto);
                            },
                          ),
                      icon: Icon(Icons.calendar_month),
                      label:
                          (form.lastWatered == null)
                              ? Text("Choose a date")
                              : Text(
                                "${form.lastWatered!.month}/${form.lastWatered!.day}/${form.lastWatered!.year}",
                              ),
                    ),
                  ],
                ),
              TextField(
                controller: _notesController,
                decoration: const InputDecoration(labelText: "Notes"),
                maxLines: null,
              ),
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

              ElevatedButton(
                onPressed: () async {
                  await _showImageSourceActionSheet(context);
                },
                child:
                    (form.pickedImage == null)
                        ? Text("Add a photo")
                        : Text("Change photo"),
              ),
              const SizedBox(height: 16),
              if (form.pickedImage != null) ...[
                Text("Photo Date"),
                ElevatedButton.icon(
                  onPressed:
                      () => _pickDate(
                        context: context,
                        initialDate: form.photoDate,
                        onPicked: (pickedPhoto) {
                          notifier.updatePhotoDate(pickedPhoto);
                        },
                      ),
                  icon: Icon(Icons.calendar_month),
                  label: Text(
                    "${form.photoDate.month}/${form.photoDate.day}/${form.photoDate.year}",
                  ),
                ),
                TextField(
                  controller: _photoNotesController,
                  decoration: const InputDecoration(
                    labelText: "About this photo",
                  ),
                  maxLines: null,
                ),
              ],
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  OutlinedButton.icon(
                    icon: const Icon(Icons.close),
                    label: const Text("Cancel"),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.check),
                    label: const Text("Submit"),
                    onPressed: () {
                      _handleSubmit(isAdd);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
