import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import 'package:zeerah/controllers/service%20_list_controller.dart';

import 'package:zeerah/core/common/app_exports.dart';
import 'package:zeerah/core/models/service_list_model.dart';

class CategoryDetailsScreen extends StatelessWidget {
  final String subcategoryName;
  final int subcategoryId;
  final String? parentCategoryName;

  const CategoryDetailsScreen({
    Key? key,
    required this.subcategoryName,
    required this.subcategoryId,
    this.parentCategoryName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Print the three arguments
    print("=== CategoryDetailsScreen Arguments ===");
    print("subcategoryName: $subcategoryName");
    print("subcategoryId: $subcategoryId");
    print("parentCategoryName: $parentCategoryName");
    print("=======================================");

    return Scaffold(
      backgroundColor: AppColors.categoryBgColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: EdgeInsets.all(Insets.xs),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.naturalWhite,
              borderRadius: BorderRadius.circular(Insets.xsm),
              boxShadow: [
                BoxShadow(
                  color: AppColors.naturalBlack.withOpacity(0.05),
                  blurRadius: AppSizes.w(context, 10),
                ),
              ],
            ),
            child: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new,
                size: 18,
                color: AppColors.naturalBlack87,
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
        title: Text(
          subcategoryName.replaceAll('\n', ' '),
          style: TextStyle(
            color: AppColors.naturalBlack87,
            fontWeight: FontWeight.bold,
            fontSize: AppSizes.w(context, 20),
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: EdgeInsets.all(Insets.xs),
            child: Container(
              width: AppSizes.w(context, 44),
              decoration: BoxDecoration(
                color: AppColors.naturalWhite,
                borderRadius: BorderRadius.circular(Insets.xsm),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.naturalBlack.withOpacity(0.05),
                    blurRadius: AppSizes.w(context, 10),
                  ),
                ],
              ),
              child: const Icon(Icons.notes, color: AppColors.naturalBlack87),
            ),
          ),
        ],
      ),
      body: Consumer<ServiceListController>(
        builder: (context, controller, _) {
          if (controller.serviceList.isEmpty && !controller.isLoading) {
            controller.setSubcategory(subcategoryId);
            controller.fetchServices();
          }

          if (controller.isLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primaryRed),
            );
          }

          if (controller.serviceList.isEmpty) {
            return Center(child: Text(UserMessages.noServicesFound));
          }

          return ListView.separated(
            padding: EdgeInsets.all(Insets.md),
            itemCount: controller.serviceList.length,
            separatorBuilder: (_, __) =>
                SizedBox(height: AppSizes.h(context, 16)),
            itemBuilder: (context, index) {
              final service = controller.serviceList[index];
              return _ServiceCard(service: service);
            },
          );
        },
      ),
    );
  }
}

class _ServiceCard extends StatelessWidget {
  final ServiceData service;

  const _ServiceCard({required this.service});

  @override
  Widget build(BuildContext context) {
    final List<Color> cardColors = [
      AppColors.cardLightGreen,
      AppColors.cardLightBlue,
      AppColors.cardLightYellow,
      AppColors.cardLightPink,
      AppColors.cardLightPurple,
      AppColors.cardLightTeal,
    ];
    final Color cardColor = cardColors[service.id! % cardColors.length];

    return Container(
      height: AppSizes.h(context, 160),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(Insets.lg),
      ),
      padding: EdgeInsets.all(Insets.xsm),
      child: Row(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: AppSizes.w(context, 130),
                height: AppSizes.h(context, 110),
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Insets.md),
                ),
                child: CachedNetworkImage(
                  imageUrl: service.providerImage?? "",
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                  placeholder: (context, url) => Container(
                    color: Colors.grey[300],
                    child: const Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppColors.naturalGray,
                        ),
                      ),
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: Colors.grey[300],
                    child: const Icon(
                      Icons.broken_image,
                      color: AppColors.naturalBlack26,
                    ),
                  ),
                ),
              ),
              SizedBox(height: AppSizes.h(context, 8)),
              GestureDetector(
                onTap: () {
                  HapticFeedback.selectionClick();
                  Navigator.pushNamed(
                    context,
                    AppRoutes.serviceDetails,
                    arguments: service,
                  );
                },
                child: Text(
                  UserMessages.viewDetails,
                  style: TextStyle(
                    fontSize: AppSizes.w(context, 11),
                    fontWeight: FontWeight.w700,
                    color: AppColors.naturalBlack,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(width: Insets.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.auto_fix_high,
                      size: 16,
                      color: AppColors.naturalBlack45,
                    ),
                    SizedBox(width: Insets.xxs),
                    Expanded(
                      child: Text(
                        service.name ?? "",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: AppSizes.w(context, 18),
                          fontWeight: FontWeight.bold,
                          color: AppColors.naturalBlack87,
                        ),
                      ),
                    ),
                    SizedBox(width: Insets.xxs),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: Insets.xxs,
                        vertical: Insets.xxxs,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.naturalWhite,
                        borderRadius: BorderRadius.circular(Insets.xs),
                      ),
                      child: Row(
                        children: [
                          Text(
                            service.totalRating?.toString() ??
                                UserMessages.defaultRating,
                            style: TextStyle(
                              fontSize: AppSizes.w(context, 12),
                              fontWeight: FontWeight.bold,
                              color: AppColors.naturalBlack87,
                            ),
                          ),
                          SizedBox(width: Insets.xxxs),
                          const Icon(
                            Icons.star,
                            size: 12,
                            color: AppColors.starOrange,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: AppSizes.h(context, 4)),
                Text(
                  service.description ?? UserMessages.defaultServiceDescription,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: AppSizes.w(context, 13),
                    color: AppColors.naturalBlack45,
                    letterSpacing: 0.2,
                  ),
                ),
                SizedBox(height: AppSizes.h(context, 16)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '₹${service.price ?? 0}',
                      style: TextStyle(
                        fontSize: AppSizes.w(context, 15),
                        fontWeight: FontWeight.bold,
                        color: AppColors.naturalBlack87,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        HapticFeedback.lightImpact();
                        Navigator.pushNamed(
                          context,
                          AppRoutes.bookingConfig,
                          arguments: service,
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: Insets.sm,
                          vertical: Insets.xs,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.bookNowButtonColor,
                          borderRadius: BorderRadius.circular(Insets.md),
                        ),
                        child: Text(
                          UserMessages.bookNow,
                          style: TextStyle(
                            color: AppColors.naturalWhite,
                            fontSize: AppSizes.w(context, 13),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
