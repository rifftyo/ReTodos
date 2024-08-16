import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todolist_app/provider/theme_provider.dart';
import 'package:todolist_app/provider/todo_provider.dart';
import 'package:todolist_app/ui/home_page.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => TodoProvider()),
      ],
      child: const MyApp(),
    ),
  );
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

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          theme: themeProvider.isDark ? darkTheme : lightTheme,
          debugShowCheckedModeBanner: false,
          title: 'TodoList App',
          home: const HomePage(),
        );
      },
    );
  }
}
