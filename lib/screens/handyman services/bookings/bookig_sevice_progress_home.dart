import 'package:zeerah/core/common/app_exports.dart';
import 'package:zeerah/screens/handyman%20services/bookings/service_in_progess.dart';

class BookingServiceProgressHome extends StatefulWidget {
  final int serviceDurationInSeconds; // Pass duration from first widget
  
  const BookingServiceProgressHome({
    Key? key, 
    required this.serviceDurationInSeconds
  }) : super(key: key);

  @override
  State<BookingServiceProgressHome> createState() =>
      _BookingServiceProgressHomeState();
}

class _BookingServiceProgressHomeState extends State<BookingServiceProgressHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryRed,
      appBar: AppBar(
        leading: Padding(
          padding: EdgeInsets.only(top: AppSizes.h(context, 16)),
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.naturalWhite),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        elevation: 0,
        toolbarHeight: AppSizes.h(context, 80),
        centerTitle: true,
        backgroundColor: AppColors.primaryRed,
        title: Padding(
          padding: EdgeInsets.only(top: AppSizes.h(context, 18)),
          child: Text(
            UserMessages.serviceInProgress,
            style: TextStyle(
              color: AppColors.naturalWhite,
              fontSize: AppSizes.w(context, 20),
            ),
          ),
        ),
      ),
      body: ServiceInProgress(
        serviceDuration: widget.serviceDurationInSeconds, // Pass duration to second widget
      ),
    );
  }
}