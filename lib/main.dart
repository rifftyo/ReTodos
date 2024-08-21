import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todolist_app/helpers/notifications_helper.dart';
import 'package:todolist_app/provider/theme_provider.dart';
import 'package:todolist_app/provider/time_picker_provider.dart';
import 'package:todolist_app/provider/todo_provider.dart';
import 'package:todolist_app/ui/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AndroidAlarmManager.initialize();
  final NotificationsHelper notificationsHelper = NotificationsHelper();
  await notificationsHelper.initNotifications();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => TodoProvider()),
        ChangeNotifierProvider(create: (_) => TimePickerProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

final darkTheme = ThemeData(
  primaryColor: Colors.orange,
  primarySwatch: Colors.blue,
  brightness: Brightness.dark,
  cardColor: Colors.black26,
);

final lightTheme = ThemeData(
  primaryColor: Colors.orange,
  primarySwatch: Colors.blue,
  brightness: Brightness.light,
  cardColor: Colors.amber[100],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, _) {
        return MaterialApp(
          theme: themeProvider.isDark ? darkTheme : lightTheme,
          debugShowCheckedModeBanner: false,
          title: 'Retods',
          home: const HomePage(),
        );
      },
    );
  }
}
