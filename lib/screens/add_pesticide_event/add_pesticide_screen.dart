import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plant_application/database/plant_app_db.dart';
import 'package:plant_application/models/enums/event_types_enum.dart';
import 'package:plant_application/models/pesticide_event_data.dart';
import 'package:plant_application/notifier_providers/accessories_provider.dart';
import 'package:plant_application/notifier_providers/db_providers.dart';
import 'package:plant_application/screens/shared/accessory_dialog.dart';
import 'package:plant_application/screens/shared/background_scaffold.dart';
import 'package:plant_application/screens/shared/custom_app_bar.dart';
import 'package:plant_application/screens/shared/date_card.dart';
import 'package:plant_application/screens/shared/fake_blur.dart';
import 'package:plant_application/screens/shared/selection_section.dart';
import 'package:plant_application/screens/shared/sticky_bottom_buttons.dart';
import 'package:plant_application/screens/shared/text_form_field.dart';
import 'package:plant_application/screens/shared/text_widgets.dart';
import 'package:plant_application/theme.dart';
import 'package:plant_application/utils/datetime_extensions.dart';

class AddPesticideScreen extends ConsumerStatefulWidget {
  const AddPesticideScreen({
    super.key,
    required this.plantId,
    this.initialData,
  });

  final int plantId;
  final PesticideEventData? initialData;

  @override
  ConsumerState<AddPesticideScreen> createState() => _AddPesticideScreenState();
}

class _AddPesticideScreenState extends ConsumerState<AddPesticideScreen> {
  final _notesController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final Set<int> _addedPesticides = {};
  late DateTime _pickedDate;
  late bool isEdit;
  bool _removePesticide = false;

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    final data = widget.initialData;
    if (data != null) {
      isEdit = true;
      _notesController.text = data.event.notes ?? '';
      _pickedDate = DateTime.parse(data.event.date);
      _addedPesticides.addAll(data.accessories.map((a) => a.id));
    } else {
      isEdit = false;
      _pickedDate = DateTime.now();
    }
  }

  Future<void> _pickDate(BuildContext context) async {
    final selected =
        await showDatePicker(
          context: context,
          initialDate: _pickedDate,
          firstDate: DateTime(2025),
          lastDate: DateTime.now(),
        ) ??
        DateTimeHelpers.getNowTruncated();
    setState(() {
      _pickedDate = selected;
    });
  }

  Future<void> _submit() async {
    final notes = _notesController.text;
    final event = EventsCompanion(
      plantId: Value(widget.plantId),
      eventType: Value(EventType.pesticide.toString()),
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
      eventId = widget.initialData!.event.id;
      await db.eventsDao.updateEventFromCompanion(eventId, event);
    }
    await _submitAccessories(eventId);
  }

  Future<void> _submitAccessories(int eventId) async {
    final db = ref.read(databaseProvider);
    final List<EventAccessoriesCompanion> itemsToSubmit = [];
    for (final p in _addedPesticides) {
      itemsToSubmit.add(
        EventAccessoriesCompanion(
          eventId: Value(eventId),
          accessoryId: Value(p),
        ),
      );
    }
    if (isEdit) {
      await db.accessoriesDao.deleteEventAccessoriesByEvents([eventId]);
    }
    await db.accessoriesDao.insertEventAccessories(itemsToSubmit);
  }

  @override
  Widget build(BuildContext context) {
    final accessoriesAsync = ref.watch(accessoriesNotifierProvider);
    final pestColors = SelectionColorScheme.pink;
    final dateColors = SelectionColorScheme.yellow;
    final notesColors = SelectionColorScheme.green;

    return BackgroundScaffold(
      appBar: CustomAppBar(title: "pesticide event"),
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                FakeBlur(
                  borderRadius: BorderRadius.zero,
                  overlay: pestColors.secondaryColor.withAlpha(200),
                  padding: EdgeInsets.fromLTRB(8, 8, 8, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      accessoriesAsync.when(
                        data: (accessories) {
                          final pesticides =
                              accessories
                                  .where(
                                    (a) =>
                                        a.type ==
                                        EventType.pesticide.toString(),
                                  )
                                  .toList();

                          return SelectionSection<Accessory>(
                            title: "pesticides",
                            items: pesticides,
                            isSelected:
                                (pesticide) =>
                                    _addedPesticides.contains(pesticide.id),
                            onItemPressed: (pesticide) {
                              if (!_removePesticide) {
                                setState(() {
                                  if (_addedPesticides.contains(pesticide.id)) {
                                    _addedPesticides.remove(pesticide.id);
                                  } else {
                                    _addedPesticides.add(pesticide.id);
                                  }
                                });
                              } else {
                                _addedPesticides.clear();
                                ref
                                    .read(accessoriesNotifierProvider.notifier)
                                    .deleteAccessory(pesticide.id);
                              }
                            },
                            getItemName: (pesticide) => pesticide.name,
                            colorScheme: pestColors,
                            onAddNew: () async {
                              final newId = await showAccessoryDialog(
                                context,
                                ref,
                                null,
                                EventType.pesticide,
                              );
                              if (newId != null) {
                                setState(() {
                                  _addedPesticides.add(newId);
                                  _removePesticide = false;
                                });
                              }
                            },
                            onRemoveToggle:
                                () => setState(() {
                                  _removePesticide = !_removePesticide;
                                }),
                            isRemoveMode: _removePesticide,
                            canRemove: true,
                          );
                        },
                        loading:
                            () => Center(
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(0, 8, 0, 16),
                                child: CircularProgressIndicator(
                                  color: pestColors.primaryColor,
                                ),
                              ),
                            ),
                        error: (e, st) {
                          debugPrintStack();
                          return Center(
                            child: Padding(
                              padding: EdgeInsets.only(bottom: 8),
                              child: Text('Error loading pesticides: $e'),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 8),

                // Date section
                FakeBlur(
                  borderRadius: BorderRadius.zero,
                  overlay: dateColors.secondaryColor.withAlpha(200),
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SectionTitleText("date", color: dateColors.textColor),
                      DateCard(
                        colors: dateColors,
                        onTap: () {
                          _pickDate(context);
                        },
                        dateText:
                            "${_pickedDate.month}/${_pickedDate.day}/${_pickedDate.year}",
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 8),

                // Notes section
                FakeBlur(
                  borderRadius: BorderRadius.zero,
                  overlay: notesColors.secondaryColor.withAlpha(200),
                  padding: EdgeInsets.fromLTRB(8, 8, 8, 16),
                  child: Column(
                    children: [
                      Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SectionTitleText(
                              "notes",
                              color: notesColors.textColor,
                            ),
                            ThemedTextFormField(
                              controller: _notesController,
                              hint: "about this event",
                              colorScheme: notesColors,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ]),
            ),
          ),

          StickyBottomButtons(
            onSubmit: () async {
              await _submit();
              if (context.mounted) Navigator.pop(context);
            },
            onCancel: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }
}
