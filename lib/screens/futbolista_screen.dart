import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../helpers/db_helper.dart';
import '../models/futbolista.dart';

class FutbolistaScreen extends StatefulWidget {
  @override
  _FutbolistaScreenState createState() => _FutbolistaScreenState();
}

class _FutbolistaScreenState extends State<FutbolistaScreen> {
  final DBHelper _dbHelper = DBHelper();
  List<Futbolista> _futbolistas = [];
  List<Futbolista> _filteredFutbolistas = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadFutbolistas();
    _searchController.addListener(_onSearchChanged);
  }

  Future<void> _loadFutbolistas() async {
    final futbolistas = await _dbHelper.getFutbolistas();
    setState(() {
      _futbolistas = futbolistas;
      _filteredFutbolistas = futbolistas;
    });
  }

  Future<void> _saveFutbolista(Futbolista futbolista) async {
    if (futbolista.id == null) {
      await _dbHelper.insertFutbolista(futbolista);
    } else {
      await _dbHelper.updateFutbolista(futbolista);
    }
    _loadFutbolistas();
  }

  Future<void> _deleteFutbolista(int id) async {
    await _dbHelper.deleteFutbolista(id);
    _loadFutbolistas();
  }

  void _onSearchChanged() {
    setState(() {
      _filteredFutbolistas = _futbolistas
          .where((futbolista) => futbolista.nombre
              .toLowerCase()
              .contains(_searchController.text.toLowerCase()))
          .toList();
    });
  }

  void _showDeleteConfirmation(int id, String nombre) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar eliminación'),
          content: Text('¿Estás seguro de que deseas eliminar a $nombre?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () {
                _deleteFutbolista(id);
                Navigator.of(context).pop();
              },
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );
  }

  void _showFormDialog({Futbolista? futbolista}) {
    final nombreController =
        TextEditingController(text: futbolista?.nombre ?? '');
    final edadController =
        TextEditingController(text: futbolista?.edad.toString() ?? '');
    final posicionController =
        TextEditingController(text: futbolista?.posicion ?? '');
    final golesController =
        TextEditingController(text: futbolista?.goles.toString() ?? '');

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.green[50],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Text(
            futbolista == null ? 'Agregar Futbolista' : 'Editar Futbolista',
            style: TextStyle(color: Colors.green[900]),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTextField(controller: nombreController, label: 'Nombre'),
                _buildTextField(
                  controller: edadController,
                  label: 'Edad',
                  keyboardType: TextInputType.number,
                ),
                _buildTextField(controller: posicionController, label: 'Posición'),
                _buildTextField(
                  controller: golesController,
                  label: 'Goles',
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
              onPressed: () {
                final nuevoFutbolista = Futbolista(
                  id: futbolista?.id,
                  nombre: nombreController.text.trim(),
                  edad: int.tryParse(edadController.text.trim()) ?? 0,
                  posicion: posicionController.text.trim(),
                  goles: int.tryParse(golesController.text.trim()) ?? 0,
                );
                _saveFutbolista(nuevoFutbolista);
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[700],
              ),
              child: const Text('Guardar'),
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
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
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
            Icon(Icons.sports_soccer, color: Colors.white),
            SizedBox(width: 10),
            Expanded(
              child: TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  hintText: 'Buscar futbolista...',
                  hintStyle: TextStyle(color: Colors.white70),
                  border: InputBorder.none,
                ),
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
      body: _filteredFutbolistas.isEmpty
          ? Center(
              child: Text(
                'No hay futbolistas disponibles.',
                style: TextStyle(color: Colors.green[800]),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: _filteredFutbolistas.length,
              itemBuilder: (context, index) {
                final futbolista = _filteredFutbolistas[index];
                return Card(
                  color: Colors.green[50],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 3.0,
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.green[800],
                      child: FaIcon(
                        FontAwesomeIcons.user,
                        color: Colors.white,
                      ),
                    ),
                    title: Text(
                      futbolista.nombre,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.green[900],
                      ),
                    ),
                    subtitle: Text(
                      'Posición: ${futbolista.posicion}, Goles: ${futbolista.goles}',
                      style: TextStyle(color: Colors.green[700]),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _showDeleteConfirmation(
                        futbolista.id!,
                        futbolista.nombre,
                      ),
                    ),
                    onTap: () => _showFormDialog(futbolista: futbolista),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green[700],
        onPressed: () => _showFormDialog(),
        child: const Icon(Icons.add),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }
}
