import 'package:bogbon/servis/DatabaseService.dart';
import 'package:bogbon/servis/model/PlantModel.dart';
import 'package:flutter/material.dart';

class PlantProvider extends ChangeNotifier {
  List<PlantModel> _plants = [];
  List<PlantModel> get plants => _plants;

  PlantProvider() {
    loadPlants();
  }

  void loadPlants() {
    _plants = DatabaseService.getAllPlants();
    notifyListeners();
  }

  Future<void> addPlant(PlantModel plant) async {
    await DatabaseService.addPlant(plant);
    loadPlants();
  }

  Future<void> deletePlant(String id) async {
    await DatabaseService.deletePlant(id);
    loadPlants();
  }

  void refresh() {
    loadPlants();
  }
}
