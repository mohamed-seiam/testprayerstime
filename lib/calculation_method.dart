import 'package:adhan_dart/adhan_dart.dart';
import 'package:hive/hive.dart';
part 'calculation_method.g.dart';
@HiveType(typeId: 1)
class CalculationMethodModel {
  @HiveField(0)
  CalculationParameters calculationMethod;
  CalculationMethodModel({required this.calculationMethod});
}