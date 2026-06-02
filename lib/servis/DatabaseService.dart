import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'model/PlantModel.dart';

class DatabaseService {
  static const String _plantsBoxName = 'plants';
  static const String _favoritesBoxName = 'favorites_ids';
  static const String _historyBoxName = 'scan_history';

  static Future<void> init() async {
    try {
      await Hive.initFlutter();
      
      // Adapterni ro'yxatdan o'tkazish
      _registerAdapters();

      // Boxlarni ochish
      await _openBoxes();

      // Dastlabki sinxronizatsiya
      await _checkAndSyncData();
      
      debugPrint("Hive muvaffaqiyatli ishga tushdi");
    } catch (e) {
      debugPrint("Hive Init Error: $e");
      // Agar schema xatosi bo'lsa, bazani tozalab ko'ramiz
      try {
        await Hive.deleteBoxFromDisk(_plantsBoxName);
        await _openBoxes();
        await _checkAndSyncData();
      } catch (e2) {
        debugPrint("Hive Recovery Error: $e2");
      }
    }
  }

  static void _registerAdapters() {
    _registerSafe(PlantModelAdapter());
    _registerSafe(PlantLocationAdapter());
    _registerSafe(DifficultyLevelAdapter());
    _registerSafe(GrowthRateAdapter());
    _registerSafe(SunlightTypeAdapter());
    _registerSafe(CareModelAdapter());
    _registerSafe(WateringModelAdapter());
    _registerSafe(SunlightModelAdapter());
    _registerSafe(TemperatureModelAdapter());
    _registerSafe(HumidityModelAdapter());
    _registerSafe(FertilizerModelAdapter());
    _registerSafe(RepottingModelAdapter());
    _registerSafe(DiseaseModelAdapter());
    _registerSafe(PestModelAdapter());
    _registerSafe(ReminderModelAdapter());
    _registerSafe(TreatmentModelAdapter());
  }

  static Future<void> _openBoxes() async {
    await Hive.openBox<PlantModel>(_plantsBoxName);
    await Hive.openBox<String>(_favoritesBoxName);
    await Hive.openBox<PlantModel>(_historyBoxName);
  }

  static void _registerSafe<T>(TypeAdapter<T> adapter) {
    if (!Hive.isAdapterRegistered(adapter.typeId)) {
      Hive.registerAdapter(adapter);
    }
  }

  static Future<void> _checkAndSyncData() async {
    final box = Hive.box<PlantModel>(_plantsBoxName);
    
    // Agar baza bo'sh bo'lsa yoki eski (kam) ma'lumotlar bo'lsa, yangilaymiz
    if (box.isEmpty || box.length < 10) {
      try {
        // Eski ma'lumotlarni tozalaymiz (faqat bir marta yangilash uchun)
        await box.clear();
        
        final String response = await rootBundle.loadString('assets/baza/plants.json');
        final List<dynamic> data = json.decode(response);
        final plants = data.map((e) => PlantModel.fromJson(e)).toList();
        
        final Map<String, PlantModel> plantMap = {
          for (var p in plants) p.id: p
        };
        await box.putAll(plantMap);
        debugPrint("Baza yangilandi: ${plants.length} ta o'simlik yuklandi");
      } catch (e) {
        debugPrint("Sync Error: $e");
      }
    }
  }

  // --- Metodlar ---
  static List<PlantModel> getAllPlants() {
    if (!Hive.isBoxOpen(_plantsBoxName)) return [];
    return Hive.box<PlantModel>(_plantsBoxName).values.toList();
  }

  static PlantModel? getPlantById(String id) {
    if (!Hive.isBoxOpen(_plantsBoxName)) return null;
    return Hive.box<PlantModel>(_plantsBoxName).get(id);
  }

  static List<String> getFavoriteIds() {
    if (!Hive.isBoxOpen(_favoritesBoxName)) return [];
    return Hive.box<String>(_favoritesBoxName).values.toList();
  }

  static Future<void> toggleFavorite(String id) async {
    final box = Hive.box<String>(_favoritesBoxName);
    if (box.values.contains(id)) {
      final key = box.keys.firstWhere((k) => box.get(k) == id);
      await box.delete(key);
    } else {
      await box.add(id);
    }
  }

  static bool isFavorite(String id) {
    if (!Hive.isBoxOpen(_favoritesBoxName)) return false;
    return Hive.box<String>(_favoritesBoxName).values.contains(id);
  }

  static List<PlantModel> getScanHistory() {
    if (!Hive.isBoxOpen(_historyBoxName)) return [];
    return Hive.box<PlantModel>(_historyBoxName).values.toList().reversed.toList();
  }

  static Future<void> addToHistory(PlantModel plant) async {
    final box = Hive.box<PlantModel>(_historyBoxName);
    await box.add(plant);
  }

  static Future<void> addPlant(PlantModel plant) async {
    final box = Hive.box<PlantModel>(_plantsBoxName);
    await box.put(plant.id, plant);
  }

  static Future<void> deletePlant(String id) async {
    final box = Hive.box<PlantModel>(_plantsBoxName);
    await box.delete(id);
    final favBox = Hive.box<String>(_favoritesBoxName);
    if (favBox.values.contains(id)) {
      final key = favBox.keys.firstWhere((k) => favBox.get(k) == id);
      await favBox.delete(key);
    }
  }
}
