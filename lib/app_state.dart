part of 'app_cubit.dart';

@immutable
abstract class AppState {}

class AppInitial extends AppState {}

class PrayersTimeDataLoading extends AppState {}

class PrayersTimeDataSuccess extends AppState {}

class PrayersTimeDataFailure extends AppState {}
