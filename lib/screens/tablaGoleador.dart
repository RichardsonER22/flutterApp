import 'package:flutter/material.dart';
import '../models/futbolista.dart';
import '../helpers/db_helper.dart';

class ClasificacionScreen extends StatefulWidget {
  @override
  _ClasificacionScreenState createState() => _ClasificacionScreenState();
}

class _ClasificacionScreenState extends State<ClasificacionScreen> {
  final DBHelper _dbHelper = DBHelper();
  late Future<List<Futbolista>> _futbolistas;

  @override
  void initState() {
    super.initState();
    _futbolistas = _dbHelper.getFutbolistasOrdenadosPorGoles(); // Obtener futbolistas ordenados
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tabla de Clasificación'),
      ),
      body: FutureBuilder<List<Futbolista>>(
        future: _futbolistas,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error al cargar los futbolistas'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No hay futbolistas registrados'));
          }

          // Obtener los futbolistas ordenados por goles
          final futbolistas = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: DataTable(
              columns: const <DataColumn>[
                DataColumn(label: Text('Posición')),
                DataColumn(label: Text('Nombre')),
                DataColumn(label: Text('Goles')),
              ],
              rows: List.generate(futbolistas.length, (index) {
                final futbolista = futbolistas[index];
                return DataRow(
                  cells: [
                    DataCell(Text('${index + 1}')), // Mostrar la posición
                    DataCell(Text(futbolista.nombre)),
                    DataCell(Text(futbolista.goles.toString())),
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
