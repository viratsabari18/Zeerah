import 'package:flutter/material.dart';

class AddressProvider with ChangeNotifier {
  final List<Map<String, dynamic>> _savedAddresses = [
    {
      'label': 'Home',
      'icon': Icons.home_outlined,
      'distance': '0 m',
      'address': 'H1,604, Jasmine Grove, Jasmine Grove 959 , NH-9 ( Earlier, NH-2...',
      'phone': '+91-9140324761',
    },
    {
      'label': 'College',
      'icon': Icons.location_on_outlined,
      'distance': '1.8\nkm',
      'address': 'GH 1, GH 1, Ajay Kumar Garg Engineering College, Delhi - Me...',
      'phone': '+91-9140324761',
    },
  ];

  Map<String, dynamic>? _selectedLocation;

  List<Map<String, dynamic>> get savedAddresses => List.unmodifiable(_savedAddresses);
  Map<String, dynamic>? get selectedLocation => _selectedLocation;

  void addAddress(Map<String, dynamic> address) {
    // Add new address at the beginning of the list
    _savedAddresses.insert(0, address);
    notifyListeners();
  }

  void setSelectedLocation(Map<String, dynamic> location) {
    _selectedLocation = location;
    notifyListeners();
  }
}
