import 'dart:async';
import 'package:zeerah/core/common/app_exports.dart';

class BookingStatusScreen extends StatefulWidget {
  final CategoryItem service;

  const BookingStatusScreen({required this.service, super.key});

  @override
  State<BookingStatusScreen> createState() => _BookingStatusScreenState();
}

class _BookingStatusScreenState extends State<BookingStatusScreen> with SingleTickerProviderStateMixin {
  late AnimationController _rippleController;

  @override
  void initState() {
    super.initState();
    _rippleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat();

    // Simulate finding a professional after 5 seconds
    Timer(const Duration(seconds: 4), () {
      if (mounted) {
        Navigator.pushReplacementNamed(
          context,
          AppRoutes.professionalAssigned,
          arguments: {
            'service': widget.service,
            'status': BookingStatusModel(
              currentState: BookingState.onTheWay,
              professional: ProfessionalMatch.dummy(),
              arrivalTime: "12 mins",
            ),
          },
        );
      }
    });
  }

  @override
  void dispose() {
    _rippleController.dispose();
    super.dispose();
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
        title: const Text(
          "Finding a Professional",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            // Hero Illustrations (Clipped circles)
            _buildHeroImages(),
            const SizedBox(height: 32),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                "We’re finding the best professional for you",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  height: 1.2,
                ),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              "Searching...",
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
            const Text(
              "Usually within 2~5 minutes",
              style: TextStyle(color: Colors.black54, fontSize: 13),
            ),
            const SizedBox(height: 40),
            // Timeline Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTimelineIcons(),
                  const SizedBox(width: 16),
                  Expanded(child: _buildTimelineContent()),
                ],
              ),
            ),
            const Divider(thickness: 4, color: Color(0xFFEEEEEE), height: 80),
            // Service Details Card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _buildServiceInfo(),
            ),
            const SizedBox(height: 48),
            // Action Buttons
            _buildActionButtons(context),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroImages() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildClippedImage("lib/assets/images/worker_1.png"),
        const SizedBox(width: 12),
        _buildClippedImage("lib/assets/images/worker_2.png"),
      ],
    );
  }

  Widget _buildClippedImage(String path) {
    return Container(
      width: 160,
      height: 180,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(80),
        image: DecorationImage(
          image: AssetImage(path),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildTimelineIcons() {
    return Column(
      children: [
        _SearchingRippleIcon(controller: _rippleController),
        Container(
          width: 2,
          height: 40,
          color: Colors.black,
        ),
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.black, width: 2),
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildTimelineContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFFFE082).withOpacity(0.8),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Searching for professionals",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              SizedBox(height: 4),
              Text(
                "We are matching you with nearby experts...",
                style: TextStyle(fontSize: 12, color: Colors.black87),
              ),
            ],
          ),
        ),
        const SizedBox(height: 28),
        const Padding(
          padding: EdgeInsets.only(left: 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Waiting for acceptance",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black87),
              ),
              SizedBox(height: 4),
              Text(
                "Live tracking will start automatically, once professional accepts.",
                style: TextStyle(fontSize: 12, color: Colors.black45),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildServiceInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Service Details",
          style: TextStyle(color: Color(0xFF2E7D32), fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.service.title,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    "26 march,2026 ~ 11:00AM",
                    style: TextStyle(fontSize: 13, color: Colors.black54),
                  ),
                ],
              ),
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(widget.service.image, width: 100, height: 70, fit: BoxFit.cover),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: GestureDetector(
            onTap: () {},
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: const Color(0xFFD90000),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: Text(
                  "Need to reschedule?",
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ),
       
      ],
    );
  }
}

class _SearchingRippleIcon extends StatelessWidget {
  final Animation<double> controller;

  const _SearchingRippleIcon({required this.controller});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return SizedBox(
          width: 90,
          height: 90,
          child: Stack(
            alignment: Alignment.center,
            children: [
              _buildRipple(1.0, controller.value),
              _buildRipple(0.6, (controller.value + 0.5) % 1.0),
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFE082),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.orange[400]!, width: 2),
                ),
                child: const Icon(Icons.sensors, color: Colors.black, size: 24),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildRipple(double opacityFactor, double progress) {
    return Container(
      width: 50 + (40 * progress),
      height: 50 + (40 * progress),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.orange.withOpacity((1.0 - progress) * 0.4 * opacityFactor),
      ),
    );
  }
}
