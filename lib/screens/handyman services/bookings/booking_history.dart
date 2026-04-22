import 'package:zeerah/core/common/app_exports.dart';
import 'package:zeerah/core/models/booking_model.dart';
import 'package:zeerah/widgets/custom/fade_animation_text.dart';

class BookingHistory extends StatefulWidget {
  BookingHistory({super.key});

  @override
  State<BookingHistory> createState() => _BookingHistoryState();
}

class _BookingHistoryState extends State<BookingHistory> {
  Color getOuterColor(BookingStatus status) {
    switch (status) {
      case BookingStatus.inProgress:
        return AppColors.outerInProgress;
      case BookingStatus.accepted:
        return AppColors.outerAccepted;
      case BookingStatus.completed:
        return AppColors.outerCompleted;
      case BookingStatus.rejected:
        return AppColors.outerRejected;
    }
  }

  Color getInnerColor(BookingStatus status) {
    switch (status) {
      case BookingStatus.inProgress:
        return AppColors.innerInProgress;
      case BookingStatus.accepted:
        return AppColors.innerAccepted;
      case BookingStatus.completed:
        return AppColors.innerCompleted;
      case BookingStatus.rejected:
        return AppColors.innerRejected;
    }
  }

  Color getBorderColor(BookingStatus status) {
    switch (status) {
      case BookingStatus.inProgress:
        return AppColors.borderInProgress;
      case BookingStatus.accepted:
        return AppColors.pauseBlue;
      case BookingStatus.completed:
        return AppColors.neonGreen;
      case BookingStatus.rejected:
        return AppColors.borderRejected;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.naturalWhite,
      appBar: AppBar(
        toolbarHeight: AppSizes.h(context, 70),
        backgroundColor: AppColors.primaryRed,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.naturalWhite),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          UserMessages.bookingHistory,
          style: TextStyle(
            color: AppColors.naturalWhite,
            fontSize: AppSizes.w(context, 20),
          ),
        ),
      ),
      body: SafeArea(
        child: ListView.builder(
          padding: EdgeInsets.all(Insets.sm),
          itemCount: BookingModel.dummyList().length,
          itemBuilder: (_, i) {
            final item = BookingModel.dummyList()[i];

            return Container(
              margin: EdgeInsets.only(bottom: Insets.sm),
              padding: EdgeInsets.all(Insets.xsm),
              decoration: BoxDecoration(
                color: getOuterColor(item.status),
                borderRadius: BorderRadius.circular(Insets.sm),
                border: Border.all(color: getBorderColor(item.status)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: AppSizes.h(context, 8)),
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(Insets.xs),
                        child: Image.network(
                          item.image,
                          height: AppSizes.h(context, 80),
                          width: AppSizes.w(context, 70),
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            height: AppSizes.h(context, 80),
                            width: AppSizes.w(context, 70),
                            color: Colors.grey.shade300,
                            child: const Icon(Icons.image),
                          ),
                        ),
                      ),
                      SizedBox(width: Insets.xs),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: Insets.xs,
                                    vertical: Insets.xxs,
                                  ),
                                  decoration: BoxDecoration(
                                    color: getInnerColor(item.status),
                                    borderRadius: BorderRadius.circular(Insets.md),
                                  ),
                                  child: Text(
                                    "#1",
                                    style: TextStyle(
                                      fontSize: AppSizes.w(context, 11),
                                      color: getBorderColor(item.status),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: Insets.xs,
                                    vertical: Insets.xxs,
                                  ),
                                  decoration: BoxDecoration(
                                    color: getInnerColor(item.status),
                                    borderRadius: BorderRadius.circular(Insets.md),
                                  ),
                                  child: Text(
                                    item.status.value,
                                    style: TextStyle(
                                      fontSize: AppSizes.w(context, 11),
                                      color: getBorderColor(item.status),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.title,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                if (item.status == BookingStatus.accepted)
                                  BlinkingText(
                                    text: UserMessages.currentlyAtYourService,
                                    style: TextStyle(
                                      fontSize: AppSizes.w(context, 11),
                                      color: AppColors.blinkingRed,
                                    ),
                                  ),
                                if (item.status == BookingStatus.inProgress)
                                  BlinkingText(
                                    text: UserMessages.timeRemaining,
                                    style: TextStyle(
                                      fontSize: AppSizes.w(context, 11),
                                      color: AppColors.blinkingGreen,
                                    ),
                                  ),
                                Text(
                                  item.price,
                                  style: TextStyle(
                                    color: AppColors.priceOrange,
                                  ),
                                ),
                              ].withSpaceBetween(height: AppSizes.h(context, 2)),
                            ),
                          ].withSpaceBetween(height: AppSizes.h(context, 6)),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: AppSizes.h(context, 10)),
                  Container(
                    padding: EdgeInsets.all(Insets.xsm),
                    decoration: BoxDecoration(
                      color: getInnerColor(item.status),
                      borderRadius: BorderRadius.circular(Insets.sm),
                    ),
                    child: Column(
                      children: [
                        rowText(UserMessages.addressLabel, item.address),
                        SizedBox(height: AppSizes.h(context, 12)),
                        rowText(UserMessages.dateLabel, item.date),
                        SizedBox(height: AppSizes.h(context, 12)),
                        rowText(UserMessages.timeLabel, item.time),
                        if (item.paymentStatus == PaymentStatus.paid) ...[
                          SizedBox(height: AppSizes.h(context, 10)),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: AppSizes.w(context, 70),
                                child: Text(
                                  UserMessages.paymentStatusLabel,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.all(AppSizes.h(context, 7)),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(Insets.xsm),
                                  border: Border.all(color: AppColors.naturalWhite),
                                  color: AppColors.approvedGreen,
                                ),
                                child: Text(
                                  UserMessages.approved,
                                  style: TextStyle(
                                    color: AppColors.naturalWhite,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                  SizedBox(height: AppSizes.h(context, 17)),
                  if (item.status != BookingStatus.rejected)
                    Divider(color: AppColors.naturalGray),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: AppSizes.w(context, 18),
                        backgroundColor: Colors.grey.shade200,
                        child: ClipOval(
                          child: Image.network(
                            item.professional.avatarUrl,
                            height: AppSizes.h(context, 36),
                            width: AppSizes.w(context, 36),
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Image.asset(
                              UserMessages.riderImage,
                              height: AppSizes.h(context, 36),
                              width: AppSizes.w(context, 36),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: Insets.xs),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item.professional.name),
                          SizedBox(height: AppSizes.h(context, 8)),
                          Text(UserMessages.handyman),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget rowText(String title, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: AppSizes.w(context, 70),
          child: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
        Expanded(child: Text(value)),
      ],
    );
  }
}