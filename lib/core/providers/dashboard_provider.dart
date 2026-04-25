import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';

class DashboardProvider with ChangeNotifier {
  bool _isLoading = false;
  List<String> _sliderImages = [];
  List<Map<String, dynamic>> _categories = [];
  Map<int, List<Map<String, dynamic>>> _subCategoriesMap = {};
  int? _selectedCategoryId;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  List<String> get sliderImages => _sliderImages;
  List<Map<String, dynamic>> get categories => _categories;
  List<Map<String, dynamic>> get currentSubCategories => 
      (_selectedCategoryId != null) ? (_subCategoriesMap[_selectedCategoryId] ?? []) : [];
  int? get selectedCategoryId => _selectedCategoryId;
  String? get errorMessage => _errorMessage;

  final String baseUrl = "https://ethically-thaw-bok.ngrok-free.dev";
  final String dashboardUrl = "https://ethically-thaw-bok.ngrok-free.dev/api/dashboard-detail";
  final String categoryUrl = "https://ethically-thaw-bok.ngrok-free.dev/api/category-list";
  final String subCategoryUrl = "https://ethically-thaw-bok.ngrok-free.dev/api/subcategory-list";
  Future<void> fetchInitialData() async {
    if (_categories.isEmpty) {
      // Fetch dashboard and categories in parallel for speed
      await Future.wait([
        fetchDashboardData(),
        fetchCategories(),
      ]);
    }
  }

  Future<void> fetchDashboardData() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await http.get(Uri.parse(dashboardUrl));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == true) {
          final List<dynamic> sliderData = data['slider'];
          _sliderImages = sliderData.map((item) {
            String imageUrl = item['slider_image'] ?? "";
            if (imageUrl.contains("127.0.0.1:8000")) {
              imageUrl = imageUrl.replaceAll("http://127.0.0.1:8000", baseUrl);
            }
            return imageUrl;
          }).toList();
        }
      }
    } catch (e) {
      debugPrint("Error fetching dashboard: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchCategories() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.get(Uri.parse(categoryUrl));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> catData = data['data'];
        _categories = catData.map((item) {
          String imageUrl = item['category_image'] ?? "";
          if (imageUrl.contains("127.0.0.1:8000")) {
            imageUrl = imageUrl.replaceAll("http://127.0.0.1:8000", baseUrl);
          }
          return {
            'id': item['id'],
            'name': item['name'],
            'image': imageUrl,
          };
        }).toList();

        // Prefetch first category subcategories immediately
        if (_categories.isNotEmpty) {
          _selectedCategoryId = _categories[0]['id'];
          await fetchSubCategories(_selectedCategoryId!);
        }
      }
    } catch (e) {
      debugPrint("Error fetching categories: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> selectCategory(int categoryId) async {
    if (_selectedCategoryId == categoryId) return;
    _selectedCategoryId = categoryId;
    notifyListeners();

    if (!_subCategoriesMap.containsKey(categoryId)) {
      await fetchSubCategories(categoryId);
    }
  }

  Future<void> fetchSubCategories(int categoryId) async {
    try {
      final response = await http.get(Uri.parse("$subCategoryUrl?category_id=$categoryId"));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> subCatData = data['data'];
        final subCats = subCatData.map((item) {
          String imageUrl = item['category_image'] ?? "";
          if (imageUrl.contains("127.0.0.1:8000")) {
            imageUrl = imageUrl.replaceAll("http://127.0.0.1:8000", baseUrl);
          }
          return {
            'id': item['id'],
            'name': item['name'],
            'image': imageUrl,
            'description': item['description'] ?? "Professional service at your doorstep",
          };
        }).toList();

        _subCategoriesMap[categoryId] = subCats;
        notifyListeners();

        // High-fidelity Optimization: Pre-cache images for the current category
        if (subCats.isNotEmpty) {
          _precacheImages(subCats);
        }
      }
    } catch (e) {
      debugPrint("Error fetching sub-categories: $e");
    }
  }

  void _precacheImages(List<Map<String, dynamic>> items) {
    for (var item in items) {
      final String? imageUrl = item['image'];
      if (imageUrl != null && imageUrl.startsWith('http')) {
        // Pre-fetching image into disk and memory cache
        CachedNetworkImageProvider(imageUrl).resolve(const ImageConfiguration()).addListener(
          ImageStreamListener((info, synchronousCall) {
            // Image is now cached and ready for instant display
          }),
        );
      }
    }
  }
}
