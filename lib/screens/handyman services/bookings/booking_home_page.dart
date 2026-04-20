
import 'package:zeerah/core/common/app_exports.dart';
import 'package:zeerah/screens/handyman%20services/bookings/select_date.dart';
import 'package:zeerah/screens/handyman%20services/bookings/service_type.dart';
import 'package:zeerah/screens/handyman%20services/bookings/price_details.dart';

class BookingHomePage extends StatefulWidget {
  final String bookingCategory;

  const BookingHomePage({this.bookingCategory = "Laudary", super.key});

  @override
  State<BookingHomePage> createState() => _BookingHomePageState();
}

class _BookingHomePageState extends State<BookingHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.naturalWhite,
      appBar: AppBar(
        titleSpacing: 0,
        toolbarHeight: AppSizes.h(context, 80),
        leading: Padding(
          padding: EdgeInsets.only(top: AppSizes.h(context, 10)),
          child: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios, color: AppColors.naturalWhite),
          ),
        ),
        backgroundColor: AppColors.primaryRed,
        title: Padding(
          padding: EdgeInsets.only(top: AppSizes.h(context, 10)),
          child: Text(
            "${widget.bookingCategory} Booking",
            style: TextStyle(
              color: AppColors.naturalWhite,
              fontSize: AppSizes.w(context, 20),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: const [
                    ServiceType(),
                    SelectDate(),
                    PriceDetails(),
                  ],
                ),
              ),
            ),
            Container(
              color: AppColors.naturalWhite,
              padding: EdgeInsets.fromLTRB(
                Insets.sm,
                Insets.xsm,
                Insets.sm,
                Insets.sm,
              ),
              child: SizedBox(
                width: double.infinity,
                height: AppSizes.h(context, 52),
                child: ElevatedButton(
                  onPressed: () {
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryRed,
                    foregroundColor: AppColors.naturalWhite,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(Insets.sm),
                    ),
                  ),
                  child: Text(
                    'Confirm',
                    style: TextStyle(
                      fontSize: AppSizes.w(context, 16),
                      fontWeight: FontWeight.w700,
                      color: AppColors.naturalWhite,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}