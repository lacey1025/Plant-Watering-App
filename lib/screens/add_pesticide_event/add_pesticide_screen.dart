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
import 'package:plant_application/screens/shared/fake_blur.dart';
import 'package:plant_application/screens/shared/text_form_field.dart';
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
  final GlobalKey _bottomNavKey = GlobalKey();
  double _bottomNavHeight = 0;
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
    _getBottomNavHeight();
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

  void _getBottomNavHeight() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final RenderBox? renderBox =
          _bottomNavKey.currentContext?.findRenderObject() as RenderBox?;
      if (renderBox != null) {
        setState(() {
          _bottomNavHeight = renderBox.size.height;
        });
      }
    });
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

  @override
  Widget build(BuildContext context) {
    final accessoriesAsync = ref.watch(accessoriesNotifierProvider);
    return BackgroundScaffold(
      appBar: CustomAppBar(title: "pesticide event"),
      bottomNavigatorBar: SafeArea(
        key: _bottomNavKey,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  child: const Text("submit"),
                  onPressed: () async {
                    await _submit();
                    if (context.mounted) Navigator.pop(context);
                  },
                ),
              ),
              const SizedBox(height: 4),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.secondaryBlue,
                    foregroundColor: AppColors.darkTextBlue,
                  ),
                  child: const Text("cancel"),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          children: [
            FakeBlur(
              borderRadius: BorderRadius.zero,
              overlay: AppColors.secondaryBlue.withAlpha(200),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //
                    accessoriesAsync.when(
                      data: (accessories) {
                        final pesticides =
                            accessories
                                .where(
                                  (a) =>
                                      a.type == EventType.pesticide.toString(),
                                )
                                .toList();

                        return Column(
                          spacing: 4,
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "pesticides",
                                style: Theme.of(
                                  context,
                                ).textTheme.titleMedium?.copyWith(
                                  color: AppColors.darkTextBlue,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                            ...pesticides.map((entry) {
                              final pesticide = entry;
                              bool isSelected = _addedPesticides.contains(
                                pesticide.id,
                              );

                              return SizedBox(
                                width: double.infinity,
                                child: ElevatedButton.icon(
                                  icon:
                                      _removePesticide
                                          ? Icon(Icons.close)
                                          : null,
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor:
                                        (isSelected || _removePesticide)
                                            ? AppColors.lightTextBlue
                                            : AppColors.darkTextBlue,
                                    backgroundColor:
                                        _removePesticide
                                            ? Theme.of(
                                              context,
                                            ).colorScheme.error
                                            : isSelected
                                            ? AppColors.primaryBlue
                                            : AppColors.secondaryBlue,
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
                                          .read(
                                            accessoriesNotifierProvider
                                                .notifier,
                                          )
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
                                if (!_removePesticide)
                                  TextButton.icon(
                                    icon: Icon(Icons.add),
                                    style: TextButton.styleFrom(
                                      foregroundColor: AppColors.darkTextBlue,
                                      backgroundColor: null,
                                    ),
                                    onPressed: () async {
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
                                    label: Text('add new'),
                                  ),
                                if (pesticides.isNotEmpty)
                                  TextButton.icon(
                                    icon:
                                        (_removePesticide)
                                            ? Icon(Icons.done)
                                            : Icon(Icons.remove),
                                    style: TextButton.styleFrom(
                                      foregroundColor: AppColors.darkTextBlue,
                                      backgroundColor: null,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _removePesticide = !_removePesticide;
                                      });
                                    },
                                    label: Text(
                                      (_removePesticide) ? "done" : 'remove',
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        );
                      },
                      loading: () => Center(child: CircularProgressIndicator()),
                      error: (e, st) {
                        debugPrintStack();
                        return Center(child: Text('Error: $e'));
                      },
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 4),
            FakeBlur(
              borderRadius: BorderRadius.zero,
              overlay: AppColors.secondaryBlue.withAlpha(200),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "date",
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppColors.darkTextBlue,
                        fontSize: 20,
                      ),
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
              ),
            ),
            SizedBox(height: 4),
            FakeBlur(
              borderRadius: BorderRadius.zero,
              overlay: AppColors.secondaryBlue.withAlpha(200),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "notes",
                            style: Theme.of(
                              context,
                            ).textTheme.titleMedium?.copyWith(
                              color: AppColors.darkTextBlue,
                              fontSize: 20,
                            ),
                          ),
                          ThemedTextFormField(
                            controller: _notesController,
                            hint: "about this event",
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

            SizedBox(height: _bottomNavHeight),
          ],
        ),
      ),
    );
  }
}
