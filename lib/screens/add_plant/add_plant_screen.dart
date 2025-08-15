import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plant_application/screens/add_plant/full_screen_image_page.dart';
import 'package:plant_application/screens/add_plant/image_source_sheet.dart';
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
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    final form = ref.read(plantFormProvider(widget.form));
    _nameController = TextEditingController(text: form.name);
    _notesController = TextEditingController(text: form.notes);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _handleSubmit(bool isAdd) {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    final notifier = ref.read(plantFormProvider(widget.form).notifier);
    notifier.updateName(_nameController.text);
    notifier.updateNotes(_notesController.text);

    if (isAdd) {
      notifier.submit();
    } else {
      notifier.updatePlant();
    }

    Navigator.of(
      context,
    ).pushReplacement(MaterialPageRoute(builder: (_) => const HomeScreen()));
  }

  Future<void> _pickDate(BuildContext context) async {
    final form = ref.watch(plantFormProvider(widget.form));
    final notifier = ref.read(plantFormProvider(widget.form).notifier);
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: form.lastWatered ?? DateTime.now(),
      firstDate: DateTime(2025),
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != form.lastWatered) {
      notifier.updateLastWatered(picked);
    }
  }

  Future<void> _showImageSourceActionSheet(BuildContext context) async {
    showModalBottomSheet(
      context: context,
      builder:
          (context) => ImageSourceSheet(
            onImageSelected: (image) {
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
                // const SizedBox(height: 8),
                //   const Text("Watering window size"),
                //   Slider(
                //     value: form.windowSize.toDouble(),
                //     min: 1,
                //     max: 10,
                //     divisions: 9,
                //     label: "${form.windowSize}",
                //     onChanged: notifier.updateWindowSize,
                //   ),
                //   Text('${form.windowSize.toInt()} days'),
              ],
              const SizedBox(height: 8),
              if (isAdd)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text("Date last watered"),
                    ElevatedButton.icon(
                      onPressed: () => _pickDate(context),
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
