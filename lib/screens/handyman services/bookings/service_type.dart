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

          Consumer<AddressProvider>(
            builder: (context, addressProvider, child) {
              final selectedLocation = addressProvider.selectedLocation;
              
              if (selectedLocation == null) {
                return GestureDetector(
                  onTap: () => Navigator.pushNamed(context, AppRoutes.selectLocation),
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: Insets.sm),
                    padding: EdgeInsets.all(Insets.sm),
                    decoration: BoxDecoration(
                      color: AppColors.naturalWhite,
                      borderRadius: BorderRadius.circular(Insets.sm),
                      border: Border.all(color: Colors.grey.shade300, width: 1),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.add_location_alt_outlined, color: AppColors.primaryRed),
                        SizedBox(width: Insets.sm),
                        Text(
                          UserMessages.enterYourAddress,
                          style: TextStyle(
                            color: AppColors.naturalBlack.withOpacity(0.6),
                            fontSize: AppSizes.w(context, 14),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const Spacer(),
                        const Icon(Icons.chevron_right, color: Colors.grey),
                      ],
                    ),
                  ),
                );
              }

              String label = selectedLocation['label'] ?? "Address";
              String displayAddress = selectedLocation['address'] ?? "";
              
              return Container(
                margin: EdgeInsets.symmetric(horizontal: Insets.sm),
                padding: EdgeInsets.all(Insets.sm),
                decoration: BoxDecoration(
                  color: AppColors.naturalWhite,
                  borderRadius: BorderRadius.circular(Insets.sm),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.naturalBlack.withOpacity(0.08),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(Insets.xs),
                      decoration: BoxDecoration(
                        color: AppColors.primaryRed.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.location_on,
                        color: AppColors.primaryRed,
                        size: 24,
                      ),
                    ),
                    SizedBox(width: Insets.sm),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            UserMessages.yourAddress,
                            style: TextStyle(
                              fontSize: AppSizes.w(context, 14),
                              fontWeight: FontWeight.w700,
                              color: AppColors.naturalBlack,
                            ),
                          ),
                          Text(
                            label,
                            style: TextStyle(
                              fontSize: AppSizes.w(context, 11),
                              fontWeight: FontWeight.w600,
                              color: AppColors.primaryRed,
                            ),
                          ),
                          SizedBox(height: AppSizes.h(context, 2)),
                          Text(
                            displayAddress,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: AppSizes.w(context, 12),
                              color: AppColors.naturalBlack.withOpacity(0.6),
                              height: 1.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: Insets.sm),
                    TextButton(
                      onPressed: () => Navigator.pushNamed(context, AppRoutes.selectLocation),
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: Insets.xsm),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: const Text(
                        "Change",
                        style: TextStyle(
                          color: AppColors.primaryRed,
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
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