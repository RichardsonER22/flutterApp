import 'package:flutter/material.dart';
import 'package:futapp/screens/equipo_screen.dart';
import 'screens/LoginScreen.dart';
import 'screens/RegisterScreen.dart';
import 'screens/home_screen.dart';
import 'screens/futbolista_screen.dart';
import 'screens/arbitro_screen.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App de Futbolistas',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
        '/home': (context) => HomeScreen(),
        '/futbolistas': (context) => FutbolistaScreen(),
        '/equipos': (context) =>EquipoScreen(),
        '/Arbitros': (context) =>ArbitroScreen(),
       

      },
    );
  }
}
