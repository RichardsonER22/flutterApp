import 'package:flutter/material.dart';
import '../helpers/db_helper.dart';
import '../models/entrenador.dart';

class EntrenadorScreen extends StatefulWidget {
  @override
  _EntrenadorScreenState createState() => _EntrenadorScreenState();
}

class _EntrenadorScreenState extends State<EntrenadorScreen> {
  final DBHelper _dbHelper = DBHelper();
  List<Entrenador> _entrenadores = [];
  List<Entrenador> _filteredEntrenadores = [];
  String _searchQuery = '';
  String _sortOrder = 'nombre'; // Opciones: 'nombre', 'experiencia'

  @override
  void initState() {
    super.initState();
    _loadEntrenadores();
  }

  Future<void> _loadEntrenadores() async {
    final entrenadores = await _dbHelper.getEntrenadores();
    setState(() {
      _entrenadores = entrenadores;
      _applyFilters();
    });
  }

  void _applyFilters() {
    List<Entrenador> filtered = _entrenadores.where((entrenador) {
      return entrenador.nombre.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    if (_sortOrder == 'nombre') {
      filtered.sort((a, b) => a.nombre.compareTo(b.nombre));
    } else if (_sortOrder == 'experiencia') {
      filtered.sort((a, b) => b.experiencia.compareTo(a.experiencia));
    }

    setState(() {
      _filteredEntrenadores = filtered;
    });
  }

  void _showFormDialog({Entrenador? entrenador}) {
    final _nombreController = TextEditingController(text: entrenador?.nombre ?? '');
    final _experienciaController = TextEditingController(
      text: entrenador?.experiencia.toString() ?? '',
    );
    final _especialidadController = TextEditingController(
      text: entrenador?.especialidad ?? '',
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          title: Text(
            entrenador == null ? 'Agregar Entrenador' : 'Editar Entrenador',
            style: TextStyle(color: Colors.green[800], fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTextField(controller: _nombreController, label: 'Nombre'),
                _buildTextField(
                  controller: _experienciaController,
                  label: 'Años de Experiencia',
                  keyboardType: TextInputType.number,
                ),
                _buildTextField(
                  controller: _especialidadController,
                  label: 'Especialidad',
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
              onPressed: () async {
                final confirm = await _showSaveConfirmationDialog();
                if (confirm) {
                  final nuevoEntrenador = Entrenador(
                    id: entrenador?.id,
                    nombre: _nombreController.text.trim(),
                    experiencia: int.tryParse(_experienciaController.text.trim()) ?? 0,
                    especialidad: _especialidadController.text.trim(),
                  );
                  _saveEntrenador(nuevoEntrenador);
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _saveEntrenador(Entrenador entrenador) async {
    if (entrenador.id == null) {
      await _dbHelper.insertEntrenador(entrenador);
    } else {
      await _dbHelper.updateEntrenador(entrenador);
    }
    _loadEntrenadores();
  }

  Future<void> _deleteEntrenador(int id) async {
    final confirmDelete = await _showDeleteConfirmationDialog();
    if (confirmDelete) {
      await _dbHelper.deleteEntrenador(id);
      _loadEntrenadores();
    }
  }

  Future<bool> _showSaveConfirmationDialog() async {
    return await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Confirmar acción'),
              content: const Text(
                  '¿Estás seguro de que deseas guardar los cambios para este entrenador?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('Cancelar'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text('Confirmar'),
                ),
              ],
            );
          },
        ) ??
        false; // Si el usuario cierra el diálogo, retorna `false` por defecto.
  }

  Future<bool> _showDeleteConfirmationDialog() async {
    return await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Confirmar eliminación'),
              content: const Text(
                  '¿Estás seguro de que deseas eliminar este entrenador? Esta acción no se puede deshacer.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('Cancelar'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text('Eliminar'),
                ),
              ],
            );
          },
        ) ??
        false; // Si el usuario cierra el diálogo, retorna `false` por defecto.
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
        title: const Text('Entrenadores'),
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
              const PopupMenuItem(value: 'experiencia', child: Text('Ordenar por Experiencia')),
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
            child: _filteredEntrenadores.isEmpty
                ? const Center(
                    child: Text('No hay entrenadores disponibles.'),
                  )
                : ListView.builder(
                    itemCount: _filteredEntrenadores.length,
                    itemBuilder: (context, index) {
                      final entrenador = _filteredEntrenadores[index];
                      return Card(
                        color: Colors.green[50],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        elevation: 4.0,
                        child: ListTile(
                          title: Text(
                            entrenador.nombre,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, color: Colors.green[800]),
                          ),
                          subtitle: Text(
                            'Experiencia: ${entrenador.experiencia} años\nEspecialidad: ${entrenador.especialidad}',
                            style: TextStyle(color: Colors.green[700]),
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _deleteEntrenador(entrenador.id!),
                          ),
                          onTap: () => _showFormDialog(entrenador: entrenador),
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
