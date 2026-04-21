import 'package:flutter/material.dart';
import 'package:zeerah/core/common/app_exports.dart';

class ServiceDetailsCard extends StatelessWidget {
  const ServiceDetailsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: Insets.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      UserMessages.serviceDetails,
                      style: TextStyle(
                        color: AppColors.primaryRed,
                        fontWeight: FontWeight.w600,
                        fontSize: AppSizes.w(context, 17),
                      ),
                    ),
                    SizedBox(height: AppSizes.h(context, 6)),
                    Text(
                      UserMessages.fullHomeCleaning,
                      style: TextStyle(
                        fontSize: AppSizes.w(context, 14),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: AppSizes.h(context, 4)),
                    Text(
                      UserMessages.serviceDateTime,
                      style: TextStyle(
                        fontSize: AppSizes.w(context, 11),
                        color: AppColors.naturalBlack54,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(Insets.xs),
                child: Image.asset(
                  UserMessages.fullHouseCleaningImage,
                  height: AppSizes.h(context, 90),
                  width: AppSizes.w(context, 120),
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    height: AppSizes.h(context, 70),
                    width: AppSizes.w(context, 90),
                    color: Colors.grey.shade300,
                    child: const Icon(Icons.image),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: AppSizes.h(context, 20)),
          Row(
            children: [
              const Expanded(child: ActionButton(icon: Icons.pause, text: UserMessages.pause, color: AppColors.pauseBlue)),
              SizedBox(width: Insets.xsm),
              const Expanded(child: ActionButton(icon: Icons.close, text: UserMessages.stop, color: AppColors.primaryRed)),
              SizedBox(width: Insets.xsm),
              const Expanded(child: ActionButton(icon: Icons.support_agent, text: UserMessages.support, color: AppColors.naturalBlack)),
            ],
          ),
        ],
      ),
    );
  }
}

class ActionButton extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color color;

  const ActionButton({
    super.key,
    required this.icon,
    required this.text,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppSizes.h(context, 55),
      decoration: BoxDecoration(
        color: AppColors.naturalWhite,
        borderRadius: BorderRadius.circular(Insets.sm),
        boxShadow: const [
          BoxShadow(
            color: AppColors.naturalBlack12,
            blurRadius: 8,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color),
          SizedBox(width: Insets.xxs),
          Text(
            text,
            style: TextStyle(color: color, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}