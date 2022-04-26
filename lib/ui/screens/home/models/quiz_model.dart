import 'package:json_annotation/json_annotation.dart';

part 'quiz_model.g.dart';

@JsonSerializable()
class Quiz {
  Quiz();

  String? question;
  List<String>? answers;
  String? correct;

  /// Connect the generated [_$QuizFromJson] function to the `fromJson`
  factory Quiz.fromJson(Map<String, dynamic> json) => _$QuizFromJson(json);

  /// Connect the generated [_$QuizToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$QuizToJson(this);
}
