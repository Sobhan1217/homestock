import 'package:hive/hive.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../features/family/domain/entities/family.dart';

final familyServiceProvider = Provider((ref) => FamilyService());

class FamilyService {
  static const String boxName = 'family_box';
  late Box<Map> _box;
  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;
    try {
      _box = await Hive.openBox<Map>(boxName);
      _initialized = true;
    } catch (e) {
      print('Error initializing family service: $e');
    }
  }

  // Generate invite code (6-character alphanumeric)
  String _generateInviteCode() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = <int>[];
    for (int i = 0; i < 6; i++) {
      random.add((DateTime.now().millisecondsSinceEpoch + i) % chars.length);
    }
    return random.map((i) => chars[i % chars.length]).join();
  }

  // Create family
  Future<Family> createFamily({
    required String familyName,
    required String adminId,
    required String adminEmail,
    required String adminName,
  }) async {
    try {
      await init();
      final family = Family(
        id: const Uuid().v4(),
        name: familyName,
        adminId: adminId,
        inviteCode: _generateInviteCode(),
        members: [
          FamilyMember(
            userId: adminId,
            email: adminEmail,
            displayName: adminName,
            role: 'admin',
          ),
        ],
      );
      await _box.put(family.id, family.toMap());
      return family;
    } catch (e) {
      print('Error creating family: $e');
      rethrow;
    }
  }

  // Join family by invite code
  Future<Family?> joinFamilyByCode({
    required String inviteCode,
    required String userId,
    required String userEmail,
    required String userName,
  }) async {
    try {
      await init();
      final allFamilies = _box.values
          .map((v) => Family.fromMap(Map<String, dynamic>.from(v)))
          .toList();

      final family = allFamilies.firstWhere(
        (f) => f.inviteCode.toUpperCase() == inviteCode.toUpperCase(),
        orElse: () => Family(
          id: '',
          name: '',
          adminId: '',
          inviteCode: '',
        ),
      );

      if (family.id.isEmpty) return null;

      // Check if already a member
      if (family.members.any((m) => m.userId == userId)) {
        return family;
      }

      // Add new member
      final newMember = FamilyMember(
        userId: userId,
        email: userEmail,
        displayName: userName,
        role: 'member',
      );

      family.members.add(newMember);
      await _box.put(family.id, family.toMap());
      return family;
    } catch (e) {
      print('Error joining family: $e');
      rethrow;
    }
  }

  // Get user's family
  Future<Family?> getUserFamily(String userId) async {
    try {
      await init();
      final allFamilies = _box.values
          .map((v) => Family.fromMap(Map<String, dynamic>.from(v)))
          .toList();

      try {
        return allFamilies.firstWhere(
          (f) => f.members.any((m) => m.userId == userId),
        );
      } catch (e) {
        return null;
      }
    } catch (e) {
      print('Error getting user family: $e');
      return null;
    }
  }

  // Get all families (admin only)
  List<Family> getAll() {
    try {
      return _box.values
          .map((v) => Family.fromMap(Map<String, dynamic>.from(v)))
          .toList();
    } catch (e) {
      print('Error getting all families: $e');
      return [];
    }
  }

  // Add member to family (admin only)
  Future<void> addMember({
    required String familyId,
    required String userId,
    required String userEmail,
    required String userName,
  }) async {
    try {
      await init();
      final familyMap = _box.get(familyId);
      if (familyMap != null) {
        final family = Family.fromMap(Map<String, dynamic>.from(familyMap));
        if (!family.members.any((m) => m.userId == userId)) {
          family.members.add(
            FamilyMember(
              userId: userId,
              email: userEmail,
              displayName: userName,
              role: 'member',
            ),
          );
          await _box.put(familyId, family.toMap());
        }
      }
    } catch (e) {
      print('Error adding member: $e');
    }
  }

  // Remove member from family
  Future<void> removeMember({
    required String familyId,
    required String userId,
  }) async {
    try {
      await init();
      final familyMap = _box.get(familyId);
      if (familyMap != null) {
        final family = Family.fromMap(Map<String, dynamic>.from(familyMap));
        family.members.removeWhere((m) => m.userId == userId);
        await _box.put(familyId, family.toMap());
      }
    } catch (e) {
      print('Error removing member: $e');
    }
  }

  // Update family name
  Future<void> updateFamilyName({
    required String familyId,
    required String newName,
  }) async {
    try {
      await init();
      final familyMap = _box.get(familyId);
      if (familyMap != null) {
        familyMap['name'] = newName;
        await _box.put(familyId, familyMap);
      }
    } catch (e) {
      print('Error updating family name: $e');
    }
  }
}
