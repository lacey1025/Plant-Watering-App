import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plant_application/database/plant_app_db.dart';
import 'package:plant_application/models/enums/event_types_enum.dart';
import 'package:plant_application/models/repot_data.dart';
import 'package:plant_application/models/water_event_data.dart';
import 'package:plant_application/notifier_providers/db_providers.dart';
import 'package:plant_application/notifier_providers/plant_provider.dart';
import 'package:plant_application/screens/shared/background_scaffold.dart';
import 'package:plant_application/screens/shared/custom_tab_bar.dart';
import 'package:plant_application/screens/shared/fake_blur.dart';
import 'package:plant_application/screens/view_plant/widgets/banner_widget.dart';
import 'package:plant_application/screens/view_plant/widgets/bottom_buttons.dart';
import 'package:plant_application/screens/view_plant/widgets/event_section_widget.dart';
import 'package:plant_application/screens/view_plant/widgets/notes_card.dart';
import 'package:plant_application/screens/view_plant/widgets/plant_app_bar.dart';
import 'package:plant_application/theme.dart';

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

  @override
  Widget build(BuildContext context) {
    final plantAsync = ref.watch(plantNotifierProvider(widget.plantId));
    final wateringAsync = ref.watch(
      wateringEventsForPlantProvider(widget.plantId),
    );
    final repotAsync = ref.watch(repotEventsForPlantProvider(widget.plantId));
    final pesticideAsync = ref.watch(
      pesticideEventsForPlantProvider(widget.plantId),
    );

    return BackgroundScaffold(
      appBar: PlantAppBar(plantId: widget.plantId, plantAsync: plantAsync),
      body: plantAsync.when(
        data: (plant) {
          if (plant == null) {
            return const Center(child: Text('Plant not found'));
          }

          return Column(
            children: [
              if (plant.plant.inWateringSchedule) BannerWidget(plant: plant),

              // Scrollable main area
              Expanded(
                child: Column(
                  children: [
                    // Notes & schedule card
                    if ((plant.plant.notes?.isNotEmpty ?? false) ||
                        plant.schedule != null)
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: NotesCard(plant: plant),
                      ),

                    // Tabs
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: CustomTabBar(
                        controller: _tabController,
                        tabs: const ["watering", "repot", "pesticide"],
                        reverse: true,
                      ),
                    ),

                    // Expand tabs to fill space
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: FakeBlur(
                          overlay: AppColors.secondaryGreen.withAlpha(150),
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(16),
                            bottomRight: Radius.circular(16),
                          ),
                          // color: AppColors.secondaryGreen,
                          child: TabBarView(
                            controller: _tabController,
                            children: [
                              wateringAsync.when(
                                data:
                                    (events) =>
                                        EventSection<List<WaterEventData>>(
                                          title: "watering history",
                                          plantId: plant.plant.id,
                                          events: events,
                                          eventType: EventType.watering,
                                        ),
                                loading:
                                    () => const Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                error:
                                    (e, st) => Center(child: Text('Error: $e')),
                              ),
                              repotAsync.when(
                                data:
                                    (events) => EventSection<List<RepotData>>(
                                      title: "repot history",
                                      plantId: plant.plant.id,
                                      events: events,
                                      eventType: EventType.repot,
                                    ),
                                loading:
                                    () => const Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                error:
                                    (e, st) => Center(child: Text('Error: $e')),
                              ),
                              pesticideAsync.when(
                                data:
                                    (events) => EventSection<List<Event>>(
                                      title: "pesticide history",
                                      plantId: plant.plant.id,
                                      events: events,
                                      eventType: EventType.pesticide,
                                    ),
                                loading:
                                    () => const Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                error:
                                    (e, st) => Center(child: Text('Error: $e')),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Bottom buttons
              Padding(
                padding: const EdgeInsets.all(8),
                child: BottomButtons(plant: plant),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Error: $e')),
      ),
    );
  }
}
