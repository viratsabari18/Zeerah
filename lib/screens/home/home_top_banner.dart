import 'package:carousel_slider/carousel_slider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:zeerah/core/providers/address_provider.dart';
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
      padding: EdgeInsets.symmetric(horizontal: Insets.sm, vertical: Insets.xs),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left: Location Section
          Expanded(
            child: Consumer<AddressProvider>(
              builder: (context, provider, _) {
                final selectedLoc = provider.selectedLocation;
                final String address = selectedLoc?['address'] ?? "Select your location";
                
                return GestureDetector(
                  onTap: () => Navigator.pushNamed(context, AppRoutes.selectLocation),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.near_me, color: Colors.black, size: 18),
                          const SizedBox(width: 8),
                          Text(
                            "Shivam",
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w500,
                              fontSize: 17,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              address,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                         
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          // Right: Wallet + Profile and Notification
          Row(
            children: [
              // Wallet + Profile Pill
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.85),
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(width: 8),
                    Image.asset(
                      UserMessages.homepageAppbarCoin,
                      height: 24,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      "₹200",
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () => Navigator.pushNamed(context, AppRoutes.profile),
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: const BoxDecoration(
                          color: Color(0xFFE53935),
                          shape: BoxShape.circle,
                        ),
                        child: const CircleAvatar(
                          radius: 14,
                          backgroundColor: Color(0xFFE53935),
                          child: Icon(Icons.person, color: Colors.white, size: 18),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              // Notification Icon
              GestureDetector(
                onTap: () => Navigator.pushNamed(context, AppRoutes.notificationHistory),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    const Icon(Icons.notifications, color: Colors.black, size: 32),
                    Positioned(
                      right: -2,
                      top: -2,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Color(0xFFFFD600),
                          shape: BoxShape.circle,
                        ),
                        child: const Text(
                          "3",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
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
    );
  }
}
