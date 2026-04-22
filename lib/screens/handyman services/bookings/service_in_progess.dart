import 'dart:async';
import 'package:zeerah/core/common/app_exports.dart';
import 'package:zeerah/screens/handyman%20services/bookings/end_otp_screen.dart';
import 'package:zeerah/screens/handyman%20services/bookings/service_details_card.dart';
import 'package:zeerah/screens/handyman%20services/bookings/service_progress_widget.dart';

class ServiceInProgress extends StatefulWidget {
  final int serviceDuration; // Receive duration from first widget
  
  const ServiceInProgress({
    super.key,
    required this.serviceDuration,
  });

  @override
  State<ServiceInProgress> createState() => _ServiceInProgressState();
}

class _ServiceInProgressState extends State<ServiceInProgress> {
  late Timer _timer;
  late int totalSeconds;
  bool isCompleted = false;

  @override
  void initState() {
    super.initState();
    totalSeconds = widget.serviceDuration; // Use the duration passed from first widget
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (totalSeconds > 0) {
          totalSeconds--;
          // Check if timer has completed
          if (totalSeconds == 0) {
            _handleServiceCompletion();
          }
        }
      });
    });
  }

  void _handleServiceCompletion() {
    // Stop the timer first
    _timer.cancel();
    
   
    setState(() {
      isCompleted = true;
    });
    
    print("Service completed automatically after ${widget.serviceDuration} seconds");
    

  }


  String formatTime(int seconds) {
    int h = seconds ~/ 3600;
    int m = (seconds % 3600) ~/ 60;
    int s = seconds % 60;
    return "${h.toString().padLeft(2, '0')}:"
        "${m.toString().padLeft(2, '0')}:"
        "${s.toString().padLeft(2, '0')}";
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.naturalWhite,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  Image.asset(
                    !isCompleted
                        ? UserMessages.serviceInProgressImage
                        : UserMessages.serviceCompletedImage,
                    height: AppSizes.h(context, 200),
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  if (!isCompleted) ...[
                    Padding(
                      padding: EdgeInsets.only(left: AppSizes.w(context, 90)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            UserMessages.liveTimer,
                            style: TextStyle(
                              color: AppColors.primaryRed,
                              fontSize: AppSizes.w(context, 12),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: AppSizes.h(context, 5)),
                          Text(
                            formatTime(totalSeconds),
                            style: TextStyle(
                              fontSize: AppSizes.w(context, 30),
                              fontWeight: FontWeight.bold,
                              color: AppColors.naturalBlack,
                            ),
                          ),
                          SizedBox(height: AppSizes.h(context, 10)),
                          Text(
                            UserMessages.serviceRunning,
                            style: TextStyle(
                              color: AppColors.primaryRed,
                              fontSize: AppSizes.w(context, 18),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: AppSizes.h(context, 6)),
                          Text(
                            UserMessages.startedAt,
                            style: TextStyle(
                              fontSize: AppSizes.w(context, 13),
                              color: AppColors.primaryRed,
                            ),
                          ),
                          SizedBox(height: AppSizes.h(context, 4)),
                          Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: UserMessages.estimated,
                                  style: TextStyle(
                                    color: AppColors.primaryRed,
                                    fontSize: AppSizes.w(context, 13),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                TextSpan(
                                  text: UserMessages.estimatedTime,
                                  style: TextStyle(
                                    color: AppColors.naturalBlack54,
                                    fontSize: AppSizes.w(context, 13),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ] else ...[
                    Positioned(
                      bottom: AppSizes.h(context, 25),
                      left: 0,
                      right: 0,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(
                            UserMessages.progressClock,
                            width: AppSizes.w(context, 90),
                            height: AppSizes.h(context, 90),
                          ),
                          Text(
                            UserMessages.serviceComplete,
                            style: TextStyle(
                              color: AppColors.completedBlue,
                              fontSize: AppSizes.w(context, 20),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: AppSizes.h(context, 8)),
                          Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: UserMessages.handymanHas,
                                  style: TextStyle(
                                    color: AppColors.naturalBlack,
                                    fontSize: AppSizes.w(context, 16),
                                  ),
                                ),
                                TextSpan(
                                  text: UserMessages.finished,
                                  style: TextStyle(
                                    color: AppColors.completedBlue,
                                    fontSize: AppSizes.w(context, 16),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                TextSpan(
                                  text: UserMessages.theService,
                                  style: TextStyle(
                                    color: AppColors.naturalBlack,
                                    fontSize: AppSizes.w(context, 16),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
              Transform.translate(
                offset: Offset(0, -Insets.sm),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.naturalWhite,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(Insets.md),
                      topRight: Radius.circular(Insets.md),
                    ),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(Insets.sm),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              radius: AppSizes.w(context, 28),
                              backgroundColor: Colors.grey,
                              backgroundImage: const NetworkImage(
                                UserMessages.profileImageUrl,
                              ),
                              onBackgroundImageError: (_, __) {},
                              child: const Icon(
                                Icons.person,
                                color: AppColors.naturalBlack,
                              ),
                            ),
                            SizedBox(width: Insets.xsm),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    UserMessages.profileName,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: AppSizes.w(context, 16),
                                    ),
                                  ),
                                  SizedBox(height: AppSizes.h(context, 4)),
                                  Text(
                                    UserMessages.professionalRating,
                                    style: TextStyle(fontSize: AppSizes.w(context, 12)),
                                  ),
                                  SizedBox(height: AppSizes.h(context, 6)),
                                  Text(
                                    isCompleted
                                        ? UserMessages.serviceCompletedText
                                        : UserMessages.serviceInProgressText,
                                    style: TextStyle(
                                      color: isCompleted
                                          ? AppColors.completedBlue
                                          : AppColors.primaryRed,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: Insets.xsm,
                                vertical: Insets.xxs,
                              ),
                              decoration: BoxDecoration(
                                color: isCompleted
                                    ? AppColors.completedBlue
                                    : AppColors.progressGreen,
                                borderRadius: BorderRadius.circular(Insets.xs),
                              ),
                              child: Text(
                                isCompleted ? UserMessages.completed : UserMessages.inProgress,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.naturalWhite,
                                  fontSize: AppSizes.w(context, 12),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: AppSizes.h(context, 15)),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: Insets.sm),
                        child: Row(
                          children: [
                            Container(
                              height: AppSizes.h(context, 45),
                              padding: EdgeInsets.symmetric(
                                vertical: Insets.xs,
                                horizontal: Insets.md,
                              ),
                              decoration: BoxDecoration(
                                color: isCompleted ? AppColors.darkRed : AppColors.primaryYellow,
                                borderRadius: BorderRadius.circular(Insets.xsm),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.phone_outlined,
                                    color: isCompleted ? AppColors.naturalWhite : AppColors.primaryRed,
                                  ),
                                  SizedBox(width: Insets.xxs),
                                  Text(
                                    UserMessages.call,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: isCompleted ? AppColors.naturalWhite : AppColors.naturalBlack,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: AppSizes.w(context, 36)),
                            Container(
                              height: AppSizes.h(context, 45),
                              padding: EdgeInsets.symmetric(
                                vertical: Insets.xxs,
                                horizontal: Insets.md,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(color: AppColors.primaryRed),
                                borderRadius: BorderRadius.circular(Insets.xsm),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.chat, color: AppColors.primaryRed),
                                  SizedBox(width: Insets.xxs),
                                  Text(
                                    UserMessages.chat,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.darkRed,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: AppSizes.h(context, 20)),
                      if (isCompleted) ...[
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: Insets.sm),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    Icons.check_circle,
                                    color: AppColors.completedBlue,
                                    size: 20,
                                  ),
                                  SizedBox(width: Insets.xxs),
                                  Text.rich(
                                    TextSpan(
                                      children: [
                                        TextSpan(
                                          text: UserMessages.completedLabel,
                                          style: TextStyle(
                                            color: AppColors.completedBlue,
                                            fontWeight: FontWeight.w600,
                                            fontSize: AppSizes.w(context, 14),
                                          ),
                                        ),
                                        TextSpan(
                                          text: UserMessages.completedTime,
                                          style: TextStyle(
                                            color: AppColors.naturalBlack,
                                            fontWeight: FontWeight.w600,
                                            fontSize: AppSizes.w(context, 14),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: AppSizes.h(context, 6)),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.check_circle,
                                    color: AppColors.completedBlue,
                                    size: 20,
                                  ),
                                  SizedBox(width: Insets.xxs),
                                  Text.rich(
                                    TextSpan(
                                      children: [
                                        TextSpan(
                                          text: UserMessages.stoppageTimeLabel,
                                          style: TextStyle(
                                            color: AppColors.completedBlue,
                                            fontWeight: FontWeight.w600,
                                            fontSize: AppSizes.w(context, 14),
                                          ),
                                        ),
                                        TextSpan(
                                          text: UserMessages.stoppageTimeValue,
                                          style: TextStyle(
                                            color: AppColors.naturalBlack,
                                            fontWeight: FontWeight.w600,
                                            fontSize: AppSizes.w(context, 14),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: AppSizes.h(context, 20)),
                            ],
                          ),
                        ),
                      ],
                      SizedBox(height: AppSizes.h(context, 15)),
                      if (isCompleted) ...[
                        const EndOtpView(),
                      ] else ...[
                        const ServiceProgressWidget(),
                        SizedBox(height: AppSizes.h(context, 7)),
                        const ServiceDetailsCard(),
                        SizedBox(height: AppSizes.h(context, 30)),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}