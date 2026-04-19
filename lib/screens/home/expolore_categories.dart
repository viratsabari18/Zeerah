
import 'package:zeerah/core/common/app_exports.dart';

class ExpoloreCategories extends StatefulWidget {
  const ExpoloreCategories({super.key});

  @override
  State<ExpoloreCategories> createState() => _ExpoloreCategoriesState();
}

class _ExpoloreCategoriesState extends State<ExpoloreCategories> {
  int selectedIndex = 0;

  final List<Map<String, String>> categories = [
    {"title": "Cleaning", "image": UserMessages.cleaning},
    {"title": "Electrician", "image": UserMessages.electrician},
    {"title": "Pest\nControl", "image": UserMessages.pestControl},
    {"title": "Plumber", "image": UserMessages.plumber},
    {"title": "Appliance\nRepair", "image": UserMessages.applianceRepair},
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: Insets.sm),
          child: Text(
            UserMessages.exploreCategories,
            style: TextStyle(
              fontSize: AppSizes.w(context, 18),
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        SizedBox(
          height: AppSizes.h(context, 120),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: Insets.xsm),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final item = categories[index];
              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedIndex = index;
                  });
                },
                child: _CategoryItem(
                  title: item["title"]!,
                  image: item["image"]!,
                  isSelected: selectedIndex == index,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _CategoryItem extends StatelessWidget {
  final String title;
  final String image;
  final bool isSelected;

  const _CategoryItem({
    required this.title,
    required this.image,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Insets.xxs),
      child: Container(
        height: AppSizes.h(context, 80),
        width: AppSizes.w(context, 80),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryYellow : AppColors.naturalWhite,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppColors.naturalBlack.withOpacity(0.2),
              blurRadius: AppSizes.w(context, 10),
              spreadRadius: AppSizes.w(context, 1),
              offset: const Offset(0, 4),
            ),
            BoxShadow(
              color: AppColors.naturalBlack.withOpacity(0.08),
              blurRadius: AppSizes.w(context, 18),
              spreadRadius: AppSizes.w(context, 2),
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(Insets.xxs),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: AppSizes.h(context, 40),
                width: AppSizes.w(context, 40),
                child: Image.asset(image, fit: BoxFit.contain),
              ),
              SizedBox(height: Insets.xxs),
              Text(
                title,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: AppSizes.w(context, 9),
                  fontWeight: FontWeight.w600,
                  color: AppColors.naturalBlack,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}