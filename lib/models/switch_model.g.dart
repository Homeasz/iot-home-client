// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'switch_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PowerSwitchAdapter extends TypeAdapter<PowerSwitch> {
  @override
  final int typeId = 1;

  @override
  PowerSwitch read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PowerSwitch(
      id: fields[0] as int,
      name: fields[1] as String,
      state: fields[2] as bool,
      type: fields[3] as String,
      roomName: fields[4] as String?,
      createdAt: DateTime(1970),
      updatedAt: DateTime(1970),
    );
  }

  @override
  void write(BinaryWriter writer, PowerSwitch obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.state)
      ..writeByte(3)
      ..write(obj.type)
      ..writeByte(4)
      ..write(obj.roomName);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PowerSwitchAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
