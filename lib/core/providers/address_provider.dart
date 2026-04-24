import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddressProvider with ChangeNotifier {
  AddressProvider() {
    _loadFromPrefs();
  }

  final List<Map<String, dynamic>> _savedAddresses = [];

  Map<String, dynamic>? _selectedLocation;

  List<Map<String, dynamic>> get savedAddresses => List.unmodifiable(_savedAddresses);
  Map<String, dynamic>? get selectedLocation => _selectedLocation;

  void clearAddressData() async {
    _selectedLocation = null;
    _savedAddresses.clear();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('selected_location');
    notifyListeners();
  }

  void addAddress(Map<String, dynamic> address) {
    _savedAddresses.insert(0, address);
    notifyListeners();
  }

  void setSelectedLocation(Map<String, dynamic> location) {
    _selectedLocation = location;
    _saveToPrefs(location);
    notifyListeners();
  }

  Future<void> _saveToPrefs(Map<String, dynamic> location) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      // Remove IconData as it cannot be serialized to JSON
      final mapToSave = Map<String, dynamic>.from(location);
      mapToSave.remove('icon');
      
      await prefs.setString('selected_location', jsonEncode(mapToSave));
    } catch (e) {
      debugPrint("Error saving address to prefs: $e");
    }
  }

  Future<void> _loadFromPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedStr = prefs.getString('selected_location');
      
      if (savedStr != null) {
        final Map<String, dynamic> loadedMap = jsonDecode(savedStr);
        
        // Restore the icon based on label
        loadedMap['icon'] = _getIconForLabel(loadedMap['label']);
        
        _selectedLocation = loadedMap;
        notifyListeners();
      }
    } catch (e) {
      debugPrint("Error loading address from prefs: $e");
    }
  }

  IconData _getIconForLabel(String? label) {
    switch (label) {
      case 'Home':
        return Icons.home_outlined;
      case 'Work':
        return Icons.work_outline;
      case 'College':
        return Icons.school_outlined;
      case 'Hotel':
        return Icons.apartment_outlined;
      default:
        return Icons.location_on_outlined;
    }
  }
}
