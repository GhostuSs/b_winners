// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'limit_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LimitsHiveAdapter extends TypeAdapter<LimitsHive> {
  @override
  final int typeId = 2;

  @override
  LimitsHive read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LimitsHive(
      timeToUpdate: fields[0] as DateTime?,
      attempts: fields[1] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, LimitsHive obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.timeToUpdate)
      ..writeByte(1)
      ..write(obj.attempts);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LimitsHiveAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
