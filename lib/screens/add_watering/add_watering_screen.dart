import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plant_application/database/plant_app_db.dart';
import 'package:plant_application/models/enums/event_types_enum.dart';
import 'package:plant_application/models/enums/timing_enum.dart';
import 'package:plant_application/notifier_providers/accessories_provider.dart';
import 'package:plant_application/screens/add_watering/watering_form_data.dart';
import 'package:plant_application/screens/add_watering/watering_form_notifier.dart';
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

class AddWateringScreen extends ConsumerStatefulWidget {
  const AddWateringScreen({super.key, required this.plantId, this.editData});

  final int plantId;
  final WateringFormData? editData;

  @override
  ConsumerState<AddWateringScreen> createState() => _AddWateringScreenState();
}

class _AddWateringScreenState extends ConsumerState<AddWateringScreen> {
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
  bool _isLoading = true;

  @override
  void dispose() {
    _potSizeController.dispose();
    _soilTypeController.dispose();
    _repotNotesController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    if (widget.editData != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final notifier = ref.read(
          wateringFormProvider(widget.plantId).notifier,
        );
        notifier.loadForEdit(widget.editData!);
        _isLoading = false;
      });
      _notesController.text = widget.editData?.notes ?? '';
    } else {
      _isLoading = false;
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

  @override
  Widget build(BuildContext context) {
    final provider = wateringFormProvider(widget.plantId);
    final form = ref.watch(provider);
    final notifier = ref.read(provider.notifier);
    final accessoriesAsync = ref.watch(accessoriesNotifierProvider);

    final waterRepotColors = SelectionColorScheme.pink;
    final fertColors = SelectionColorScheme.yellow;
    final timingColors = SelectionColorScheme.green;
    final dateColors = SelectionColorScheme.blue;

    return BackgroundScaffold(
      appBar: CustomAppBar(title: "watering event"),
      body:
          _isLoading
              ? SizedBox.shrink()
              : CustomScrollView(
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        FakeBlur(
                          overlay: waterRepotColors.secondaryColor.withAlpha(
                            200,
                          ),
                          borderRadius: BorderRadius.zero,
                          padding: EdgeInsets.fromLTRB(8, 8, 8, 0),
                          child: accessoriesAsync.when(
                            data: (accessories) {
                              final waterAccessories =
                                  accessories
                                      .where(
                                        (a) =>
                                            a.type ==
                                            EventType.watering.toString(),
                                      )
                                      .toList();

                              return SelectionSection<Accessory>(
                                title: "water type",
                                items: waterAccessories,
                                isSelected: (accessory) {
                                  if (form.waterTypeId == null) {
                                    final firstItem =
                                        waterAccessories.isNotEmpty
                                            ? waterAccessories.first
                                            : null;
                                    if (accessory.id == firstItem?.id) {
                                      selectedWaterId = accessory.id;
                                      return true;
                                    }
                                  }
                                  return form.waterTypeId == accessory.id;
                                },
                                onItemPressed: (accessory) {
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
                                        .read(
                                          accessoriesNotifierProvider.notifier,
                                        )
                                        .deleteAccessory(accessory.id);
                                  }
                                  if (waterAccessories.isEmpty) {
                                    _removeWaterTypes = false;
                                  }
                                },
                                getItemName: (accessory) => accessory.name,
                                colorScheme: waterRepotColors,
                                onAddNew: () async {
                                  final newId = await showAccessoryDialog(
                                    context,
                                    ref,
                                    null,
                                    EventType.watering,
                                  );
                                  if (newId != null) {
                                    notifier.updateWaterTypeId(newId);
                                    _validWaterType = true;
                                    _removeWaterTypes = false;
                                  }
                                },
                                onRemoveToggle:
                                    () => setState(
                                      () =>
                                          _removeWaterTypes =
                                              !_removeWaterTypes,
                                    ),
                                isRemoveMode: _removeWaterTypes,
                                canRemove: true,
                                errorMessage:
                                    !_validWaterType
                                        ? "please add a water type"
                                        : null,
                              );
                            },
                            loading:
                                () => Center(
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                      top: 8,
                                      bottom: 16,
                                    ),
                                    child: CircularProgressIndicator(
                                      color: waterRepotColors.primaryColor,
                                    ),
                                  ),
                                ),
                            error: (e, st) {
                              debugPrint(st.toString());
                              return Padding(
                                padding: EdgeInsets.only(bottom: 8),
                                child: Text('Error loading water types: $e'),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 8),

                        // Fertilizer section
                        FakeBlur(
                          overlay: fertColors.secondaryColor.withAlpha(200),
                          borderRadius: BorderRadius.zero,
                          padding: EdgeInsets.fromLTRB(8, 8, 8, 0),
                          child: accessoriesAsync.when(
                            data: (accessories) {
                              final fertilizerAccessories =
                                  accessories
                                      .where(
                                        (a) =>
                                            a.type ==
                                            EventType.fertilizer.toString(),
                                      )
                                      .toList();
                              return SelectionSection<Accessory>(
                                title: "fertilizers",
                                items: fertilizerAccessories,
                                isSelected:
                                    (fert) => form.fertilizers.any(
                                      (f) => f.accessoryId == fert.id,
                                    ),
                                onItemPressed: (fert) {
                                  if (!_removeFertTypes) {
                                    if (form.fertilizers.any(
                                      (f) => f.accessoryId == fert.id,
                                    )) {
                                      notifier.removeFertilizer(fert.id);
                                    } else {
                                      notifier.addFertilizer(fert.id, 1);
                                    }
                                  } else {
                                    notifier.removeFertilizer(fert.id);
                                    ref
                                        .read(
                                          accessoriesNotifierProvider.notifier,
                                        )
                                        .deleteAccessory(fert.id);

                                    if (fertilizerAccessories.length <= 1) {
                                      _removeFertTypes = false;
                                    }
                                  }
                                },
                                getItemName: (fert) => fert.name,
                                colorScheme: fertColors,
                                customItemBuilder: (
                                  fert,
                                  isSelected,
                                  isRemoveMode,
                                ) {
                                  return _buildFertilizerButton(
                                    fert,
                                    isSelected,
                                    interval,
                                    form,
                                    notifier,
                                    ref,
                                    fertilizerAccessories,
                                  );
                                },
                                onAddNew: () async {
                                  await showAccessoryDialog(
                                    context,
                                    ref,
                                    null,
                                    EventType.fertilizer,
                                  );
                                },
                                onRemoveToggle:
                                    () => setState(() {
                                      _removeFertTypes = !_removeFertTypes;
                                    }),
                                isRemoveMode: _removeFertTypes,
                                canRemove: true,
                                spacing: 2,
                              );
                            },
                            loading:
                                () => Center(
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                      top: 8,
                                      bottom: 16,
                                    ),
                                    child: CircularProgressIndicator(
                                      color: fertColors.primaryColor,
                                    ),
                                  ),
                                ),
                            error: (e, st) {
                              debugPrintStack();
                              return Padding(
                                padding: EdgeInsets.only(bottom: 8),
                                child: Text('Error loading pesticides: $e'),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 8),

                        // timing section
                        FakeBlur(
                          overlay: timingColors.secondaryColor.withAlpha(200),
                          borderRadius: BorderRadius.zero,
                          padding: EdgeInsets.all(8),
                          child: Column(
                            children: [
                              SelectionSection<Timing>(
                                title: "timing",
                                items: Timing.values,
                                isSelected: (timing) => form.timing == timing,
                                onItemPressed:
                                    (timing) => notifier.updateTiming(timing),
                                getItemName:
                                    (timing) => timing.toString().toLowerCase(),
                                colorScheme: timingColors,
                              ),
                              if (form.timing == Timing.early ||
                                  form.timing == Timing.late) ...[
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Text(
                                      "how many days off?",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: timingColors.textColor,
                                      ),
                                    ),
                                    Container(
                                      height: 40,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                        color: timingColors.primaryColor,
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          IconButton(
                                            icon: Icon(
                                              Icons.remove,
                                              size: 18,
                                              color:
                                                  timingColors
                                                      .selectedTextColor,
                                            ),
                                            onPressed: () {
                                              notifier.updateDaysToCorrect(
                                                (form.daysToCorrect - 1).clamp(
                                                  1,
                                                  14,
                                                ),
                                              );
                                            },
                                          ),
                                          Text(
                                            form.daysToCorrect.toString(),
                                            style: TextStyle(
                                              color:
                                                  timingColors
                                                      .selectedTextColor,
                                            ),
                                          ),
                                          IconButton(
                                            icon: Icon(
                                              Icons.add,
                                              size: 18,
                                              color:
                                                  timingColors
                                                      .selectedTextColor,
                                            ),
                                            onPressed: () {
                                              notifier.updateDaysToCorrect(
                                                (form.daysToCorrect + 1).clamp(
                                                  0,
                                                  14,
                                                ),
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ],
                          ),
                        ),

                        const SizedBox(height: 8),

                        FakeBlur(
                          overlay: dateColors.secondaryColor.withAlpha(200),
                          borderRadius: BorderRadius.zero,
                          padding: EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 12,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SectionTitleText(
                                "about",
                                color: dateColors.textColor,
                              ),
                              DateCard(
                                colors: dateColors,
                                titleText: "date",
                                onTap: () => _pickDate(context),
                                dateText:
                                    "${form.date.month}/${form.date.day}/${form.date.year}",
                              ),
                              // Row(
                              //   mainAxisAlignment:
                              //       MainAxisAlignment.spaceBetween,
                              //   children: [
                              //     SectionTitleText(
                              //       "date",
                              //       color: dateColors.textColor,
                              //     ),
                              //     SizedBox(width: 30),
                              //     ElevatedButton.icon(
                              //       onPressed: () => _pickDate(context),
                              //       icon: Icon(Icons.calendar_month),
                              //       label: Text(
                              //         "${form.date.month}/${form.date.day}/${form.date.year}",
                              //       ),
                              //     ),
                              //   ],
                              // ),
                              ThemedTextFormField(
                                controller: _notesController,
                                label: "notes",
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 8),

                        if (!form.isEdit)
                          FakeBlur(
                            overlay: waterRepotColors.secondaryColor.withAlpha(
                              200,
                            ),
                            borderRadius: BorderRadius.zero,
                            padding: EdgeInsets.all(8),
                            child: Column(
                              spacing: 4,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SectionTitleText(
                                      "did you repot?",
                                      color: waterRepotColors.textColor,
                                    ),

                                    Switch(
                                      activeColor:
                                          waterRepotColors.primaryColor,
                                      inactiveTrackColor:
                                          waterRepotColors.secondaryColor,
                                      inactiveThumbColor: Color.fromRGBO(
                                        168,
                                        122,
                                        149,
                                        1,
                                      ),
                                      trackOutlineColor:
                                          WidgetStateProperty.all(
                                            Color.fromRGBO(168, 122, 149, 1),
                                          ),
                                      value: form.isRepot,
                                      onChanged: (val) {
                                        notifier.updateIsRepot(val);
                                        _repotNotesController.clear();
                                        _potSizeController.clear();
                                        _soilTypeController.clear();
                                      },
                                    ),
                                  ],
                                ),
                                if (form.isRepot) ...[
                                  const SizedBox(height: 10),
                                  Form(
                                    key: _formKey,
                                    child: ThemedTextFormField(
                                      controller: _potSizeController,
                                      label: "pot size",
                                      colorScheme: SelectionColorScheme.pink,
                                      keyboardType: TextInputType.number,
                                      validator: (value) {
                                        if (form.isRepot) {
                                          if (value == null || value.isEmpty) {
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
                                  ThemedTextFormField(
                                    controller: _soilTypeController,
                                    label: "soil type",
                                    colorScheme: SelectionColorScheme.pink,
                                  ),
                                  ThemedTextFormField(
                                    controller: _repotNotesController,
                                    label: "notes",
                                    colorScheme: SelectionColorScheme.pink,
                                  ),

                                  SizedBox(height: 4),
                                ],
                              ],
                            ),
                          ),
                      ]),
                    ),
                  ),
                  StickyBottomButtons(
                    isHorizontal: true,
                    onSubmit: () async {
                      if (form.isRepot) {
                        final validate = _formKey.currentState?.validate();
                        if (validate == null || validate == false) {
                          return;
                        }
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
                    onCancel: () {
                      Navigator.pop(context);
                    },
                  ),
                  // SliverFillRemaining(
                  //   hasScrollBody: false,
                  //   child: Column(
                  //     children: [
                  //       Spacer(),
                  //       Row(
                  //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  //         children: [
                  //           SizedBox(width: 8),
                  //           Expanded(
                  //             child: FilledButton(
                  //               style: FilledButton.styleFrom(
                  //                 backgroundColor: dateColors.secondaryColor,
                  //                 foregroundColor: dateColors.primaryColor,
                  //               ),
                  //               onPressed: () {
                  //                 Navigator.pop(context);
                  //               },
                  //               child: const Text("cancel"),
                  //             ),
                  //           ),
                  //           SizedBox(width: 8),
                  //           Expanded(
                  //             child: FilledButton(
                  //               child: const Text("submit"),
                  //               onPressed: () async {
                  //                 if (form.isRepot) {
                  //                   final validate =
                  //                       _formKey.currentState?.validate();
                  //                   if (validate == null || validate == false) {
                  //                     return;
                  //                   }
                  //                 }
                  //                 if (form.waterTypeId == null) {
                  //                   if (selectedWaterId != null) {
                  //                     notifier.updateWaterTypeId(
                  //                       selectedWaterId!,
                  //                     );
                  //                   } else {
                  //                     setState(() {
                  //                       _validWaterType = false;
                  //                     });
                  //                     return;
                  //                   }
                  //                 }
                  //                 notifier.updateNotes(_notesController.text);
                  //                 if (form.isRepot) {
                  //                   notifier.updatePotSize(
                  //                     double.tryParse(_potSizeController.text)!,
                  //                   );
                  //                   notifier.updateSoilType(
                  //                     _soilTypeController.text,
                  //                   );
                  //                   notifier.updateRepotNotes(
                  //                     _repotNotesController.text,
                  //                   );
                  //                 }

                  //                 await notifier.submitForm();

                  //                 if (context.mounted) {
                  //                   Navigator.pop(context);
                  //                 }
                  //               },
                  //             ),
                  //           ),
                  //           SizedBox(width: 8),
                  //         ],
                  //       ),
                  //       SizedBox(height: 8),
                  //     ],
                  //   ),
                  // ),
                ],
              ),
    );
  }

  String _strengthLabel(double strength) {
    // Convert decimal to fraction string
    if (strength == 2) return "200%";
    if (strength == 1.75) return "175%";
    if (strength == 1.5) return "150%";
    if (strength == 1.25) return "125%";
    if (strength == 1) return "100%";
    if (strength == .75) return "75%";
    if (strength == 0.5) return "50%";
    if (strength == 0.25) return "25%";
    return strength.toStringAsFixed(2);
  }

  // Inside the same class

  Widget _buildFertilizerButton(
    Accessory fert,
    bool isSelected,
    double interval,
    WateringFormData form,
    WateringFormNotifier notifier,
    WidgetRef ref,
    List<Accessory> fertilizerAccessories,
  ) {
    return ElevatedButton.icon(
      icon: _removeFertTypes ? const Icon(Icons.close) : null,
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(
          horizontal: 16,
          vertical: isSelected ? 0 : 14,
        ),
        foregroundColor:
            (isSelected || _removeFertTypes)
                ? AppColors.lightTextYellow
                : AppColors.darkTextYellow,
        backgroundColor:
            _removeFertTypes
                ? AppColors.error
                : isSelected
                ? AppColors.primaryYellow
                : AppColors.secondaryYellow,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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

          if (fertilizerAccessories.length <= 1) {
            _removeFertTypes =
                false; // toggle remove mode off if last one removed
          }
        }
      },
      label: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(fert.name),
          if (isSelected && !_removeFertTypes)
            _buildStrengthAdjuster(fert, interval, form, notifier),
        ],
      ),
    );
  }

  Widget _buildStrengthAdjuster(
    Accessory fert,
    double interval,
    WateringFormData form,
    WateringFormNotifier notifier,
  ) {
    final strength =
        form.fertilizers.firstWhere((f) => f.accessoryId == fert.id).strength;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 24,
          height: 46,
          child: IconButton(
            style: IconButton.styleFrom(splashFactory: NoSplash.splashFactory),
            padding: EdgeInsets.zero,
            iconSize: 22,
            onPressed: () {
              final newStrength = (strength - interval).clamp(0.25, 2.0);
              notifier.updateFertilizerStrength(fert.id, newStrength);
            },
            icon: const Icon(Icons.remove, color: Colors.white),
          ),
        ),
        SizedBox(
          width: 50,
          child: Text(
            _strengthLabel(strength),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.lightTextYellow,
            ),
          ),
        ),
        SizedBox(
          width: 24,
          height: 46,
          child: IconButton(
            style: IconButton.styleFrom(splashFactory: NoSplash.splashFactory),
            padding: EdgeInsets.zero,
            iconSize: 22,
            onPressed: () {
              final newStrength = (strength + interval).clamp(0.0, 2.0);
              notifier.updateFertilizerStrength(fert.id, newStrength);
            },
            icon: const Icon(Icons.add, color: Colors.white),
          ),
        ),
      ],
    );
  }
}
