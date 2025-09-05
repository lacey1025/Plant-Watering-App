import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:plant_application/database/plant_app_db.dart';
import 'package:plant_application/models/accessory_data.dart';
import 'package:plant_application/models/enums/event_types_enum.dart';
import 'package:plant_application/models/fertilizer_data.dart';
import 'package:plant_application/models/pesticide_event_data.dart';
import 'package:plant_application/models/plant_card_data.dart';
import 'package:plant_application/models/repot_data.dart';
import 'package:plant_application/models/enums/timing_enum.dart';
import 'package:plant_application/models/water_event_data.dart';
import 'package:plant_application/notifier_providers/db_providers.dart';
import 'package:plant_application/screens/add_pesticide_event/add_pesticide_screen.dart';
import 'package:plant_application/screens/add_repot/add_repot_screen.dart';
import 'package:plant_application/screens/add_watering/add_watering_screen.dart';
import 'package:plant_application/screens/add_watering/watering_form_data.dart';
import 'package:plant_application/screens/view_plant/widgets/delete_dialog.dart';
import 'package:plant_application/theme.dart';
import 'package:plant_application/utils/adaptive_watering_schedule.dart';
import 'package:plant_application/utils/datetime_extensions.dart';

class EventSection<T> extends ConsumerStatefulWidget {
  const EventSection({
    super.key,
    required this.events,
    required this.plantId,
    required this.title,
    required this.eventType,
  });

  final List<dynamic> events;
  final int plantId;
  final String title;
  final EventType eventType;

  @override
  ConsumerState<EventSection<T>> createState() => _EventSectionState<T>();
}

class _EventSectionState<T> extends ConsumerState<EventSection<T>> {
  int? expandedEventId;

  void _editPesticideEvent(Event event, List<AccessoryData> accessories) {
    expandedEventId = null;
    final data = PesticideEventData(event: event, accessories: accessories);

    Navigator.of(context).push(
      MaterialPageRoute(
        builder:
            (_) =>
                AddPesticideScreen(plantId: widget.plantId, initialData: data),
      ),
    );
  }

  void _editWaterEvent(
    WaterEventData event,
    List<AccessoryData> accessories,
  ) async {
    final fertilizers =
        accessories.map((a) {
          if (a.type == EventType.fertilizer.toString()) {
            return FertilizerData(accessoryId: a.id, strength: a.strength ?? 1);
          }
        }).toSet();
    final waterId =
        accessories
            .where((a) => a.type == EventType.watering.toString())
            .firstOrNull
            ?.id;

    final form = WateringFormData(
      plantId: widget.plantId,
      waterTypeId: waterId,
      fertilizers: fertilizers.whereType<FertilizerData>().toSet(),
      date: event.date,
      timing: event.timingFeedback ?? Timing.justRight,
      daysToCorrect: event.offsetDays ?? 0,
      notes: event.notes ?? '',
      isEdit: true,
      eventId: event.id,
    );
    expandedEventId = null;
    Navigator.of(context).push(
      MaterialPageRoute(
        builder:
            (_) => AddWateringScreen(plantId: widget.plantId, editData: form),
      ),
    );
  }

  void _editRepotEvent(RepotData data) {
    expandedEventId = null;
    Navigator.of(context).push(
      MaterialPageRoute(
        builder:
            (_) => AddRepotScreen(plantId: widget.plantId, initialData: data),
      ),
    );
  }

  void _deleteEvent(int eventId, EventType type) async {
    final db = ref.read(databaseProvider);
    await db.transaction(() async {
      if (type == EventType.watering) {
        await db.eventsDao.deleteWaterEvents([eventId]);
      } else if (type == EventType.repot) {
        await db.eventsDao.deleteRepotEvents([eventId]);
      }
      await db.accessoriesDao.deleteEventAccessoriesByEvents([eventId]);
      await db.eventsDao.deleteEvent(eventId);
    });
    if (type == EventType.watering) {
      final plants = await ref.read(plantCardsProvider.future);
      final plant =
          plants.where((p) => p.plant.id == widget.plantId).firstOrNull;
      if (plant == null) return;
      await AdaptiveWateringSchedule.adjustPlantSchedule(eventId, plant, ref);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // header section
        Container(
          color: AppColors.secondaryGreen,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          alignment: Alignment.centerLeft,
          child: Text(
            widget.title,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(color: AppColors.darkTextGreen),
          ),
        ),
        if (widget.events.isNotEmpty) Divider(color: AppColors.primaryGreen),

        // events list
        Expanded(
          // height: 200,
          child:
              widget.events.isEmpty
                  ? Center(
                    child: Padding(
                      padding: EdgeInsets.all(32.0),
                      child: Text(
                        'No events',
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: AppColors.darkTextGreen,
                        ),
                      ),
                    ),
                  )
                  : ListView.builder(
                    itemCount: widget.events.length,
                    itemBuilder: (context, index) {
                      final event = widget.events[index];
                      final eventId =
                          (event != null && (event.id is int))
                              ? (event.id as int)
                              : index;
                      final date =
                          (event != null && event.date is DateTime)
                              ? (event.date as DateTime)
                              : (event.date is String)
                              ? (DateTimeHelpers.dateStringToDateTime(
                                event.date,
                              ))
                              : DateTime.now();
                      final daysBetween =
                          (event is WaterEventData || event is RepotData)
                              ? event.daysSinceLast
                              : null;
                      final isExpanded = eventId == expandedEventId;

                      return Container(
                        key: ValueKey('event-$eventId'),
                        color:
                            isExpanded
                                ? Color.fromRGBO(128, 176, 139, 1)
                                : AppColors.secondaryGreen,
                        child: Column(
                          children: [
                            ListTile(
                              title: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    date.formatDate(false),
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodyMedium?.copyWith(
                                      color:
                                          isExpanded
                                              ? AppColors.lightTextGreen
                                              : AppColors.darkTextGreen,
                                    ),
                                  ),
                                  (daysBetween != null)
                                      ? Text(
                                        date.daysBeforeString(daysBetween),
                                        style: GoogleFonts.inter(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color:
                                              isExpanded
                                                  ? AppColors.lightTextGreen
                                                  : AppColors.darkTextGreen,
                                        ),
                                      )
                                      : const Text(''),
                                  const SizedBox(width: 12),
                                ],
                              ),
                              trailing: IconButton(
                                icon: Icon(
                                  isExpanded
                                      ? Icons.expand_less
                                      : Icons.expand_more,
                                  color:
                                      isExpanded
                                          ? AppColors.lightTextGreen
                                          : AppColors.darkTextGreen,
                                ),
                                onPressed: () {
                                  setState(() {
                                    if (isExpanded) {
                                      expandedEventId = null;
                                    } else {
                                      expandedEventId = eventId;
                                    }
                                  });
                                },
                              ),
                            ),
                            if (isExpanded)
                              Container(
                                color: Color.fromRGBO(128, 176, 139, 1),
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Consumer(
                                            builder: (context, widgetRef, _) {
                                              final accessoriesAsync = widgetRef
                                                  .watch(
                                                    accessoriesForEventProvider(
                                                      eventId,
                                                    ),
                                                  );

                                              return accessoriesAsync.when(
                                                data: (accessories) {
                                                  return Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      // Content section with better spacing and organization
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets.symmetric(
                                                              horizontal: 8,
                                                            ),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            // Accessories section with better layout
                                                            if (accessories
                                                                .isNotEmpty)
                                                              ..._buildAccessoryWidgets(
                                                                accessories,
                                                                event
                                                                    .runtimeType,
                                                              ),

                                                            // Repot specific data with cards
                                                            if (event
                                                                is RepotData) ...[
                                                              const SizedBox(
                                                                height: 8,
                                                              ),
                                                              _buildInfoCard(
                                                                icon:
                                                                    Icons
                                                                        .local_florist,
                                                                label:
                                                                    "Pot Size",
                                                                value:
                                                                    event
                                                                        .potSize
                                                                        .toString(),
                                                              ),
                                                              const SizedBox(
                                                                height: 4,
                                                              ),
                                                              _buildInfoCard(
                                                                icon:
                                                                    Icons.grass,
                                                                label:
                                                                    "Soil Type",
                                                                value:
                                                                    event
                                                                        .soilType,
                                                              ),
                                                            ],

                                                            // Notes section with better styling
                                                            if (event != null &&
                                                                event.notes !=
                                                                    null &&
                                                                (event.notes
                                                                        as String)
                                                                    .isNotEmpty) ...[
                                                              const SizedBox(
                                                                height: 4,
                                                              ),
                                                              _buildInfoCard(
                                                                icon:
                                                                    Icons
                                                                        .note_alt,
                                                                label: "Notes",
                                                                value:
                                                                    event.notes,
                                                              ),
                                                              const SizedBox(
                                                                height: 4,
                                                              ),
                                                            ],
                                                          ],
                                                        ),
                                                      ),

                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceEvenly,
                                                        children: [
                                                          _buildActionButton(
                                                            icon:
                                                                Icons
                                                                    .edit_outlined,
                                                            label: "edit",
                                                            onPressed: () {
                                                              switch (widget
                                                                  .eventType) {
                                                                case EventType
                                                                    .watering:
                                                                  _editWaterEvent(
                                                                    event,
                                                                    accessories,
                                                                  );
                                                                  break;
                                                                case EventType
                                                                    .repot:
                                                                  _editRepotEvent(
                                                                    event,
                                                                  );
                                                                  break;
                                                                case EventType
                                                                    .pesticide:
                                                                  _editPesticideEvent(
                                                                    event,
                                                                    accessories,
                                                                  );
                                                                  break;
                                                                default:
                                                                  return;
                                                              }
                                                            },
                                                          ),
                                                          _buildActionButton(
                                                            icon:
                                                                Icons
                                                                    .delete_outline,
                                                            label: "delete",
                                                            onPressed: () async {
                                                              final confirmed =
                                                                  await showDialog<
                                                                    bool
                                                                  >(
                                                                    context:
                                                                        context,
                                                                    builder:
                                                                        (
                                                                          context,
                                                                        ) => DeleteDialog(
                                                                          itemName:
                                                                              "this event",
                                                                        ),
                                                                  );
                                                              if (confirmed ==
                                                                  true) {
                                                                _deleteEvent(
                                                                  eventId,
                                                                  widget
                                                                      .eventType,
                                                                );
                                                              }
                                                            },
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  );
                                                },
                                                loading:
                                                    () => Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                            16.0,
                                                          ),
                                                      child: Center(
                                                        child: SizedBox(
                                                          height: 20,
                                                          width: 20,
                                                          child: CircularProgressIndicator(
                                                            strokeWidth: 2,
                                                            color:
                                                                AppColors
                                                                    .lightTextGreen,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                error:
                                                    (e, st) => Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                            16.0,
                                                          ),
                                                      child: Text(
                                                        'Error loading accessories: $e',
                                                        style: TextStyle(
                                                          color:
                                                              AppColors
                                                                  .lightTextGreen,
                                                        ),
                                                      ),
                                                    ),
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            if (index != widget.events.length - 1)
                              Divider(color: AppColors.primaryGreen),
                          ],
                        ),
                      );
                    },
                  ),
        ),
        FilledButton.icon(
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.primaryYellow,
            minimumSize: const Size.fromHeight(16),
            padding: EdgeInsets.all(16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(8),
                bottomRight: Radius.circular(8),
                topLeft: Radius.zero,
                topRight: Radius.zero,
              ),
            ),
          ),
          icon: const Icon(Icons.add),
          label: Text(
            "add ${widget.eventType == EventType.watering
                ? 'watering'
                : widget.eventType == EventType.repot
                ? 'repot'
                : 'pesticide'} event",
          ),
          onPressed: () {
            setState(() {
              expandedEventId = null;
            });

            Widget Function(BuildContext) builder;
            switch (widget.eventType) {
              case EventType.watering:
                builder = (_) => AddWateringScreen(plantId: widget.plantId);
                break;
              case EventType.repot:
                builder = (_) => AddRepotScreen(plantId: widget.plantId);
                break;
              case EventType.pesticide:
                builder = (_) => AddPesticideScreen(plantId: widget.plantId);
                break;
              default:
                return;
            }

            Navigator.of(context).push(MaterialPageRoute(builder: builder));
          },
        ),
      ],
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.lightTextGreen.withAlpha(30),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: AppColors.lightTextGreen),
          const SizedBox(width: 8),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: AppColors.lightTextGreen,
                ),
                children: [
                  TextSpan(
                    text: "$label: ",
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  TextSpan(
                    text: value,
                    style: const TextStyle(fontWeight: FontWeight.w400),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: AppColors.lightTextGreen, size: 20),
            const SizedBox(height: 4),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: AppColors.lightTextGreen,
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildAccessoryWidgets(
    List<AccessoryData> accessories,
    Type eventType,
  ) {
    if (eventType == RepotData) {
      return [];
    }

    final List<AccessoryData> waterList =
        accessories
            .where((a) => a.type == EventType.watering.toString())
            .toList();
    final Iterable<AccessoryData> fertilizerList = accessories.where(
      (a) => a.type == EventType.fertilizer.toString(),
    );
    final Iterable<AccessoryData> pesticideList = accessories.where(
      (a) => a.type == EventType.pesticide.toString(),
    );

    final List<Widget> widgets = [];

    // Water type section
    if (waterList.isNotEmpty) {
      widgets.add(
        _buildInfoCard(
          icon: Icons.water_drop,
          label: "Water Type",
          value: waterList[0].name,
        ),
      );
    }

    // Fertilizers section
    if (fertilizerList.isNotEmpty) {
      widgets.add(const SizedBox(height: 4));
      widgets.add(
        _buildAccessorySection(
          icon: Icons.eco,
          title: "Fertilizers:",
          items:
              fertilizerList
                  .map(
                    (f) =>
                        '${f.name}${(f.strength != null) ? ' (${(f.strength! * 100).toInt()}%)' : ''}',
                  )
                  .toList(),
        ),
      );
    }

    // Pesticides section
    if (pesticideList.isNotEmpty) {
      widgets.add(const SizedBox(height: 8));
      widgets.add(
        _buildAccessorySection(
          icon: Icons.pest_control,
          title: "Pesticides",
          items: pesticideList.map((p) => p.name).toList(),
        ),
      );
    }

    return widgets;
  }

  Widget _buildAccessorySection({
    required IconData icon,
    required String title,
    required List<String> items,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.lightTextGreen.withAlpha(30),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: AppColors.lightTextGreen),
              const SizedBox(width: 6),
              Text(
                title,
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                  color: AppColors.lightTextGreen,
                ),
              ),
            ],
          ),
          ...items.map(
            (item) => Padding(
              padding: const EdgeInsets.only(left: 22, top: 2),
              child: Text(
                item,
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w400,
                  fontSize: 13,
                  color: AppColors.lightTextGreen,
                  height: 1.3,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
