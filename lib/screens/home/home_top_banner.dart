import 'package:carousel_slider/carousel_slider.dart';

import 'package:zeerah/core/common/app_exports.dart';

class HomeTopBanner extends StatefulWidget {
  const HomeTopBanner({super.key});

  @override
  State<HomeTopBanner> createState() => _HomeTopBannerState();
}

class _HomeTopBannerState extends State<HomeTopBanner> {
  int currentIndex = 0;

  final List<String> banners = [
    UserMessages.homepageBannerDummy2,
    UserMessages.homepageBannerDummy3,
    UserMessages.homeBanner,
    UserMessages.homepageBannerDummy,
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppSizes.h(context, 325),
      child: Stack(
        children: [
          CarouselSlider(
            options: CarouselOptions(
              height: AppSizes.h(context, 325),
              autoPlay: true,
              viewportFraction: 1.0,
              onPageChanged: (index, reason) {
                setState(() {
                  currentIndex = index;
                });
              },
            ),
            items: banners.map((image) {
              return Image.asset(
                image,
                width: double.infinity,
                fit: BoxFit.cover,
              );
            }).toList(),
          ),
          Positioned(
            top: Insets.xs,
            left: 0,
            right: 0,
            child: SafeArea(child: _topAppBar(context)),
          ),
          Positioned(
            bottom: Insets.md,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(banners.length, (index) {
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: EdgeInsets.symmetric(horizontal: Insets.xxs),
                  width: currentIndex == index ? Insets.xsm : Insets.xxs,
                  height: Insets.xxs,
                  decoration: BoxDecoration(
                    color: currentIndex == index
                        ? AppColors.softBlue
                        : AppColors.naturalBlack.withOpacity(0.54),
                    borderRadius: BorderRadius.circular(Insets.xs),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _topAppBar(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Insets.xs),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: Insets.sm,
          vertical: Insets.xs,
        ),
        decoration: BoxDecoration(
          color: AppColors.naturalWhite.withOpacity(0.4),
          borderRadius: BorderRadius.circular(Insets.sm),
          boxShadow: [
            BoxShadow(
              color: AppColors.naturalBlack.withOpacity(0.1),
              blurRadius: Insets.xs,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Image.asset(
                        UserMessages.homeLocation,
                        height: AppSizes.h(context, 24),
                        color: AppColors.naturalBlack,
                      ),
                      SizedBox(width: Insets.xs),
                      Text(
                        "Shivam",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: AppSizes.w(context, 19),
                          color: AppColors.naturalBlack,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: Insets.xxxs),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          "Dada Colony, Chaukh...",
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: AppSizes.w(context, 13),
                            fontWeight: FontWeight.w500,
                            color: AppColors.naturalBlack,
                          ),
                        ),
                      ),
                      Icon(
                        Icons.keyboard_arrow_down,
                        size: AppSizes.w(context, 19),
                        color: AppColors.naturalBlack,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(width: Insets.xs),
            Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: Insets.xs,
                    vertical: Insets.xxs,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.softPeach,
                    borderRadius: BorderRadius.circular(Insets.md),
                  ),
                  child: Row(
                    children: [
                      Image.asset(
                        UserMessages.homepageAppbarCoin,
                        height: AppSizes.h(context, 20),
                      ),
                      SizedBox(width: Insets.xxs),
                      Text(
                        "₹200",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: AppSizes.w(context, 13),
                        ),
                      ),
                      SizedBox(width: Insets.xxs),
                      GestureDetector(
                        onTap: () => Navigator.pushNamed(context, AppRoutes.profile),
                        child: Container(
                          padding: EdgeInsets.all(Insets.xxs),
                          decoration: const BoxDecoration(
                            color: AppColors.primaryRed,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.person,
                            color: AppColors.naturalWhite,
                            size: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: Insets.xxxs),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, AppRoutes.notificationHistory);
                  },
                  child: Stack(
                    children: [
                      Image.asset(
                        UserMessages.homeNotifications,
                        height: AppSizes.h(context, 32),
                        color: AppColors.naturalBlack,
                      ),
                      Positioned(
                        right: 0,
                        top: -5,
                        child: Container(
                          padding: EdgeInsets.all(Insets.xxs),
                          decoration: BoxDecoration(
                            color: AppColors.brightYellow,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            "3",
                            style: TextStyle(
                              color: AppColors.naturalBlack,
                              fontSize: AppSizes.w(context, 11),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
