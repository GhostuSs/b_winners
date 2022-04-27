import 'package:hive/hive.dart';
part 'profile_model.g.dart';

@HiveType(typeId: 3)
class ProfileStat extends HiveObject {
  ProfileStat(
      {
      this.eQuiz,
      this.hQuiz,
      this.nQuiz,
      this.expQuiz,
      this.qQuiz});
  @HiveField(2)
  int? qQuiz=0;
  @HiveField(3)
  int? eQuiz=0;
  @HiveField(4)
  int? nQuiz=0;
  @HiveField(5)
  int? hQuiz=0;
  @HiveField(6)
  int? expQuiz=0;
}
