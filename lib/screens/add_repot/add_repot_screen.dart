import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plant_application/database/plant_app_db.dart';
import 'package:plant_application/models/enums/event_types_enum.dart';
import 'package:plant_application/models/repot_data.dart';
import 'package:plant_application/notifier_providers/db_providers.dart';
import 'package:plant_application/screens/shared/background_scaffold.dart';
import 'package:plant_application/screens/shared/custom_app_bar.dart';
import 'package:plant_application/screens/shared/date_card.dart';
import 'package:plant_application/screens/shared/fake_blur.dart';
import 'package:plant_application/screens/shared/sticky_bottom_buttons.dart';
import 'package:plant_application/screens/shared/text_form_field.dart';
import 'package:plant_application/screens/shared/text_widgets.dart';
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
    final selected =
        await showDatePicker(
          context: context,
          initialDate: _pickedDate,
          firstDate: DateTime(2023),
          lastDate: DateTime.now(),
        ) ??
        DateTimeHelpers.getNowTruncated();

    setState(() {
      _pickedDate = selected;
    });
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
      notes: notes.isNotEmpty ? Value(notes) : Value.absent(),
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
      soilType: soilType.isNotEmpty ? Value(soilType) : Value.absent(),
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
    final colors = SelectionColorScheme.blue;
    return BackgroundScaffold(
      appBar: CustomAppBar(title: "repot event"),
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            sliver: SliverToBoxAdapter(
              child: FakeBlur(
                borderRadius: BorderRadius.zero,
                overlay: colors.secondaryColor.withAlpha(200),
                padding: EdgeInsets.fromLTRB(16, 8, 16, 16),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: SectionTitleText(
                        "repotting info",
                        color: colors.textColor,
                      ),
                    ),
                    DateCard(
                      colors: colors,
                      titleText: "date",
                      onTap: () => _pickDate(context),
                      dateText:
                          "${_pickedDate.month}/${_pickedDate.day}/${_pickedDate.year}",
                    ),
                    Form(
                      key: _formKey,
                      child: Column(
                        spacing: 8,
                        children: [
                          ThemedTextFormField(
                            controller: _potSizeController,
                            label: "pot size",
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
                          ),
                          ThemedTextFormField(
                            controller: _notesController,
                            label: 'notes',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
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
          ),
        ],
      ),
    );
  }
}
