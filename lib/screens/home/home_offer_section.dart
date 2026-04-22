import 'package:google_fonts/google_fonts.dart';
import 'package:zeerah/core/common/app_exports.dart';

class HomeOfferSection extends StatelessWidget {
  const HomeOfferSection({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildOfferSection(context);
  }

  Widget _buildOfferSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 32), // Added spacing to shift the section down
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Offer for you',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.naturalBlack,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SizedBox(
            height: 230,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Featured Large Card (Left)
                Expanded(flex: 11, child: _buildFeaturedOfferCard()),
                const SizedBox(width: 10),
                // 2x2 Grid of Small Cards (Right)
                Expanded(
                  flex: 19,
                  child: Column(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Expanded(
                              child: _buildSmallOfferCard(
                                title: 'Bundle\n& Save',
                                subtitle: 'Up to 25%',
                                footer: 'Book 2+ Service',
                                color: const Color(0xFFFF6B6B),
                                icon: Icons.redeem,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: _buildSmallOfferCard(
                                title: 'Refer\n& Earn',
                                subtitle: '50 Points',
                                footer: 'Invite a friend',
                                color: const Color(0xFF5D8BF4),
                                icon: Icons.account_balance_wallet,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Expanded(
                        child: Row(
                          children: [
                            Expanded(
                              child: _buildSmallOfferCard(
                                title: 'Weekend\nSpecial',
                                subtitle: 'Up to 15%',
                                footer: 'Sat & Sun Only',
                                color: const Color(0xFF58E067),
                                icon: Icons.calendar_today,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: _buildSmallOfferCard(
                                title: 'First Booking\nOffer',
                                subtitle: '20% OFF',
                                footer: 'For new user\'s only',
                                color: const Color(0xFFD600D6),
                                icon: Icons.redeem,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFeaturedOfferCard() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFFE84F),
        borderRadius: BorderRadius.circular(26),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            '20%\nOFF',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: AppColors.primaryRed,
              height: 1,
            ),
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            decoration: BoxDecoration(
              color: AppColors.primaryRed,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'Limited Offer',
              style: GoogleFonts.poppins(
                fontSize: 10,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Flexible(
            child: Image.asset('lib/assets/images/man.png', fit: BoxFit.contain),
          ),
          const SizedBox(height: 6),
          Text(
            'Gardening Services',
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSmallOfferCard({
    required String title,
    required String subtitle,
    required String footer,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: Colors.white.withOpacity(0.9), size: 16),
              Text(
                subtitle,
                style: GoogleFonts.poppins(
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              height: 1.1,
            ),
          ),
          const Spacer(),
          Text(
            footer,
            style: GoogleFonts.poppins(
              fontSize: 8,
              color: Colors.white.withOpacity(0.8),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
