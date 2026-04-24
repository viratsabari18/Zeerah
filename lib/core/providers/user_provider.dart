import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserProvider with ChangeNotifier {
  User? _user;

  UserProvider() {
    // Check if a user is already logged in via Firebase
    _user = FirebaseAuth.instance.currentUser;
  }

  User? get user => _user;

  String get displayName => _user?.displayName ?? "Guest";
  String get email => _user?.email ?? "";
  
  // Extract first name from display name or email
  String get firstName {
    if (_user?.displayName != null && _user!.displayName!.isNotEmpty) {
      return _user!.displayName!.split(' ').first;
    }
    if (_user?.email != null && _user!.email!.isNotEmpty) {
      return _user!.email!.split('@').first;
    }
    return "User";
  }

  void setUser(User? user) {
    _user = user;
    notifyListeners();
  }

  void clearUser() {
    _user = null;
    notifyListeners();
  }
}
