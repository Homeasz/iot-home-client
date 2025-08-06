// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'routine_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RoutineSwitchCloudResponseAdapter
    extends TypeAdapter<RoutineSwitchCloudResponse> {
  @override
  final int typeId = 4;

  @override
  RoutineSwitchCloudResponse read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RoutineSwitchCloudResponse(
      id: fields[0] as int,
      action: fields[1] as bool,
      revertDuration: fields[2] as int,
    );
  }

  @override
  void write(BinaryWriter writer, RoutineSwitchCloudResponse obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.action)
      ..writeByte(2)
      ..write(obj.revertDuration);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RoutineSwitchCloudResponseAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class RoutineCloudResponseAdapter extends TypeAdapter<RoutineCloudResponse> {
  @override
  final int typeId = 3;

  @override
  RoutineCloudResponse read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RoutineCloudResponse(
      id: fields[0] as int,
      name: fields[1] as String,
      repeat: fields[2] as int,
      switches: (fields[3] as List).cast<RoutineSwitchCloudResponse>(),
      time: TimeOfDay(
          hour: int.parse(fields[4].split(':')[0]),
          minute: int.parse(fields[4].split(':')[1])),
      type: fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, RoutineCloudResponse obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.repeat)
      ..writeByte(3)
      ..write(obj.switches)
      ..writeByte(4)
      ..write("${obj.time.hour}:${obj.time.minute}")
      ..writeByte(5)
      ..write(obj.type);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RoutineCloudResponseAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
