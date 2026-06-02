import 'package:bogbon/servis/DatabaseService.dart';
import 'package:bogbon/servis/NotificationService.dart';
import 'package:bogbon/servis/model/PlantModel.dart';
import 'package:bogbon/servis/shared_preferences/Shared_preferens.dart';
import 'package:flutter/material.dart';

class NotificationProvider extends ChangeNotifier {
  List<PlantModel> _notificationPlants = [];
  List<PlantModel> get notificationPlants => _notificationPlants;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  NotificationProvider() {
    loadNotificationPlants();
  }

  Future<void> loadNotificationPlants() async {
    _isLoading = true;
    notifyListeners();
    try {
      final allPlants = DatabaseService.getAllPlants();
      
      List<PlantModel> filtered = [];
      for (var plant in allPlants) {
        bool isOn = await SharedPreferens.getNotification(plant.id);
        if (isOn) {
          filtered.add(plant);
        }
      }
      _notificationPlants = filtered;
    } catch (e) {
      debugPrint("Eslatmalarni yuklashda xato: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> toggleNotification(PlantModel plant, bool status) async {
    await SharedPreferens.setNotification(plant.id, status);
    final int plantIdInt = int.tryParse(plant.id) ?? 0;

    if (status) {
      await NotificationService.schedulePlantReminder(
        id: plantIdInt,
        plantName: plant.name,
        days: plant.reminders.wateringDays,
      );
      if (!_notificationPlants.any((p) => p.id == plant.id)) {
        _notificationPlants.add(plant);
      }
    } else {
      await NotificationService.cancelReminder(plantIdInt);
      _notificationPlants.removeWhere((p) => p.id == plant.id);
    }
    notifyListeners();
  }

  bool isNotificationOn(String id) {
    return _notificationPlants.any((p) => p.id == id);
  }
}
