import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/user_model.dart';

class QuestionnaireModel {
  final String id;
  final String title;
  final String description;
  final String createdBy;
  final DateTime createdAt;
  final List<QuestionModel> questions;
  final bool isForNewMembers;
  final bool isDaily;
  final bool isActive;

  QuestionnaireModel({
    required this.id,
    required this.title,
    required this.description,
    required this.createdBy,
    required this.createdAt,
    required this.questions,
    required this.isForNewMembers,
    required this.isDaily,
    required this.isActive,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'createdBy': createdBy,
      'createdAt': Timestamp.fromDate(createdAt),
      'questions': questions.map((q) => q.toMap()).toList(),
      'isForNewMembers': isForNewMembers,
      'isDaily': isDaily,
      'isActive': isActive,
    };
  }

  factory QuestionnaireModel.fromMap(Map<String, dynamic> map) {
    return QuestionnaireModel(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      createdBy: map['createdBy'] ?? '',
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      questions: List<QuestionModel>.from(
        (map['questions'] as List).map(
          (q) => QuestionModel.fromMap(q),
        ),
      ),
      isForNewMembers: map['isForNewMembers'] ?? false,
      isDaily: map['isDaily'] ?? false,
      isActive: map['isActive'] ?? true,
    );
  }
}

class QuestionModel {
  final String id;
  final String text;
  final QuestionType type;
  final List<String> options;
  final bool isRequired;

  QuestionModel({
    required this.id,
    required this.text,
    required this.type,
    required this.options,
    required this.isRequired,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'text': text,
      'type': type.toString().split('.').last,
      'options': options,
      'isRequired': isRequired,
    };
  }

  factory QuestionModel.fromMap(Map<String, dynamic> map) {
    return QuestionModel(
      id: map['id'] ?? '',
      text: map['text'] ?? '',
      type: _getQuestionTypeFromString(map['type'] ?? 'text'),
      options: List<String>.from(map['options'] ?? []),
      isRequired: map['isRequired'] ?? true,
    );
  }
}

enum QuestionType {
  text,
  multipleChoice,
  checkbox,
  number,
  date,
}

QuestionType _getQuestionTypeFromString(String type) {
  switch (type) {
    case 'text':
      return QuestionType.text;
    case 'multipleChoice':
      return QuestionType.multipleChoice;
    case 'checkbox':
      return QuestionType.checkbox;
    case 'number':
      return QuestionType.number;
    case 'date':
      return QuestionType.date;
    default:
      return QuestionType.text;
  }
}

class QuestionnaireResponseModel {
  final String id;
  final String questionnaireId;
  final String userId;
  final DateTime submittedAt;
  final Map<String, dynamic> answers;

  QuestionnaireResponseModel({
    required this.id,
    required this.questionnaireId,
    required this.userId,
    required this.submittedAt,
    required this.answers,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'questionnaireId': questionnaireId,
      'userId': userId,
      'submittedAt': Timestamp.fromDate(submittedAt),
      'answers': answers,
    };
  }

  factory QuestionnaireResponseModel.fromMap(Map<String, dynamic> map) {
    return QuestionnaireResponseModel(
      id: map['id'] ?? '',
      questionnaireId: map['questionnaireId'] ?? '',
      userId: map['userId'] ?? '',
      submittedAt: (map['submittedAt'] as Timestamp).toDate(),
      answers: Map<String, dynamic>.from(map['answers'] ?? {}),
    );
  }
}
