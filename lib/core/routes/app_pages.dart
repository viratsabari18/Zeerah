import 'package:flutter/cupertino.dart';
import 'package:zeerah/core/routes/app_routes.dart';
import 'package:zeerah/screens/auth/otp_verification.dart';
import 'package:zeerah/screens/auth/sign_in_screen.dart';
import 'package:zeerah/screens/auth/splash_screen.dart';
import 'package:zeerah/screens/cetagories/service_cetagorices.dart';
import 'package:zeerah/screens/handyman%20services/bookings/booking_home_page.dart';
import 'package:zeerah/screens/handyman%20services/bookings/bookig_sevice_progress_home.dart';
import 'package:zeerah/screens/handyman%20services/bookings/service_in_progess.dart';

import 'package:zeerah/screens/handyman%20services/payments/payments_home_page.dart';
import 'package:zeerah/screens/handyman%20services/reviews/ratings_and_review_screen.dart';
import 'package:zeerah/screens/home/home_page.dart';

class AppPages {
  static Map<String, WidgetBuilder> routes = {
    AppRoutes.splash: (context) => SplashScreen(),
    AppRoutes.signIn: (context) => SignInScreen(),
    AppRoutes.otpVerifly: (context) => OtpVerification(),
    AppRoutes.homePage: (context) => HomePage(),
    AppRoutes.serviceCategories: (context) {
      final title = ModalRoute.of(context)!.settings.arguments as String;
      return ServiceCetagorices(title: title);
    },

    AppRoutes.serviceBookings: (context) => BookingHomePage(),
    AppRoutes.serviceInProgress: (context) =>
        ServiceInProgress(serviceDuration: 10),
    AppRoutes.bookingServiceProgressHomePage: (context) =>
        BookingServiceProgressHome(serviceDurationInSeconds: 10),
    AppRoutes.paymentsHomePage: (context) => PaymentsHomePage(),
    AppRoutes.serviceReviewScreen: (context) => RatingsAndReviewScreen(),
  };
}
