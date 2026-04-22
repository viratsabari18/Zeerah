import 'package:zeerah/core/common/app_exports.dart';

class PaymentsHomePage extends StatefulWidget {
  const PaymentsHomePage({super.key});

  @override
  State<PaymentsHomePage> createState() => _PaymentsHomePageState();
}

class _PaymentsHomePageState extends State<PaymentsHomePage> {
  String selectedMethod = UserMessages.upi;

  Widget paymentTile({
    required String title,
    required String icon,
    required String value,
  }) {
    final bool isSelected = selectedMethod == value;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedMethod = value;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: Insets.sm, vertical: Insets.sm),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.selectedPaymentBg : AppColors.naturalWhite,
          borderRadius: BorderRadius.circular(Insets.sm),
        ),
        child: Row(
          children: [
            Image.asset(icon, height: AppSizes.h(context, 22)),
            SizedBox(width: Insets.xsm),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: AppSizes.w(context, 15),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Container(
              height: AppSizes.h(context, 22),
              width: AppSizes.w(context, 22),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.naturalBlack),
              ),
              child: isSelected
                  ? Padding(
                      padding: EdgeInsets.all(Insets.xxs),
                      child: Image.asset(
                        UserMessages.paymentsSelected,
                      ),
                    )
                  : null,
            )
          ],
        ),
      ),
    );
  }

  Widget billRow(String title, String value, Color color) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppSizes.h(context, 4)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Text("• "),
              Text(title),
            ],
          ),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.reviewBgColor,
      appBar: AppBar(
        backgroundColor: AppColors.primaryRed,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.naturalWhite),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Text(
          UserMessages.paymentSummary,
          style: TextStyle(
            fontSize: AppSizes.w(context, 18),
            fontWeight: FontWeight.w600,
            color: AppColors.naturalWhite,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Main scrollable content
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(Insets.sm),
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
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: AppSizes.h(context, 6)),
                              Text(
                                UserMessages.fullHomeCleaning,
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: AppSizes.h(context, 4)),
                              Text(
                                UserMessages.serviceDateTime,
                                style: TextStyle(
                                  fontSize: AppSizes.w(context, 11),
                                  color: AppColors.naturalBlack.withOpacity(0.54),
                                ),
                              ),
                            ],
                          ),
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(Insets.xs),
                          child: Image.asset(
                            UserMessages.fullHouseCleaningImage,
                            height: AppSizes.h(context, 80),
                            width: AppSizes.w(context, 110),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: AppSizes.h(context, 20)),
                    Text(
                      UserMessages.billBreakdown,
                      style: TextStyle(
                        color: AppColors.billGreen,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: AppSizes.h(context, 10)),
                    billRow(UserMessages.serviceFee, "₹ 2,599", AppColors.naturalBlack),
                    billRow(UserMessages.extraTime, "+ ₹399", AppColors.neonGreen),
                    billRow(UserMessages.coupon, "- ₹599", AppColors.softBlue),
                    SizedBox(height: AppSizes.h(context, 12)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          UserMessages.totalAmount,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "₹2,599",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: AppSizes.w(context, 18),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: AppSizes.h(context, 10)),
                    Container(
                      height: AppSizes.h(context, 2),
                      decoration: BoxDecoration(
                        color: AppColors.billGreen.withOpacity(0.3),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.billGreen.withOpacity(0.5),
                            blurRadius: AppSizes.w(context, 6),
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: AppSizes.h(context, 20)),
                    Text(
                      UserMessages.paymentMethod,
                      style: TextStyle(
                        color: AppColors.billGreen,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: AppSizes.h(context, 12)),
                    paymentTile(
                      title: UserMessages.upi,
                      icon: UserMessages.paymentsUpi,
                      value: UserMessages.upi,
                    ),
                    paymentTile(
                      title: UserMessages.creditDebitCard,
                      icon: UserMessages.paymentsCreditCard,
                      value: UserMessages.card,
                    ),
                    paymentTile(
                      title: UserMessages.wallet,
                      icon: UserMessages.paymentsWallet,
                      value: UserMessages.walletValue,
                    ),
                    paymentTile(
                      title: UserMessages.cashOnDelivery,
                      icon: UserMessages.paymentsCashOnDelivery,
                      value: UserMessages.cod,
                    ),
                    SizedBox(height: AppSizes.h(context, 20)),
                    Container(
                      height: AppSizes.h(context, 55),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColors.payButtonColor,
                        borderRadius: BorderRadius.circular(Insets.sm),
                      ),
                      child: Center(
                        child: Text(
                          UserMessages.payNow,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: AppSizes.w(context, 16),
                          ),
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
    );
  }
}