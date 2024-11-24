import 'package:flutter/material.dart';
import '../helpers/db_helper.dart';
import '../models/usuario.dart'; 
import 'futbolista_screen.dart';
import 'equipo_screen.dart';
import 'entrenador_screen.dart';
import 'estadio_screen.dart';
import 'arbitro_screen.dart';
import 'calendario_screen.dart';
import 'tablaGoleador.dart';
import 'tablaEquipos.dart';
import 'tablaEntrenadores.dart';
import 'tablaEstadios.dart';
import 'tablaArbitros.dart';
import 'LoginScreen.dart'; // Asegúrate de importar tu pantalla de login



class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pantalla de Inicio'),
      ),
      // Agregamos el Drawer a la pantalla principal
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            // Header del Drawer
            UserAccountsDrawerHeader(
              accountName: Text('Usuario'),
              accountEmail: Text('usuario@ejemplo.com'),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.person, size: 50),
              ),
            ),
            // Botones del Drawer
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Perfil'),
              onTap: () {
                // Acción al hacer clic en el botón de perfil
                Navigator.pushNamed(context, '/perfil');
              },
            ),
            ListTile(
  leading: Icon(Icons.sports_soccer),
  title: Text('Tabla de Goleadores'),
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ClasificacionScreen()),
    );
  },
),
ListTile(
  leading: Icon(Icons.sports_score),
  title: Text('Clasificación de Equipos'),
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ClasificacionEquiposScreen()),
    );
  },
),
ListTile(
  leading: Icon(Icons.school),
  title: Text('Clasificación de Entrenadores'),
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ClasificacionEntrenadoresScreen()),
    );
  },
),
ListTile(
  leading: Icon(Icons.stadium),
  title: Text('Clasificación de Estadios'),
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ClasificacionEstadiosScreen()),
    );
  },
),
ListTile(
  leading: Icon(Icons.gavel),
  title: Text('Clasificación de Árbitros'),
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ClasificacionArbitrosScreen()),
    );
  },
),





          
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text('Cerrar sesión'),
              onTap: () {
                // Acción al hacer clic en el botón de cerrar sesión
                _showLogoutConfirmationDialog(context);
              },
            ),
          ],
        ),
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
            _buildOptionCard(
              context,
              icon: Icons.calendar_month,
              title: 'Calendario de partidos',
              subtitle: 'Supervisa calendario de partidos.',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CalendarioScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // Función para mostrar el diálogo de confirmación
  void _showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Confirmar cierre de sesión'),
          content: const Text('¿Estás seguro de que deseas cerrar sesión?'),
          actions: [
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Cierra el cuadro de diálogo
              },
            ),
            ElevatedButton(
              child: const Text('Cerrar sesión'),
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Cierra el cuadro de diálogo
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                  (route) => false, // Elimina todas las rutas anteriores
                );
              },
            ),
          ],
        );
      },
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
