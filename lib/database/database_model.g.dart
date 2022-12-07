// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MockAdapter extends TypeAdapter<Mock> {
  @override
  final int typeId = 0;

  @override
  Mock read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Mock(
      name: fields[1] as String,
      id: fields[0] as int?,
      job: fields[2] as String,
      number: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Mock obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.job)
      ..writeByte(3)
      ..write(obj.number);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MockAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
