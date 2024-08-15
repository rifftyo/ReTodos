import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todolist_app/ui/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final bool isDark = await _getThemePreference();
  runApp(MyApp(isDark: isDark));
}

Future<bool> _getThemePreference() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getBool('isDark') ?? false;
}

final darkTheme = ThemeData(
  primaryColor: Colors.orange,
  primarySwatch: Colors.blue,
  brightness: Brightness.dark,
);

final lightTheme = ThemeData(
  primaryColor: Colors.orange,
  primarySwatch: Colors.blue,
  brightness: Brightness.light,
);

class MyApp extends StatefulWidget {
  final bool isDark;

  const MyApp({super.key, required this.isDark});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isDark = false;

  @override
  void initState() {
    super.initState();
    isDark = widget.isDark;
  }

  Future<void> _changeTheme() async {
    setState(() {
      isDark = !isDark;
    });
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDark', isDark);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: isDark ? darkTheme : lightTheme,
      debugShowCheckedModeBanner: false,
      title: 'TodoList App',
      home: HomePage(changeTheme: _changeTheme, isDark: isDark),
    );
  }
}
