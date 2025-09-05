import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plant_application/models/enums/event_types_enum.dart';
import 'package:plant_application/models/plant_card_data.dart';
import 'package:plant_application/notifier_providers/accessories_provider.dart';
import 'package:plant_application/screens/add_plant/add_plant_screen.dart';
import 'package:plant_application/screens/shared/accessory_dialog.dart';
import 'package:plant_application/screens/home/item_list_tab.dart';
import 'package:plant_application/screens/home/plant_card.dart';
import 'package:plant_application/screens/shared/background_scaffold.dart';
import 'package:plant_application/screens/shared/custom_app_bar.dart';
import 'package:plant_application/screens/shared/custom_tab_bar.dart';
import 'package:plant_application/theme.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with TickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final plantCardsAsync = ref.watch(plantCardsProvider);
    final accessoriesAsync = ref.watch(accessoriesNotifierProvider);

    return BackgroundScaffold(
      appBar: CustomAppBar(title: "my plants"),
      body: Column(
        children: [
          const SizedBox(height: 16), // space above tab bar
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: CustomTabBar(
              controller: _tabController,
              tabs: const ["plants", "fertilizers", "pesticides"],
            ),
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 8),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white54,
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(8)),
              ),
              child: TabBarView(
                controller: _tabController,
                children: [
                  // Plants tab
                  plantCardsAsync.when(
                    loading:
                        () => Center(
                          child: CircularProgressIndicator(
                            color: AppColors.primaryBlue,
                          ),
                        ),
                    error:
                        (e, st) => Padding(
                          padding: EdgeInsets.all(16),
                          child: Text(
                            "error loading plants: $e",
                            style: TextStyle(
                              color: AppColors.darkTextBlue,
                              fontSize: 16,
                            ),
                          ),
                        ),
                    data: (plantCards) {
                      plantCards.sort((a, b) {
                        final aDate = a.earliestNextWater;
                        final bDate = b.earliestNextWater;
                        if (aDate == null && bDate == null) return 0;
                        if (aDate == null) return 1;
                        if (bDate == null) return -1;
                        return aDate.compareTo(bDate);
                      });
                      return ListView.builder(
                        itemCount: plantCards.length,
                        itemBuilder: (context, index) {
                          final card = plantCards[index];
                          return PlantCard(plant: card);
                        },
                      );
                    },
                  ),

                  // Fertilizers tab
                  accessoriesAsync.when(
                    loading:
                        () => Center(
                          child: CircularProgressIndicator(
                            color: AppColors.primaryBlue,
                          ),
                        ),
                    error:
                        (e, st) => Padding(
                          padding: EdgeInsets.all(16),
                          child: Text(
                            "error loading fertilizers: $e",
                            style: TextStyle(
                              color: AppColors.darkTextBlue,
                              fontSize: 16,
                            ),
                          ),
                        ),
                    data: (data) {
                      final fertilizers =
                          data
                              .where(
                                (a) =>
                                    a.type == EventType.fertilizer.toString() &&
                                    a.isActive,
                              )
                              .toList();
                      return ItemListTab(
                        items: fertilizers,
                        emptyMessage: "no fertilizers added yet",
                      );
                    },
                  ),

                  // Pesticides tab
                  accessoriesAsync.when(
                    loading:
                        () => Center(
                          child: CircularProgressIndicator(
                            color: AppColors.primaryBlue,
                          ),
                        ),
                    error:
                        (e, st) => Padding(
                          padding: EdgeInsets.all(16),
                          child: Text(
                            "error loading pesticides: $e",
                            style: TextStyle(
                              color: AppColors.darkTextBlue,
                              fontSize: 16,
                            ),
                          ),
                        ),
                    data: (data) {
                      final pesticides =
                          data
                              .where(
                                (a) =>
                                    a.type == EventType.pesticide.toString() &&
                                    a.isActive,
                              )
                              .toList();
                      return ItemListTab(
                        items: pesticides,
                        emptyMessage: "no pesticides added yet",
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: FilledButton.icon(
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(48),
              ),
              icon: Icon(Icons.add),
              label: Text(
                _tabController.index == 0
                    ? "add plant"
                    : _tabController.index == 1
                    ? "add fertilizer"
                    : "add pesticide",
              ),
              onPressed: () {
                if (_tabController.index == 0) {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const AddPlantScreen()),
                  );
                } else if (_tabController.index == 1) {
                  showAccessoryDialog(context, ref, null, EventType.fertilizer);
                } else if (_tabController.index == 2) {
                  showAccessoryDialog(context, ref, null, EventType.pesticide);
                }
              },
            ),
          ),
          const SizedBox(height: 16), // space at the bottom
        ],
      ),
    );
  }
}
