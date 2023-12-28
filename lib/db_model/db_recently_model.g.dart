// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'db_recently_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RecentlymodelAdapter extends TypeAdapter<Recentlymodel> {
  @override
  final int typeId = 3;

  @override
  Recentlymodel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Recentlymodel(
      songID: fields[0] as int,
    );
  }

  @override
  void write(BinaryWriter writer, Recentlymodel obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.songID);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RecentlymodelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
