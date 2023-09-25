import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:background_task_test/app_cubit.dart';
import 'package:background_task_test/notification_handelr.dart';
import 'package:background_task_test/test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';

import 'cach_helper.dart';
import 'calculation_method.dart';
import 'constance.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CacheHelper.init();
  await Hive.initFlutter();
  Hive.registerAdapter(CalculationMethodModelAdapter());
  await Hive.openBox<CalculationMethodModel>(kCalcMethodBox);
 await AwesomeNotifications().initialize(
   null,
    [
      NotificationChannel(
        channelKey:channelKey,
        channelName: 'adhan',
        playSound: true,
        soundSource: 'resource://raw/res_adhan',
        channelShowBadge: true,
        importance: NotificationImportance.Max,
        criticalAlerts: true,
        enableVibration: true,
        enableLights: true,
        locked: true,
        channelDescription:'Nothing',
      ),
    ],
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: BlocProvider(
        create: (context)=>AppCubit(
          NotificationHandelr(),
        ),
          child: const TestNotification()),
    );
  }
}

class TestNotification extends StatefulWidget {
  const TestNotification({Key? key}) : super(key: key);

  @override
  State<TestNotification> createState() => _TestNotificationState();
}

class _TestNotificationState extends State<TestNotification> {
  @override
  void initState() {
    AppCubit.get(context).determinePosition().then((value) {
      AppCubit.get(context).getPrayersTime();
      AppCubit.get(context).getListOfPrayersTimeForOneMonth().then((value) {
        AppCubit.get(context).makeNotificationsForOneMonth();
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child:  TestScreen(),
      ),
    );
  }
}
