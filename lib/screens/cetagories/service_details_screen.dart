import 'package:zeerah/core/common/app_exports.dart';

class ServiceDetailsScreen extends StatefulWidget {
  final CategoryItem service;

  const ServiceDetailsScreen({required this.service, super.key});

  @override
  State<ServiceDetailsScreen> createState() => _ServiceDetailsScreenState();
}

class _ServiceDetailsScreenState extends State<ServiceDetailsScreen> {
  bool _showAllReviews = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(context),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHowItsDone(),
                  const SizedBox(height: 32),
                  _buildWhatsIncluded(),
                  const SizedBox(height: 32),
                  _buildWhatsNotIncluded(),
                  const SizedBox(height: 32),
                  _buildReviewsSection(),
                  const SizedBox(height: 100), // Padding for bottom bar
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  Widget _buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 250,
      pinned: true,
      backgroundColor: Colors.white,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(widget.service.image, fit: BoxFit.cover),
            Container(color: Colors.black.withOpacity(0.2)),
            Positioned(
              bottom: 20,
              left: 20,
              child: Text(
                widget.service.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHowItsDone() {
    if (widget.service.howItsDone.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "How it’s done",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 160,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: widget.service.howItsDone.length,
            itemBuilder: (context, index) {
              final step = widget.service.howItsDone[index];
              return Container(
                width: 140,
                margin: const EdgeInsets.only(right: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.black12),
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                        child: Image.asset(
                          step['image']!,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          errorBuilder: (_, __, ___) => Container(
                            color: Colors.grey[200],
                            child: const Icon(Icons.image_not_supported, color: Colors.grey),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "${index + 1}. ${step['title']}",
                        maxLines: 2,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildWhatsIncluded() {
    if (widget.service.whatsIncluded.isEmpty) return const SizedBox.shrink();

    // Palette of colors from design
    final List<Color> cardPalette = [
      const Color(0xFFE3F2FD), // Light Blue
      const Color(0xFFF3E5F5), // Light Purple
      const Color(0xFFFFDB99), // Light Yellow/Mustard
      const Color(0xFFEEEEEE), // Light Grey
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "What’s Included",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        // Two-column grid layout with rotating colors
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 2.2,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
          ),
          itemCount: widget.service.whatsIncluded.length,
          itemBuilder: (context, index) {
            final item = widget.service.whatsIncluded[index];
            final color = cardPalette[index % cardPalette.length]; // Rotate through palette
            
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: Text(
                  item,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                    height: 1.2,
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildWhatsNotIncluded() {
    if (widget.service.whatsNotIncluded.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "What’s Not Included",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.redAccent),
        ),
        const SizedBox(height: 16),
        ...widget.service.whatsNotIncluded.map((item) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            children: [
              const Icon(Icons.close, color: Colors.red, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  item,
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.black87),
                ),
              ),
            ],
          ),
        )),
      ],
    );
  }

  Widget _buildReviewsSection() {
    final reviews = widget.service.customerReviews;
    final displayReviews = _showAllReviews 
        ? reviews 
        : reviews.take(2).toList(); // Show initially 2 comments

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Customer Reviews",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  _showAllReviews = !_showAllReviews;
                });
              },
              child: Text(
                _showAllReviews ? "Hide <<" : "See all >>",
                style: const TextStyle(
                  color: Colors.redAccent,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        // Aggregated Rating Dashboard
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF9F0),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.orange.withOpacity(0.1)),
          ),
          child: Row(
            children: [
              Column(
                children: [
                  Text(
                    widget.service.rating,
                    style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: List.generate(5, (i) => Icon(Icons.star, size: 14, color: i < 5 ? Colors.amber : Colors.grey[300])),
                  ),
                  const SizedBox(height: 8),
                  const Text("(65K+ Reviews)", style: TextStyle(color: Colors.teal, fontWeight: FontWeight.w500, fontSize: 12)),
                ],
              ),
              const SizedBox(width: 32),
              Expanded(
                child: Column(
                  children: [
                    _buildRatingBar(5, 0.8),
                    _buildRatingBar(4, 0.6),
                    _buildRatingBar(3, 0.4),
                    _buildRatingBar(2, 0.2),
                    _buildRatingBar(1, 0.1),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        // Individual Reviews
        ...displayReviews.map((review) => _buildReviewCard(review)),
      ],
    );
  }

  Widget _buildRatingBar(int star, double percent) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Text("$star", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
          const SizedBox(width: 4),
          const Icon(Icons.star, size: 12, color: Colors.amber),
          const SizedBox(width: 8),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: percent,
                backgroundColor: Colors.grey[200],
                color: star >= 3 ? (star == 3 ? Colors.blue : Colors.green) : (star == 2 ? Colors.orange : Colors.red),
                minHeight: 8,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewCard(Map<String, dynamic> review) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(backgroundColor: Colors.grey[200], radius: 20, child: const Icon(Icons.person, color: Colors.grey)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(review['name'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    Text(review['date'], style: TextStyle(color: Colors.grey[500], fontSize: 12)),
                  ],
                ),
              ),
              Row(
                children: List.generate(5, (i) => Icon(Icons.star, size: 16, color: i < review['rating'] ? Colors.red : Colors.grey[300])),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            review['comment'],
            style: const TextStyle(fontSize: 14, color: Colors.black87, height: 1.4),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5))],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Price from", style: TextStyle(color: Colors.black54, fontSize: 12)),
                  Text(
                    "₹${widget.service.price}",
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                HapticFeedback.heavyImpact();
                // Navigate to configuration
                Navigator.pushNamed(context, AppRoutes.bookingConfig);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFF263238),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Book Now',
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
