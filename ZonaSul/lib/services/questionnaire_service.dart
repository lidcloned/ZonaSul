import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import '../models/questionnaire_model.dart';

class QuestionnaireService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _uuid = const Uuid();

  // Criar novo questionário
  Future<String> createQuestionnaire({
    required String title,
    required String description,
    required String createdBy,
    required List<QuestionModel> questions,
    required bool isForNewMembers,
    required bool isDaily,
  }) async {
    try {
      final String id = _uuid.v4();
      final QuestionnaireModel questionnaire = QuestionnaireModel(
        id: id,
        title: title,
        description: description,
        createdBy: createdBy,
        createdAt: DateTime.now(),
        questions: questions,
        isForNewMembers: isForNewMembers,
        isDaily: isDaily,
        isActive: true,
      );

      await _firestore
          .collection('questionnaires')
          .doc(id)
          .set(questionnaire.toMap());

      return id;
    } catch (e) {
      rethrow;
    }
  }

  // Obter todos os questionários
  Stream<List<QuestionnaireModel>> getQuestionnaires() {
    return _firestore
        .collection('questionnaires')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => QuestionnaireModel.fromMap(doc.data()))
          .toList();
    });
  }

  // Obter questionários para novos membros
  Stream<List<QuestionnaireModel>> getNewMemberQuestionnaires() {
    return _firestore
        .collection('questionnaires')
        .where('isForNewMembers', isEqualTo: true)
        .where('isActive', isEqualTo: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => QuestionnaireModel.fromMap(doc.data()))
          .toList();
    });
  }

  // Obter questionários diários
  Stream<List<QuestionnaireModel>> getDailyQuestionnaires() {
    return _firestore
        .collection('questionnaires')
        .where('isDaily', isEqualTo: true)
        .where('isActive', isEqualTo: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => QuestionnaireModel.fromMap(doc.data()))
          .toList();
    });
  }

  // Obter questionário por ID
  Future<QuestionnaireModel?> getQuestionnaireById(String id) async {
    try {
      final doc = await _firestore.collection('questionnaires').doc(id).get();
      if (doc.exists) {
        return QuestionnaireModel.fromMap(doc.data()!);
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  // Atualizar questionário
  Future<void> updateQuestionnaire(QuestionnaireModel questionnaire) async {
    try {
      await _firestore
          .collection('questionnaires')
          .doc(questionnaire.id)
          .update(questionnaire.toMap());
    } catch (e) {
      rethrow;
    }
  }

  // Desativar questionário
  Future<void> deactivateQuestionnaire(String id) async {
    try {
      await _firestore.collection('questionnaires').doc(id).update({
        'isActive': false,
      });
    } catch (e) {
      rethrow;
    }
  }

  // Enviar resposta de questionário
  Future<String> submitQuestionnaireResponse({
    required String questionnaireId,
    required String userId,
    required Map<String, dynamic> answers,
  }) async {
    try {
      final String id = _uuid.v4();
      final QuestionnaireResponseModel response = QuestionnaireResponseModel(
        id: id,
        questionnaireId: questionnaireId,
        userId: userId,
        submittedAt: DateTime.now(),
        answers: answers,
      );

      await _firestore
          .collection('questionnaire_responses')
          .doc(id)
          .set(response.toMap());

      return id;
    } catch (e) {
      rethrow;
    }
  }

  // Obter respostas de questionário por usuário
  Future<List<QuestionnaireResponseModel>> getUserResponses(
      String userId) async {
    try {
      final snapshot = await _firestore
          .collection('questionnaire_responses')
          .where('userId', isEqualTo: userId)
          .orderBy('submittedAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => QuestionnaireResponseModel.fromMap(doc.data()))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  // Verificar se o usuário já respondeu um questionário específico
  Future<bool> hasUserRespondedQuestionnaire(
      String userId, String questionnaireId) async {
    try {
      final snapshot = await _firestore
          .collection('questionnaire_responses')
          .where('userId', isEqualTo: userId)
          .where('questionnaireId', isEqualTo: questionnaireId)
          .limit(1)
          .get();

      return snapshot.docs.isNotEmpty;
    } catch (e) {
      rethrow;
    }
  }

  // Obter todas as respostas para um questionário específico
  Future<List<QuestionnaireResponseModel>> getQuestionnaireResponses(
      String questionnaireId) async {
    try {
      final snapshot = await _firestore
          .collection('questionnaire_responses')
          .where('questionnaireId', isEqualTo: questionnaireId)
          .orderBy('submittedAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => QuestionnaireResponseModel.fromMap(doc.data()))
          .toList();
    } catch (e) {
      rethrow;
    }
  }
}
