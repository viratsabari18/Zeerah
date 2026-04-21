import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:zeerah/core/common/app_exports.dart';

class SelectDate extends StatefulWidget {
  const SelectDate({super.key});

  @override
  State<SelectDate> createState() => _SelectDateState();
}

class _SelectDateState extends State<SelectDate> {
  DateTime currentMonth = DateTime.now();
  DateTime selectedDate = DateTime.now();

  String selectedSlot = UserMessages.morning;
  String selectedTime = "10:00 AM";

  final List<String> timeSlots = [
    "9:00 AM",
    "10:00 AM",
    "11:00 AM",
    "12:00 PM",
    "1:00 PM",
    "2:00 PM",
    "3:00 PM",
    "4:00 PM",
  ];

  Widget innerShadowChip({
    required String text,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: Insets.md, vertical: Insets.xs),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryRed : AppColors.naturalWhite,
          border: Border.all(width: 0.5, color: AppColors.darkGray),
          borderRadius: BorderRadius.circular(Insets.md),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? AppColors.naturalWhite : AppColors.naturalBlack,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    int daysInMonth = DateUtils.getDaysInMonth(currentMonth.year, currentMonth.month);
    int firstDay = DateTime(currentMonth.year, currentMonth.month, 1).weekday;

    return Column(
      children: [
        SizedBox(height: AppSizes.h(context, 10)),
        Text(
          UserMessages.selectDateTime,
          style: TextStyle(
            fontSize: AppSizes.w(context, 18),
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: AppSizes.h(context, 4)),
        Text(
          UserMessages.choosePreferredSchedule,
          style: TextStyle(color: Colors.grey.shade600),
        ),
        SizedBox(height: AppSizes.h(context, 16)),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: Icon(Icons.arrow_back_ios, size: AppSizes.w(context, 16)),
              onPressed: () {
                setState(() {
                  currentMonth = DateTime(currentMonth.year, currentMonth.month - 1);
                });
              },
            ),
            Text(
              DateFormat("MMMM yyyy").format(currentMonth),
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
            IconButton(
              icon: Icon(Icons.arrow_forward_ios, size: AppSizes.w(context, 16)),
              onPressed: () {
                setState(() {
                  currentMonth = DateTime(currentMonth.year, currentMonth.month + 1);
                });
              },
            ),
          ],
        ),
        SizedBox(height: AppSizes.h(context, 12)),
        Row(
          children: UserMessages.weekDays
              .map((e) => Expanded(
                    child: Center(
                      child: Text(e, style: const TextStyle(color: Colors.grey)),
                    ),
                  ))
              .toList(),
        ),
        SizedBox(height: AppSizes.h(context, 8)),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: daysInMonth + (firstDay - 1),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
          ),
          itemBuilder: (context, index) {
            if (index < firstDay - 1) {
              return const SizedBox();
            }

            int day = index - (firstDay - 2);
            DateTime date = DateTime(currentMonth.year, currentMonth.month, day);
            bool isSelected = DateUtils.isSameDay(date, selectedDate);

            return GestureDetector(
              onTap: () {
                setState(() => selectedDate = date);
              },
              child: Center(
                child: Container(
                  width: AppSizes.w(context, 32),
                  height: AppSizes.h(context, 32),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primaryRed : Colors.transparent,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      "$day",
                      style: TextStyle(
                        color: isSelected ? AppColors.naturalWhite : AppColors.naturalBlack,
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
        SizedBox(height: AppSizes.h(context, 16)),
        Text(
          UserMessages.availableTimeSlots,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: AppSizes.h(context, 10)),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: UserMessages.timeSlotsCategory.map((slot) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: Insets.xxs),
              child: innerShadowChip(
                text: slot,
                isSelected: selectedSlot == slot,
                onTap: () {
                  setState(() => selectedSlot = slot);
                },
              ),
            );
          }).toList(),
        ),
        SizedBox(height: AppSizes.h(context, 12)),
        Wrap(
          spacing: Insets.xs,
          runSpacing: Insets.xs,
          children: timeSlots.map((time) {
            bool isSelected = selectedTime == time;

            return GestureDetector(
              onTap: () {
                setState(() => selectedTime = time);
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: Insets.sm, vertical: Insets.xs),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primaryRed : AppColors.naturalWhite,
                  borderRadius: BorderRadius.circular(Insets.md),
                  boxShadow: isSelected
                      ? []
                      : [
                          BoxShadow(
                            color: AppColors.naturalBlack.withOpacity(0.1),
                            offset: const Offset(2, 2),
                            blurRadius: AppSizes.w(context, 6),
                          ),
                          BoxShadow(
                            color: AppColors.naturalWhite.withOpacity(0.9),
                            offset: const Offset(-2, -2),
                            blurRadius: AppSizes.w(context, 6),
                          ),
                        ],
                ),
                child: Text(
                  time,
                  style: TextStyle(
                    color: isSelected ? AppColors.naturalWhite : AppColors.naturalBlack,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        SizedBox(height: AppSizes.h(context, 20)),
        Container(
          padding: EdgeInsets.symmetric(horizontal: Insets.sm, vertical: Insets.xsm),
          decoration: BoxDecoration(
            color: AppColors.naturalWhite,
            borderRadius: BorderRadius.vertical(top: Radius.circular(Insets.sm)),
          ),
          child: Row(
            children: [
              Stack(
                children: [
                  Container(
                    width: AppSizes.w(context, 48),
                    height: AppSizes.h(context, 48),
                    decoration: BoxDecoration(
                      color: AppColors.calendarBg,
                      borderRadius: BorderRadius.circular(Insets.xsm),
                    ),
                    child: const Icon(Icons.calendar_today),
                  ),
                  Positioned(
                    bottom: AppSizes.h(context, 5),
                    right: AppSizes.w(context, 5),
                    child: Container(
                      width: AppSizes.w(context, 16),
                      height: AppSizes.h(context, 16),
                      decoration: const BoxDecoration(
                        color: AppColors.primaryRed,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.check, size: 10, color: AppColors.naturalWhite),
                    ),
                  )
                ],
              ),
              SizedBox(width: Insets.xsm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      UserMessages.selected,
                      style: TextStyle(fontSize: AppSizes.w(context, 12)),
                    ),
                    Text(
                      "${DateFormat("EEE, d MMM yyyy").format(selectedDate)} · $selectedTime",
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
              Container(
                width: AppSizes.w(context, 40),
                height: AppSizes.h(context, 40),
                decoration: const BoxDecoration(
                  color: AppColors.primaryRed,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check, color: AppColors.naturalWhite),
              ),
            ],
          ),
        ),
      ],
    );
  }
}