import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'pantallas/inicio_page.dart';

void main() => runApp(const ProviderScope(child: AppAcademica()));

class AppAcademica extends StatelessWidget {
  const AppAcademica({super.key});

  @override
  Widget build(BuildContext context) {
    const semilla = Color(0xFF1A5FB4);
    return MaterialApp(
      title: 'App académica',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: semilla),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: semilla,
          brightness: Brightness.dark,
        ),
      ),
      home: const Inicio(),
    );
  }
}
