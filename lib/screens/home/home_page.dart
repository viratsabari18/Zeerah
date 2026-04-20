import 'package:zeerah/core/common/app_exports.dart';
import 'package:zeerah/screens/home/expolore_categories.dart';
import 'package:zeerah/screens/home/expolre_categories_stack.dart';

import 'package:zeerah/screens/home/home_offer_section.dart';
import 'package:zeerah/screens/home/home_top_banner.dart';
import 'package:zeerah/screens/home/refer_section.dart';
import 'package:zeerah/screens/home/reliable_and_trustworthy_section.dart';
import 'package:zeerah/screens/home/seracbox.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.naturalWhite,
      body: SafeArea(
        top: false,
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                children: [
                  const HomeTopBanner(),
                  Transform.translate(
                    offset: Offset(0, -Insets.sm),
                    child: const HomeOfferSection(),
                  ),
                ],
              ),
            ),
            const SliverToBoxAdapter(child: SearchBox()),
            const SliverToBoxAdapter(child: ExpoloreCategories()),
        SliverToBoxAdapter(
  child:ExpolreCategoriesStack   (),
),

            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: Insets.sm),
              ),
            ),
            SliverToBoxAdapter(child: ReliableAndTrustworthySection()),
            SliverToBoxAdapter(child: ReferSection()),
          ],
        ),
      ),
    );
  }
}
