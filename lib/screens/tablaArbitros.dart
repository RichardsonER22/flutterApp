import 'package:flutter/material.dart';
import '../models/arbitro.dart';
import '../helpers/db_helper.dart';

class ClasificacionArbitrosScreen extends StatefulWidget {
  @override
  _ClasificacionArbitrosScreenState createState() => _ClasificacionArbitrosScreenState();
}

class _ClasificacionArbitrosScreenState extends State<ClasificacionArbitrosScreen> {
  final DBHelper _dbHelper = DBHelper();
  late Future<List<Arbitro>> _arbitros;

  @override
  void initState() {
    super.initState();
    _arbitros = _dbHelper.getArbitrosOrdenadosPorExperiencia(); // Obtener árbitros ordenados por experiencia
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Clasificación de Árbitros'),
      ),
      body: FutureBuilder<List<Arbitro>>(
        future: _arbitros,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error al cargar los árbitros'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No hay árbitros registrados'));
          }

          // Obtener los árbitros ordenados por años de experiencia
          final arbitros = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: DataTable(
              columns: const <DataColumn>[
                DataColumn(label: Text('Posición')),
                DataColumn(label: Text('Nombre')),
                DataColumn(label: Text('Años de Experiencia')),
              ],
              rows: List.generate(arbitros.length, (index) {
                final arbitro = arbitros[index];
                return DataRow(
                  cells: [
                    DataCell(Text('${index + 1}')), // Mostrar la posición
                    DataCell(Text(arbitro.nombre)),
                    DataCell(Text(arbitro.experiencia.toString())),
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
