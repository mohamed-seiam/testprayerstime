import 'package:adhan_dart/adhan_dart.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:background_task_test/app_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TestScreen extends StatefulWidget {
  const TestScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  List<String> months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];

  @override
  void initState() {
    AwesomeNotifications().isNotificationAllowed().then((notificationAllowed) {
      if (!notificationAllowed) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Allow Notifications'),
            content: const Text('Our app would like to send you notifications'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  'Don\'t Allow',
                  style: TextStyle(color: Colors.grey, fontSize: 18),
                ),
              ),
              TextButton(
                onPressed: () {
                  AwesomeNotifications()
                      .requestPermissionToSendNotifications()
                      .then((_) => Navigator.pop(context));
                },
                child: const Text(
                  'Allow',
                  style: TextStyle(
                      color: Colors.teal,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        );
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var cubit = AppCubit.get(context);
    return BlocBuilder<AppCubit, AppState>(
      builder: (context, state) {
        return state is PrayersTimeDataSuccess
            ? Column(
                children: [
                  Text(
                    '${cubit.date.day}  ${months[cubit.date.month - 1]} ${cubit.date.year}',
                    style: const TextStyle(
                      fontSize: 25,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () {
                          cubit.date = cubit.date.add(const Duration(days: -1));
                          setState(() {
                            cubit.prayerTimes = PrayerTimes(cubit.coordinates!,
                                cubit.date, cubit.calculationMethod!);
                          });
                        },
                        child: const Icon(
                          Icons.arrow_left,
                          size: 60,
                        ),
                      ),
                      Text(
                        cubit.nextPrayer!,
                        textDirection: TextDirection.rtl,
                        style: const TextStyle(fontSize: 40),
                      ),
                      InkWell(
                        onTap: () {
                          cubit.date = cubit.date.add(const Duration(days: 1));
                          setState(() {
                            cubit.prayerTimes = PrayerTimes(cubit.coordinates!,
                                cubit.date, cubit.calculationMethod!);
                          });
                        },
                        child: const Icon(
                          Icons.arrow_right,
                          size: 60,
                        ),
                      ),
                    ],
                  ),
                  RemainsSecondsAndMinute(
                    prayerTimesForRemain: cubit.prayerTimesForRemain!,
                  ),
                  const Text(
                    'ZoneName',
                    style: TextStyle(fontSize: 20),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      const Text('الفجر'),
                      const Icon(Icons.sunny),
                      Text(
                        cubit.timePresenter(cubit.prayerTimes!.fajr!.toLocal()),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      const Text('الضهر'),
                      const Icon(Icons.sunny),
                      Text(cubit
                          .timePresenter(cubit.prayerTimes!.dhuhr!.toLocal())),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      const Text('العصر'),
                      const Icon(Icons.sunny),
                      Text(cubit
                          .timePresenter(cubit.prayerTimes!.asr!.toLocal())),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      const Text('المغرب'),
                      const Icon(Icons.sunny),
                      Text(cubit.timePresenter(
                          cubit.prayerTimes!.maghrib!.toLocal())),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      const Text('العشاء'),
                      const Icon(Icons.sunny),
                      Text(cubit
                          .timePresenter(cubit.prayerTimes!.isha!.toLocal())),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      const Text('شروق الشمس'),
                      const Icon(Icons.sunny),
                      Text(cubit.timePresenter(
                          cubit.prayerTimes!.sunrise!.toLocal())),
                    ],
                  ),
                ],
              )
            : const Center(
                child: CircularProgressIndicator(),
              );
      },
    );
  }
}

class RemainsSecondsAndMinute extends StatelessWidget {
  const RemainsSecondsAndMinute({Key? key, required this.prayerTimesForRemain})
      : super(key: key);
  final PrayerTimes prayerTimesForRemain;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: BlocProvider.of<AppCubit>(context)
            .remainsTime(prayerTimes: prayerTimesForRemain),
        builder: (context, snapshot) {
          return snapshot.data != null
              ? Text(
                  '${snapshot.data}',
                  style: const TextStyle(fontSize: 20),
                )
              : const Center(child: CircularProgressIndicator());
        });
  }
}
