import 'package:zeerah/core/models/service_models.dart';

class BookingModel {
  final String title;
  final String price;
  final String address;
  final String date;
  final String time;
  final BookingStatus status;
  final PaymentStatus paymentStatus;
  final String image;
  final ProfessionalMatch professional;

  BookingModel({
    required this.title,
    required this.price,
    required this.address,
    required this.date,
    required this.time,
    required this.status,
    required this.paymentStatus,
    required this.image,
    required this.professional,
  });

  /// FROM JSON
  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      title: json['title'] ?? '',
      price: json['price'] ?? '',
      address: json['address'] ?? '',
      date: json['date'] ?? '',
      time: json['time'] ?? '',
      status: BookingStatusExt.fromString(json['status']),
      paymentStatus:
          PaymentStatusExt.fromString(json['paymentStatus']),
      image: json['image'] ?? '',
      professional:
          ProfessionalMatch.fromJson(json['professional'] ?? {}),
    );
  }

  /// TO JSON
  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "price": price,
      "address": address,
      "date": date,
      "time": time,
      "status": status.value,
      "paymentStatus": paymentStatus.value,
      "image": image,
      "professional": professional.toJson(),
    };
  }


  static List<BookingModel> dummyList() {
    return [
      BookingModel(
        title: "Bathroom Cleaning",
        price: "₹200",
        address: "2,2 Katampe, Abuja, Nigeria",
        date: "March 16, 2026",
        time: "10:00AM",
        status: BookingStatus.inProgress,
        paymentStatus: PaymentStatus.pending,
        image: "https://picsum.photos/200",
        professional: ProfessionalMatch.dummy(),
      ),
      BookingModel(
        title: "Deep Cleaning",
        price: "₹2,599",
        address: "2,2 Katampe, Abuja",
        date: "March 16, 2026",
        time: "10:00AM",
        status: BookingStatus.accepted,
        paymentStatus: PaymentStatus.pending,
        image: "https://picsum.photos/201",
        professional: ProfessionalMatch.dummy(),
      ),
      BookingModel(
        title: "Filter Replacement",
        price: "₹650",
        address: "2,2 Katampe, Abuja",
        date: "March 16, 2026",
        time: "10:00AM",
        status: BookingStatus.completed,
        paymentStatus: PaymentStatus.paid,
        image: "https://picsum.photos/202",
        professional: ProfessionalMatch.dummy(),
      ),
      BookingModel(
        title: "Deep Cleaning",
        price: "₹2,399",
        address: "2,2 Katampe, Abuja",
        date: "March 16, 2026",
        time: "10:00AM",
        status: BookingStatus.rejected,
        paymentStatus: PaymentStatus.failed,
        image: "https://picsum.photos/203",
        professional: ProfessionalMatch.dummy(),
      ),
    ];
  }
}

enum PaymentStatus {
  pending,
  paid,
  failed,
  refunded,
}

enum BookingStatus {
  inProgress,
  accepted,
  completed,
  rejected,
}

extension PaymentStatusExt on PaymentStatus {
  String get value {
    switch (this) {
      case PaymentStatus.pending:
        return "Pending";
      case PaymentStatus.paid:
        return "Paid";
      case PaymentStatus.failed:
        return "Failed";
      case PaymentStatus.refunded:
        return "Refunded";
    }
  }

  static PaymentStatus fromString(String? status) {
    switch (status) {
      case "Paid":
        return PaymentStatus.paid;
      case "Failed":
        return PaymentStatus.failed;
      case "Refunded":
        return PaymentStatus.refunded;
      case "Pending":
      default:
        return PaymentStatus.pending;
    }
  }
}
extension BookingStatusExt on BookingStatus {
  String get value {
    switch (this) {
      case BookingStatus.inProgress:
        return "In Progress";
      case BookingStatus.accepted:
        return "Accepted";
      case BookingStatus.completed:
        return "Completed";
      case BookingStatus.rejected:
        return "Rejected";
    }
  }

  static BookingStatus fromString(String? status) {
    switch (status) {
      case "Accepted":
        return BookingStatus.accepted;
      case "Completed":
        return BookingStatus.completed;
      case "Rejected":
        return BookingStatus.rejected;
      case "In Progress":
      default:
        return BookingStatus.inProgress;
    }
  }
}