import 'package:bogbon/servis/DatabaseService.dart';
import 'package:bogbon/servis/model/PlantModel.dart';
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
    await syncOverduePlants();
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
    if (allPlants.isEmpty) return;

    final now = DateTime.now();
    bool changed = false;


    List<String> newPostponedList = List.from(_postponedPlants);


    for (var plant in allPlants) {

      final int days = plant.smartNotifications.wateringDays;
      final int idInt = int.tryParse(plant.id) ?? 0;
      
      // Test holati (10 soniya)
      final bool isTest = (idInt == 1 || idInt == 2);
      
      DateTime nextWatering;
      if (isTest) {
        nextWatering = plant.createdAt.add(const Duration(seconds: 10));
      } else {
        nextWatering = plant.lastWateredAt.add(Duration(days: days));
      }
      
      if (now.isAfter(nextWatering)) {
        final plantData = "${plant.id}|${plant.name}";
        if (!newPostponedList.contains(plantData)) {
          newPostponedList.add(plantData);
          changed = true;
          debugPrint("Avto-qo'shildi: ${plant.name}");
        }
      }
    }

    // 2. Sug'orilgan yoki o'chirilganlarni ro'yxatdan olib tashlash
    final originalLength = newPostponedList.length;
    newPostponedList.removeWhere((data) {
      final parts = data.split('|');
      final id = parts[0];
      
      final plantIndex = allPlants.indexWhere((p) => p.id == id);
      if (plantIndex == -1) return true; 
      
      final plant = allPlants[plantIndex];
      final int days = plant.smartNotifications.wateringDays;
      final int idInt = int.tryParse(plant.id) ?? 0;
      final bool isTest = (idInt == 1 || idInt == 2);

      DateTime nextW;
      if (isTest) {
        nextW = plant.createdAt.add(const Duration(seconds: 10));
      } else {
        nextW = plant.lastWateredAt.add(Duration(days: days));
      }
      
      return now.isBefore(nextW);
    });

    if (changed || newPostponedList.length != originalLength) {
      _postponedPlants = newPostponedList;
      await SharedPreferens.setPostponedPlants(_postponedPlants);
      notifyListeners();
    }
  }
}
