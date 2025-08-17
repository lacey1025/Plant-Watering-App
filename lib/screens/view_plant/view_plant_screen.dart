import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plant_application/database/plant_app_db.dart';
import 'package:plant_application/models/event_types_enum.dart';
import 'package:plant_application/models/repot_data.dart';
import 'package:plant_application/models/water_event_data.dart';
import 'package:plant_application/providers/home_screen_providers.dart';
import 'package:plant_application/providers/plant_provider.dart';
import 'package:plant_application/screens/add_plant/add_plant_screen.dart';
import 'package:plant_application/screens/add_plant/plant_form_data.dart';
import 'package:plant_application/screens/home/home_screen.dart';
import 'package:plant_application/screens/view_plant/banner_widget.dart';
import 'package:plant_application/screens/view_plant/event_section_widget.dart';
import 'package:plant_application/screens/view_plant/photo_reminder_banner.dart';
import 'package:plant_application/screens/view_plant/plant_app_bar.dart';
import 'package:plant_application/utils/datetime_extensions.dart';

class ViewPlant extends ConsumerStatefulWidget {
  final int plantId;
  const ViewPlant({super.key, required this.plantId});

  @override
  ConsumerState<ViewPlant> createState() => _ViewPlantState();
}

class _ViewPlantState extends ConsumerState<ViewPlant>
    with TickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  String formatDate(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final plantAsync = ref.watch(plantNotifierProvider(widget.plantId));
    final plantNotifier = ref.read(
      plantNotifierProvider(widget.plantId).notifier,
    );
    final wateringAsync = ref.watch(
      wateringEventsForPlantProvider(widget.plantId),
    );
    final repotAsync = ref.watch(repotEventsForPlantProvider(widget.plantId));
    final pesticideAsync = ref.watch(
      pesticideEventsForPlantProvider(widget.plantId),
    );

    return Scaffold(
      appBar: PlantAppBar(plantId: widget.plantId, plantAsync: plantAsync),
      body: plantAsync.when(
        data: (plant) {
          if (plant == null) {
            return const Center(child: Text('Plant not found'));
          }

          return Column(
            children: [
              if (plant.plant.inWateringSchedule) BannerWidget(plant: plant),

              // Plant details section
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (plant.plant.notes != null &&
                        plant.plant.notes!.isNotEmpty) ...[
                      Text("Notes: ${plant.plant.notes}"),
                      const SizedBox(height: 8),
                    ],
                    if (plant.schedule != null) ...[
                      Text("Water every ${plant.schedule!.frequency} days"),
                      const SizedBox(height: 8),
                    ],
                  ],
                ),
              ),

              // Tab bar
              TabBar(
                controller: _tabController,
                tabs: const [
                  Tab(text: "Watering"),
                  Tab(text: "Repot"),
                  Tab(text: "Pesticide"),
                ],
              ),

              // Tab content - takes remaining space
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    // Watering tab
                    wateringAsync.when(
                      data: (events) {
                        return SizedBox(
                          height: 200,
                          child: EventSection<List<WaterEventData>>(
                            title: "Watering History",
                            plantId: plant.plant.id,
                            events: events,
                            formatDate: formatDate,
                            eventType: EventType.watering,
                          ),
                        );
                      },
                      loading:
                          () =>
                              const Center(child: CircularProgressIndicator()),
                      error: (e, st) => Center(child: Text('Error: $e')),
                    ),

                    // Repot tab
                    repotAsync.when(
                      data: (events) {
                        return SizedBox(
                          height: 200,
                          child: EventSection<List<RepotData>>(
                            title: "Repot History",
                            plantId: plant.plant.id,
                            events: events,
                            formatDate: formatDate,
                            eventType: EventType.repot,
                          ),
                        );
                      },
                      loading:
                          () =>
                              const Center(child: CircularProgressIndicator()),
                      error: (e, st) => Center(child: Text('Error: $e')),
                    ),

                    // Pesticide tab
                    pesticideAsync.when(
                      data: (events) {
                        return EventSection<List<Event>>(
                          title: "Pesticide History",
                          plantId: plant.plant.id,
                          events: events,
                          formatDate: formatDate,
                          eventType: EventType.pesticide,
                        );
                      },
                      loading:
                          () =>
                              const Center(child: CircularProgressIndicator()),
                      error: (e, st) => Center(child: Text('Error: $e')),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Error: $e')),
      ),
      bottomSheet: plantAsync.when(
        data: (plant) {
          if (plant == null) return const SizedBox.shrink();
          return Container(
            padding: const EdgeInsets.all(8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                PhotoReminderBanner(
                  dateAdded: DateTimeHelpers.dateStringToDateTime(
                    plant.plant.dateAdded,
                  ),
                  plantId: plant.plant.id,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          _deletePlantDialog(
                            onDelete: () async {
                              await plantNotifier.deletePlant();
                            },
                          );
                        },
                        child: const Text("Delete Plant"),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          final plantForm = PlantFormData(
                            id: plant.plant.id,
                            name: plant.plant.name,
                            inSchedule: plant.plant.inWateringSchedule,
                            notes: plant.plant.notes ?? '',
                            frequency:
                                plant.schedule?.frequency.toDouble() ?? 7,
                          );
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => AddPlantScreen(form: plantForm),
                            ),
                          );
                        },
                        child: const Text("Edit Plant"),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
              ],
            ),
          );
        },
        loading: () => const SizedBox.shrink(),
        error: (e, st) => const SizedBox.shrink(),
      ),
    );
  }

  Future<void> _deletePlantDialog({required void Function() onDelete}) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Confirm Delete'),
            content: const Text('Are you sure you want to delete this plant?'),
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
      if (mounted) {
        Navigator.of(
          context,
        ).pushReplacement(MaterialPageRoute(builder: (_) => HomeScreen()));
      }
    }
  }
}
