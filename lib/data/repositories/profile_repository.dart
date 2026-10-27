import 'package:isar_community/isar.dart';

import '../models/user_profile.dart';

class ProfileRepository {
  ProfileRepository(this._isar);
  final Isar _isar;

  Stream<UserProfile?> watch() => _isar.userProfiles.watchObject(
    UserProfile.singletonId,
    fireImmediately: true,
  );

  Future<UserProfile?> get() => _isar.userProfiles.get(UserProfile.singletonId);

  Future<UserProfile> getOrCreate() async {
    final existing = await get();
    if (existing != null) return existing;
    final profile = UserProfile();
    await save(profile);
    return profile;
  }

  Future<void> save(UserProfile profile) async {
    profile.id = UserProfile.singletonId;
    await _isar.writeTxn(() => _isar.userProfiles.put(profile));
  }

  Future<void> deleteAll() =>
      _isar.writeTxn(() => _isar.userProfiles.where().deleteAll());
}
