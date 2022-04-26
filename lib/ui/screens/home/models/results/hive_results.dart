import 'package:hive/hive.dart';

part 'hive_results.g.dart';

@HiveType(typeId: 1)
class HiveResult extends HiveObject {
  HiveResult({this.quizIndex, this.correctAnswers});

  @HiveField(0)
  String? quizIndex;
  @HiveField(1)
  String? correctAnswers;
}
