class UserModel {
  final String uid;
  final String username;
  final String email;
  final String gameName;
  final String whatsapp;
  final String role; // 'owner', 'admin', 'member'
  final int level;
  final int hoursPlayed;
  final int points;
  final String profileImageUrl;
  final String joinDate;

  UserModel({
    required this.uid,
    required this.username,
    required this.email,
    required this.gameName,
    required this.whatsapp,
    required this.role,
    this.level = 1,
    this.hoursPlayed = 0,
    this.points = 0,
    this.profileImageUrl = '',
    required this.joinDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'username': username,
      'email': email,
      'gameName': gameName,
      'whatsapp': whatsapp,
      'role': role,
      'level': level,
      'hoursPlayed': hoursPlayed,
      'points': points,
      'profileImageUrl': profileImageUrl,
      'joinDate': joinDate,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      username: map['username'] ?? '',
      email: map['email'] ?? '',
      gameName: map['gameName'] ?? '',
      whatsapp: map['whatsapp'] ?? '',
      role: map['role'] ?? 'member',
      level: map['level'] ?? 1,
      hoursPlayed: map['hoursPlayed'] ?? 0,
      points: map['points'] ?? 0,
      profileImageUrl: map['profileImageUrl'] ?? '',
      joinDate: map['joinDate'] ?? '',
    );
  }

  UserModel copyWith({
    String? uid,
    String? username,
    String? email,
    String? gameName,
    String? whatsapp,
    String? role,
    int? level,
    int? hoursPlayed,
    int? points,
    String? profileImageUrl,
    String? joinDate,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      username: username ?? this.username,
      email: email ?? this.email,
      gameName: gameName ?? this.gameName,
      whatsapp: whatsapp ?? this.whatsapp,
      role: role ?? this.role,
      level: level ?? this.level,
      hoursPlayed: hoursPlayed ?? this.hoursPlayed,
      points: points ?? this.points,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      joinDate: joinDate ?? this.joinDate,
    );
  }
}
