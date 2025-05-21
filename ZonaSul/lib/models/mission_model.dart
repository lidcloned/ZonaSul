import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class MissionModel {
  final String id;
  final String title;
  final String description;
  final String createdBy;
  final DateTime createdAt;
  final String difficulty;
  final String reward;
  final MissionStatus status;
  final List<String> assignedTo;
  final double progress;
  final DateTime? completedAt;
  final String? validatedBy;
  final DateTime? validatedAt;

  MissionModel({
    required this.id,
    required this.title,
    required this.description,
    required this.createdBy,
    required this.createdAt,
    required this.difficulty,
    required this.reward,
    required this.status,
    required this.assignedTo,
    this.progress = 0.0,
    this.completedAt,
    this.validatedBy,
    this.validatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'createdBy': createdBy,
      'createdAt': Timestamp.fromDate(createdAt),
      'difficulty': difficulty,
      'reward': reward,
      'status': status.toString().split('.').last,
      'assignedTo': assignedTo,
      'progress': progress,
      'completedAt': completedAt != null ? Timestamp.fromDate(completedAt!) : null,
      'validatedBy': validatedBy,
      'validatedAt': validatedAt != null ? Timestamp.fromDate(validatedAt!) : null,
    };
  }

  factory MissionModel.fromMap(Map<String, dynamic> map) {
    return MissionModel(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      createdBy: map['createdBy'] ?? '',
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      difficulty: map['difficulty'] ?? 'Média',
      reward: map['reward'] ?? '',
      status: _getMissionStatusFromString(map['status'] ?? 'pending'),
      assignedTo: List<String>.from(map['assignedTo'] ?? []),
      progress: map['progress']?.toDouble() ?? 0.0,
      completedAt: map['completedAt'] != null ? (map['completedAt'] as Timestamp).toDate() : null,
      validatedBy: map['validatedBy'],
      validatedAt: map['validatedAt'] != null ? (map['validatedAt'] as Timestamp).toDate() : null,
    );
  }

  MissionModel copyWith({
    String? id,
    String? title,
    String? description,
    String? createdBy,
    DateTime? createdAt,
    String? difficulty,
    String? reward,
    MissionStatus? status,
    List<String>? assignedTo,
    double? progress,
    DateTime? completedAt,
    String? validatedBy,
    DateTime? validatedAt,
  }) {
    return MissionModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      difficulty: difficulty ?? this.difficulty,
      reward: reward ?? this.reward,
      status: status ?? this.status,
      assignedTo: assignedTo ?? this.assignedTo,
      progress: progress ?? this.progress,
      completedAt: completedAt ?? this.completedAt,
      validatedBy: validatedBy ?? this.validatedBy,
      validatedAt: validatedAt ?? this.validatedAt,
    );
  }
}

enum MissionStatus {
  pending,
  approved,
  inProgress,
  completed,
  validated,
  rejected,
}

MissionStatus _getMissionStatusFromString(String status) {
  switch (status) {
    case 'pending':
      return MissionStatus.pending;
    case 'approved':
      return MissionStatus.approved;
    case 'inProgress':
      return MissionStatus.inProgress;
    case 'completed':
      return MissionStatus.completed;
    case 'validated':
      return MissionStatus.validated;
    case 'rejected':
      return MissionStatus.rejected;
    default:
      return MissionStatus.pending;
  }
}
