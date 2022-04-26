// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive_results.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HiveResultAdapter extends TypeAdapter<HiveResult> {
  @override
  final int typeId = 1;

  @override
  HiveResult read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HiveResult(
      quizIndex: fields[0] as String?,
      correctAnswers: fields[1] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, HiveResult obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.quizIndex)
      ..writeByte(1)
      ..write(obj.correctAnswers);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HiveResultAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
