import 'dart:io';

import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:plant_application/database/plant_app_db.dart';
import 'package:plant_application/notifier_providers/photos_provider.dart';
import 'package:plant_application/screens/add_plant/widgets/full_screen_image_page.dart';
import 'package:plant_application/screens/shared/image_source_sheet.dart';
import 'package:plant_application/screens/shared/background_scaffold.dart';
import 'package:plant_application/screens/shared/custom_app_bar.dart';
import 'package:plant_application/screens/shared/date_card.dart';
import 'package:plant_application/screens/shared/fake_blur.dart';
import 'package:plant_application/screens/shared/sticky_bottom_buttons.dart';
import 'package:plant_application/screens/shared/text_form_field.dart';
import 'package:plant_application/theme.dart';

class AddPhotoScreen extends ConsumerStatefulWidget {
  const AddPhotoScreen({
    super.key,
    required this.plantId,
    this.initialData,
    this.initialImage,
    this.initialDate,
  });

  final int plantId;
  final Photo? initialData;
  final XFile? initialImage;
  final DateTime? initialDate;

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
  final colors = SelectionColorScheme.blue;

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
      _pickedDate = widget.initialDate ?? DateTime.now();
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
        notes: notes.isNotEmpty ? Value(notes) : Value(null),
        isPrimary: Value(_isPrimary),
      );
      notifier.insertPhoto(photoCompanion);
    } else {
      if (widget.initialData == null) return false;
      final photoCompanion = PhotosCompanion(
        id: Value(widget.initialData!.id),
        date: Value(_pickedDate.toString()),
        notes: notes.isNotEmpty ? Value(notes) : Value(null),
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

    return BackgroundScaffold(
      appBar: CustomAppBar(title: "add a photo"),
      body: FakeBlur(
        borderRadius: BorderRadius.zero,
        overlay: colors.secondaryColor.withAlpha(150),
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                        ),

                                        icon: const Icon(
                                          Icons.add_a_photo,
                                          color: Colors.white,
                                        ),
                                        label: const Text(
                                          "select photo",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        onPressed: () async {
                                          await ImageSourceSheet.show(
                                            context,
                                            onImageSelected: (image, date) {
                                              setState(() {
                                                _pickedImage = image;
                                                _pickedDate =
                                                    date ?? DateTime.now();
                                              });
                                            },
                                          );
                                        },
                                      ),
                            ),
                          ),
                          if (_pickedImage != null)
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 8),
                              decoration: BoxDecoration(
                                color: Colors.black38,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(8),
                                  topRight: Radius.circular(8),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    (!_isFirst &&
                                            !(widget.initialData != null &&
                                                _isPrimary))
                                        ? MainAxisAlignment.spaceBetween
                                        : MainAxisAlignment.end,
                                children: [
                                  if (!_isFirst &&
                                      !(widget.initialData != null &&
                                          _isPrimary))
                                    TextButton.icon(
                                      style: TextButton.styleFrom(
                                        foregroundColor: Colors.white,
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
                                        _isPrimary
                                            ? Icons.star
                                            : Icons.star_border,
                                        size: 24,
                                      ),
                                      label: Text("set as cover photo"),
                                    ),
                                  if (_pickedImage != null)
                                    IconButton(
                                      onPressed: () async {
                                        await ImageSourceSheet.show(
                                          context,
                                          onImageSelected: (image, date) async {
                                            if (image != null) {
                                              setState(() {
                                                _pickedImage = image;
                                                _pickedDate =
                                                    date ?? DateTime.now();
                                              });
                                            }
                                          },
                                        );
                                      },
                                      icon: Icon(
                                        Icons.edit,
                                        color: Colors.white,
                                        size: 24,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                        ],
                      ),
                      SizedBox(height: 8),
                      DateCard(
                        titleText: "photo date",
                        colors: colors,
                        onTap: () => _pickDate(context),
                        dateText:
                            "${_pickedDate.month}/${_pickedDate.day}/${_pickedDate.year}",
                      ),
                      ThemedTextFormField(
                        controller: _notesController,
                        label: "notes",
                        hint: "optional",
                      ),
                    ],
                  ),
                ]),
              ),
            ),

            StickyBottomButtons(
              onSubmit: () async {
                final success = await _submit();
                if (context.mounted && success) {
                  Navigator.pop(context);
                }
              },
              onCancel: () => Navigator.pop(context),
              isHorizontal: true,
            ),
          ],
        ),
      ),
    );
  }
}
