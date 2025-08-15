import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plant_application/providers/home_screen_providers.dart';
import 'package:plant_application/screens/add_plant/add_plant_screen.dart';
import 'package:plant_application/screens/home/plant_card.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final plantCardsAsync = ref.watch(plantCardsProvider);
    return Scaffold(
      appBar: AppBar(title: Text("My Plants")),
      body: plantCardsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) {
          print(st);
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

          return Column(
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                  child: ListView.builder(
                    itemCount: plantCards.length,
                    itemBuilder: (context, index) {
                      final card = plantCards[index];
                      return PlantCard(plant: card);
                    },
                  ),
                ),
              ),
              ElevatedButton(
                child: Text("Add Plant"),
                onPressed: () {
                  Navigator.of(
                    context,
                  ).push(MaterialPageRoute(builder: (_) => AddPlantScreen()));
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
