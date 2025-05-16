
import 'dart:collection';
import 'dart:io';

import 'package:alquilafacil/spaces/domain/model/space.dart';

abstract class SpaceService{
  Future<List<Space>> getAllSpaces();
  Future<Space> getSpaceById(int id);
  Future<HashSet<String>>  getAllDistricts();
  Future<List<Space>> getAllSpacesByCategoryIdAndCapacityRange(int categoryId, int minRange, int maxRange);
  Future<String> uploadImage(File image);
  Future<String> createSpace(Space space);
  Future<List<Space>> getSpacesByUserId(int userId);
  Future<Space> updateSpace(int spaceId, Map<String, dynamic> spaceToUpdate);
}