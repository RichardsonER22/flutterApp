import 'package:flutter/material.dart';
import 'futbolista_screen.dart';
import 'equipo_screen.dart';
import 'entrenador_screen.dart';
import 'estadio_screen.dart';
import 'arbitro_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bienvenido'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildOptionCard(
              context,
              icon: Icons.sports_soccer,
              title: 'Ver Futbolistas',
              subtitle: 'Consulta y gestiona los futbolistas.',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FutbolistaScreen()),
                );
              },
            ),
            _buildOptionCard(
              context,
              icon: Icons.group,
              title: 'Gestionar Equipos',
              subtitle: 'Crea y organiza equipos.',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EquipoScreen()),
                );
              },
            ),
            _buildOptionCard(
              context,
              icon: Icons.school,
              title: 'Gestionar Entrenadores',
              subtitle: 'Administra entrenadores del equipo.',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EntrenadorScreen()),
                );
              },
            ),
            _buildOptionCard(
              context,
              icon: Icons.stadium,
              title: 'Gestionar Estadios',
              subtitle: 'Revisa y organiza los estadios.',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EstadioScreen()),
                );
              },
            ),
            _buildOptionCard(
              context,
              icon: Icons.gavel,
              title: 'Gestionar Árbitros',
              subtitle: 'Controla y supervisa a los árbitros.',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ArbitroScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      elevation: 4.0,
      margin: const EdgeInsets.only(bottom: 16.0),
      child: ListTile(
        leading: Icon(icon, size: 40, color: Theme.of(context).primaryColor),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: onTap,
      ),
    );
  }
}
