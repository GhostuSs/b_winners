// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quiz_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Quiz _$QuizFromJson(Map<String, dynamic> json) => Quiz()
  ..question = json['question'] as String?
  ..answers =
      (json['answers'] as List<dynamic>?)?.map((e) => e as String).toList()
  ..correct = json['correct'] as String?;

Map<String, dynamic> _$QuizToJson(Quiz instance) => <String, dynamic>{
      'question': instance.question,
      'answers': instance.answers,
      'correct': instance.correct,
    };
