import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferens {
  /// User Nameni xotiraga saqlash
  static Future<void> setSaqlash(String userName) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("userName", userName);
  }

  /// Xotiradan User Nameni o'qish
  static Future<String> getOqish() async {
    final prefs = await SharedPreferences.getInstance();
    String userName = await prefs.getString("userName") ?? "User";
    return userName;
  }

  /// Saqlangan o'simliklar ID larini o'qish
  static Future<List<String>> getYoqtirganlar() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList("favorites") ?? [];
  }

  /// O'simlikni saqlanganlarga qo'shish yoki o'chirish
  static Future<bool> setYoqtirganlar(String id) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> favorites = prefs.getStringList("favorites") ?? [];

    if (favorites.contains(id)) {
      favorites.remove(id);
      await prefs.setStringList("favorites", favorites);
      return false;
    } else {
      favorites.add(id);
      await prefs.setStringList("favorites", favorites);
      return true;
    }
  }

  /// Theme rejimini saqlash
  static Future<void> setTheme(bool isDark) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("isDark", isDark);
  }

  /// Theme rejimini o'qish
  static Future<bool> getTheme() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool("isDark") ?? true;
  }

  /// Bildirishnoma holatini saqlash
  static Future<void> setNotification(String id, bool status) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("notif_$id", status);
  }

  /// Bildirishnoma holatini o'qish
  static Future<bool> getNotification(String id) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool("notif_$id") ?? false;
  }

  /// XP miqdorini saqlash
  static Future<void> setXP(int xp) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt("user_xp", xp);
  }

  /// XP miqdorini o'qish
  static Future<int> getXP() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt("user_xp") ?? 0;
  }

  /// Jami sug'orishlar sonini saqlash
  static Future<void> setWateringCount(int count) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt("total_waterings", count);
  }

  /// Jami sug'orishlar sonini o'qish
  static Future<int> getWateringCount() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt("total_waterings") ?? 0;
  }

  /// Keyinroq sug'orilishi kerak bo'lgan o'simliklar ro'yxatini saqlash
  static Future<void> setPostponedPlants(List<String> plants) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList("postponed_plants", plants);
  }

  /// Keyinroq sug'orilishi kerak bo'lgan o'simliklar ro'yxatini o'qish
  static Future<List<String>> getPostponedPlants() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList("postponed_plants") ?? [];
  }

  /// Profil rasmini saqlash
  static Future<void> setProfileImage(String path) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("profile_image", path);
  }

  /// Profil rasmini o'qish
  static Future<String?> getProfileImage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("profile_image");
  }
}
