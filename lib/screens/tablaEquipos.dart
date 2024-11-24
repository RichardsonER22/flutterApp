import 'package:flutter/material.dart';
import '../models/equipo.dart';
import '../helpers/db_helper.dart';

class ClasificacionEquiposScreen extends StatefulWidget {
  @override
  _ClasificacionEquiposScreenState createState() =>
      _ClasificacionEquiposScreenState();
}

class _ClasificacionEquiposScreenState
    extends State<ClasificacionEquiposScreen> {
  final DBHelper _dbHelper = DBHelper();
  late Future<List<Equipo>> _equipos;

  @override
  void initState() {
    super.initState();
    _equipos = _dbHelper.getEquiposOrdenadosPorTitulos(); // Obtener equipos ordenados
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tabla de Clasificación de Equipos'),
      ),
      body: FutureBuilder<List<Equipo>>(
        future: _equipos,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error al cargar los equipos'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No hay equipos registrados'));
          }

          // Obtener los equipos ordenados por títulos
          final equipos = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: DataTable(
              columns: const <DataColumn>[
                DataColumn(label: Text('Posición')),
                DataColumn(label: Text('Nombre')),
                DataColumn(label: Text('Títulos')),
              ],
              rows: List.generate(equipos.length, (index) {
                final equipo = equipos[index];
                return DataRow(
                  cells: [
                    DataCell(Text('${index + 1}')), // Mostrar la posición
                    DataCell(Text(equipo.nombre)),
                    DataCell(Text(equipo.titulos.toString())),
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
