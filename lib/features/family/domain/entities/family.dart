class FamilyMember {
  final String userId;
  final String email;
  final String displayName;
  final String role; // 'admin' or 'member'
  final DateTime dateJoined;

  FamilyMember({
    required this.userId,
    required this.email,
    required this.displayName,
    this.role = 'member',
    DateTime? dateJoined,
  }) : dateJoined = dateJoined ?? DateTime.now();

  Map<String, dynamic> toMap() => {
    'userId': userId,
    'email': email,
    'displayName': displayName,
    'role': role,
    'dateJoined': dateJoined.toIso8601String(),
  };

  factory FamilyMember.fromMap(Map<String, dynamic> map) {
    return FamilyMember(
      userId: map['userId'] as String,
      email: map['email'] as String,
      displayName: map['displayName'] as String,
      role: map['role'] as String? ?? 'member',
      dateJoined: map['dateJoined'] != null
          ? DateTime.parse(map['dateJoined'] as String)
          : null,
    );
  }
}

class Family {
  final String id;
  final String name;
  final String adminId;
  final List<FamilyMember> members;
  final String inviteCode;
  final DateTime createdAt;

  Family({
    required this.id,
    required this.name,
    required this.adminId,
    List<FamilyMember>? members,
    required this.inviteCode,
    DateTime? createdAt,
  })  : members = members ?? [],
        createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'adminId': adminId,
    'members': members.map((m) => m.toMap()).toList(),
    'inviteCode': inviteCode,
    'createdAt': createdAt.toIso8601String(),
  };

  factory Family.fromMap(Map<String, dynamic> map) {
    return Family(
      id: map['id'] as String,
      name: map['name'] as String,
      adminId: map['adminId'] as String,
      members: (map['members'] as List<dynamic>? ?? [])
          .map((m) => FamilyMember.fromMap(Map<String, dynamic>.from(m as Map)))
          .toList(),
      inviteCode: map['inviteCode'] as String,
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'] as String)
          : null,
    );
  }
}
