
import 'package:zeerah/core/common/app_exports.dart';

class HomeOfferSection extends StatelessWidget {
  const HomeOfferSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration:  BoxDecoration(
        color: AppColors.naturalWhite,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(Insets.md),
          topRight: Radius.circular(Insets.md),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(Insets.sm, Insets.md, Insets.sm, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              UserMessages.offerForYou,
              style: TextStyle(
                fontSize: AppSizes.w(context, 19),
                fontWeight: FontWeight.w800,
                color: AppColors.naturalBlack,
              ),
            ),
            SizedBox(height: AppSizes.h(context, 12)),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 2, child: _GardeningCard()),
                SizedBox(width: AppSizes.w(context, 7.5)),
                Expanded(
                  flex: 3,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: _TinyCard(
                              color: AppColors.lightRed,
                              title: UserMessages.bundleAndSave,
                              subtitle: UserMessages.upTo25Percent,
                              desc: UserMessages.book2PlusServices,
                              image: UserMessages.homeGiftBox,
                            ),
                          ),
                          SizedBox(width: AppSizes.w(context, 3.75)),
                          Expanded(
                            child: _TinyCard(
                              color: AppColors.softBlue,
                              title: UserMessages.referAndEarn,
                              subtitle: UserMessages.points50,
                              desc: UserMessages.inviteFriend,
                              image: UserMessages.homeParse,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: AppSizes.h(context, 8)),
                      Row(
                        children: [
                          Expanded(
                            child: _TinyCard(
                              color: AppColors.neonGreen,
                              title: UserMessages.weekendSpecial,
                              subtitle: UserMessages.upTo15Percent,
                              desc: UserMessages.satSunOnly,
                              image: UserMessages.homeCalendar,
                            ),
                          ),
                          SizedBox(width: AppSizes.w(context, 3.75)),
                          Expanded(
                            child: _TinyCard(
                              color: AppColors.pinkPurple,
                              title: UserMessages.firstBooking,
                              subtitle: UserMessages.percent20OFF,
                              desc: UserMessages.forNewUsers,
                              image: UserMessages.homeGiftBox,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _GardeningCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.offerYellow,
        borderRadius: BorderRadius.circular(Insets.sm),
        boxShadow: [
          BoxShadow(
            color: AppColors.naturalBlack.withOpacity(0.25),
            offset: const Offset(-4, 6),
            blurRadius: AppSizes.w(context, 10),
            spreadRadius: AppSizes.w(context, 1),
          ),
        ],
      ),
      padding: EdgeInsets.all(AppSizes.w(context, 11)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            UserMessages.percent20OFF,
            style: TextStyle(
              color: AppColors.primaryRed,
              fontSize: AppSizes.w(context, 17),
              fontWeight: FontWeight.w900,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: AppSizes.h(context, 6.5)),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppSizes.w(context, 7.5),
              vertical: AppSizes.h(context, 2.5),
            ),
            decoration: BoxDecoration(
              color: AppColors.primaryRed,
              borderRadius: BorderRadius.circular(Insets.xs),
            ),
            child: Text(
              UserMessages.limited,
              style: TextStyle(
                color: AppColors.naturalWhite,
                fontSize: AppSizes.w(context, 9),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Image.asset(
            UserMessages.homeGardening,
            height: AppSizes.h(context, 65),
            width: AppSizes.w(context, 56),
            fit: BoxFit.contain,
          ),
          Text(
            UserMessages.gardeningServices,
            style: TextStyle(
              fontSize: AppSizes.w(context, 11),
              fontWeight: FontWeight.w600,
              color: AppColors.naturalBlack.withOpacity(0.87),
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _TinyCard extends StatelessWidget {
  final Color color;
  final String title;
  final String subtitle;
  final String desc;
  final String image;

  const _TinyCard({
    required this.color,
    required this.title,
    required this.subtitle,
    required this.desc,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(Insets.sm),
        boxShadow: [
          BoxShadow(
            color: AppColors.naturalBlack.withOpacity(0.25),
            offset: const Offset(-4, 6),
            blurRadius: AppSizes.w(context, 10),
            spreadRadius: AppSizes.w(context, 1),
          ),
        ],
      ),
      padding: EdgeInsets.all(AppSizes.w(context, 7.5)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            image,
            height: AppSizes.h(context, 24),
            width: AppSizes.w(context, 19),
            fit: BoxFit.contain,
          ),
          SizedBox(width: AppSizes.w(context, 3.75)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: AppColors.naturalWhite,
                    fontSize: AppSizes.w(context, 10.5),
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: AppSizes.h(context, 3)),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: AppColors.naturalWhite,
                    fontSize: AppSizes.w(context, 9),
                    fontWeight: FontWeight.w800,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: AppSizes.h(context, 2.5)),
                Text(
                  desc,
                  style: TextStyle(
                    color: AppColors.naturalWhite.withOpacity(0.7),
                    fontSize: AppSizes.w(context, 7.5),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}