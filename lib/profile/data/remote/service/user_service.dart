import 'package:alquilafacil/profile/domain/model/profile.dart';

abstract class UserService {
  Future<String> getUsernameByUserId(int userId);
  Future<Profile> createProfile(String email, String password,String name, String fatherName, String motherName, String documentNumber, String dateOfBirth, String phoneNumber, String photoUrl);
  Future<Profile> getProfileByUserId(int userId);
  Future<Profile> updateProfile(int id, Map<String, dynamic> profileToUpdate);
}