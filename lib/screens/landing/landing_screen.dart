import 'package:flutter/material.dart';
import 'package:zeerah/core/common/app_exports.dart';
import 'package:zeerah/screens/handyman%20services/bookings/booking_history.dart';
import 'package:zeerah/screens/home/home_page.dart';
import 'package:zeerah/screens/message/message_screen.dart';
import 'package:zeerah/screens/profile/profile_screen.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  int currentIndex = 0;

  late PageController _pageController;

  final List<Widget> pages = [
    const HomePage(),
    BookingHistory(),
    const MessageScreen(),
    ProfileScreen(user: UserModel.mock()),
  ];

  final List<IconData> icons = [
    Icons.home,
    Icons.calendar_today,
    Icons.chat,
    Icons.person,
  ];

  final List<String> labels = [
    UserMessages.home,
    UserMessages.bookings,
    UserMessages.chat,
    UserMessages.profile,
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: currentIndex);
  }

  void onTabTapped(int index) {
    setState(() {
      currentIndex = index;
    });
    _pageController.jumpToPage(index);
  }

  double _getPosition(double width) {
    int itemCount = icons.length;
    double itemWidth = width / itemCount;
    return itemWidth * currentIndex + itemWidth / 2 - AppSizes.w(context, 30);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.naturalWhite,
        body: PageView(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: pages,
        ),
        bottomNavigationBar: LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;

            return SizedBox(
              height: AppSizes.h(context, 82),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned.fill(
                    child: CustomPaint(
                      painter: NavBarPainter(
                        centerX: _getPosition(width) + AppSizes.w(context, 30),
                      ),
                    ),
                  ),
                  Row(
                    children: List.generate(icons.length, (index) {
                      final isSelected = index == currentIndex;

                      return Expanded(
                        child: GestureDetector(
                          onTap: () => onTabTapped(index),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              SizedBox(height: AppSizes.h(context, 18)),
                              Icon(
                                icons[index],
                                color: isSelected
                                    ? AppColors.selectedNavColor
                                    : AppColors.unselectedNavColor,
                              ),
                              SizedBox(height: AppSizes.h(context, 4)),
                              Text(
                                labels[index],
                                style: TextStyle(
                                  color: isSelected
                                      ? AppColors.selectedNavColor
                                      : AppColors.unselectedNavColor,
                                  fontSize: AppSizes.w(context, 11),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ),
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOut,
                    left: _getPosition(width),
                    top: -AppSizes.h(context, 38),
                    child: Container(
                      height: AppSizes.h(context, 60),
                      width: AppSizes.w(context, 60),
                      decoration: BoxDecoration(
                        color: AppColors.selectedNavColor,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.naturalBlack.withOpacity(0.25),
                            blurRadius: AppSizes.w(context, 10),
                          )
                        ],
                      ),
                      child: Icon(
                        icons[currentIndex],
                        color: AppColors.naturalWhite,
                        size: AppSizes.w(context, 28),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class NavBarPainter extends CustomPainter {
  final double centerX;

  const NavBarPainter({required this.centerX});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.navBarBgColor
      ..style = PaintingStyle.fill;

    final path = Path();

    path.moveTo(0, 0);
    path.lineTo(centerX - 65, 0);
    path.quadraticBezierTo(
      centerX - 45, 0,
      centerX - 35, 15,
    );
    path.quadraticBezierTo(
      centerX, 55,
      centerX + 35, 15,
    );
    path.quadraticBezierTo(
      centerX + 45, 0,
      centerX + 65, 0,
    );
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    
    canvas.drawShadow(path, AppColors.naturalBlack, 6, true);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant NavBarPainter oldDelegate) {
    return oldDelegate.centerX != centerX;
  }
}