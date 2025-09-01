import 'dart:io';

import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:plant_application/database/plant_app_db.dart';
import 'package:plant_application/notifier_providers/photos_provider.dart';
import 'package:plant_application/screens/add_plant/widgets/full_screen_image_page.dart';
import 'package:plant_application/screens/add_plant/widgets/image_source_sheet.dart';

class AddPhotoScreen extends ConsumerStatefulWidget {
  const AddPhotoScreen({
    super.key,
    required this.plantId,
    this.initialData,
    this.initialImage,
  });

  final int plantId;
  final Photo? initialData;
  final XFile? initialImage;

  @override
  ConsumerState<AddPhotoScreen> createState() => _AddPhotoScreenState();
}

class _AddPhotoScreenState extends ConsumerState<AddPhotoScreen> {
  final _notesController = TextEditingController();
  XFile? _initialImage;
  XFile? _pickedImage;
  late DateTime _pickedDate;
  late bool isEdit;
  bool _isPrimary = false;
  bool _isFirst = false;

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    Photo? initial = widget.initialData;
    isEdit = (initial == null) ? false : true;
    _notesController.text = initial?.notes ?? '';
    if (initial != null) {
      _isPrimary = (initial.isPrimary) ? true : false;
      _initialImage = XFile(initial.filePath);
      _pickedImage = _initialImage;
      _pickedDate = DateTime.parse(initial.date);
    } else {
      _pickedImage = widget.initialImage;
      _pickedDate = DateTime.now();
    }
  }

  Future<void> _pickDate(BuildContext context) async {
    final newDate =
        await showDatePicker(
          context: context,
          initialDate: _pickedDate,
          firstDate: DateTime(2020),
          lastDate: DateTime.now(),
        ) ??
        DateTime.now();
    setState(() {
      _pickedDate = newDate;
    });
  }

  Future<bool> _submit() async {
    if (_pickedImage == null) {
      return false;
    }
    final notes = _notesController.text;
    final notifier = ref.read(photoNotifierProvider(widget.plantId).notifier);

    if (_pickedImage != _initialImage) {
      final photoPath = await notifier.savePhoto(_pickedImage!);
      if (photoPath == null) {
        return false;
      }

      final photoCompanion = PhotosCompanion(
        id: Value.absentIfNull(widget.initialData?.id),
        plantId: Value(widget.plantId),
        filePath: Value(photoPath),
        date: Value(_pickedDate.toString()),
        notes: notes.isNotEmpty ? Value(notes) : Value.absent(),
        isPrimary: Value(_isPrimary),
      );
      notifier.insertPhoto(photoCompanion);
    } else {
      if (widget.initialData == null) return false;
      final photoCompanion = PhotosCompanion(
        id: Value(widget.initialData!.id),
        date: Value(_pickedDate.toString()),
        notes: notes.isNotEmpty ? Value(notes) : Value.absent(),
        isPrimary: Value(_isPrimary),
      );
      notifier.updatePhoto(photoCompanion);
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    _isFirst =
        ref.read(photoNotifierProvider(widget.plantId).notifier).isEmpty();
    if (_isFirst) {
      _isPrimary = true;
    }
    return Scaffold(
      appBar: AppBar(title: const Text("Add a photo")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!_isFirst && !(widget.initialData != null && _isPrimary))
              TextButton.icon(
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  splashFactory: NoSplash.splashFactory,
                  overlayColor: Colors.transparent,
                ),
                onPressed: () {
                  setState(() {
                    _isPrimary = !_isPrimary;
                  });
                },
                icon: Icon(
                  _isPrimary ? Icons.star : Icons.star_border,
                  size: 24,
                ),
                label: Text("make primary cover photo"),
              ),
            Stack(
              alignment: Alignment.topRight,
              children: [
                GestureDetector(
                  onTap: () {
                    if (_pickedImage != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (_) => FullscreenImagePage(
                                imagePath: _pickedImage!.path,
                              ),
                        ),
                      );
                    }
                  },
                  child: AspectRatio(
                    aspectRatio: 3 / 4,
                    child:
                        _pickedImage != null
                            ? ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.file(
                                File(_pickedImage!.path),
                                fit: BoxFit.cover,
                              ),
                            )
                            : TextButton.icon(
                              style: TextButton.styleFrom(
                                backgroundColor: const Color.fromARGB(
                                  160,
                                  0,
                                  0,
                                  0,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),

                              icon: const Icon(
                                Icons.add_a_photo,
                                color: Colors.white,
                              ),
                              label: const Text(
                                "select Photo",
                                style: TextStyle(color: Colors.white),
                              ),
                              onPressed: () async {
                                await _showImageSourceActionSheet(context);
                              },
                            ),
                  ),
                ),
                if (_pickedImage != null)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: GestureDetector(
                      onTap: () async {
                        await _showImageSourceActionSheet(context);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black45,
                          shape: BoxShape.circle,
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.edit,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Date",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                ElevatedButton.icon(
                  onPressed: () => _pickDate(context),
                  icon: Icon(Icons.calendar_month),
                  label: Text(
                    "${_pickedDate.month}/${_pickedDate.day}/${_pickedDate.year}",
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            TextFormField(
              decoration: const InputDecoration(labelText: "Notes (optional)"),
              controller: _notesController,
            ),

            const SizedBox(height: 30),

            // Submit & Cancel buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  icon: const Icon(Icons.check),
                  label: const Text("Submit"),
                  onPressed: () async {
                    final success = await _submit();
                    if (context.mounted && success) {
                      Navigator.pop(context);
                    }
                  },
                ),
                OutlinedButton.icon(
                  icon: const Icon(Icons.close),
                  label: const Text("Cancel"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showImageSourceActionSheet(BuildContext context) async {
    showModalBottomSheet(
      context: context,
      builder:
          (context) => ImageSourceSheet(
            onImageSelected: (image) {
              Navigator.pop(context);
              setState(() {
                _pickedImage = image;
              });
            },
          ),
    );
  }
}
