import '../../domain/entities/area.dart';

class AreaModel extends Area {
  const AreaModel({
    required super.id,
    required super.name,
    required super.centerLatitude,
    required super.centerLongitude,
    required super.radiusInMeters,
    super.description,
    required super.assignedAgentIds,
    required super.createdById,
    required super.createdByName,
    required super.createdAt,
    required super.updatedAt,
    super.isActive,
  });

  /// Convert from Firestore document
  factory AreaModel.fromFirestore(Map<String, dynamic> data) {
    return AreaModel(
      id: data['id'] as String,
      name: data['name'] as String,
      centerLatitude: (data['centerLatitude'] as num).toDouble(),
      centerLongitude: (data['centerLongitude'] as num).toDouble(),
      radiusInMeters: (data['radiusInMeters'] as num).toDouble(),
      description: data['description'] as String?,
      assignedAgentIds: List<String>.from(data['assignedAgentIds'] ?? []),
      createdById: data['createdById'] as String,
      createdByName: data['createdByName'] as String,
      createdAt: DateTime.parse(data['createdAt'] as String),
      updatedAt: DateTime.parse(data['updatedAt'] as String),
      isActive: data['isActive'] as bool? ?? true,
    );
  }

  /// Convert to Firestore document
  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'name': name,
      'centerLatitude': centerLatitude,
      'centerLongitude': centerLongitude,
      'radiusInMeters': radiusInMeters,
      'description': description,
      'assignedAgentIds': assignedAgentIds,
      'createdById': createdById,
      'createdByName': createdByName,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'isActive': isActive,
    };
  }

  /// Convert from entity
  factory AreaModel.fromEntity(Area area) {
    return AreaModel(
      id: area.id,
      name: area.name,
      centerLatitude: area.centerLatitude,
      centerLongitude: area.centerLongitude,
      radiusInMeters: area.radiusInMeters,
      description: area.description,
      assignedAgentIds: area.assignedAgentIds,
      createdById: area.createdById,
      createdByName: area.createdByName,
      createdAt: area.createdAt,
      updatedAt: area.updatedAt,
      isActive: area.isActive,
    );
  }
}
