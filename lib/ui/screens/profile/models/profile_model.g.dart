// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProfileStatAdapter extends TypeAdapter<ProfileStat> {
  @override
  final int typeId = 3;

  @override
  ProfileStat read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProfileStat(
      totalCorrAnsw: fields[0] as int?,
      progress: fields[1] as double?,
      eQuiz: fields[3] as int?,
      hQuiz: fields[5] as int?,
      nQuiz: fields[4] as int?,
      expQuiz: fields[6] as int?,
      qQuiz: fields[2] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, ProfileStat obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.totalCorrAnsw)
      ..writeByte(1)
      ..write(obj.progress)
      ..writeByte(2)
      ..write(obj.qQuiz)
      ..writeByte(3)
      ..write(obj.eQuiz)
      ..writeByte(4)
      ..write(obj.nQuiz)
      ..writeByte(5)
      ..write(obj.hQuiz)
      ..writeByte(6)
      ..write(obj.expQuiz);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProfileStatAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
