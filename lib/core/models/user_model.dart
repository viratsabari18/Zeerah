class UserModel {
  final String id;
  final String name;
  final String image;
  final String lastSeen;

  UserModel({
    required this.id,
    required this.name,
    required this.image,
    required this.lastSeen,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      image: json['image'],
      lastSeen: json['last_seen'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "image": image,
      "last_seen": lastSeen,
    };
  }
}