import 'dart:async';
import 'package:zeerah/core/common/app_exports.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushReplacementNamed(
          context,
          AppRoutes.signIn,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = AppSizes.width(context);

    return Scaffold(
      backgroundColor: AppColors.primaryRed,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(Insets.md),
            child: Image.asset(
              UserMessages.splashScreenImage,
              width: width * 0.6,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}