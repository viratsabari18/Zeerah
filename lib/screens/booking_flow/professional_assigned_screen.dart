import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:zeerah/core/common/app_exports.dart';

class ProfessionalAssignedScreen extends StatefulWidget {
  final CategoryItem service;
  final BookingStatusModel bookingStatus;

  const ProfessionalAssignedScreen({
    required this.service,
    required this.bookingStatus,
    super.key,
  });

  @override
  State<ProfessionalAssignedScreen> createState() => _ProfessionalAssignedScreenState();
}

class _ProfessionalAssignedScreenState extends State<ProfessionalAssignedScreen> {
  late GoogleMapController mapController;
  Timer? _movementTimer;
  LatLng _userLocation = const LatLng(28.6139, 77.2090); // Default Delhi
  LatLng _currentRiderPos = const LatLng(28.6155, 77.2150);
  late int _remainingMins;
  late BookingState _simulatedState;
  BitmapDescriptor? _carIcon;
  List<LatLng> _routePoints = [];
  int _currentStep = 0;
  bool _isLoadingLocation = true;

  @override
  void initState() {
    super.initState();
    _currentRiderPos = const LatLng(28.6155, 77.2150); // Initial fallback
    _remainingMins = 12;
    _simulatedState = widget.bookingStatus.currentState;
    _initializeTracking();
  }

  Future<void> _initializeTracking() async {
    _generateRoadSnappedRoute(); // Populate initial route with fallback coords
    _startMovementSimulation(); // Start moving immediately
    
    // Background tasks that shouldn't block the visual simulation
    _loadCustomIcons();
    _determinePosition(); 
  }

  Future<void> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if (mounted) setState(() => _isLoadingLocation = false);
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        if (mounted) setState(() => _isLoadingLocation = false);
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      if (mounted) setState(() => _isLoadingLocation = false);
      return;
    }

    try {
      Position position = await Geolocator.getCurrentPosition();
      setState(() {
        _userLocation = LatLng(position.latitude, position.longitude);
        _generateRoadSnappedRoute();
        _isLoadingLocation = false;
      });
      mapController.animateCamera(CameraUpdate.newLatLngZoom(_userLocation, 15));
    } catch (e) {
      if (mounted) setState(() => _isLoadingLocation = false);
    }
  }

  void _generateRoadSnappedRoute() {
    // 1. Defining major road grid turns
    final List<LatLng> majorPoints = [
      LatLng(_userLocation.latitude + 0.005, _userLocation.longitude + 0.005), // Start far
      LatLng(_userLocation.latitude + 0.005, _userLocation.longitude + 0.002), // First Turn
      LatLng(_userLocation.latitude + 0.002, _userLocation.longitude + 0.002), // Second Turn
      LatLng(_userLocation.latitude + 0.001, _userLocation.longitude + 0.001), // Near Turn
      _userLocation, // Home
    ];

    // 2. Interpolate hundreds of small points between major turns for smoothness
    final List<LatLng> smoothPoints = [];
    for (int i = 0; i < majorPoints.length - 1; i++) {
        final start = majorPoints[i];
        final end = majorPoints[i+1];
        const int stepsPerSegment = 50; 
        
        for (int s = 0; s <= stepsPerSegment; s++) {
            final lat = start.latitude + (end.latitude - start.latitude) * (s / stepsPerSegment);
            final lng = start.longitude + (end.longitude - start.longitude) * (s / stepsPerSegment);
            smoothPoints.add(LatLng(lat, lng));
        }
    }
    
    _routePoints = smoothPoints;
    _currentRiderPos = _routePoints[0];
    _currentStep = 0;
  }

  @override
  void dispose() {
    _movementTimer?.cancel();
    super.dispose();
  }

  Future<Uint8List> _getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!.buffer.asUint8List();
  }

  Future<void> _loadCustomIcons() async {
    try {
      final Uint8List markerIcon = await _getBytesFromAsset('lib/assets/images/rider_car.png', 100); 
      if (mounted) {
        setState(() {
          _carIcon = BitmapDescriptor.fromBytes(markerIcon);
        });
      }
    } catch (e) {
      // Fallback already handled in build
    }
  }

  void _startMovementSimulation() {
    if (_routePoints.isEmpty) _generateRoadSnappedRoute(); 
    
    // Smooth Timer: Update every 100ms for fluid movement
    _movementTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (_currentStep < _routePoints.length - 1) {
        if (mounted) {
          setState(() {
            _currentStep++;
            _currentRiderPos = _routePoints[_currentStep];
            
            // ETA Calculation (Simulated total time 20 seconds / 200 ticks)
            double progress = _currentStep / _routePoints.length;
            _remainingMins = (12 - (progress * 11)).toInt().clamp(1, 12);
            
            // Update progress state based on movement
            if (_currentStep > 0 && _currentStep < _routePoints.length - 1) {
              _simulatedState = BookingState.started; 
            } else if (_currentStep == _routePoints.length - 1) {
              _simulatedState = BookingState.completed; 
            }
          });
          
          // If reached final destination
          if (_currentStep == _routePoints.length - 1) {
            _movementTimer?.cancel();
            
            // Arrival Pause before redirect
            Future.delayed(const Duration(seconds: 2), () {
              if (mounted) {
                Navigator.pushReplacementNamed(
                  context, 
                  AppRoutes.serviceVerification,
                  arguments: {
                    'service': widget.service,
                    'status': widget.bookingStatus,
                  },
                );
              }
            });
          }
        }
      } else {
        _movementTimer?.cancel();
      }
    });
  }

  // Silver Map Style for a premium look
  static const String _mapStyle = '''
[
  {
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#f5f5f5"
      }
    ]
  },
  {
    "elementType": "labels.icon",
    "stylers": [
      {
        "visibility": "off"
      }
    ]
  },
  {
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#616161"
      }
    ]
  },
  {
    "elementType": "labels.text.stroke",
    "stylers": [
      {
        "color": "#f5f5f5"
      }
    ]
  },
  {
    "featureType": "administrative.land_parcel",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#bdbdbd"
      }
    ]
  },
  {
    "featureType": "poi",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#eeeeee"
      }
    ]
  },
  {
    "featureType": "poi",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#757575"
      }
    ]
  },
  {
    "featureType": "poi.park",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#e5e5e5"
      }
    ]
  },
  {
    "featureType": "poi.park",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#9e9e9e"
      }
    ]
  },
  {
    "featureType": "road",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#ffffff"
      }
    ]
  },
  {
    "featureType": "road.arterial",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#757575"
      }
    ]
  },
  {
    "featureType": "road.highway",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#dadada"
      }
    ]
  },
  {
    "featureType": "road.highway",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#616161"
      }
    ]
  },
  {
    "featureType": "road.local",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#9e9e9e"
      }
    ]
  },
  {
    "featureType": "transit.line",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#e5e5e5"
      }
    ]
  },
  {
    "featureType": "transit.station",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#eeeeee"
      }
    ]
  },
  {
    "featureType": "water",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#c9c9c9"
      }
    ]
  },
  {
    "featureType": "water",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#9e9e9e"
      }
    ]
  }
]
''';

  @override
  Widget build(BuildContext context) {
    final pro = widget.bookingStatus.professional ?? ProfessionalMatch.dummy();

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                _buildMapHeader(context, "$_remainingMins mins"),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: _buildProProfile(pro),
                ),
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: _buildContactActions(),
                ),
                const SizedBox(height: 32),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: _buildServiceProgress(),
                ),
                const Divider(thickness: 4, color: Color(0xFFEEEEEE), height: 80),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: _buildServiceDetails(),
                ),
                const SizedBox(height: 32),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: _buildActionFooter(),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
          Positioned(
            top: 40,
            left: 20,
            child: CircleAvatar(
              backgroundColor: Colors.white,
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMapHeader(BuildContext context, String time) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        SizedBox(
          height: 300,
          width: double.infinity,
          child: GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _userLocation,
              zoom: 15.0,
            ),
            onMapCreated: (controller) {
              mapController = controller;
              mapController.setMapStyle(_mapStyle);
            },
            polylines: {
               Polyline(
                polylineId: const PolylineId('route'),
                color: const Color(0xFFD90000), // Bold Red path
                width: 5,
                points: _routePoints.sublist(_currentStep),
              ),
            },
            markers: {
              // Rider Marker (Custom Car)
              Marker(
                markerId: const MarkerId('rider'),
                position: _currentRiderPos,
                icon: _carIcon ?? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
                infoWindow: const InfoWindow(title: 'Rider On the Way'),
              ),
              // User Marker (Orange/Red)
              Marker(
                markerId: const MarkerId('user'),
                position: _userLocation,
                icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
                infoWindow: const InfoWindow(title: 'Home'),
              ),
            },
          ),
        ),
        Positioned(
          bottom: 20,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(color: Colors.black12, blurRadius: 10, offset: const Offset(0, 5)),
              ],
            ),
            child: Text(
              "Arriving in $time",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
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
                      color: const Color(0xFF6366F1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      "Accepted",
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
                "On their way to your location",
                style: TextStyle(color: Color(0xFF6366F1), fontWeight: FontWeight.bold, fontSize: 13),
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

  Widget _buildServiceProgress() {
    final steps = widget.bookingStatus.steps ?? [
      const ProgressStepModel(title: "Booking confirmed", subtitle: "", state: BookingState.assigned),
      const ProgressStepModel(title: "Professional Assigned", subtitle: "", state: BookingState.assigned),
      const ProgressStepModel(title: "On the Way", subtitle: "On thier way to your location", state: BookingState.onTheWay),
      const ProgressStepModel(title: "Service Started", subtitle: "", state: BookingState.started),
      const ProgressStepModel(title: "Service Completed", subtitle: "", state: BookingState.completed),
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
          final bool isCompleted = index <= _getStepIndex(_simulatedState);
          final bool isActive = _getStepIndex(step.state) == _getStepIndex(_simulatedState);
          
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

  int _getStepIndex(BookingState state) {
    switch (state) {
      case BookingState.searching: return -1;
      case BookingState.assigned: return 1;
      case BookingState.onTheWay: return 2;
      case BookingState.started: return 3;
      case BookingState.completed: return 4;
      default: return 0;
    }
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
                    widget.service.title,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "${widget.bookingStatus.appointmentDate} ~ ${widget.bookingStatus.appointmentTime}",
                    style: const TextStyle(fontSize: 13, color: Colors.black54),
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

  Widget _buildActionFooter() {
    return Row(
      children: [
        Expanded(child: _buildFooterButton(Icons.calendar_today, "Reschedule", Colors.green[800]!)),
        const SizedBox(width: 8),
        Expanded(child: _buildFooterButton(Icons.close, "Cancel", Colors.red)),
        const SizedBox(width: 8),
        Expanded(child: _buildFooterButton(Icons.support_agent, "Support", Colors.black)),
      ],
    );
  }

  Widget _buildFooterButton(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black12),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12)),
        ],
      ),
    );
  }
}

class MapRoutePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.red
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path()
      ..moveTo(size.width * 0.3, size.height * 0.4)
      ..lineTo(size.width * 0.5, size.height * 0.3)
      ..lineTo(size.width * 0.7, size.height * 0.2);

    canvas.drawPath(path, paint);
    canvas.drawCircle(Offset(size.width * 0.3, size.height * 0.4), 6, Paint()..color = Colors.orange);
    canvas.drawCircle(Offset(size.width * 0.7, size.height * 0.2), 8, Paint()..color = Colors.green);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
