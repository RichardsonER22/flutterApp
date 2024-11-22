import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../models/partido.dart';

class CalendarioScreen extends StatefulWidget {
  @override
  _CalendarioScreenState createState() => _CalendarioScreenState();
}

class _CalendarioScreenState extends State<CalendarioScreen> {
  late final ValueNotifier<List<Partido>> _selectedDayPartidos;
  late DateTime _selectedDay;
  final List<Partido> _partidos = []; // Lista de partidos registrados

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now();
    _selectedDayPartidos = ValueNotifier(_getPartidosForDay(_selectedDay));
  }

  // Filtrar partidos por fecha
  List<Partido> _getPartidosForDay(DateTime day) {
    return _partidos.where((partido) {
      return partido.fecha.year == day.year &&
          partido.fecha.month == day.month &&
          partido.fecha.day == day.day;
    }).toList();
  }

  // Mostrar detalles del partido
  void _showPartidoDialog({Partido? partido}) {
    final _equipoLocalController = TextEditingController(text: partido?.equipoLocal ?? '');
    final _equipoVisitanteController = TextEditingController(text: partido?.equipoVisitante ?? '');
    final _lugarController = TextEditingController(text: partido?.lugar ?? '');
    final _fechaController = TextEditingController(text: partido?.fecha.toString() ?? '');

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(partido == null ? 'Agregar Partido' : 'Editar Partido'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                _buildTextField(controller: _equipoLocalController, label: 'Equipo Local'),
                _buildTextField(controller: _equipoVisitanteController, label: 'Equipo Visitante'),
                _buildTextField(controller: _lugarController, label: 'Lugar'),
                _buildTextField(controller: _fechaController, label: 'Fecha', keyboardType: TextInputType.datetime),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                final confirmSave = await _showSaveConfirmationDialog();
                if (confirmSave) {
                  final nuevoPartido = Partido(
                    id: partido?.id ?? _partidos.length + 1, // Generar ID único si es nuevo
                    equipoLocal: _equipoLocalController.text.trim(),
                    equipoVisitante: _equipoVisitanteController.text.trim(),
                    lugar: _lugarController.text.trim(),
                    fecha: DateTime.tryParse(_fechaController.text.trim()) ?? DateTime.now(), // Validar fecha
                  );
                  _savePartido(nuevoPartido);
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

  // Función para guardar el partido
  void _savePartido(Partido partido) {
    setState(() {
      // Validación de fecha futura
      if (partido.fecha.isBefore(DateTime.now())) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('¡La fecha debe ser futura!')),
        );
        return;
      }

      if (_partidos.any((p) => p.id == partido.id)) {
        // Editar partido existente
        _partidos.removeWhere((p) => p.id == partido.id);
      }
      _partidos.add(partido); // Agregar el nuevo partido
      _selectedDayPartidos.value = _getPartidosForDay(_selectedDay); // Actualizar lista de partidos para la fecha seleccionada
    });
  }

  // Función para eliminar un partido
  void _deletePartido(int id) async {
    final confirmDelete = await _showDeleteConfirmationDialog();
    if (confirmDelete) {
      setState(() {
        _partidos.removeWhere((partido) => partido.id == id);
        _selectedDayPartidos.value = _getPartidosForDay(_selectedDay);
      });
    }
  }

  // Crear campo de texto
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
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  // Diálogo de confirmación para guardar
  Future<bool> _showSaveConfirmationDialog() async {
    return await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar acción'),
          content: const Text('¿Estás seguro de que deseas guardar este partido?'),
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
    ) ?? false; // Si el usuario cierra el diálogo sin seleccionar, retorna `false`
  }

  // Diálogo de confirmación para eliminar
  Future<bool> _showDeleteConfirmationDialog() async {
    return await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar eliminación'),
          content: const Text('¿Estás seguro de que deseas eliminar este partido? Esta acción no se puede deshacer.'),
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
    ) ?? false; // Si el usuario cierra el diálogo sin seleccionar, retorna `false`
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendario de Partidos'),
      ),
      body: Column(
        children: [
          // Calendario
          TableCalendar<Partido>(
            focusedDay: _selectedDay,
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            selectedDayPredicate: (day) => isSameDay(day, _selectedDay),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _selectedDayPartidos.value = _getPartidosForDay(_selectedDay);
              });
            },
            eventLoader: (day) {
              return _getPartidosForDay(day);
            },
            calendarStyle: CalendarStyle(
              todayDecoration: BoxDecoration(
                color: Colors.orangeAccent,
                shape: BoxShape.circle,
              ),
              selectedDecoration: BoxDecoration(
                color: Colors.blueAccent,
                shape: BoxShape.circle,
              ),
              markerDecoration: BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
              ),
              outsideDaysVisible: false, // Ocultar los días fuera del mes
            ),
            headerStyle: HeaderStyle(
              formatButtonVisible: false, // Ocultar el botón de formato
              titleCentered: true,
              leftChevronIcon: Icon(Icons.arrow_left, color: Colors.blue),
              rightChevronIcon: Icon(Icons.arrow_right, color: Colors.blue),
            ),
          ),
          // Lista de partidos para el día seleccionado
          Expanded(
            child: ValueListenableBuilder<List<Partido>>(
              valueListenable: _selectedDayPartidos,
              builder: (context, partidos, _) {
                return partidos.isEmpty
                    ? const Center(child: Text('No hay partidos para esta fecha.'))
                    : ListView.builder(
                        itemCount: partidos.length,
                        itemBuilder: (context, index) {
                          final partido = partidos[index];
                          return Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            elevation: 4.0,
                            child: ListTile(
                              title: Text('${partido.equipoLocal} vs ${partido.equipoVisitante}'),
                              subtitle: Text('Lugar: ${partido.lugar} | Fecha: ${partido.fecha.toLocal()}'),
                              trailing: IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () => _deletePartido(partido.id),
                              ),
                              onTap: () => _showPartidoDialog(partido: partido),
                            ),
                          );
                        },
                      );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showPartidoDialog(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
