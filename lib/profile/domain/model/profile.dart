class Profile {
  final int id;
  late final String name;
  late final String fatherName;
  late final String motherName;
  late final String documentNumber;
  late final String dateOfBirth;
  late final String phoneNumber;
  late final String photoUrl;
  final int userId;
  Profile({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.fatherName,
    required this.motherName,
    required this.userId,
    required this.documentNumber,
    required this.dateOfBirth,
    required this.photoUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'fatherName': fatherName,
      'motherName': motherName,
      'phone': phoneNumber,
      'documentNumber': documentNumber,
      'dateOfBirth': dateOfBirth,
      'userId': userId,
      'photoUrl':photoUrl
    };
  }

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['id'],
      phoneNumber: json['phone'],
      name: json['fullName'].split(" ")[0],
      fatherName: json['fullName'].split(" ")[1],
      motherName: json['fullName'].split(" ")[2],
      documentNumber: json['documentNumber'],
      dateOfBirth: json['dateOfBirth'],
      userId: json['userId'],
      photoUrl: json['photoUrl']
    );
  }
}