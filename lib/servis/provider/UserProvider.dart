import 'package:bogbon/servis/shared_preferences/Shared_preferens.dart';
import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  String _userName = "User";
  String? _profileImagePath;

  String get userName => _userName;
  String? get profileImagePath => _profileImagePath;

  UserProvider() {
    loadUserData();
  }

  Future<void> loadUserData() async {
    _userName = await SharedPreferens.getOqish();
    _profileImagePath = await SharedPreferens.getProfileImage();
    notifyListeners();
  }

  Future<void> updateName(String name) async {
    await SharedPreferens.setSaqlash(name);
    _userName = name;
    notifyListeners();
  }

  Future<void> updateProfileImage(String path) async {
    await SharedPreferens.setProfileImage(path);
    _profileImagePath = path;
    notifyListeners();
  }
}
