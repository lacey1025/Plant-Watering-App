import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plant_application/models/event_types_enum.dart';
import 'package:plant_application/models/timing_enum.dart';
import 'package:plant_application/providers/accessories_provider.dart';
import 'package:plant_application/screens/add_watering/add_accessory_dialog.dart';
import 'package:plant_application/screens/add_watering/watering_form_data.dart';
import 'package:plant_application/screens/add_watering/watering_form_notifier.dart';

class AddWateringScreen extends ConsumerStatefulWidget {
  const AddWateringScreen({super.key, required this.plantId, this.editData});

  final int plantId;
  final WateringFormData? editData;

  @override
  ConsumerState<AddWateringScreen> createState() => _AddWateringScreenState();
}

class _AddWateringScreenState extends ConsumerState<AddWateringScreen> {
  @override
  void initState() {
    super.initState();
    if (widget.editData != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final notifier = ref.read(
          wateringFormProvider(widget.plantId).notifier,
        );
        notifier.loadForEdit(widget.editData!);
      });
    }
  }

  Future<void> _pickDate(BuildContext context) async {
    final provider = wateringFormProvider(widget.plantId);
    final form = ref.watch(provider);
    final notifier = ref.read(provider.notifier);
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: form.date,
      firstDate: DateTime(2025),
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != form.date) {
      notifier.updateDate(picked);
    }
  }

  double interval = 0.25;
  int? selectedWaterId;
  final _potSizeController = TextEditingController();
  final _soilTypeController = TextEditingController();
  final _repotNotesController = TextEditingController();
  final _notesController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _removeWaterTypes = false;
  bool _removeFertTypes = false;
  bool _validWaterType = true;

  @override
  Widget build(BuildContext context) {
    final provider = wateringFormProvider(widget.plantId);
    final form = ref.watch(provider);
    final notifier = ref.read(provider.notifier);
    final accessoriesAsync = ref.watch(accessoriesNotifierProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("Watering Event")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                    "${form.date.month}/${form.date.day}/${form.date.year}",
                  ),
                ),
              ],
            ),
            // Water type section
            const Text(
              "Water Type",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            accessoriesAsync.when(
              data: (accessories) {
                final waterAccessories =
                    accessories.where((a) => a.type == 'watering').toList();

                return Column(
                  spacing: 8,
                  children: [
                    ...waterAccessories.asMap().entries.map((entry) {
                      final index = entry.key;
                      final accessory = entry.value;
                      bool isSelected;
                      if (form.waterTypeId == null && index == 0) {
                        isSelected = true;
                        selectedWaterId = accessory.id;
                      } else {
                        isSelected = form.waterTypeId == accessory.id;
                      }

                      return SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          icon: _removeWaterTypes ? Icon(Icons.close) : null,
                          style: ElevatedButton.styleFrom(
                            foregroundColor:
                                (isSelected || _removeWaterTypes)
                                    ? Colors.white
                                    : Theme.of(context).colorScheme.primary,
                            backgroundColor:
                                _removeWaterTypes
                                    ? Theme.of(context).colorScheme.error
                                    : isSelected
                                    ? Theme.of(context).colorScheme.primary
                                    : null,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () {
                            if (!_removeWaterTypes) {
                              selectedWaterId = accessory.id;
                              notifier.updateWaterTypeId(accessory.id);
                              if (!_validWaterType) {
                                _validWaterType = true;
                              }
                            } else {
                              selectedWaterId = null;
                              notifier.removeWaterType(accessory.id);
                              ref
                                  .read(accessoriesNotifierProvider.notifier)
                                  .deleteAccessory(accessory.id);
                            }
                          },
                          label: Text(accessory.name),
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
                            final newId = await addWaterTypeDialog(
                              context,
                              type: EventType.watering,
                              ref: ref,
                            );
                            if (newId != null) {
                              notifier.updateWaterTypeId(newId);
                              _validWaterType = true;
                              _removeWaterTypes = false;
                            }
                          },
                          label: Text('Add new'),
                        ),
                        if (waterAccessories.isNotEmpty)
                          TextButton.icon(
                            icon:
                                (_removeWaterTypes)
                                    ? Icon(Icons.done)
                                    : Icon(Icons.remove),
                            style: TextButton.styleFrom(
                              foregroundColor:
                                  Theme.of(context).colorScheme.primary,
                              backgroundColor: null,
                            ),
                            onPressed: () {
                              setState(() {
                                _removeWaterTypes = !_removeWaterTypes;
                              });
                            },
                            label: Text(
                              (_removeWaterTypes) ? "done" : 'remove',
                            ),
                          ),
                      ],
                    ),
                    if (!_validWaterType)
                      Text(
                        "please add a water type",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                        ),
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

            const SizedBox(height: 20),

            // Fertilizer section
            const Text(
              "Fertilizer",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            accessoriesAsync.when(
              data: (accessories) {
                final fertilizerAccessories =
                    accessories.where((a) => a.type == 'fertilizer').toList();

                return Column(
                  children: [
                    ...fertilizerAccessories.map((fert) {
                      final isSelected = form.fertilizers.any(
                        (f) => f.accessoryId == fert.id,
                      );
                      return ElevatedButton.icon(
                        icon: _removeFertTypes ? Icon(Icons.close) : null,
                        style: ElevatedButton.styleFrom(
                          foregroundColor:
                              (isSelected || _removeFertTypes)
                                  ? Colors.white
                                  : Theme.of(context).colorScheme.primary,
                          backgroundColor:
                              _removeFertTypes
                                  ? Theme.of(context).colorScheme.error
                                  : isSelected
                                  ? Theme.of(context).colorScheme.primary
                                  : null,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () {
                          if (!_removeFertTypes) {
                            if (isSelected) {
                              notifier.removeFertilizer(fert.id);
                            } else {
                              notifier.addFertilizer(fert.id, 1);
                            }
                          } else {
                            notifier.removeFertilizer(fert.id);
                            ref
                                .read(accessoriesNotifierProvider.notifier)
                                .deleteAccessory(fert.id);
                          }
                        },
                        label: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(fert.name),
                            if (isSelected && !_removeFertTypes)
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.remove, size: 18),
                                    onPressed: () {
                                      final oldStrength =
                                          form.fertilizers
                                              .firstWhere(
                                                (f) => f.accessoryId == fert.id,
                                              )
                                              .strength;
                                      final strength = (oldStrength - interval)
                                          .clamp(0.25, 2.0);
                                      notifier.updateFertilizerStrength(
                                        fert.id,
                                        strength,
                                      );
                                    },
                                  ),
                                  Text(
                                    _strengthLabel(
                                      form.fertilizers
                                          .firstWhere(
                                            (f) => f.accessoryId == fert.id,
                                          )
                                          .strength,
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.add, size: 18),
                                    onPressed: () {
                                      final oldStrength =
                                          form.fertilizers
                                              .firstWhere(
                                                (f) => f.accessoryId == fert.id,
                                              )
                                              .strength;
                                      final strength = (oldStrength + interval)
                                          .clamp(0.0, 2.0);
                                      notifier.updateFertilizerStrength(
                                        fert.id,
                                        strength,
                                      );
                                    },
                                  ),
                                ],
                              ),
                          ],
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
                            await addWaterTypeDialog(
                              context,
                              type: EventType.fertilizer,
                              ref: ref,
                            );
                          },
                          label: Text('Add new'),
                        ),

                        if (fertilizerAccessories.isNotEmpty)
                          TextButton.icon(
                            icon:
                                (_removeFertTypes)
                                    ? Icon(Icons.done)
                                    : Icon(Icons.remove),
                            style: TextButton.styleFrom(
                              foregroundColor:
                                  Theme.of(context).colorScheme.primary,
                              backgroundColor: null,
                            ),
                            onPressed: () {
                              setState(() {
                                _removeFertTypes = !_removeFertTypes;
                              });
                            },
                            label: Text((_removeFertTypes) ? "done" : 'remove'),
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
            const SizedBox(height: 20),

            // Timing section
            const Text(
              "Timing",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Wrap(
              spacing: 8,
              children:
                  Timing.values.map((t) {
                    final isSelected = form.timing == t;
                    return SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor:
                              isSelected
                                  ? Colors.white
                                  : Theme.of(context).colorScheme.primary,
                          backgroundColor:
                              isSelected
                                  ? Theme.of(context).colorScheme.primary
                                  : null,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              8,
                            ), // rounded corners
                          ),
                        ),
                        onPressed: () {
                          notifier.updateTiming(t);
                        },
                        child: Text(t.toString()),
                      ),
                    );
                  }).toList(),
            ),
            if (form.timing == Timing.early || form.timing == Timing.late) ...[
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "How many days off?",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: 20),
                  Container(
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(
                        color: Theme.of(context).primaryColor,
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.remove, size: 18),
                          onPressed: () {
                            notifier.updateDaysToCorrect(
                              (form.daysToCorrect - 1).clamp(0, 14),
                            );
                          },
                        ),
                        Text(form.daysToCorrect.toString()),
                        IconButton(
                          icon: Icon(Icons.add, size: 18),
                          onPressed: () {
                            notifier.updateDaysToCorrect(
                              (form.daysToCorrect + 1).clamp(0, 14),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 20),
            TextFormField(
              decoration: const InputDecoration(labelText: "Notes"),
              controller: _notesController,
            ),
            const SizedBox(height: 20),
            // Repot switch
            if (!form.isEdit) ...[
              SwitchListTile(
                title: const Text(
                  "Did you repot?",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                value: form.isRepot,
                onChanged: (val) {
                  notifier.updateIsRepot(val);
                  _repotNotesController.clear();
                  _potSizeController.clear();
                  _soilTypeController.clear();
                },
              ),
              if (form.isRepot) ...[
                const SizedBox(height: 10),
                Form(
                  key: _formKey,
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: "Pot Size (cm)",
                    ),
                    keyboardType: TextInputType.number,
                    controller: _potSizeController,
                    validator: (value) {
                      if (form.isRepot) {
                        if (value == null) {
                          return 'Please enter a pot size';
                        }
                        final potSize = double.tryParse(
                          _potSizeController.text,
                        );
                        if (potSize == null) {
                          return 'Please ensure pot size is a number';
                        }
                      }
                      return null;
                    },
                  ),
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: "Soil Type"),
                  controller: _soilTypeController,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: "Notes"),
                  controller: _repotNotesController,
                ),
              ],
            ],

            const SizedBox(height: 30),

            // Submit & Cancel buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  icon: const Icon(Icons.check),
                  label: const Text("Submit"),
                  onPressed: () async {
                    if (form.isRepot) {
                      final validate = _formKey.currentState?.validate();
                      if (validate == null || validate == false) return;
                    }
                    if (form.waterTypeId == null) {
                      if (selectedWaterId != null) {
                        notifier.updateWaterTypeId(selectedWaterId!);
                      } else {
                        setState(() {
                          _validWaterType = false;
                        });
                        return;
                      }
                    }
                    notifier.updateNotes(_notesController.text);
                    if (form.isRepot) {
                      notifier.updatePotSize(
                        double.tryParse(_potSizeController.text)!,
                      );
                      notifier.updateSoilType(_soilTypeController.text);
                      notifier.updateRepotNotes(_repotNotesController.text);
                    }

                    await notifier.submitForm();

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

  String _strengthLabel(double strength) {
    // Convert decimal to fraction string
    if (strength == 2) return "2";
    if (strength == 1.75) return "1 3/4";
    if (strength == 1.5) return "1 1/2";
    if (strength == 1.25) return "1 1/4";
    if (strength == 1) return "1";
    if (strength == .75) return "3/4";
    if (strength == 0.5) return "1/2";
    if (strength == 0.25) return "1/4";
    return strength.toStringAsFixed(2);
  }
}
