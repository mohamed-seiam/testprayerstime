// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'calculation_method.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CalculationMethodModelAdapter
    extends TypeAdapter<CalculationMethodModel> {
  @override
  final int typeId = 1;

  @override
  CalculationMethodModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CalculationMethodModel(
      calculationMethod: fields[0] as CalculationParameters,
    );
  }

  @override
  void write(BinaryWriter writer, CalculationMethodModel obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.calculationMethod);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CalculationMethodModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
