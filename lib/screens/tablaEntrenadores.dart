import 'package:flutter/material.dart';
import '../models/entrenador.dart';
import '../helpers/db_helper.dart';

class ClasificacionEntrenadoresScreen extends StatefulWidget {
  @override
  _ClasificacionEntrenadoresScreenState createState() =>
      _ClasificacionEntrenadoresScreenState();
}

class _ClasificacionEntrenadoresScreenState
    extends State<ClasificacionEntrenadoresScreen> {
  final DBHelper _dbHelper = DBHelper();
  late Future<List<Entrenador>> _entrenadores;

  @override
  void initState() {
    super.initState();
    _entrenadores = _dbHelper.getEntrenadoresOrdenadosPorExperiencia(); // Obtener entrenadores ordenados
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tabla de Clasificación de Entrenadores'),
      ),
      body: FutureBuilder<List<Entrenador>>(
        future: _entrenadores,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error al cargar los entrenadores'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No hay entrenadores registrados'));
          }

          // Obtener los entrenadores ordenados por años de experiencia
          final entrenadores = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: DataTable(
              columns: const <DataColumn>[
                DataColumn(label: Text('Posición')),
                DataColumn(label: Text('Nombre')),
                DataColumn(label: Text('Experiencia')),
              ],
              rows: List.generate(entrenadores.length, (index) {
                final entrenador = entrenadores[index];
                return DataRow(
                  cells: [
                    DataCell(Text('${index + 1}')), // Mostrar la posición
                    DataCell(Text(entrenador.nombre)),
                    DataCell(Text(entrenador.experiencia.toString())),
                  ],
                );
              }),
            ),
          );
        },
      ),
    );
  }
}
