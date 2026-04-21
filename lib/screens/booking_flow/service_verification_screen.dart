import 'package:zeerah/core/common/app_exports.dart';

class ServiceVerificationScreen extends StatelessWidget {
  final CategoryItem service;
  final BookingStatusModel bookingStatus;

  const ServiceVerificationScreen({
    required this.service,
    required this.bookingStatus,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final pro = bookingStatus.professional ?? ProfessionalMatch.dummy();
    
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
          "Arrived",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _buildOTPSection(),
            ),
            const SizedBox(height: 32),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _buildProProfile(pro),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _buildContactActions(),
            ),
            const Divider(thickness: 4, color: Color(0xFFEEEEEE), height: 80),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _buildServiceDetails(),
            ),
            const SizedBox(height: 32),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _buildActionButtonRow(),
            ),
            const SizedBox(height: 60),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtonRow() {
    return Row(
      children: [
        Expanded(
          child: _buildFooterButton(Icons.support_agent, "Contact Support", Colors.black),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildFooterButton(Icons.close, "Cancel Job", Colors.red),
        ),
      ],
    );
  }

  Widget _buildFooterButton(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceProgress() {
    final steps = bookingStatus.steps ?? [
      const ProgressStepModel(title: "Booking confirmed", subtitle: "", state: BookingState.assigned),
      const ProgressStepModel(title: "Professional Assigned", subtitle: "", state: BookingState.assigned),
      const ProgressStepModel(title: "On the Way", subtitle: "", state: BookingState.onTheWay),
      const ProgressStepModel(title: "Professional Arrived", subtitle: "Rider reached its destination", state: BookingState.completed),
      const ProgressStepModel(title: "Service Started", subtitle: "", state: BookingState.started),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Service Progress",
          style: TextStyle(color: Color(0xFFD90000), fontWeight: FontWeight.bold, fontSize: 18),
        ),
        const SizedBox(height: 20),
        ...List.generate(steps.length, (index) {
          final step = steps[index];
          // In this screen, we assume reached, so everything up to "Arrived" is done
          final bool isCompleted = index <= 3; 
          final bool isActive = index == 3;
          
          return _buildProgressStep(
            step.title, 
            subtitle: step.subtitle,
            isCompleted: isCompleted, 
            isActive: isActive,
            isLast: index == steps.length - 1
          );
        }),
      ],
    );
  }

  Widget _buildProgressStep(String title, {required String subtitle, required bool isCompleted, bool isActive = false, required bool isLast}) {
    return Row(
      children: [
        Column(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isCompleted ? const Color(0xFFFFD9CC) : Colors.white,
                border: Border.all(color: isCompleted ? Colors.transparent : Colors.black26),
              ),
              child: Icon(
                isActive ? Icons.sensors : (isCompleted ? Icons.check : null),
                size: 14,
                color: isActive ? Colors.orange : (isCompleted ? Colors.orange : Colors.transparent),
              ),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 30,
                color: isCompleted ? const Color(0xFFFFD9CC) : Colors.black12,
              ),
          ],
        ),
        const SizedBox(width: 16),
        Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              margin: const EdgeInsets.only(bottom: 12),
              width: 280,
              decoration: BoxDecoration(
                color: isCompleted ? const Color(0xFFFFE082).withOpacity(0.8) : Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: isCompleted ? Colors.black : Colors.black54,
                          ),
                        ),
                        if (isActive && subtitle.isNotEmpty)
                          Text(
                            subtitle,
                            style: const TextStyle(fontSize: 10, color: Colors.black54),
                          ),
                      ],
                    ),
                  ),
                  if (isActive) const Icon(Icons.sensors, color: Color(0xFFD90000), size: 16),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildOTPSection() {
    return Column(
      children: [
        Image.asset(
          'lib/assets/images/handsman.png',
          height: 180,
          fit: BoxFit.contain,
        ),
        const SizedBox(height: 12),
        const Column(
          children: [
            Text(
              "Handyman has",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.black54),
            ),
            Text(
              "ARRIVED",
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFF4CAF50)),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF8E1),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: const Color(0xFFFFD54F), width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              const Text(
                "Service OTP",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(4, (index) {
                  final List<String> otp = ["4", "2", "9", "1"]; 
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 6),
                    width: 54,
                    height: 64,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFFFD54F).withOpacity(0.5)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.06),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      otp[index],
                      style: const TextStyle(
                        fontSize: 28, 
                        fontWeight: FontWeight.bold, 
                        color: Color(0xFFD90000),
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 20),
              const Text(
                "Share this OTP with the professional to start the service",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: Colors.black54, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProProfile(ProfessionalMatch pro) {
    return Row(
      children: [
        CircleAvatar(
          radius: 35,
          backgroundImage: AssetImage(pro.avatarUrl),
          backgroundColor: const Color(0xFFFFF3E0),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    pro.name,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF4CAF50),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      "Arrived",
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.star, color: Color(0xFFFFB300), size: 16),
                  const SizedBox(width: 4),
                  Text(
                    pro.rating.toString(),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    "(${pro.jobsDone} jobs done)",
                    style: const TextStyle(color: Colors.black54, fontSize: 12),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              const Text(
                "Professional is at your door",
                style: TextStyle(color: Color(0xFF4CAF50), fontWeight: FontWeight.bold, fontSize: 13),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildContactActions() {
    return Row(
      children: [
        Expanded(
          child: _buildActionButton(
            icon: Icons.call,
            label: "Call",
            color: const Color(0xFFFFB300),
            textColor: const Color(0xFFD90000),
            isOutlined: false,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildActionButton(
            icon: Icons.chat_bubble_outline,
            label: "Chat",
            color: const Color(0xFFD90000),
            textColor: const Color(0xFFD90000),
            isOutlined: true,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required Color textColor,
    required bool isOutlined,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: isOutlined ? Colors.white : color,
        borderRadius: BorderRadius.circular(12),
        border: isOutlined ? Border.all(color: color) : null,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: textColor, size: 20),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceDetails() {
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
                    service.title,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "${bookingStatus.appointmentDate} ~ ${bookingStatus.appointmentTime}",
                    style: const TextStyle(fontSize: 13, color: Colors.black54),
                  ),
                ],
              ),
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(service.image, width: 100, height: 70, fit: BoxFit.cover),
            ),
          ],
        ),
      ],
    );
  }
}
