import 'package:zeerah/screens/auth/otp_verification.dart';
import 'package:zeerah/screens/auth/sign_in_screen.dart';
import 'package:zeerah/screens/auth/splash_screen.dart';
import 'package:zeerah/screens/cetagories/service_cetagorices.dart';
import 'package:zeerah/screens/chat/chat_room_screen.dart';
import 'package:zeerah/screens/handyman%20services/bookings/booking_history.dart';
import 'package:zeerah/screens/home/home_page.dart';
import 'package:zeerah/screens/booking/booking_config_screen.dart';
import 'package:zeerah/screens/cetagories/category_details_screen.dart';
import 'package:zeerah/screens/cetagories/service_details_screen.dart';
import 'package:zeerah/screens/booking_flow/booking_confirmed_screen.dart';
import 'package:zeerah/screens/booking_flow/booking_status_screen.dart';
import 'package:zeerah/screens/booking_flow/professional_assigned_screen.dart';
import 'package:zeerah/screens/booking_flow/service_verification_screen.dart';
import 'package:zeerah/screens/handyman%20services/bookings/booking_home_page.dart';
import 'package:zeerah/screens/handyman%20services/bookings/bookig_sevice_progress_home.dart';
import 'package:zeerah/core/common/app_exports.dart';
import 'package:zeerah/screens/notifications/notification_history.dart';
import 'package:zeerah/screens/profile%20kyc/kyc_verifaication.dart';
import 'package:zeerah/screens/profile/favorie_service_history.dart';

class AppPages {
  static Map<String, WidgetBuilder> routes = {
    AppRoutes.splash: (context) => SplashScreen(),
    AppRoutes.signIn: (context) => SignInScreen(),
    AppRoutes.otpVerifly: (context) => OtpVerification(),
    AppRoutes.homePage: (context) => const HomePage(),
    AppRoutes.serviceCategories: (context) {
      final title = ModalRoute.of(context)!.settings.arguments as String;
      return ServiceCetagorices(title: title);
    },
    AppRoutes.cleaningServices: (context) {
      final categoryName = ModalRoute.of(context)!.settings.arguments as String;
      return CategoryDetailsScreen(categoryName: categoryName);
    },
    AppRoutes.serviceDetails: (context) {
      final service =
          ModalRoute.of(context)!.settings.arguments as CategoryItem;
      return ServiceDetailsScreen(service: service);
    },
    AppRoutes.bookingConfig: (context) {
      final service =
          ModalRoute.of(context)!.settings.arguments as CategoryItem;
      return BookingConfigScreen(service: service);
    },
    AppRoutes.bookingConfirmed: (context) {
      final service =
          ModalRoute.of(context)!.settings.arguments as CategoryItem;
      return BookingConfirmedScreen(service: service);
    },
    AppRoutes.bookingStatus: (context) {
      final service =
          ModalRoute.of(context)!.settings.arguments as CategoryItem;
      return BookingStatusScreen(service: service);
    },
    AppRoutes.professionalAssigned: (context) {
      final args = ModalRoute.of(context)!.settings.arguments;
      if (args is Map<String, dynamic>) {
        return ProfessionalAssignedScreen(
          service: args['service'] as CategoryItem,
          bookingStatus: args['status'] as BookingStatusModel,
        );
      }
      return ProfessionalAssignedScreen(
        service: args as CategoryItem,
        bookingStatus: const BookingStatusModel(
          currentState: BookingState.assigned,
        ),
      );
    },
    AppRoutes.serviceVerification: (context) {
      final args = ModalRoute.of(context)!.settings.arguments;
      if (args is Map<String, dynamic>) {
        return ServiceVerificationScreen(
          service: args['service'] as CategoryItem,
          bookingStatus: args['status'] as BookingStatusModel,
        );
      }
      return ServiceVerificationScreen(
        service: args as CategoryItem,
        bookingStatus: const BookingStatusModel(
          currentState: BookingState.arrived,
        ),
      );
    },
    AppRoutes.bookingHomePage: (context) {
      final service =
          ModalRoute.of(context)!.settings.arguments as CategoryItem;
      return BookingHomePage(service: service);
    },
    AppRoutes.serviceInProgress: (context) =>
        const BookingServiceProgressHome(serviceDurationInSeconds: 10),
    AppRoutes.notificationHistory: (context) => const NotificationHistory(),
    AppRoutes.kycVerfication:(context)=>const KycVerifaication(),
    AppRoutes.bookingHistory:(context)=>BookingHistory(),
    AppRoutes.favoitesHistory:(context)=>FavorieServiceHistory(),

    AppRoutes.chatHomeScreen:(context)=>ChatRoomScreen()
  };
}
