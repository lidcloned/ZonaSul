import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class RoleService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Obter todos os membros
  Stream<List<UserModel>> getAllMembers() {
    return _firestore
        .collection('users')
        .orderBy('username')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => UserModel.fromMap(doc.data()))
          .toList();
    });
  }

  // Obter membros por cargo
  Stream<List<UserModel>> getMembersByRole(String role) {
    return _firestore
        .collection('users')
        .where('role', isEqualTo: role)
        .orderBy('username')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => UserModel.fromMap(doc.data()))
          .toList();
    });
  }

  // Promover membro para administrador
  Future<void> promoteToAdmin(String userId) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'role': 'admin',
      });
    } catch (e) {
      rethrow;
    }
  }

  // Rebaixar administrador para membro
  Future<void> demoteToMember(String userId) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'role': 'member',
      });
    } catch (e) {
      rethrow;
    }
  }

  // Transferir propriedade do clã
  Future<void> transferOwnership(String newOwnerId, String currentOwnerId) async {
    try {
      // Iniciar transação para garantir que ambas as operações sejam concluídas
      await _firestore.runTransaction((transaction) async {
        // Rebaixar o dono atual para administrador
        transaction.update(
          _firestore.collection('users').doc(currentOwnerId),
          {'role': 'admin'},
        );

        // Promover o novo dono
        transaction.update(
          _firestore.collection('users').doc(newOwnerId),
          {'role': 'owner'},
        );
      });
    } catch (e) {
      rethrow;
    }
  }

  // Verificar se o usuário é o único dono
  Future<bool> isOnlyOwner(String userId) async {
    try {
      // Verificar se o usuário é dono
      final userDoc = await _firestore.collection('users').doc(userId).get();
      if (!userDoc.exists || userDoc.data()?['role'] != 'owner') {
        return false;
      }

      // Contar quantos donos existem
      final ownersSnapshot = await _firestore
          .collection('users')
          .where('role', isEqualTo: 'owner')
          .get();

      return ownersSnapshot.docs.length == 1;
    } catch (e) {
      rethrow;
    }
  }

  // Obter membros online (simulação, em produção seria integrado com sistema de presença)
  Future<List<UserModel>> getOnlineMembers() async {
    try {
      // Em uma implementação real, isso seria baseado em um status online/offline
      // Para simulação, vamos retornar alguns membros aleatórios
      final snapshot = await _firestore
          .collection('users')
          .limit(8)
          .get();

      return snapshot.docs
          .map((doc) => UserModel.fromMap(doc.data()))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  // Atualizar nível do usuário
  Future<void> updateUserLevel(String userId, int newLevel) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'level': newLevel,
      });
    } catch (e) {
      rethrow;
    }
  }

  // Atualizar pontos do usuário
  Future<void> updateUserPoints(String userId, int pointsToAdd) async {
    try {
      // Obter pontos atuais
      final userDoc = await _firestore.collection('users').doc(userId).get();
      final currentPoints = userDoc.data()?['points'] ?? 0;

      // Atualizar com novos pontos
      await _firestore.collection('users').doc(userId).update({
        'points': currentPoints + pointsToAdd,
      });
    } catch (e) {
      rethrow;
    }
  }

  // Atualizar horas jogadas do usuário
  Future<void> updateUserHoursPlayed(String userId, int hoursToAdd) async {
    try {
      // Obter horas atuais
      final userDoc = await _firestore.collection('users').doc(userId).get();
      final currentHours = userDoc.data()?['hoursPlayed'] ?? 0;

      // Atualizar com novas horas
      await _firestore.collection('users').doc(userId).update({
        'hoursPlayed': currentHours + hoursToAdd,
      });
    } catch (e) {
      rethrow;
    }
  }
}
