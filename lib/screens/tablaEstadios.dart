import 'package:flutter/material.dart';
import '../models/estadio.dart';
import '../helpers/db_helper.dart';

class ClasificacionEstadiosScreen extends StatefulWidget {
  @override
  _ClasificacionEstadiosScreenState createState() => _ClasificacionEstadiosScreenState();
}

class _ClasificacionEstadiosScreenState extends State<ClasificacionEstadiosScreen> {
  final DBHelper _dbHelper = DBHelper();
  late Future<List<Estadio>> _estadios;

  @override
  void initState() {
    super.initState();
    _estadios = _dbHelper.getEstadiosOrdenadosPorCapacidad(); // Obtener estadios ordenados
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tabla de Clasificación de Estadios'),
      ),
      body: FutureBuilder<List<Estadio>>(
        future: _estadios,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error al cargar los estadios'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No hay estadios registrados'));
          }

          // Obtener los estadios ordenados por capacidad
          final estadios = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: DataTable(
              columns: const <DataColumn>[
                DataColumn(label: Text('Posición')),
                DataColumn(label: Text('Nombre')),
                DataColumn(label: Text('Capacidad')),
              ],
              rows: List.generate(estadios.length, (index) {
                final estadio = estadios[index];
                return DataRow(
                  cells: [
                    DataCell(Text('${index + 1}')), // Mostrar la posición
                    DataCell(Text(estadio.nombre)),
                    DataCell(Text(estadio.capacidad.toString())),
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
