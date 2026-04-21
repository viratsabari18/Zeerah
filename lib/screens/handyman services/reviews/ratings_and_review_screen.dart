import 'package:zeerah/core/common/app_exports.dart';

class RatingsAndReviewScreen extends StatefulWidget {
  const RatingsAndReviewScreen({super.key});

  @override
  State<RatingsAndReviewScreen> createState() => _RatingsAndReviewScreenState();
}

class _RatingsAndReviewScreenState extends State<RatingsAndReviewScreen> {
  int selectedRating = 4;
  int selectedTip = 100;
  final TextEditingController reviewController = TextEditingController();
  final List<int> tips = [50, 100, 200];

  Widget buildStar(int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedRating = index + 1;
        });
      },
      child: Icon(
        Icons.star,
        size: AppSizes.w(context, 38),
        color: index < selectedRating ? AppColors.starColor : Colors.grey.shade300,
      ),
    );
  }

  Widget tipChip(int value) {
    final bool isSelected = selectedTip == value;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedTip = value;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(right: 10),
        padding: EdgeInsets.symmetric(horizontal: Insets.sm, vertical: Insets.xs),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.softPeach : AppColors.naturalWhite,
          borderRadius: BorderRadius.circular(Insets.xs),
          border: Border.all(color: AppColors.naturalBlack, width: 0.2),
        ),
        child: Text(
          value == 0 ? UserMessages.custom : "₹$value",
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  Widget bottomBtn(String text, IconData icon) {
    return GestureDetector(
      onTap: () {
        if (text == UserMessages.bookings) {
          print(UserMessages.navigateToBookings);
        } else if (text == UserMessages.home) {
          print(UserMessages.navigateToHome);
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: Insets.sm, vertical: Insets.xs),
        decoration: BoxDecoration(
          color: AppColors.primaryRed,
          borderRadius: BorderRadius.circular(Insets.md),
        ),
        child: Row(
          children: [
            Text(text, style: const TextStyle(color: AppColors.naturalWhite)),
            SizedBox(width: Insets.xxs),
            Icon(icon, color: AppColors.naturalWhite, size: AppSizes.w(context, 18)),
          ],
        ),
      ),
    );
  }

  String getRatingText(int rating) {
    switch (rating) {
      case 1:
        return UserMessages.poorService;
      case 2:
        return UserMessages.belowAverage;
      case 3:
        return UserMessages.averageService;
      case 4:
        return UserMessages.goodService;
      case 5:
        return UserMessages.excellentService;
      default:
        return UserMessages.excellentService;
    }
  }

  void submitReview() {
    String reviewText = reviewController.text.trim();

    print("=" * 50);
    print(UserMessages.reviewSubmitted);
    print("=" * 50);
    print("${UserMessages.rating}: $selectedRating ★ (${getRatingText(selectedRating)})");
    print("${UserMessages.review}: ${reviewText.isEmpty ? UserMessages.noReviewWritten : reviewText}");
    print("${UserMessages.tipAmount}: ₹${selectedTip == 0 ? UserMessages.customAmount : selectedTip}");
    print("=" * 50);
  }

  @override
  void dispose() {
    reviewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.reviewBgColor,
      resizeToAvoidBottomInset: false, 
      appBar: AppBar(
        backgroundColor: AppColors.naturalWhite,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.primaryRed),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Text(
          UserMessages.rateYourExperience,
          style: TextStyle(
            color: AppColors.primaryRed,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
        
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(Insets.sm),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
        
                    Row(
                      children: [
                        CircleAvatar(
                          radius: AppSizes.w(context, 28),
                          backgroundColor: Colors.grey.shade300,
                          child: ClipOval(
                            child: Image.network(
                              UserMessages.profileImageUrl,
                              width: AppSizes.w(context, 56),
                              height: AppSizes.h(context, 56),
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: Colors.grey.shade300,
                                  alignment: Alignment.center,
                                  child: const Icon(
                                    Icons.person,
                                    color: AppColors.naturalBlack,
                                    size: 28,
                                  ),
                                );
                              },
                              loadingBuilder: (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Container(
                                  color: Colors.grey.shade300,
                                  alignment: Alignment.center,
                                  child: SizedBox(
                                    width: AppSizes.w(context, 20),
                                    height: AppSizes.h(context, 20),
                                    child: const CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        SizedBox(width: Insets.xsm),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              UserMessages.profileName,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: AppSizes.w(context, 16),
                              ),
                            ),
                            SizedBox(height: AppSizes.h(context, 4)),
                            Text(
                              UserMessages.professionalType,
                              style: TextStyle(
                                fontSize: AppSizes.w(context, 13),
                                color: AppColors.naturalBlack.withOpacity(0.54),
                              ),
                            ),
                            SizedBox(height: AppSizes.h(context, 4)),
                            Text(
                              UserMessages.professionalStats,
                              style: TextStyle(
                                fontSize: AppSizes.w(context, 12),
                                color: AppColors.naturalBlack.withOpacity(0.54),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
        
                    SizedBox(height: AppSizes.h(context, 20)),
        
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (index) => buildStar(index)),
                    ),
        
                    SizedBox(height: AppSizes.h(context, 12)),
        
                    Center(
                      child: Text(
                        getRatingText(selectedRating),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: AppSizes.w(context, 16),
                        ),
                      ),
                    ),
        
                    SizedBox(height: AppSizes.h(context, 20)),
        
                    Text(
                      "${UserMessages.writeA}${UserMessages.review}",
                      style: TextStyle(
                        color: AppColors.reviewGreen,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
        
                    SizedBox(height: AppSizes.h(context, 8)),
        
                    Container(
                      height: AppSizes.h(context, 120),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(Insets.xsm),
                        border: Border.all(color: Colors.grey.shade300),
                        color: AppColors.naturalWhite,
                      ),
                      child: TextField(
                        controller: reviewController,
                        maxLines: 4,
                        decoration: InputDecoration(
                          hintText: UserMessages.reviewHint,
                          hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(Insets.xsm),
                        ),
                      ),
                    ),
        
                    SizedBox(height: AppSizes.h(context, 20)),
        
             
                    Text(
                      UserMessages.tipYourProfessional,
                      style: TextStyle(
                        color: AppColors.discountRed,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
        
                    SizedBox(height: AppSizes.h(context, 10)),
        
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [...tips.map((e) => tipChip(e)), tipChip(0)],
                      ),
                    ),
        
                    SizedBox(height: AppSizes.h(context, 24)),
        
            
                    GestureDetector(
                      onTap: submitReview,
                      child: Container(
                        height: AppSizes.h(context, 55),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: AppColors.submitButtonColor,
                          borderRadius: BorderRadius.circular(Insets.sm),
                        ),
                        child: const Center(
                          child: Text(
                            UserMessages.submitReview,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
        
                    SizedBox(height: AppSizes.h(context, 14)),
        
         
                    GestureDetector(
                      onTap: () {
                        print(UserMessages.bookAgainTapped);
                      },
                      child: Container(
                        height: AppSizes.h(context, 55),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: AppColors.naturalWhite,
                          borderRadius: BorderRadius.circular(Insets.sm),
                          border: Border.all(color: AppColors.primaryRed),
                          boxShadow: [
                            BoxShadow(
                              spreadRadius: 0,
                              blurRadius: AppSizes.w(context, 8),
                              color: AppColors.naturalBlack.withAlpha(70),
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Text(
                            UserMessages.bookAgain,
                            style: TextStyle(
                              color: AppColors.primaryRed,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
        
                    SizedBox(height: AppSizes.h(context, 20)),
                      
            Container(
              padding: EdgeInsets.all(Insets.md),
              decoration: BoxDecoration(
                color: AppColors.reviewBgColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  bottomBtn(UserMessages.bookings, Icons.shopping_bag),
                  bottomBtn(UserMessages.home, Icons.home),
                ],
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