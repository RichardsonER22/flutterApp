import 'package:flutter/material.dart';
import '../helpers/db_helper.dart';
import '../models/arbitro.dart';

class ArbitroScreen extends StatefulWidget {
  @override
  _ArbitroScreenState createState() => _ArbitroScreenState();
}

class _ArbitroScreenState extends State<ArbitroScreen> {
  final DBHelper _dbHelper = DBHelper();
  List<Arbitro> _arbitros = [];
  List<Arbitro> _filteredArbitros = [];
  String _searchQuery = '';
  String _sortOrder = 'nombre';

  @override
  void initState() {
    super.initState();
    _loadArbitros();
  }

  Future<void> _loadArbitros() async {
    final arbitros = await _dbHelper.getArbitros();
    setState(() {
      _arbitros = arbitros;
      _applyFilters();
    });
  }

  void _applyFilters() {
    List<Arbitro> filtered = _arbitros.where((arbitro) {
      return arbitro.nombre.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    if (_sortOrder == 'nombre') {
      filtered.sort((a, b) => a.nombre.compareTo(b.nombre));
    } else if (_sortOrder == 'experiencia') {
      filtered.sort((a, b) => b.experiencia.compareTo(a.experiencia));
    }

    setState(() {
      _filteredArbitros = filtered;
    });
  }

  void _showFormDialog({Arbitro? arbitro}) {
    final _nombreController = TextEditingController(text: arbitro?.nombre ?? '');
    final _nacionalidadController = TextEditingController(text: arbitro?.nacionalidad ?? '');
    final _experienciaController = TextEditingController(
      text: arbitro?.experiencia.toString() ?? '',
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.green.shade50,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          title: Text(
            arbitro == null ? 'Agregar Árbitro' : 'Editar Árbitro',
            style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTextField(controller: _nombreController, label: 'Nombre'),
                _buildTextField(controller: _nacionalidadController, label: 'Nacionalidad'),
                _buildTextField(
                  controller: _experienciaController,
                  label: 'Años de Experiencia',
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
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              onPressed: () async {
                final confirm = await _showSaveConfirmationDialog();
                if (confirm) {
                  final nuevoArbitro = Arbitro(
                    id: arbitro?.id,
                    nombre: _nombreController.text.trim(),
                    nacionalidad: _nacionalidadController.text.trim(),
                    experiencia: int.tryParse(_experienciaController.text.trim()) ?? 0,
                  );
                  _saveArbitro(nuevoArbitro);
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

  Future<void> _saveArbitro(Arbitro arbitro) async {
    if (arbitro.id == null) {
      await _dbHelper.insertArbitro(arbitro);
    } else {
      await _dbHelper.updateArbitro(arbitro);
    }
    _loadArbitros();
  }

  Future<void> _deleteArbitro(int id) async {
    final confirmDelete = await _showDeleteConfirmationDialog();
    if (confirmDelete) {
      await _dbHelper.deleteArbitro(id);
      _loadArbitros();
    }
  }

  Future<bool> _showDeleteConfirmationDialog() async {
    return await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Confirmar eliminación'),
              content: const Text(
                  '¿Estás seguro de que deseas eliminar este árbitro? Esta acción no se puede deshacer.'),
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

  Future<bool> _showSaveConfirmationDialog() async {
    return await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Confirmar acción'),
              content: const Text(
                  '¿Estás seguro de que deseas guardar los cambios para este árbitro?'),
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
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade100,
      appBar: AppBar(
        backgroundColor: Colors.green.shade800,
        title: const Text('Árbitros'),
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
              decoration: InputDecoration(
                labelText: 'Buscar por nombre',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                prefixIcon: const Icon(Icons.search, color: Colors.green),
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
            child: _filteredArbitros.isEmpty
                ? const Center(
                    child: Text(
                      'No hay árbitros disponibles.',
                      style: TextStyle(fontSize: 16.0, color: Colors.black54),
                    ),
                  )
                : ListView.builder(
                    itemCount: _filteredArbitros.length,
                    itemBuilder: (context, index) {
                      final arbitro = _filteredArbitros[index];
                      return Card(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        elevation: 4.0,
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.green.shade200,
                            child: const Icon(Icons.sports, color: Colors.green),
                          ),
                          title: Text(
                            arbitro.nombre,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            'Nacionalidad: ${arbitro.nacionalidad}\nExperiencia: ${arbitro.experiencia} años',
                            style: const TextStyle(color: Colors.black54),
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _deleteArbitro(arbitro.id!),
                          ),
                          onTap: () => _showFormDialog(arbitro: arbitro),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green.shade800,
        onPressed: () => _showFormDialog(),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
