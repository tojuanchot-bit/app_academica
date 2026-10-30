import 'package:flutter/material.dart';

import 'hoy_page.dart';

/// Barra de navegación con los 4 destinos (D-011).
class Inicio extends StatefulWidget {
  const Inicio({super.key});

  @override
  State<Inicio> createState() => _InicioState();
}

class _InicioState extends State<Inicio> {
  int _destino = 0;

  static const _paginas = <Widget>[
    HoyPage(),
    Center(child: Text('Materias')),
    Center(child: Text('Horario')),
    Center(child: Text('Agenda')),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: _paginas[_destino]),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _destino,
        onDestinationSelected: (i) => setState(() => _destino = i),
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
