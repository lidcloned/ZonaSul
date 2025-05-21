import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import '../models/mission_model.dart';

class MissionService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _uuid = const Uuid();

  // Criar nova missão (sugestão)
  Future<String> createMission({
    required String title,
    required String description,
    required String createdBy,
    required String difficulty,
    required String reward,
  }) async {
    try {
      final String id = _uuid.v4();
      final MissionModel mission = MissionModel(
        id: id,
        title: title,
        description: description,
        createdBy: createdBy,
        createdAt: DateTime.now(),
        difficulty: difficulty,
        reward: reward,
        status: MissionStatus.pending,
        assignedTo: [],
      );

      await _firestore.collection('missions').doc(id).set(mission.toMap());

      return id;
    } catch (e) {
      rethrow;
    }
  }

  // Obter todas as missões
  Stream<List<MissionModel>> getAllMissions() {
    return _firestore
        .collection('missions')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => MissionModel.fromMap(doc.data()))
          .toList();
    });
  }

  // Obter missões pendentes de aprovação
  Stream<List<MissionModel>> getPendingMissions() {
    return _firestore
        .collection('missions')
        .where('status', isEqualTo: MissionStatus.pending.toString().split('.').last)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => MissionModel.fromMap(doc.data()))
          .toList();
    });
  }

  // Obter missões disponíveis (aprovadas)
  Stream<List<MissionModel>> getAvailableMissions() {
    return _firestore
        .collection('missions')
        .where('status', isEqualTo: MissionStatus.approved.toString().split('.').last)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => MissionModel.fromMap(doc.data()))
          .toList();
    });
  }

  // Obter missões em andamento para um usuário
  Stream<List<MissionModel>> getUserInProgressMissions(String userId) {
    return _firestore
        .collection('missions')
        .where('status', isEqualTo: MissionStatus.inProgress.toString().split('.').last)
        .where('assignedTo', arrayContains: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => MissionModel.fromMap(doc.data()))
          .toList();
    });
  }

  // Obter missões concluídas para um usuário
  Stream<List<MissionModel>> getUserCompletedMissions(String userId) {
    return _firestore
        .collection('missions')
        .where('status', whereIn: [
          MissionStatus.completed.toString().split('.').last,
          MissionStatus.validated.toString().split('.').last
        ])
        .where('assignedTo', arrayContains: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => MissionModel.fromMap(doc.data()))
          .toList();
    });
  }

  // Obter missão por ID
  Future<MissionModel?> getMissionById(String id) async {
    try {
      final doc = await _firestore.collection('missions').doc(id).get();
      if (doc.exists) {
        return MissionModel.fromMap(doc.data()!);
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  // Aprovar missão
  Future<void> approveMission(String id) async {
    try {
      await _firestore.collection('missions').doc(id).update({
        'status': MissionStatus.approved.toString().split('.').last,
      });
    } catch (e) {
      rethrow;
    }
  }

  // Rejeitar missão
  Future<void> rejectMission(String id) async {
    try {
      await _firestore.collection('missions').doc(id).update({
        'status': MissionStatus.rejected.toString().split('.').last,
      });
    } catch (e) {
      rethrow;
    }
  }

  // Aceitar missão (usuário)
  Future<void> acceptMission(String missionId, String userId) async {
    try {
      await _firestore.collection('missions').doc(missionId).update({
        'status': MissionStatus.inProgress.toString().split('.').last,
        'assignedTo': FieldValue.arrayUnion([userId]),
      });
    } catch (e) {
      rethrow;
    }
  }

  // Atualizar progresso da missão
  Future<void> updateMissionProgress(String id, double progress) async {
    try {
      await _firestore.collection('missions').doc(id).update({
        'progress': progress,
      });
    } catch (e) {
      rethrow;
    }
  }

  // Marcar missão como concluída
  Future<void> completeMission(String id) async {
    try {
      await _firestore.collection('missions').doc(id).update({
        'status': MissionStatus.completed.toString().split('.').last,
        'completedAt': Timestamp.fromDate(DateTime.now()),
      });
    } catch (e) {
      rethrow;
    }
  }

  // Validar missão concluída
  Future<void> validateMission(String id, String validatedBy) async {
    try {
      await _firestore.collection('missions').doc(id).update({
        'status': MissionStatus.validated.toString().split('.').last,
        'validatedBy': validatedBy,
        'validatedAt': Timestamp.fromDate(DateTime.now()),
      });
    } catch (e) {
      rethrow;
    }
  }

  // Atualizar missão
  Future<void> updateMission(MissionModel mission) async {
    try {
      await _firestore
          .collection('missions')
          .doc(mission.id)
          .update(mission.toMap());
    } catch (e) {
      rethrow;
    }
  }
}
