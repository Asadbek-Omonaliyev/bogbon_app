import 'package:bogbon/servis/DatabaseService.dart';
import 'package:bogbon/servis/shared_preferences/Shared_preferens.dart';
import 'package:flutter/material.dart';

class CareProvider extends ChangeNotifier {
  int _totalWaterings = 0;
  int get totalWaterings => _totalWaterings;

  List<String> _postponedPlants = [];
  List<String> get postponedPlants => _postponedPlants;

  CareProvider() {
    _loadData();
  }

  Future<void> _loadData() async {
    _totalWaterings = await SharedPreferens.getWateringCount();
    _postponedPlants = await SharedPreferens.getPostponedPlants();
    notifyListeners();
  }

  Future<void> incrementWateringCount() async {
    _totalWaterings++;
    await SharedPreferens.setWateringCount(_totalWaterings);
    notifyListeners();
  }

  Future<void> addPostponedPlant(String plantData) async {
    if (!_postponedPlants.contains(plantData)) {
      _postponedPlants.add(plantData);
      await SharedPreferens.setPostponedPlants(_postponedPlants);
      notifyListeners();
    }
  }

  Future<void> removePostponedPlant(String plantData) async {
    if (_postponedPlants.contains(plantData)) {
      _postponedPlants.remove(plantData);
      await SharedPreferens.setPostponedPlants(_postponedPlants);
      notifyListeners();
    }
  }

  Future<void> syncOverduePlants() async {
    final allPlants = DatabaseService.getAllPlants();
    final now = DateTime.now();
    bool changed = false;

    for (var plant in allPlants) {
      final nextWatering = plant.lastWateredAt.add(Duration(days: plant.care.watering.days));
      if (now.isAfter(nextWatering)) {
        final plantData = "${plant.id}|${plant.name}";
        if (!_postponedPlants.contains(plantData)) {
          _postponedPlants.add(plantData);
          changed = true;
        }
      }
    }

    if (changed) {
      await SharedPreferens.setPostponedPlants(_postponedPlants);
      notifyListeners();
    }
  }
}
