import 'package:adhan_dart/adhan_dart.dart';
import 'package:background_task_test/constance.dart';
import 'package:background_task_test/notification_handelr.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'cach_helper.dart';
import 'calculation_method.dart';

part 'app_state.dart';

class AppCubit extends Cubit<AppState> {
  AppCubit(this.notificationHandelr) : super(AppInitial());

  static AppCubit get(context) =>
      BlocProvider.of(context);
  double? lat;
  double? lng;
  String? city;
  String? country;
  Placemark? placeMark_;
  PrayerTimes? prayerTimes;
  PrayerTimes? prayerTimesForRemain;
  DateTime date = DateTime.now();
  String? nextPrayer;
  DateTime? dateForRemains;
  Coordinates? coordinates;
  CalculationParameters? calculationMethod;
  NotificationHandelr notificationHandelr;
  List<PrayerTimes> prayersTimesForOneMonth = [];

  Future<void> changeCalculationMethod ({required CalculationParameters calculationMethod}) async {
    var calculationMethodBox = Hive.box<CalculationMethodModel>(kCalcMethodBox);
    CalculationMethodModel? calculationMethodModel = calculationMethodBox.get(kCalcMethodBox);
    calculationMethodModel ??= CalculationMethodModel(calculationMethod: CalculationMethod.MuslimWorldLeague());
    calculationMethodModel.calculationMethod = calculationMethod;

    // Save the CalculationMethodModel to the Hive box.
    await calculationMethodBox.put(kCalcMethodBox, calculationMethodModel);

  }

  Future<CalculationParameters?> getCalculationMethod() async {
    var calculationMethodBox = Hive.box<CalculationMethodModel>(kCalcMethodBox);
    // Get the current value of CalculationMethod from the Hive box.
    CalculationMethodModel? calculationMethodModel = calculationMethodBox.get(kCalcMethodBox);

    // If the current value of CalculationMethod is null, initialize it with the default calculation method.
    calculationMethodModel ??= CalculationMethodModel(calculationMethod: CalculationMethod.Egyptian());

    // Return the CalculationMethod from the CalculationMethodModel.
    return calculationMethodModel.calculationMethod;
  }


  String timePresenter(DateTime dateTime) {
    bool isGreaterThan12 = dateTime.hour >= 12 ;
    String prefix = isGreaterThan12 ? 'pm' : 'am';
    int hour = isGreaterThan12 ? dateTime.hour - 12 : dateTime.hour;
    if (hour == 0) {
      hour = 12;
    }
    int minute = dateTime.minute;
    String hourInString = hour.toString().length == 1 ? '0$hour' : '$hour';
    String minuteInString =
        minute.toString().length == 1 ? '0$minute' : '$minute';
    return '$hourInString:$minuteInString $prefix';
  }

  String nextPrayerValue({required String currentPrayer}) {
    String currentPrayerInArabic = '';
    switch (currentPrayer) {
      case 'sunrise':
        currentPrayerInArabic = 'الصبح';
      case 'fajrafter':
        currentPrayerInArabic = 'الفجر';
      case 'fajr':
        currentPrayerInArabic = 'الفجر';
        break;
      case 'dhuhr':
        currentPrayerInArabic = 'الضهر';
        break;
      case 'asr':
        currentPrayerInArabic = 'العصر';
        break;
      case 'maghrib':
        currentPrayerInArabic = 'المغرب';
        break;
      case 'isha':
        currentPrayerInArabic = 'العشاء';
        break;
    }
    return currentPrayerInArabic;
  }

  remainsTime({required PrayerTimes prayerTimes}) async* {
    yield* Stream.periodic(const Duration(seconds: 1), (t) {
      String prayer = prayerTimes.nextPrayer();
      DateTime nextPrayerTime = prayerTimes.timeForPrayer(prayer)!.toLocal();
      DateTime dateTime = DateTime.now();
      Duration remains = nextPrayerTime.difference(dateTime);
      return secondToHour(remains.inSeconds);
    });
  }

  secondToHour(int seconds) {
    int minute = seconds ~/ 60;
    int hours = minute ~/ 60;
    seconds = seconds - minute * 60;
    minute = minute - hours * 60;
    String hourInString = hours.toString().length == 1 ? '0$hours' : '$hours';
    String minuteInString =
        minute.toString().length == 1 ? '0$minute' : '$minute';
    String secondInString =
        seconds.toString().length == 1 ? '0$seconds' : '$seconds';
    return "$hourInString:$minuteInString:$secondInString";
  }

  Future<void> determinePosition() async {
    if (CacheHelper.getData(key: 'lat') != null &&
        CacheHelper.getData(key: 'lng') != null) {
      return;
    } else {
      bool serviceEnabled;
      LocationPermission permission;
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        await Geolocator.requestPermission();
      }
      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          permission = await Geolocator.requestPermission();
        }
      }
      if (permission == LocationPermission.deniedForever) {
        await Geolocator.requestPermission();
      }
      await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        // timeLimit: const Duration(seconds: 40),
      ).then((value) {
        lat = value.latitude;
        CacheHelper.saveData(key: 'lat', value: lat);
        lng = value.longitude;
        CacheHelper.saveData(key: 'lng', value: lng);
        getAddressFromLatLong(value);
      });
    }
  }

  Future<void> getAddressFromLatLong(Position position) async {
    List<Placemark> placeMark =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    placeMark_ = placeMark[0];
    city = placeMark_!.locality!;
    country = placeMark_!.thoroughfare!;

    print(city);
    print(country);
    print(placeMark_!.subLocality);
  }

  Future<void> getPrayersTime() async {
    emit(PrayersTimeDataLoading());
    dateForRemains = DateTime.now();
    calculationMethod = await getCalculationMethod();
    print(calculationMethod?.method);
    coordinates = Coordinates(CacheHelper.getData(key: 'lat') ?? lat,
        CacheHelper.getData(key: 'lng') ?? lng);
    prayerTimesForRemain =
        PrayerTimes(coordinates!, dateForRemains!, calculationMethod!);
    prayerTimes = PrayerTimes(coordinates!, date, calculationMethod!);
    nextPrayer =  nextPrayerValue(
      currentPrayer: prayerTimesForRemain?.nextPrayer(date: date) ?? '',
    );
    emit(PrayersTimeDataSuccess());
  }

  Future<void> getListOfPrayersTimeForOneMonth() async {
    calculationMethod =  await getCalculationMethod();
    prayersTimesForOneMonth.clear();
    DateTime dateTime = DateTime.now();
    for (int i = 0; i < 30; i++) {
      DateTime date = dateTime.add(Duration(days: i));
      PrayerTimes prayerTimesForNotification = PrayerTimes(
          coordinates!, date, calculationMethod!,
          precision: true,);
      prayersTimesForOneMonth.add(prayerTimesForNotification);
       print(prayersTimesForOneMonth[i].date);
      print('${prayersTimesForOneMonth[i].isha!.toLocal().hour.toInt()}:${prayersTimesForOneMonth[i].isha!.toLocal().minute}');

    }
  }
  Future<void> makeNotificationsForOneMonth() async {
   await notificationHandelr.scheduleNotifications(prayersTimesList: prayersTimesForOneMonth);
  }
}
