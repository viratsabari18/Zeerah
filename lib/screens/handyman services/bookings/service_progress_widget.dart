import 'package:flutter/material.dart';
import 'package:zeerah/core/common/app_exports.dart';

class ServiceProgressWidget extends StatefulWidget {
  const ServiceProgressWidget({super.key});

  @override
  State<ServiceProgressWidget> createState() => _ServiceProgressWidgetState();
}

class _ServiceProgressWidgetState extends State<ServiceProgressWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final int currentStep = 3;
  final List<String> steps = [
    UserMessages.bookingConfirmed,
    UserMessages.professionalAssigned,
    UserMessages.onTheWay,
    UserMessages.serviceStarted,
    UserMessages.serviceCompleted
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget buildStep(int index) {
    bool isCompleted = index < currentStep;
    bool isActive = index == currentStep;
    bool isLast = index == steps.length - 1;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: AppSizes.h(context, 10)),
          child: Column(
            children: [
              AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Container(
                    width: AppSizes.w(context, 28),
                    height: AppSizes.h(context, 28),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isCompleted
                          ? AppColors.progressYellow
                          : isActive
                              ? AppColors.primaryYellow.withOpacity(0.5 + (_controller.value * 0.5))
                              : Colors.transparent,
                      border: Border.all(
                        color: isCompleted || isActive
                            ? AppColors.progressYellow
                            : AppColors.naturalBlack45,
                        width: 2,
                      ),
                    ),
                    child: isCompleted
                        ? const Icon(Icons.check, size: 16, color: AppColors.naturalWhite)
                        : isActive
                            ? Icon(Icons.radio_button_checked,
                                size: 14, color: AppColors.progressYellow)
                            : null,
                  );
                },
              ),
              if (!isLast)
                Column(
                  children: [
                    SizedBox(height: AppSizes.h(context, 6)),
                    Container(
                      width: 2,
                      height: AppSizes.h(context, 28),
                      color: AppColors.progressYellow,
                    ),
                  ],
                ),
            ],
          ),
        ),
        SizedBox(width: Insets.xsm),
        Expanded(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 400),
            margin: EdgeInsets.only(bottom: AppSizes.h(context, 10)),
            padding: EdgeInsets.all(Insets.sm),
            decoration: BoxDecoration(
              color: isLast ? Colors.transparent : AppColors.progressBgColor,
              borderRadius: BorderRadius.circular(Insets.xs),
            ),
            child: Row(
              children: [
                Text(
                  steps[index],
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                SizedBox(width: AppSizes.w(context, 5)),
                if (isActive)
                  FadeTransition(
                    opacity: _controller,
                    child: Text(
                      UserMessages.currentlyAtYourService,
                      style: TextStyle(color: AppColors.primaryRed, fontSize: AppSizes.w(context, 10)),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: AppSizes.h(context, 16)),
      padding: EdgeInsets.symmetric(horizontal: Insets.sm),
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.naturalWhite,
        boxShadow: const [
          BoxShadow(
            color: AppColors.naturalBlack12,
            blurRadius: 6,
            offset: Offset(0, 6),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            UserMessages.serviceProgress,
            style: TextStyle(
              color: AppColors.primaryRed,
              fontWeight: FontWeight.w600,
              fontSize: AppSizes.w(context, 17),
            ),
          ),
          SizedBox(height: AppSizes.h(context, 12)),
          ...List.generate(steps.length, (index) => buildStep(index)),
        ],
      ),
    );
  }
}