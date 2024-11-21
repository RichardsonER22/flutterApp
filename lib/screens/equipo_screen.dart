import 'package:flutter/material.dart';
import '../helpers/db_helper.dart';
import '../models/equipo.dart';

class EquipoScreen extends StatefulWidget {
  @override
  _EquipoScreenState createState() => _EquipoScreenState();
}

class _EquipoScreenState extends State<EquipoScreen> {
  final DBHelper _dbHelper = DBHelper();
  List<Equipo> _equipos = [];
  List<Equipo> _filteredEquipos = [];
  String _searchQuery = '';
  String _sortOrder = 'nombre'; // Opciones: 'nombre', 'titulos'

  @override
  void initState() {
    super.initState();
    _loadEquipos();
  }

  Future<void> _loadEquipos() async {
    final equipos = await _dbHelper.getEquipos();
    setState(() {
      _equipos = equipos;
      _applyFilters();
    });
  }

  void _applyFilters() {
    List<Equipo> filtered = _equipos.where((equipo) {
      return equipo.nombre.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    if (_sortOrder == 'nombre') {
      filtered.sort((a, b) => a.nombre.compareTo(b.nombre));
    } else if (_sortOrder == 'titulos') {
      filtered.sort((a, b) => b.titulos.compareTo(a.titulos));
    }

    setState(() {
      _filteredEquipos = filtered;
    });
  }

  void _showFormDialog({Equipo? equipo}) {
    final _nombreController = TextEditingController(text: equipo?.nombre ?? '');
    final _ciudadController = TextEditingController(text: equipo?.ciudad ?? '');
    final _titulosController = TextEditingController(text: equipo?.titulos.toString() ?? '');

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.blue.shade50,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          title: Text(
            equipo == null ? 'Agregar Equipo' : 'Editar Equipo',
            style: TextStyle(
              color: Colors.blue[900],
              fontWeight: FontWeight.bold,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTextField(controller: _nombreController, label: 'Nombre'),
                _buildTextField(controller: _ciudadController, label: 'Ciudad'),
                _buildTextField(
                  controller: _titulosController,
                  label: 'Títulos',
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue[600]),
              onPressed: () {
                final nuevoEquipo = Equipo(
                  id: equipo?.id,
                  nombre: _nombreController.text.trim(),
                  ciudad: _ciudadController.text.trim(),
                  titulos: int.tryParse(_titulosController.text.trim()) ?? 0,
                );
                _saveEquipo(nuevoEquipo);
                Navigator.of(context).pop();
              },
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _saveEquipo(Equipo equipo) async {
    if (equipo.id == null) {
      await _dbHelper.insertEquipo(equipo);
    } else {
      await _dbHelper.updateEquipo(equipo);
    }
    _loadEquipos();
  }

  Future<void> _deleteEquipo(int id) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar eliminación'),
          content: const Text('¿Estás seguro de que deseas eliminar este equipo?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );

    if (shouldDelete == true) {
      await _dbHelper.deleteEquipo(id);
      _loadEquipos();
    }
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.blue),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.blue),
            borderRadius: BorderRadius.circular(12.0),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[800],
        title: Row(
          children: [
            const Icon(Icons.sports_soccer),
            const SizedBox(width: 8),
            const Text('Equipos'),
          ],
        ),
        actions: [
          PopupMenuButton<String>(
            onSelected: (String value) {
              setState(() {
                _sortOrder = value;
                _applyFilters();
              });
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'nombre', child: Text('Ordenar por Nombre')),
              const PopupMenuItem(value: 'titulos', child: Text('Ordenar por Títulos')),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Buscar por nombre',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search, color: Colors.blue),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                  _applyFilters();
                });
              },
            ),
          ),
          Expanded(
            child: _filteredEquipos.isEmpty
                ? const Center(
                    child: Text(
                      'No hay equipos disponibles.',
                      style: TextStyle(color: Colors.blue),
                    ),
                  )
                : ListView.builder(
                    itemCount: _filteredEquipos.length,
                    itemBuilder: (context, index) {
                      final equipo = _filteredEquipos[index];
                      return Card(
                        color: Colors.blue[50],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        elevation: 4.0,
                        child: ListTile(
                          leading: const Icon(Icons.group, color: Colors.blue),
                          title: Text(
                            equipo.nombre,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, color: Colors.blue[900]),
                          ),
                          subtitle: Text(
                            'Ciudad: ${equipo.ciudad}\nTítulos: ${equipo.titulos}',
                            style: TextStyle(color: Colors.blue[700]),
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _deleteEquipo(equipo.id!),
                          ),
                          onTap: () => _showFormDialog(equipo: equipo),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue[800],
        onPressed: () => _showFormDialog(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
