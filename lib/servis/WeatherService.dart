import 'dart:convert';
import 'package:bogbon/servis/DatabaseService.dart';
import 'package:bogbon/servis/NotificationService.dart';
import 'package:bogbon/servis/shared_preferences/Shared_preferens.dart';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class WeatherService {
  static const String _apiKey = "f093ea8fca470fb116cc6aa2b8fc9bf2";

  static Future<void> checkTemperatureAndNotify() async {
    try {
      // 1. Joylashuvni aniqlash
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.whileInUse || permission == LocationPermission.always) {
        Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.low,
        );

        // 2. Ob-havo ma'lumotini olish
        final url = "https://api.openweathermap.org/data/2.5/weather?lat=${position.latitude}&lon=${position.longitude}&appid=$_apiKey&units=metric";
        final response = await http.get(Uri.parse(url));

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          final double currentTemp = data['main']['temp'].toDouble();
          debugPrint("--- OB-HAVO TEKSHIRUVI ---");
          debugPrint("Hozirgi harorat: $currentTemp°C");

          final favoriteIds = DatabaseService.getFavoriteIds();
          final allPlants = DatabaseService.getAllPlants();
          
          final myPlants = allPlants.where((p) => favoriteIds.contains(p.id) || p.isUserCreated).toList();
          
          debugPrint("Mening o'simliklarim soni: ${myPlants.length}");

          List<String> tooHotPlants = [];
          List<String> tooColdPlants = [];

          for (var plant in myPlants) {
            bool isNotifEnabled = await SharedPreferens.getNotification(plant.id);
            debugPrint("O'simlik: ${plant.name}, Eslatma: $isNotifEnabled, Min: ${plant.care.temperature.min}, Max: ${plant.care.temperature.max}");
            
            if (!isNotifEnabled) continue;

            if (currentTemp > plant.care.temperature.max) {
              tooHotPlants.add(plant.name);
              debugPrint(">> OGOHLANTIRISH (ISSIQ): ${plant.name}");
            } else if (currentTemp < plant.care.temperature.min) {
              tooColdPlants.add(plant.name);
              debugPrint(">> OGOHLANTIRISH (SOVUQ): ${plant.name}");
            }
          }

          // 4. Bildirishnoma yuborish
          if (tooHotPlants.isNotEmpty) {
            await NotificationService.showNotification(
              id: 888,
              title: "Havo harorati judayam issiq! ⚠️",
              body: "Hozir ${currentTemp.round()}°C. ${tooHotPlants.join(', ')} o'simliklaringizni salqinroq joyga oling.",
            );
          }

          if (tooColdPlants.isNotEmpty) {
            await NotificationService.showNotification(
              id: 999,
              title: "Havo harorati judayam sovuq! ❄️",
              body: "Hozir ${currentTemp.round()}°C. ${tooColdPlants.join(', ')} o'simliklaringizni issiqroq joyga oling.",
            );
          }

          if (tooHotPlants.isEmpty && tooColdPlants.isEmpty) {
            debugPrint("Harorat barcha o'simliklar uchun me'yorda.");
          }
        }
      }
    } catch (e) {
      debugPrint("Ob-havo tekshirishda xato: $e");
    }
  }
}
