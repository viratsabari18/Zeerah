import 'package:flutter/material.dart';
import 'package:zeerah/core/common/app_exports.dart';
import 'package:zeerah/core/models/notification_item.dart';

class NotificationHistory extends StatefulWidget {
  const NotificationHistory({super.key});

  @override
  State<NotificationHistory> createState() => _NotificationHistoryState();
}

extension NotificationTypeExt on NotificationType {
  String get label {
    switch (this) {
      case NotificationType.rating:
        return UserMessages.ratingLabel;
      case NotificationType.accepted:
        return UserMessages.acceptedLabel;
      case NotificationType.payment:
        return UserMessages.paymentLabel;
      case NotificationType.driving:
        return UserMessages.drivingLabel;
    }
  }

  String get icon {
    switch (this) {
      case NotificationType.accepted:
        return UserMessages.notificationAcceptance;
      case NotificationType.payment:
        return UserMessages.notificationPayment;
      case NotificationType.driving:
        return UserMessages.notificationDriving;
      case NotificationType.rating:
        return "";
    }
  }
}

class _NotificationHistoryState extends State<NotificationHistory> {
  String searchQuery = "";
  NotificationType? selectedFilter;

  final TextEditingController searchController = TextEditingController();

  List<NotificationItem> notifications = NotificationItem.dummydata();

  List<NotificationItem> getFiltered() {
    return notifications.where((item) {
      final matchesSearch = item.title.toLowerCase().contains(searchQuery.toLowerCase()) ||
          item.description.toLowerCase().contains(searchQuery.toLowerCase());
      final matchesFilter = selectedFilter == null || item.type == selectedFilter;
      return matchesSearch && matchesFilter;
    }).toList();
  }

  Widget filterChip(String label, NotificationType? type) {
    final isSelected = selectedFilter == type;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedFilter = type;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: EdgeInsets.symmetric(horizontal: Insets.sm, vertical: Insets.xxs),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryRed : AppColors.naturalWhite,
          borderRadius: BorderRadius.circular(Insets.xs),
          border: Border.all(color: AppColors.primaryRed),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? AppColors.naturalWhite : AppColors.primaryRed,
            fontSize: AppSizes.w(context, 12),
          ),
        ),
      ),
    );
  }

  Widget buildStatus(NotificationType type) {
    if (type == NotificationType.rating) {
      return Row(
        children: List.generate(
          5,
          (index) => const Icon(Icons.star, color: AppColors.starOrange, size: 14),
        ),
      );
    }

    return Row(
      children: [
        if (type.icon.isNotEmpty) Image.asset(type.icon, height: AppSizes.h(context, 14)),
        if (type.icon.isNotEmpty) SizedBox(width: Insets.xxs),
        Text(type.label, style: TextStyle(fontSize: AppSizes.w(context, 11))),
      ],
    );
  }

  Widget buildActionButton(NotificationItem item) {
    String? text = item.buttonText;

    if (text == null) {
      if (item.type == NotificationType.accepted || item.type == NotificationType.driving) {
        text = UserMessages.goToBookings;
      }
    }

    if (text == null) return const SizedBox();

    final isRate = text == UserMessages.rateNow;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: Insets.sm, vertical: Insets.xxs),
      decoration: BoxDecoration(
        color: isRate ? AppColors.rateNowColor : AppColors.primaryRed,
        borderRadius: BorderRadius.circular(Insets.xs),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: AppColors.naturalWhite,
          fontSize: AppSizes.w(context, 11),
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget notificationCard(NotificationItem item) {
    return Container(
      margin: EdgeInsets.only(bottom: Insets.sm),
      padding: EdgeInsets.all(Insets.xsm),
      decoration: BoxDecoration(
        color: AppColors.notificationCardBg,
        borderRadius: BorderRadius.circular(Insets.xsm),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: AppSizes.w(context, 22),
            backgroundColor: Colors.grey.shade300,
            child: const Icon(Icons.person, color: AppColors.naturalBlack),
          ),
          SizedBox(width: Insets.xs),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        item.title,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    const Icon(Icons.more_horiz, size: 18),
                  ],
                ),
                SizedBox(height: AppSizes.h(context, 4)),
                buildStatus(item.type),
                SizedBox(height: AppSizes.h(context, 4)),
                Text(item.description, style: TextStyle(fontSize: AppSizes.w(context, 11))),
                SizedBox(height: AppSizes.h(context, 8)),
                buildActionButton(item),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final list = getFiltered();

    return Scaffold(
      backgroundColor: AppColors.notificationBgColor,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(Insets.xsm),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.arrow_back_ios, color: AppColors.primaryRed),
                  ),
                  SizedBox(width: Insets.xs),
                  Expanded(
                    child: Container(
                      height: AppSizes.h(context, 40),
                      padding: EdgeInsets.symmetric(horizontal: Insets.xs),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(Insets.md),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.search, size: 18, color: Colors.grey),
                          SizedBox(width: Insets.xxs),
                          Expanded(
                            child: TextField(
                              controller: searchController,
                              onChanged: (val) {
                                setState(() {
                                  searchQuery = val;
                                });
                              },
                              decoration: const InputDecoration(
                                hintText: UserMessages.searchNotifications,
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: Insets.xsm),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    filterChip(UserMessages.all, null),
                    filterChip(UserMessages.acceptedLabel, NotificationType.accepted),
                    filterChip(UserMessages.paymentLabel, NotificationType.payment),
                    filterChip(UserMessages.drivingLabel, NotificationType.driving),
                    filterChip(UserMessages.ratingLabel, NotificationType.rating),
                  ],
                ),
              ),
            ),
            SizedBox(height: AppSizes.h(context, 10)),
            Expanded(
              child: list.isEmpty
                  ? const Center(
                      child: Text(
                        UserMessages.noNotificationsFound,
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      padding: EdgeInsets.all(Insets.sm),
                      itemCount: list.length,
                      itemBuilder: (_, i) => notificationCard(list[i]),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}