import 'package:flutter/material.dart';

void main() => runApp(const AppAcademica());

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

// Tiene estado (la pestaña seleccionada), por eso es StatefulWidget.
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

// Sin estado: solo muestra datos fijos.
class HoyPage extends StatelessWidget {
  const HoyPage({super.key});

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Hola, Juan David', style: tema.textTheme.headlineSmall),
                  Text(
                    'Periodo 2026-2 · lunes 26 de octubre',
                    style: tema.textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.settings_outlined),
            ),
          ],
        ),
        const SizedBox(height: 16),
        const _TarjetaAvance(aprobados: 32, total: 92, nivel: 3),
        const SizedBox(height: 12),
        const _AlertaRiesgo(
          texto: 'Física Mecánica: necesitas 3.4 en lo que falta para aprobar.',
        ),
        const SizedBox(height: 20),
        Text('Clases de hoy', style: tema.textTheme.titleMedium),
        const SizedBox(height: 8),
        const _ClaseTile(
          materia: 'Estructura de Datos',
          hora: '7:00 – 9:00',
          salon: 'Salón B-201',
          color: Color(0xFF6A4BC4),
        ),
        const _ClaseTile(
          materia: 'Cálculo Integral',
          hora: '10:00 – 12:00',
          salon: 'Salón A-105',
          color: Color(0xFF00838F),
        ),
        const SizedBox(height: 20),
        Text('Pendientes', style: tema.textTheme.titleMedium),
        const SizedBox(height: 8),
        const Card(
          child: ListTile(
            leading: Icon(Icons.radio_button_unchecked),
            title: Text('Entrega taller de Física'),
            subtitle: Text('Mañana · Física Mecánica'),
          ),
        ),
        const Card(
          child: ListTile(
            leading: Icon(Icons.radio_button_unchecked),
            title: Text('Parcial de Cálculo Integral'),
            subtitle: Text('Viernes · Cálculo Integral'),
          ),
        ),
      ],
    );
  }
}

class _TarjetaAvance extends StatelessWidget {
  const _TarjetaAvance({
    required this.aprobados,
    required this.total,
    required this.nivel,
  });

  final int aprobados;
  final int total;
  final int nivel;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Avance de carrera', style: tema.textTheme.titleSmall),
            const SizedBox(height: 4),
            Text('Nivel $nivel', style: tema.textTheme.headlineMedium),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: aprobados / total,
              minHeight: 8,
              borderRadius: BorderRadius.circular(4),
            ),
            const SizedBox(height: 8),
            Text('$aprobados de $total créditos aprobados'),
          ],
        ),
      ),
    );
  }
}

class _AlertaRiesgo extends StatelessWidget {
  const _AlertaRiesgo({required this.texto});

  final String texto;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF0CC),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.warning_amber_rounded, color: Color(0xFF8A5A00)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(texto, style: const TextStyle(color: Color(0xFF8A5A00))),
          ),
        ],
      ),
    );
  }
}

class _ClaseTile extends StatelessWidget {
  const _ClaseTile({
    required this.materia,
    required this.hora,
    required this.salon,
    required this.color,
  });

  final String materia;
  final String hora;
  final String salon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Container(
          width: 6,
          height: 40,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        title: Text(materia),
        subtitle: Text('$hora · $salon'),
      ),
    );
  }
}