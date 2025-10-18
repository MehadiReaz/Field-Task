import 'package:equatable/equatable.dart';

class Area extends Equatable {
  final String id;
  final String name;
  final double centerLatitude;
  final double centerLongitude;
  final double radiusInMeters;
  final String? description;
  final List<String> assignedAgentIds;
  final String createdById;
  final String createdByName;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isActive;

  const Area({
    required this.id,
    required this.name,
    required this.centerLatitude,
    required this.centerLongitude,
    required this.radiusInMeters,
    this.description,
    required this.assignedAgentIds,
    required this.createdById,
    required this.createdByName,
    required this.createdAt,
    required this.updatedAt,
    this.isActive = true,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        centerLatitude,
        centerLongitude,
        radiusInMeters,
        description,
        assignedAgentIds,
        createdById,
        createdByName,
        createdAt,
        updatedAt,
        isActive,
      ];

  Area copyWith({
    String? id,
    String? name,
    double? centerLatitude,
    double? centerLongitude,
    double? radiusInMeters,
    String? description,
    List<String>? assignedAgentIds,
    String? createdById,
    String? createdByName,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isActive,
  }) {
    return Area(
      id: id ?? this.id,
      name: name ?? this.name,
      centerLatitude: centerLatitude ?? this.centerLatitude,
      centerLongitude: centerLongitude ?? this.centerLongitude,
      radiusInMeters: radiusInMeters ?? this.radiusInMeters,
      description: description ?? this.description,
      assignedAgentIds: assignedAgentIds ?? this.assignedAgentIds,
      createdById: createdById ?? this.createdById,
      createdByName: createdByName ?? this.createdByName,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isActive: isActive ?? this.isActive,
    );
  }
}
