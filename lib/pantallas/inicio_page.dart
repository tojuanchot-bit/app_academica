import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../estado/navegacion_provider.dart';
import 'horario_page.dart';
import 'hoy_page.dart';
import 'materias_page.dart';
import 'notas_page.dart';

/// Barra de navegación con los 5 destinos (D-011, D-024).
class Inicio extends ConsumerWidget {
  const Inicio({super.key});

  /// En el mismo orden que [Destino].
  static const _paginas = <Widget>[
    HoyPage(),
    MateriasPage(),
    NotasPage(),
    HorarioPage(),
    Center(child: Text('Agenda')),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final destino = ref.watch(destinoProvider);
    return Scaffold(
      body: SafeArea(child: _paginas[destino.index]),
      bottomNavigationBar: NavigationBar(
        selectedIndex: destino.index,
        onDestinationSelected: (i) =>
            ref.read(destinoProvider.notifier).ir(Destino.values[i]),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.today_outlined),
            selectedIcon: Icon(Icons.today),
            label: 'Hoy',
          ),
          NavigationDestination(
            icon: Icon(Icons.menu_book_outlined),
            selectedIcon: Icon(Icons.menu_book),
            label: 'Materias',
          ),
          NavigationDestination(
            icon: Icon(Icons.grading_outlined),
            selectedIcon: Icon(Icons.grading),
            label: 'Notas',
          ),
          NavigationDestination(
            icon: Icon(Icons.schedule_outlined),
            selectedIcon: Icon(Icons.schedule),
            label: 'Horario',
          ),
          NavigationDestination(
            icon: Icon(Icons.event_note_outlined),
            selectedIcon: Icon(Icons.event_note),
            label: 'Agenda',
          ),
        ],
      ),
    );
  }
}
