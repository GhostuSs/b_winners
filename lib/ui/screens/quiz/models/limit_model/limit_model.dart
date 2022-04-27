import 'package:hive/hive.dart';
part 'limit_model.g.dart';

@HiveType(typeId: 2)
class LimitsHive extends HiveObject{
  LimitsHive({this.timeToUpdate,this.attempts});

  @HiveField(0)
  DateTime? timeToUpdate;
  @HiveField(1)
  int? attempts;
}