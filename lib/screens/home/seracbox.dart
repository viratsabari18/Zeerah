

import 'package:zeerah/core/common/app_exports.dart';

class SearchBox extends StatelessWidget {
  const SearchBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: Insets.sm, vertical: Insets.xs),
      padding: EdgeInsets.symmetric(horizontal: Insets.xsm),
      height: AppSizes.h(context, 50),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(
            Icons.search,
            color: Colors.grey,
            size: 24,
          ),
          SizedBox(width: Insets.xs),
          Expanded(
            child: TextField(
              decoration: const InputDecoration(
                hintText: UserMessages.searchForService,
                hintStyle: TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                ),
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}