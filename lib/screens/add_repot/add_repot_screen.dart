import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plant_application/database/plant_app_db.dart';
import 'package:plant_application/models/enums/event_types_enum.dart';
import 'package:plant_application/models/repot_data.dart';
import 'package:plant_application/notifier_providers/db_providers.dart';
import 'package:plant_application/screens/shared/background_scaffold.dart';
import 'package:plant_application/screens/shared/custom_app_bar.dart';
import 'package:plant_application/screens/shared/fake_blur.dart';
import 'package:plant_application/screens/shared/text_form_field.dart';
import 'package:plant_application/theme.dart';
import 'package:plant_application/utils/datetime_extensions.dart';

class AddRepotScreen extends ConsumerStatefulWidget {
  const AddRepotScreen({super.key, required this.plantId, this.initialData});

  final int plantId;
  final RepotData? initialData;

  @override
  ConsumerState<AddRepotScreen> createState() => _AddRepotScreenState();
}

class _AddRepotScreenState extends ConsumerState<AddRepotScreen> {
  final _potSizeController = TextEditingController();
  final _soilTypeController = TextEditingController();
  final _notesController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late DateTime _pickedDate;
  late bool isEdit;

  @override
  void dispose() {
    _potSizeController.dispose();
    _soilTypeController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    isEdit = (widget.initialData == null) ? false : true;
    _potSizeController.text = widget.initialData?.potSize.toString() ?? '';
    _soilTypeController.text = widget.initialData?.soilType ?? '';
    _notesController.text = widget.initialData?.notes ?? '';
    _pickedDate = widget.initialData?.date ?? DateTime.now();
  }

  Future<void> _pickDate(BuildContext context) async {
    _pickedDate =
        await showDatePicker(
          context: context,
          initialDate: widget.initialData?.date ?? DateTime.now(),
          firstDate: DateTime(2023),
          lastDate: DateTime.now(),
        ) ??
        DateTimeHelpers.getNowTruncated();
  }

  Future<bool> _submit() async {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return false;
    final potSize = double.tryParse(_potSizeController.text);
    if (potSize == null) return false;
    final soilType = _soilTypeController.text;
    final notes = _notesController.text;

    final event = EventsCompanion(
      plantId: Value(widget.plantId),
      eventType: Value(EventType.repot.toString()),
      date: Value(
        DateTime(
          _pickedDate.year,
          _pickedDate.month,
          _pickedDate.day,
        ).dateTimeToDateString(),
      ),
      notes: Value(notes),
    );

    final db = ref.read(databaseProvider);
    late int eventId;
    if (!isEdit) {
      eventId = await db.eventsDao.insertEvent(event);
    } else {
      eventId = widget.initialData!.id;
      await db.eventsDao.updateEventFromCompanion(eventId, event);
    }

    final repotEvent = RepotEventsCompanion(
      eventId: Value(eventId),
      potSize: Value(potSize),
      soilType: Value(soilType),
    );

    if (!isEdit) {
      await db.eventsDao.insertRepotEvent(repotEvent);
    } else {
      await db.eventsDao.updateRepotEvent(eventId, repotEvent);
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return BackgroundScaffold(
      appBar: CustomAppBar(title: "repot event"),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: FakeBlur(
                  borderRadius: BorderRadius.zero,
                  overlay: AppColors.secondaryBlue.withAlpha(200),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 32),
                    child: Column(
                      // spacing: 8,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "date",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: AppColors.darkTextBlue,
                              ),
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
                        Form(
                          key: _formKey,
                          child: Column(
                            spacing: 4,
                            children: [
                              ThemedTextFormField(
                                controller: _potSizeController,
                                label: "pot size",
                                fillColor: AppColors.secondaryBlue,
                                textColor: AppColors.darkTextBlue,
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter a pot size';
                                  }
                                  if (double.tryParse(value) == null) {
                                    return 'Please ensure pot size is a number';
                                  }
                                  return null;
                                },
                              ),
                              ThemedTextFormField(
                                controller: _soilTypeController,
                                label: "soil type",
                                fillColor: AppColors.secondaryBlue,
                                textColor: AppColors.darkTextBlue,
                              ),
                              ThemedTextFormField(
                                controller: _notesController,
                                label: 'notes',
                                fillColor: AppColors.secondaryBlue,
                                textColor: AppColors.darkTextBlue,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    child: const Text("submit"),
                    onPressed: () async {
                      final success = await _submit();
                      if (context.mounted && success) {
                        Navigator.pop(context);
                      }
                    },
                  ),
                ),
                SizedBox(height: 4),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.secondaryBlue,
                      foregroundColor: AppColors.darkTextBlue,
                    ),
                    child: const Text("cancel"),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
