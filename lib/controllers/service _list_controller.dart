import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:zeerah/core/models/service_list_model.dart';

class ServiceListController extends ChangeNotifier {
  List<ServiceData> serviceList = [];

  bool isLoading = false;
  bool isPaginationLoading = false;
  String? errorMessage;

  int offset = 0;
  int limit = 10;

  int? subcategoryId;


  void setSubcategory(int id) {
    subcategoryId = id;
  }


  Future<void> fetchServices({bool isLoadMore = false}) async {
    if (subcategoryId == null) {
      errorMessage = "Subcategory ID is not set";
      notifyListeners();
      return;
    }

    if (isLoadMore) {
      isPaginationLoading = true;
    } else {
      isLoading = true;
      errorMessage = null;
      offset = 0;
      serviceList.clear();
    }

    notifyListeners();

    try {
      final url =
          "https://ethically-thaw-bok.ngrok-free.dev/api/service-list"
          "?subcategory_id=$subcategoryId&limit=$limit&offset=$offset";

      debugPrint("Fetching services from: $url");
      
      final response = await http.get(Uri.parse(url)).timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          throw Exception("Connection timeout");
        },
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        
        debugPrint("API Response: ${jsonData.toString()}");
        
        if (jsonData['status'] == false) {
          errorMessage = jsonData['message'] ?? "Failed to fetch services";
          notifyListeners();
          return;
        }

        ServiceListModel model = ServiceListModel.fromJson(jsonData);

        if (model.data != null && model.data!.isNotEmpty) {
          if (isLoadMore) {
            serviceList.addAll(model.data!);
          } else {
            serviceList = model.data!;
          }
          offset += limit; // next page
          errorMessage = null;
        } else {
          if (!isLoadMore) {
            serviceList = [];
            errorMessage = "No services found";
          }
        }
      } else {
        errorMessage = "Error ${response.statusCode}: Failed to load services";
        debugPrint("API ERROR: ${response.statusCode}");
        debugPrint("Response body: ${response.body}");
      }
    } catch (e) {
      errorMessage = "Error: $e";
      debugPrint("ERROR: $e");
    } finally {
      isLoading = false;
      isPaginationLoading = false;
      notifyListeners();
    }
  }


  Future<void> refreshServices() async {
    offset = 0;
    await fetchServices();
  }

  Future<void> loadMoreServices() async {
    if (!isPaginationLoading && serviceList.isNotEmpty) {
      await fetchServices(isLoadMore: true);
    }
  }
}