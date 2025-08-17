import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plant_application/models/accessory_data.dart';
import 'package:plant_application/models/fertilizer_data.dart';
import 'package:plant_application/models/repot_data.dart';
import 'package:plant_application/models/timing_enum.dart';
import 'package:plant_application/models/water_event_data.dart';
import 'package:plant_application/providers/db_provider.dart';
import 'package:plant_application/providers/home_screen_providers.dart';
import 'package:plant_application/screens/add_watering/add_watering_screen.dart';
import 'package:plant_application/screens/add_watering/watering_form_data.dart';
import 'package:plant_application/utils/adaptive_watering_schedule.dart';

class EventSection<T> extends ConsumerStatefulWidget {
  const EventSection({
    super.key,
    required this.events,
    required this.formatDate,
    required this.plantId,
    required this.title,
  });

  final List<dynamic> events;
  final String Function(DateTime) formatDate;
  final int plantId;
  final String title;

  @override
  ConsumerState<EventSection<T>> createState() => _EventSectionState<T>();
}

class _EventSectionState<T> extends ConsumerState<EventSection<T>> {
  final Set<int> expandedEventIds = {};

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();

  //   // Clear expanded items when returning to this route
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     final route = ModalRoute.of(context);
  //     if (route != null && route.isCurrent) {
  //       setState(() {
  //         expandedEventIds.clear();
  //       });
  //     }
  //   });
  // }

  void _editEvent(WaterEventData event, List<AccessoryData> accessories) async {
    final fertilizers =
        accessories.map((a) {
          if (a.type == 'fertilizer') {
            return FertilizerData(accessoryId: a.id, strength: a.strength ?? 1);
          }
        }).toSet();
    final waterId =
        accessories.where((a) => a.type == "watering").firstOrNull?.id;

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
    expandedEventIds.clear();
    Navigator.of(context).push(
      MaterialPageRoute(
        builder:
            (_) => AddWateringScreen(plantId: widget.plantId, editData: form),
      ),
    );
  }

  void _deleteEvent(int eventId) async {
    final db = ref.read(databaseProvider);
    await db.eventsDao.deleteWaterEvents([eventId]);
    await db.eventsDao.deleteEvent(eventId);
    final plants = await ref.read(plantCardsProvider.future);
    final plant = plants.where((p) => p.plant.id == widget.plantId).firstOrNull;
    if (plant == null) return;
    await AdaptiveWateringSchedule.adjustPlantSchedule(eventId, plant, ref);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Fixed title header that doesn't scroll
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(widget.title, style: Theme.of(context).textTheme.titleLarge),
            ],
          ),
        ),

        // Scrollable list content
        SizedBox(
          height: 200,
          child:
              widget.events.isEmpty
                  ? const Center(
                    child: Padding(
                      padding: EdgeInsets.all(32.0),
                      child: Text('No events'),
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
                              : DateTime.now();
                      final daysBetween =
                          (event is WaterEventData || event is RepotData)
                              ? event.daysSinceLast
                              : null;
                      final isExpanded = expandedEventIds.contains(eventId);

                      return Container(
                        key: ValueKey('event-$eventId'),
                        child: Column(
                          children: [
                            ListTile(
                              title: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(widget.formatDate(date)),
                                  (daysBetween != null)
                                      ? Text('$daysBetween days')
                                      : const Text(''),
                                  const SizedBox(width: 12),
                                ],
                              ),
                              trailing: IconButton(
                                icon: Icon(
                                  isExpanded
                                      ? Icons.expand_less
                                      : Icons.expand_more,
                                ),
                                onPressed: () {
                                  setState(() {
                                    if (isExpanded) {
                                      expandedEventIds.remove(eventId);
                                    } else {
                                      expandedEventIds.add(eventId);
                                    }
                                  });
                                },
                              ),
                            ),
                            if (isExpanded)
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // const Text(
                                    //   'Accessories:',
                                    //   style: TextStyle(
                                    //     fontWeight: FontWeight.bold,
                                    //   ),
                                    // ),
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
                                            // if (accessories.isEmpty) {
                                            //   return const Text(
                                            //     'No accessories',
                                            //   );
                                            // }
                                            return Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                if (accessories.isNotEmpty) ...[
                                                  ..._buildAccessoryWidgets(
                                                    accessories,
                                                    event.runtimeType,
                                                  ),
                                                  if (event is RepotData) ...[
                                                    Text(
                                                      "Pot size: ${event.potSize}",
                                                    ),
                                                    Text(
                                                      "Soil Type: ${event.soilType}",
                                                    ),
                                                  ],
                                                  if (event != null &&
                                                      event.notes != null &&
                                                      (event.notes as String)
                                                          .isNotEmpty)
                                                    Text(
                                                      "notes: ${event.notes}",
                                                    ),
                                                ],
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  children: [
                                                    IconButton(
                                                      onPressed: () {
                                                        _editEvent(
                                                          event,
                                                          accessories,
                                                        );
                                                      },
                                                      icon: Icon(Icons.edit),
                                                    ),
                                                    IconButton(
                                                      onPressed: () {
                                                        _deleteEventDialog(
                                                          onDelete: () async {
                                                            _deleteEvent(
                                                              eventId,
                                                            );
                                                          },
                                                        );
                                                      },
                                                      icon: Icon(Icons.delete),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            );
                                          },
                                          loading:
                                              () => const Padding(
                                                padding: EdgeInsets.all(8.0),
                                                child: SizedBox(
                                                  height: 20,
                                                  width: 20,
                                                  child:
                                                      CircularProgressIndicator(
                                                        strokeWidth: 2,
                                                      ),
                                                ),
                                              ),
                                          error:
                                              (e, st) => Text(
                                                'Error loading accessories: $e',
                                              ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            const Divider(height: 1),
                          ],
                        ),
                      );
                    },
                  ),
        ),
        TextButton.icon(
          icon: const Icon(Icons.add),
          label: Text("Add Event"),
          onPressed: () {
            if (widget.title == "Watering History") {
              setState(() {
                expandedEventIds.clear();
              });
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => AddWateringScreen(plantId: widget.plantId),
                ),
              );
            }
          },
        ),
      ],
    );
  }

  List<Widget> _buildAccessoryWidgets(
    List<AccessoryData> accessories,
    Type eventType,
  ) {
    // Repot events → no accessories shown at all
    if (eventType == RepotData) {
      return [SizedBox.shrink()];
    }

    final List<AccessoryData> waterList =
        accessories.where((a) => a.type == 'watering').toList();

    final Iterable<AccessoryData> fertilizerList = accessories.where(
      (a) => a.type == 'fertilizer',
    );
    final Iterable<AccessoryData> pesticideList = accessories.where(
      (a) => a.type == 'pesticide',
    );
    final List<Widget> list = [];
    if (waterList.isNotEmpty) {
      list.add(
        Row(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [Text("Water Type: "), Text(waterList[0].name)],
        ),
      );
      // list.addAll(waterList.map((w) => Text(w.name)));
    }
    if (fertilizerList.isNotEmpty) {
      list.add(Text("Fertilizers: "));
      list.addAll(
        fertilizerList.map(
          (f) => Text(
            '${f.name}${(f.strength != null) ? ' (${f.strength}%)' : ''}',
          ),
        ),
      );
    }
    if (pesticideList.isNotEmpty) {
      list.add(Text("Pesticides: "));
      list.addAll(pesticideList.map((p) => Text(p.name)));
    }
    return list;
  }

  Future<void> _deleteEventDialog({required void Function() onDelete}) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Confirm Delete'),
            content: const Text('Are you sure you want to delete this event?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(true),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text('Delete'),
              ),
            ],
          ),
    );
    if (confirmed == true) {
      onDelete();
    }
  }
}
