import 'package:card_swiper/card_swiper.dart';
import 'package:zeerah/core/common/app_exports.dart';

class ExploreCategoryStack extends StatefulWidget {
  const ExploreCategoryStack({super.key});

  @override
  State<ExploreCategoryStack> createState() => _ExploreCategoryStackState();
}

class _ExploreCategoryStackState extends State<ExploreCategoryStack> {
  final List<String> images = [
    UserMessages.exploreCategory1,
    UserMessages.exploreCategory2,
    UserMessages.exploreCategory3,
    UserMessages.exploreCategory4,
  ];

  final SwiperController _swiperController = SwiperController();
  int currentIndex = 0;
  int _leftPanelIndex = 0;

  @override
  void initState() {
    super.initState();
    _leftPanelIndex = (images.length - 1) % images.length;
  }

  @override
  void dispose() {
    _swiperController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const double cardHeight = 320;
    const double cardWidth = 220;

    return SizedBox(
      height: cardHeight,
      child: Stack(
        children: [
          /// LEFT SIDE PEEK IMAGE
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            child: SizedBox(
              width: AppSizes.w(context, 35),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  switchInCurve: Curves.easeInOut,
                  switchOutCurve: Curves.easeInOut,
                  layoutBuilder: (currentChild, previousChildren) {
                    return Stack(
                      fit: StackFit.expand,
                      children: [
                        ...previousChildren,
                        if (currentChild != null) currentChild,
                      ],
                    );
                  },
                  transitionBuilder: (child, animation) {
                    return FadeTransition(
                      opacity: animation,
                      child: child,
                    );
                  },
                  child: SizedBox.expand(
                    key: ValueKey(_leftPanelIndex),
                    child: Image.asset(
                      images[_leftPanelIndex],
                      fit: BoxFit.cover,
                      filterQuality: FilterQuality.high,
                    ),
                  ),
                ),
              ),
            ),
          ),

          /// SWIPER CARDS
          Padding(
            padding: EdgeInsets.only(left: AppSizes.w(context, 25)),
            child: Swiper(
              controller: _swiperController,
              itemCount: images.length,
              itemWidth: cardWidth,
              itemHeight: cardHeight,
              layout: SwiperLayout.STACK,
              axisDirection: AxisDirection.right,
              loop: true,
              scale: 0.92,
              fade: 0.2,
              onIndexChanged: (index) {
                final next = index % images.length;
                setState(() {
                  currentIndex = next;
                  _leftPanelIndex =
                      (next - 1 + images.length) % images.length;
                });
              },
              itemBuilder: (context, index) =>
                  _card(context, index, cardWidth, cardHeight),
            ),
          ),
        ],
      ),
    );
  }

  /// CARD UI
  Widget _card(
      BuildContext context, int index, double width, double height) {
    final bool showBookNow = index == 0;

    return ClipRRect(
      borderRadius: BorderRadius.circular(Insets.md),
      child: SizedBox(
        width: width,
        height: height,
        child: Stack(
          children: [
            /// ✅ FIX: FULL IMAGE FILL (NO BLACK GAP)
            Positioned.fill(
             
              child: Image.asset(
                  scale: 1.02, // 
                images[index],
                fit: BoxFit.cover,
                alignment: Alignment.center,
                filterQuality: FilterQuality.high,
              ),
            ),

            /// OVERLAY
            Positioned.fill(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color.fromRGBO(0, 0, 0, 0.3),
                      Color.fromRGBO(0, 0, 0, 0.3),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ),

            /// BOOK NOW BUTTON
            if (showBookNow)
              Positioned(
                bottom: Insets.xsm,
                left: Insets.xsm,
                right: Insets.xsm,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: Insets.xxs,
                    vertical: Insets.xxs,
                  ),
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(255, 255, 255, 0.1),
                    borderRadius: BorderRadius.circular(Insets.lg),
                    border: Border.all(
                      color: AppColors.naturalWhite,
                      width: 0.5,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(Insets.xxs),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.darkGray,
                        ),
                        child: const Icon(
                          Icons.delete_outline,
                          color: AppColors.naturalWhite,
                        ),
                      ),
                      SizedBox(width: Insets.xs),
                      const Expanded(
                        child: Text(
                          UserMessages.bookNow,
                          style: TextStyle(
                            color: AppColors.naturalWhite,
                            fontWeight: FontWeight.w700,
                            fontSize: 17,
                          ),
                        ),
                      ),
                      const CircleAvatar(
                        radius: 14,
                        backgroundColor: AppColors.naturalBlack,
                        child: Icon(
                          Icons.arrow_forward_ios,
                          size: 16,
                          color: AppColors.naturalWhite,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}