import 'package:zeerah/core/common/app_exports.dart';
import 'package:zeerah/core/services.dart/clipboard_service.dart';

class ReferSection extends StatefulWidget {
  const ReferSection({super.key});

  @override
  State<ReferSection> createState() => _ReferSectionState();
}

class _ReferSectionState extends State<ReferSection> {
  String refercode = "7H56TF";
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// MAIN CARD
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                /// IMAGE
                Image.asset(
                  "lib/assets/images/refer_section.webp", // 👈 add your image
                  height: 200,
                  width: 190,
                ),

                const SizedBox(height: 12),

                /// TEXT
                Text(
                  "Get a friend to unfazzed",
                  style: TextStyles.bodyMedium.copyWith(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: AppColors.naturalBlack,
                  ),
                ),

                const SizedBox(height: 6),

                /// GET ₹350
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "Get ",
                        style: TextStyles.bodyMedium.copyWith(
                          fontSize: 25,
                          fontWeight: FontWeight.w600,
                          color: AppColors.naturalBlack,
                        ),
                      ),
                      TextSpan(
                        text: "₹50",
                        style: TextStyles.bodyMedium.copyWith(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  "Your friend get 25 off on their first \n order",
                  textAlign: TextAlign.center,
                  style: TextStyles.bodyMedium.copyWith(
                    fontSize: 14,
                    color: AppColors.naturalBlack,
                  ),
                ),

                const SizedBox(height: 12),

                InkWell(
                  onTap: () {
                    copydata(context, refercode);
                  },

                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Color(0xFFF6EDED),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          refercode,
                          style: TextStyles.bodyMedium.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.copy, size: 16),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          /// HOW IT WORKS
          Text(
            "How it works",
            style: TextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),

          const SizedBox(height: 10),

          /// STEP CHIP
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              "Share the link with your friend",
              style: TextStyles.bodyMedium.copyWith(fontSize: 12),
            ),
          ),

          const SizedBox(height: 14),

          /// SHARE BUTTON
          SizedBox(
            width: double.infinity,
            height: 45,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                "Share invite link",
                style: TextStyle(color: AppColors.naturalBlack),
              ),
            ),
          ),

          const SizedBox(height: 10),

          /// OUTLINE BUTTON
          SizedBox(
            width: double.infinity,
            height: 45,
            child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.red),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                "Find friends to refer",
                style: TextStyle(color: Colors.red),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
