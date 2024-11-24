import 'package:flutter/material.dart';
import '../helpers/db_helper.dart';
import '../models/usuario.dart';

class EditarPerfilScreen extends StatefulWidget {
  final Usuario usuario;

  EditarPerfilScreen({required this.usuario});

  @override
  _EditarPerfilScreenState createState() => _EditarPerfilScreenState();
}

class _EditarPerfilScreenState extends State<EditarPerfilScreen> {
  final DBHelper _dbHelper = DBHelper();

  late TextEditingController _nombreController;
  late TextEditingController _correoController;
  late TextEditingController _passwordController;
  bool _isLoading = false;  // Estado de carga

  @override
  void initState() {
    super.initState();
    _nombreController = TextEditingController(text: widget.usuario.nombre);
    _correoController = TextEditingController(text: widget.usuario.email);
    _passwordController = TextEditingController(text: widget.usuario.password);
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _correoController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _showConfirmationDialog() async {
    // Mostrar un diálogo de confirmación antes de guardar los cambios
    final bool confirm = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmar cambios'),
          content: Text('¿Estás seguro de que quieres guardar los cambios?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text('Guardar'),
            ),
          ],
        );
      },
    ) ?? false;

    // Si el usuario confirma, guardar los cambios
    if (confirm) {
      _saveUsuario();
    }
  }

  Future<void> _saveUsuario() async {
    // Si estamos en proceso de guardado, no permitir más acciones
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    // Verifica que los datos no sean los mismos
    if (_nombreController.text.trim() == widget.usuario.nombre &&
        _correoController.text.trim() == widget.usuario.email &&
        _passwordController.text.trim() == widget.usuario.password) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No se han realizado cambios')),
      );
      setState(() {
        _isLoading = false;
      });
      return; // No hacer nada si no hay cambios
    }

    final updatedUsuario = Usuario(
      id: widget.usuario.id,
      nombre: _nombreController.text.trim(),
      email: _correoController.text.trim(),
      password: _passwordController.text.trim(),
    );

    // Actualiza el usuario en la base de datos
    await _dbHelper.updateUser(updatedUsuario);

    // Muestra un mensaje de éxito
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Datos actualizados con éxito')),
    );

    setState(() {
      _isLoading = false;
    });

    // Regresar a la pantalla de perfil
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Perfil'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildTextField(controller: _nombreController, label: 'Nombre'),
            _buildTextField(controller: _correoController, label: 'Correo', keyboardType: TextInputType.emailAddress),
            _buildTextField(controller: _passwordController, label: 'Contraseña', obscureText: true),
            SizedBox(height: 20),
            _isLoading 
              ? CircularProgressIndicator()  // Mostrar indicador de carga
              : ElevatedButton(
                  onPressed: _showConfirmationDialog,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,  // Color del botón
                    padding: EdgeInsets.symmetric(vertical: 16),
                    textStyle: TextStyle(fontSize: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: Text('Guardar Cambios'),
                ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false, // Para ocultar la contraseña
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText, // Si es la contraseña, ocultamos el texto
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
          filled: true,
          fillColor: Colors.grey[200], // Fondo suave
        ),
      ),
    );
  }
}
