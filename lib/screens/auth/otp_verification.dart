import 'package:zeerah/core/common/app_exports.dart';

class OtpVerification extends StatefulWidget {
  const OtpVerification({super.key});

  @override
  State<OtpVerification> createState() => _OtpVerificationState();
}

class _OtpVerificationState extends State<OtpVerification> {
  final int otpLength = 6;

  late List<TextEditingController> controllers;
  late List<FocusNode> focusNodes;

  @override
  void initState() {
    super.initState();
    controllers = List.generate(otpLength, (index) => TextEditingController());
    focusNodes = List.generate(otpLength, (index) => FocusNode());
  }

  @override
  void dispose() {
    for (var c in controllers) {
      c.dispose();
    }
    for (var f in focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  void handleOtpChange(String value, int index) {
    if (value.isNotEmpty) {
      if (index < otpLength - 1) {
        focusNodes[index + 1].requestFocus();
      } else {
        focusNodes[index].unfocus();
      }
    } else {
      if (index > 0) {
        focusNodes[index - 1].requestFocus();
      }
    }
  }

  String getOtp() {
    return controllers.map((e) => e.text).join();
  }

  void showOtpSuccessDialog(BuildContext context) {
    final w = AppSizes.width(context);
    final h = AppSizes.height(context);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: Insets.md,
              vertical: Insets.md,
            ),
            decoration: BoxDecoration(
              color: AppColors.naturalWhite,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: h * 0.12,
                  width: h * 0.12,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFFBC0D),
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.check,
                      color: Colors.red,
                      size: 50,
                      weight: 700,
                    ),
                  ),
                ),
                SizedBox(height: h * 0.025),
                Text(
                  UserMessages.otpVerified,
                  style: TextStyles.h2.copyWith(
                    color: AppColors.naturalBlack,
                    fontSize: w * 0.055,
                  ),
                ),
                SizedBox(height: h * 0.012),
                Text(
                  UserMessages.phoneNumberVerified,
                  textAlign: TextAlign.center,
                  style: TextStyles.bodySmall.copyWith(
                    color: AppColors.naturalBlack,
                    fontSize: w * 0.035,
                  ),
                ),
                SizedBox(height: h * 0.025),
                SizedBox(
                  width: double.infinity,
                  height: h * 0.065,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryYellow,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      // Navigator.pop(context);
                      Navigator.pushNamed(context, AppRoutes.homePage);
                    },
                    child: Text(
                      UserMessages.continueMsg,
                      style: TextStyles.button.copyWith(
                        color: AppColors.naturalBlack,
                        fontWeight: FontWeight.bold,
                        fontSize: w * 0.045,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget otpBox(int index, double boxWidth) {
    return Container(
      width: boxWidth,
      height: boxWidth * 1.2,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.naturalWhite,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: controllers[index],
        focusNode: focusNodes[index],
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          height: 1,
          color: Colors.black,
        ),
        decoration: const InputDecoration(
          counterText: "",
          border: InputBorder.none,
          contentPadding: EdgeInsets.zero,
        ),
        onChanged: (value) => handleOtpChange(value, index),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final w = AppSizes.width(context);
    final h = AppSizes.height(context);

    double horizontalPadding = Insets.md * 2;
    double spacing = Insets.xs * (otpLength - 1);
    double availableWidth = w - horizontalPadding - spacing;
    double boxWidth = availableWidth / otpLength;

    boxWidth = boxWidth.clamp(45.0, 75.0);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.primaryRed,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: Insets.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: h * 0.02),

              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Icon(Icons.arrow_back_ios, color: Colors.white),
              ),

              SizedBox(height: h * 0.03),

              Text(
                UserMessages.logIn,
                style: TextStyles.h2.copyWith(
                  color: Colors.white,
                  fontSize: w * 0.06,
                ),
              ),

              SizedBox(height: h * 0.01),

              Text(
                UserMessages.enterTheOtp,
                style: TextStyles.bodySmall.copyWith(
                  color: AppColors.naturalWhite,
                  fontWeight: FontWeight.w500,
                  fontSize: w * 0.035,
                ),
              ),

              SizedBox(height: h * 0.04),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(otpLength, (index) {
                  return Padding(
                    padding: EdgeInsets.only(
                      right: index == otpLength - 1 ? 0 : Insets.xs,
                    ),
                    child: otpBox(index, boxWidth),
                  );
                }),
              ),

              SizedBox(height: h * 0.04),

              SizedBox(
                width: double.infinity,
                height: h * 0.065,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryYellow,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    String otp = getOtp();
                    if (otp.length == 6) {
                      showOtpSuccessDialog(context);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(UserMessages.enterVaildOtp),
                        ),
                      );
                    }
                  },
                  child: Text(
                    UserMessages.veriflyOtp,
                    style: TextStyles.button.copyWith(
                      color: AppColors.naturalBlack,
                      fontWeight: FontWeight.bold,
                      fontSize: w * 0.045,
                    ),
                  ),
                ),
              ),

              SizedBox(height: h * 0.02),

              RichText(
                text: TextSpan(
                  style: TextStyles.bodySmall.copyWith(
                    color: Colors.white70,
                    fontSize: w * 0.035,
                  ),
                  children: [
                    TextSpan(text: UserMessages.doNotReciveYourCode),
                    TextSpan(
                      text: UserMessages.resendOtp,
                      style: TextStyles.bodySmall.copyWith(
                        color: AppColors.primaryYellow,
                        fontWeight: FontWeight.w600,
                        fontSize: w * 0.035,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: h * 0.08),

              Center(
                child: Image.asset(
                  UserMessages.veriflyOtpImage,
                  height: h * 0.28,
                  width: w * 0.6,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
