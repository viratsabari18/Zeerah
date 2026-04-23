import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zeerah/core/common/app_exports.dart';
import 'package:zeerah/core/providers/address_provider.dart';
import 'package:zeerah/widgets/common/map_picker_screen.dart';

class ServiceType extends StatefulWidget {
  const ServiceType({super.key});

  @override
  State<ServiceType> createState() => _ServiceTypeState();
}

class _ServiceTypeState extends State<ServiceType> {
  int selectedIndex = 0;

  /// ✅ Controllers
  final TextEditingController addressController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  final List<Map<String, String>> services = [
    {
      "title": UserMessages.regularWash,
      "subtitle": UserMessages.standardWashing,
      "image": UserMessages.serviceBookingDummy1,
    },
    {
      "title": UserMessages.washAndIron,
      "subtitle": UserMessages.washDryClean,
      "image": UserMessages.serviceBookingDummy2,
    },
    {
      "title": UserMessages.dryCleaning,
      "subtitle": UserMessages.professionalCleaning,
      "image": UserMessages.serviceBookingDummy3,
    },
  ];

  final selectedBg = AppColors.selectedServiceBg;
  final tickColor = AppColors.tickColor;

  @override
  void dispose() {
    addressController.dispose();
    descriptionController.dispose();
    super.dispose();
  }



  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 🔴 Title
          Padding(
            padding: EdgeInsets.only(
                right: Insets.sm, left: Insets.sm, top: Insets.sm, bottom: Insets.xxs),
            child: Text(
              UserMessages.serviceType,
              style: TextStyle(
                fontSize: AppSizes.w(context, 18),
                fontWeight: FontWeight.bold,
                color: AppColors.primaryRed,
              ),
            ),
          ),

          /// 📦 Service List
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: services.length,
            itemBuilder: (context, index) {
              final item = services[index];
              final isSelected = selectedIndex == index;

              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedIndex = index;
                  });
                },
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: Insets.xsm, vertical: Insets.xxs),
                  padding: EdgeInsets.all(Insets.xsm),
                  decoration: BoxDecoration(
                    color: isSelected ? selectedBg : AppColors.naturalWhite,
                    borderRadius: BorderRadius.circular(Insets.xs),
                  ),
                  child: Row(
                    children: [
                      /// 🖼 Image
                      ClipRRect(
                        borderRadius: BorderRadius.circular(Insets.xs),
                        child: Image.asset(
                          item["image"]!,
                          height: AppSizes.h(context, 50),
                          width: AppSizes.w(context, 50),
                          fit: BoxFit.cover,
                        ),
                      ),

                      SizedBox(width: Insets.xsm),

                      /// 📝 Text
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item["title"]!,
                              style: TextStyle(
                                fontSize: AppSizes.w(context, 14),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: AppSizes.h(context, 4)),
                            Text(
                              item["subtitle"]!,
                              style: TextStyle(
                                fontSize: AppSizes.w(context, 12),
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),

                      /// ✅ Tick
                      if (isSelected)
                        Container(
                          height: AppSizes.h(context, 26),
                          width: AppSizes.w(context, 26),
                          decoration: BoxDecoration(
                            color: tickColor,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.check,
                            color: AppColors.naturalWhite,
                            size: 16,
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),

          SizedBox(height: AppSizes.h(context, 16)),

          /// 📍 Address Title
          Padding(
            padding: EdgeInsets.symmetric(horizontal: Insets.sm),
            child: Text(
              UserMessages.yourAddress,
              style: TextStyle(
                fontSize: AppSizes.w(context, 17),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          SizedBox(height: AppSizes.h(context, 8)),

          Consumer<AddressProvider>(
            builder: (context, addressProvider, child) {
              // Sync address controller if provider has a selected location
              if (addressProvider.selectedLocation != null) {
                addressController.text = addressProvider.selectedLocation!['address'];
              }
              
              return GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  Navigator.pushNamed(context, AppRoutes.selectLocation);
                },
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: Insets.sm),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Insets.xsm),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: TextField(
                    controller: addressController,
                    maxLines: 3,
                    readOnly: true,
                    onTap: () => Navigator.pushNamed(context, AppRoutes.selectLocation),
                    decoration: InputDecoration(
                      hintText: UserMessages.enterYourAddress,
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(Insets.xsm),
                    ),
                  ),
                ),
              );
            },
          ),

          SizedBox(height: AppSizes.h(context, 10)),

          /// 🗺 Map Options
          Padding(
            padding: EdgeInsets.symmetric(horizontal: Insets.sm),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () => Navigator.pushNamed(context, AppRoutes.selectLocation),
                  child: Text(
                    UserMessages.chooseFromMap,
                    style: const TextStyle(color: Colors.blue),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: AppSizes.h(context, 16)),

          /// 📝 Description Title
          Padding(
            padding: EdgeInsets.symmetric(horizontal: Insets.sm),
            child: Text(
              UserMessages.descriptionTitle,
              style: TextStyle(
                fontSize: AppSizes.w(context, 16),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          SizedBox(height: AppSizes.h(context, 8)),

          Container(
            margin: EdgeInsets.symmetric(horizontal: Insets.sm),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Insets.xsm),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: TextField(
              controller: descriptionController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: UserMessages.enterDescription,
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(Insets.xsm),
              ),
            ),
          ),
        ],
      ),
    );
  }
}