import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plant_application/models/enums/event_types_enum.dart';
import 'package:plant_application/models/plant_card_data.dart';
import 'package:plant_application/notifier_providers/accessories_provider.dart';
import 'package:plant_application/screens/add_plant/add_plant_screen.dart';
import 'package:plant_application/screens/shared/accessory_dialog.dart';
import 'package:plant_application/screens/home/item_list_tab.dart';
import 'package:plant_application/screens/home/plant_card.dart';

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

    return Scaffold(
      appBar: AppBar(title: const Text("My Plants")),
      body: Column(
        children: [
          TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: "plants"),
              Tab(text: "fertilizers"),
              Tab(text: "pesticides"),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Plants tab
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                  child: plantCardsAsync.when(
                    loading:
                        () => const Center(child: CircularProgressIndicator()),
                    error: (e, st) {
                      return Center(child: Text("Error loading plants: $e"));
                    },
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
                ),

                // Fertilizers tab
                accessoriesAsync.when(
                  loading:
                      () => const Center(child: CircularProgressIndicator()),
                  error: (e, st) {
                    return Center(child: Text("Error loading fertilizers: $e"));
                  },
                  data: (data) {
                    final fertilizers =
                        data
                            .where(
                              (a) =>
                                  a.type == EventType.fertilizer.toString() &&
                                  a.isActive == true,
                            )
                            .toList();
                    return ItemListTab(
                      items: fertilizers,
                      emptyMessage: "No fertilizers added yet",
                    );
                  },
                ),

                // Pesticides tab
                accessoriesAsync.when(
                  loading:
                      () => const Center(child: CircularProgressIndicator()),
                  error: (e, st) {
                    return Center(child: Text("Error loading pesticides: $e"));
                  },
                  data: (data) {
                    final pesticides =
                        data
                            .where(
                              (a) =>
                                  a.type == EventType.pesticide.toString() &&
                                  a.isActive == true,
                            )
                            .toList();
                    return ItemListTab(
                      items: pesticides,
                      emptyMessage: "No pesticides added yet",
                    );
                  },
                ),
              ],
            ),
          ),

          ElevatedButton(
            child: Text(
              _tabController.index == 0
                  ? "Add Plant"
                  : _tabController.index == 1
                  ? "Add Fertilizer"
                  : "Add Pesticide",
            ),
            onPressed: () {
              if (_tabController.index == 0) {
                // Add plant
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const AddPlantScreen()),
                );
              } else if (_tabController.index == 1) {
                // Add fertilizer
                showAccessoryDialog(context, ref, null, EventType.fertilizer);
              } else if (_tabController.index == 2) {
                // Add pesticide
                showAccessoryDialog(context, ref, null, EventType.pesticide);
              }
            },
          ),
        ],
      ),
    );
  }
}
