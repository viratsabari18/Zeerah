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
    const MessageScreen(),
     BookingHistory(),
    ProfileScreen(user: UserModel.mock()),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void onTabTapped(int index) {
    setState(() {
      currentIndex = index;
    });

    _pageController.jumpToPage(index);
  }

  Widget _navIcon(IconData icon, int index) {
    final isSelected = currentIndex == index;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      padding: EdgeInsets.all(Insets.xxs),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.darkRed.withOpacity(0.6) : Colors.transparent,
        borderRadius: BorderRadius.circular(Insets.xs),
      ),
      child: Icon(
        icon,
        size: isSelected ? AppSizes.w(context, 26) : AppSizes.w(context, 22),
        color: isSelected ? AppColors.naturalWhite : AppColors.naturalWhite70,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: pages,
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: AppColors.primaryRed,
          boxShadow: [BoxShadow(color: AppColors.naturalBlack26, blurRadius: 10)],
        ),
        child: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: onTabTapped,
          type: BottomNavigationBarType.fixed,
          backgroundColor: AppColors.primaryRed,
          elevation: 0,
          selectedItemColor: AppColors.naturalWhite,
          selectedLabelStyle: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: AppSizes.w(context, 12),
          ),
          unselectedItemColor: AppColors.naturalWhite70,
          unselectedLabelStyle: TextStyle(fontSize: AppSizes.w(context, 11)),
          items: [
            BottomNavigationBarItem(
              icon: _navIcon(Icons.home, 0),
              label: UserMessages.home,
            ),
            BottomNavigationBarItem(
              icon: _navIcon(Icons.calendar_today, 1),
              label: UserMessages.bookings,
            ),
            BottomNavigationBarItem(
              icon: _navIcon(Icons.chat, 2),
              label: UserMessages.chat,
            ),
            BottomNavigationBarItem(
              icon: _navIcon(Icons.person, 3),
              label: UserMessages.profile,
            ),
          ],
        ),
      ),
    );
  }
}