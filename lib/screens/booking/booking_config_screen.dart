import 'package:zeerah/core/common/app_exports.dart';

class BookingConfigScreen extends StatefulWidget {
  final CategoryItem service;
  const BookingConfigScreen({required this.service, super.key});

  @override
  State<BookingConfigScreen> createState() => _BookingConfigScreenState();
}

class _BookingConfigScreenState extends State<BookingConfigScreen> {
  int _selectedBhkIndex = 0;
  final Set<int> _selectedAddOnIndices = {};

  final List<Map<String, dynamic>> bhkOptions = [
    {"title": "1 BHK", "price": 2599},
    {"title": "2 BHK", "price": 3599},
    {"title": "3 BHK", "price": 4599},
  ];

  final List<Map<String, dynamic>> addOnServices = [
    {
      "title": "Sofa & mattress cleaning",
      "subtitle": "Adds deep fabric cleaning",
      "price": 599,
    },
    {
      "title": "Kitchen Cabinets & Alliances",
      "subtitle": "Deep Cleaning inside cabinets",
      "price": 599,
    },
  ];

  double get _totalPrice {
    double total = bhkOptions[_selectedBhkIndex]['price'].toDouble();
    for (int index in _selectedAddOnIndices) {
      total += addOnServices[index]['price'];
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
           
            const SizedBox(height: 24),
            const Text(
              'Select Options',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),
            // BHK Options Row
            Row(
              children: List.generate(bhkOptions.length, (index) {
                final option = bhkOptions[index];
                final isSelected = _selectedBhkIndex == index;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedBhkIndex = index),
                    child: Container(
                      margin: EdgeInsets.only(
                        right: index == bhkOptions.length - 1 ? 0 : 12,
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      decoration: BoxDecoration(
                        color: isSelected ? const Color(0xFFFFD9CC) : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isSelected ? Colors.transparent : Colors.black12,
                          width: 1,
                        ),
                      ),
                      child: Column(
                        children: [
                          Text(
                            option['title'],
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '₹${option['price']}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 32),
            const Text(
              'Add-on-services',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),
            // Add-on Services List
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: addOnServices.length,
              separatorBuilder: (_, __) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final service = addOnServices[index];
                final isAdded = _selectedAddOnIndices.contains(index);
                return Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.black12),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              service['title'],
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              service['subtitle'],
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        children: [
                          Text(
                            '₹${service['price']}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          ),
                          const SizedBox(height: 12),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                if (isAdded) {
                                  _selectedAddOnIndices.remove(index);
                                } else {
                                  _selectedAddOnIndices.add(index);
                                }
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                              decoration: BoxDecoration(
                                color: isAdded ? Colors.grey : const Color(0xFF263238),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                isAdded ? 'Remove' : 'Add',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 120), // Spacer for bottom bar
          ],
        ),
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Total:',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Text(
                  '₹${_totalPrice.toInt()}',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
            GestureDetector(
              onTap: () {
                HapticFeedback.mediumImpact();
                Navigator.pushNamed(
                  context,
                  AppRoutes.bookingHomePage,
                  arguments: widget.service,
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFF263238),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Continue',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
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
