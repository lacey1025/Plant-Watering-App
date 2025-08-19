import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plant_application/database/plant_app_db.dart';
import 'package:plant_application/models/enums/event_types_enum.dart';
import 'package:plant_application/models/pesticide_event_data.dart';
import 'package:plant_application/notifier_providers/accessories_provider.dart';
import 'package:plant_application/notifier_providers/db_providers.dart';
import 'package:plant_application/screens/add_watering/add_accessory_dialog.dart';
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
    _pickedDate =
        await showDatePicker(
          context: context,
          initialDate: _pickedDate,
          firstDate: DateTime(2025),
          lastDate: DateTime.now(),
        ) ??
        DateTimeHelpers.getNowTruncated();
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
      notes: Value(notes),
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

  // Future<bool> _submit() async {
  //   final isValid = _formKey.currentState?.validate() ?? false;
  //   if (!isValid) return false;
  //   final notes = _notesController.text;

  //   final event = EventsCompanion(
  //     plantId: Value(widget.plantId),
  //     eventType: Value(EventType.repot.toString()),
  //     date: Value(
  //       DateTime(
  //         _pickedDate.year,
  //         _pickedDate.month,
  //         _pickedDate.day,
  //       ).dateTimeToDateString(),
  //     ),
  //     notes: Value(notes),
  //   );

  //   final db = ref.read(databaseProvider);
  //   late int eventId;
  //   if (!isEdit) {
  //     eventId = await db.eventsDao.insertEvent(event);
  //   } else {
  //     eventId = widget.initialData!.id;
  //     await db.eventsDao.updateEventFromCompanion(eventId, event);
  //   }

  //   final repotEvent = RepotEventsCompanion(
  //     eventId: Value(eventId),
  //     potSize: Value(potSize),
  //     soilType: Value(soilType),
  //   );

  //   if (!isEdit) {
  //     await db.eventsDao.insertRepotEvent(repotEvent);
  //   } else {
  //     await db.eventsDao.updateRepotEvent(eventId, repotEvent);
  //   }

  //   return true;
  // }

  @override
  Widget build(BuildContext context) {
    final accessoriesAsync = ref.watch(accessoriesNotifierProvider);
    return Scaffold(
      appBar: AppBar(title: const Text("Pesticide Event")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //
            accessoriesAsync.when(
              data: (accessories) {
                final pesticides =
                    accessories
                        .where((a) => a.type == EventType.pesticide.toString())
                        .toList();

                return Column(
                  spacing: 8,
                  children: [
                    ...pesticides.map((entry) {
                      final pesticide = entry;
                      bool isSelected = _addedPesticides.contains(pesticide.id);

                      return SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          icon: _removePesticide ? Icon(Icons.close) : null,
                          style: ElevatedButton.styleFrom(
                            foregroundColor:
                                (isSelected || _removePesticide)
                                    ? Colors.white
                                    : Theme.of(context).colorScheme.primary,
                            backgroundColor:
                                _removePesticide
                                    ? Theme.of(context).colorScheme.error
                                    : isSelected
                                    ? Theme.of(context).colorScheme.primary
                                    : null,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () {
                            if (!_removePesticide) {
                              setState(() {
                                if (isSelected) {
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
                          label: Text(pesticide.name),
                        ),
                      );
                    }),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextButton.icon(
                          icon: Icon(Icons.add),
                          style: TextButton.styleFrom(
                            foregroundColor:
                                Theme.of(context).colorScheme.primary,
                            backgroundColor: null,
                          ),
                          onPressed: () async {
                            final newId = await addAccessoryDialog(
                              context,
                              type: EventType.pesticide,
                              ref: ref,
                            );
                            if (newId != null) {
                              setState(() {
                                _addedPesticides.add(newId);
                                _removePesticide = false;
                              });
                            }
                          },
                          label: Text('Add new'),
                        ),
                        if (pesticides.isNotEmpty)
                          TextButton.icon(
                            icon:
                                (_removePesticide)
                                    ? Icon(Icons.done)
                                    : Icon(Icons.remove),
                            style: TextButton.styleFrom(
                              foregroundColor:
                                  Theme.of(context).colorScheme.primary,
                              backgroundColor: null,
                            ),
                            onPressed: () {
                              setState(() {
                                _removePesticide = !_removePesticide;
                              });
                            },
                            label: Text((_removePesticide) ? "done" : 'remove'),
                          ),
                      ],
                    ),
                  ],
                );
              },
              loading: () => Center(child: CircularProgressIndicator()),
              error: (e, st) {
                print(st);
                return Center(child: Text('Error: $e'));
              },
            ),
            //
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Date",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    setState(() {
                      _pickDate(context);
                    });
                  },
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
                children: [
                  TextFormField(
                    decoration: const InputDecoration(labelText: "Notes"),
                    controller: _notesController,
                  ),
                ],
              ),
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
                    await _submit();
                    if (context.mounted) {
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
}
