import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import '../models/area_model.dart';

abstract class AreaRemoteDataSource {
  Future<AreaModel> createArea(AreaModel area);
  Future<List<AreaModel>> getAreas();
  Future<AreaModel> getAreaById(String id);
  Future<List<AreaModel>> getAreasByAgentId(String agentId);
  Future<AreaModel> updateArea(AreaModel area);
  Future<void> deleteArea(String id);
}

@LazySingleton(as: AreaRemoteDataSource)
class AreaRemoteDataSourceImpl implements AreaRemoteDataSource {
  final FirebaseFirestore firestore;

  AreaRemoteDataSourceImpl({required this.firestore});

  @override
  Future<AreaModel> createArea(AreaModel area) async {
    try {
      await firestore.collection('areas').doc(area.id).set(area.toFirestore());
      return area;
    } catch (e) {
      throw Exception('Failed to create area: $e');
    }
  }

  @override
  Future<List<AreaModel>> getAreas() async {
    try {
      final snapshot = await firestore
          .collection('areas')
          .where('isActive', isEqualTo: true)
          .get();

      final areas = snapshot.docs
          .map((doc) => AreaModel.fromFirestore(doc.data()))
          .toList();

      // Sort by name in the app instead of using orderBy in the query
      areas.sort((a, b) => a.name.compareTo(b.name));

      return areas;
    } catch (e) {
      throw Exception('Failed to get areas: $e');
    }
  }

  @override
  Future<AreaModel> getAreaById(String id) async {
    try {
      final doc = await firestore.collection('areas').doc(id).get();

      if (!doc.exists) {
        throw Exception('Area not found');
      }

      return AreaModel.fromFirestore(doc.data()!);
    } catch (e) {
      throw Exception('Failed to get area: $e');
    }
  }

  @override
  Future<List<AreaModel>> getAreasByAgentId(String agentId) async {
    try {
      final snapshot = await firestore
          .collection('areas')
          .where('isActive', isEqualTo: true)
          .where('assignedAgentIds', arrayContains: agentId)
          .get();

      final areas = snapshot.docs
          .map((doc) => AreaModel.fromFirestore(doc.data()))
          .toList();

      // Sort by name in the app instead of using orderBy in the query
      areas.sort((a, b) => a.name.compareTo(b.name));

      return areas;
    } catch (e) {
      throw Exception('Failed to get areas by agent: $e');
    }
  }

  @override
  Future<AreaModel> updateArea(AreaModel area) async {
    try {
      final updatedArea = area.copyWith(updatedAt: DateTime.now()) as AreaModel;
      await firestore
          .collection('areas')
          .doc(area.id)
          .update(updatedArea.toFirestore());
      return updatedArea;
    } catch (e) {
      throw Exception('Failed to update area: $e');
    }
  }

  @override
  Future<void> deleteArea(String id) async {
    try {
      // Soft delete by setting isActive to false
      await firestore.collection('areas').doc(id).update({
        'isActive': false,
        'updatedAt': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      throw Exception('Failed to delete area: $e');
    }
  }
}
