import 'package:flutter/material.dart';
import '../helpers/db_helper.dart';
import '../models/estadio.dart';

class EstadioScreen extends StatefulWidget {
  @override
  _EstadioScreenState createState() => _EstadioScreenState();
}

class _EstadioScreenState extends State<EstadioScreen> {
  final DBHelper _dbHelper = DBHelper();
  List<Estadio> _estadios = [];
  List<Estadio> _filteredEstadios = [];
  String _searchQuery = '';
  String _sortOrder = 'nombre'; // Opciones: 'nombre', 'capacidad'

  @override
  void initState() {
    super.initState();
    _loadEstadios();
  }

  Future<void> _loadEstadios() async {
    final estadios = await _dbHelper.getEstadios();
    setState(() {
      _estadios = estadios;
      _applyFilters();
    });
  }

  void _applyFilters() {
    List<Estadio> filtered = _estadios.where((estadio) {
      return estadio.nombre.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    if (_sortOrder == 'nombre') {
      filtered.sort((a, b) => a.nombre.compareTo(b.nombre));
    } else if (_sortOrder == 'capacidad') {
      filtered.sort((a, b) => b.capacidad.compareTo(a.capacidad));
    }

    setState(() {
      _filteredEstadios = filtered;
    });
  }

  void _showFormDialog({Estadio? estadio}) {
    final _nombreController = TextEditingController(text: estadio?.nombre ?? '');
    final _ubicacionController = TextEditingController(text: estadio?.ubicacion ?? '');
    final _capacidadController = TextEditingController(text: estadio?.capacidad.toString() ?? '');

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.green.shade50,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          title: Text(
            estadio == null ? 'Agregar Estadio' : 'Editar Estadio',
            style: TextStyle(
              color: Colors.green[900],
              fontWeight: FontWeight.bold,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTextField(controller: _nombreController, label: 'Nombre'),
                _buildTextField(controller: _ubicacionController, label: 'Ubicación'),
                _buildTextField(
                  controller: _capacidadController,
                  label: 'Capacidad',
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
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green[600]),
              onPressed: () {
                final nuevoEstadio = Estadio(
                  id: estadio?.id,
                  nombre: _nombreController.text.trim(),
                  ubicacion: _ubicacionController.text.trim(),
                  capacidad: int.tryParse(_capacidadController.text.trim()) ?? 0,
                );
                _saveEstadio(nuevoEstadio);
                Navigator.of(context).pop();
              },
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _saveEstadio(Estadio estadio) async {
    if (estadio.id == null) {
      await _dbHelper.insertEstadio(estadio);
    } else {
      await _dbHelper.updateEstadio(estadio);
    }
    _loadEstadios();
  }

  Future<void> _deleteEstadio(int id) async {
    await _dbHelper.deleteEstadio(id);
    _loadEstadios();
  }

  void _confirmDeleteEstadio(int id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar eliminación'),
          content: const Text('¿Estás seguro de que deseas eliminar este estadio? Esta acción no se puede deshacer.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () {
                _deleteEstadio(id);
                Navigator.of(context).pop();
              },
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );
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
          labelStyle: const TextStyle(color: Colors.green),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.green),
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
        backgroundColor: Colors.green[800],
        title: Row(
          children: [
            const Icon(Icons.stadium),
            const SizedBox(width: 8),
            const Text('Estadios'),
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
              const PopupMenuItem(value: 'capacidad', child: Text('Ordenar por Capacidad')),
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
                prefixIcon: Icon(Icons.search, color: Colors.green),
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
            child: _filteredEstadios.isEmpty
                ? const Center(
                    child: Text(
                      'No hay estadios disponibles.',
                      style: TextStyle(color: Colors.green),
                    ),
                  )
                : ListView.builder(
                    itemCount: _filteredEstadios.length,
                    itemBuilder: (context, index) {
                      final estadio = _filteredEstadios[index];
                      return Card(
                        color: Colors.green[50],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        elevation: 4.0,
                        child: ListTile(
                          leading: const Icon(Icons.location_on, color: Colors.green),
                          title: Text(
                            estadio.nombre,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, color: Colors.green[900]),
                          ),
                          subtitle: Text(
                            'Ubicación: ${estadio.ubicacion}\nCapacidad: ${estadio.capacidad}',
                            style: TextStyle(color: Colors.green[700]),
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _confirmDeleteEstadio(estadio.id!),
                          ),
                          onTap: () => _showFormDialog(estadio: estadio),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green[800],
        onPressed: () => _showFormDialog(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
