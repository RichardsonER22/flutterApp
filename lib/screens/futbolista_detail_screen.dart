import 'package:flutter/material.dart';
import '../models/futbolista.dart';

class FutbolistaDetailScreen extends StatelessWidget {
  final Futbolista futbolista;
  final Function(Futbolista) onEdit;

  FutbolistaDetailScreen({
    required this.futbolista,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${futbolista.nombre}'),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () => _showEditFormDialog(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Nombre: ${futbolista.nombre}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Edad: ${futbolista.edad}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 8),
            Text(
              'Posición: ${futbolista.posicion}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 8),
            Text(
              'Goles: ${futbolista.goles}',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditFormDialog(BuildContext context) {
    final _nombreController = TextEditingController(text: futbolista.nombre);
    final _edadController = TextEditingController(text: futbolista.edad.toString());
    final _posicionController = TextEditingController(text: futbolista.posicion);
    final _golesController = TextEditingController(text: futbolista.goles.toString());

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Editar Futbolista'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nombreController,
                decoration: InputDecoration(labelText: 'Nombre'),
              ),
              TextField(
                controller: _edadController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Edad'),
              ),
              TextField(
                controller: _posicionController,
                decoration: InputDecoration(labelText: 'Posición'),
              ),
              TextField(
                controller: _golesController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Goles'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                final updatedFutbolista = Futbolista(
                  id: futbolista.id,
                  nombre: _nombreController.text,
                  edad: int.tryParse(_edadController.text) ?? 0,
                  posicion: _posicionController.text,
                  goles: int.tryParse(_golesController.text) ?? 0,
                );
                onEdit(updatedFutbolista);
                Navigator.of(context).pop();
              },
              child: Text('Guardar'),
            ),
          ],
        );
      },
    );
  }
}
