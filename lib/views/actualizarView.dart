import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ActualizarView extends StatefulWidget {
  const ActualizarView({Key? key}) : super(key: key);

  @override
  _ActualizarViewState createState() => _ActualizarViewState();
}

class _ActualizarViewState extends State<ActualizarView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _apellidoController = TextEditingController();
  final TextEditingController _direccionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Actualizar Datos'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _buildTextField(_nombreController, 'Nombre'),
              _buildTextField(_apellidoController, 'Apellido'),
              _buildTextField(_direccionController, 'Dirección'),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _updateData,
                child: const Text('Guardar Cambios'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  TextFormField _buildTextField(TextEditingController controller, String label) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor ingrese su $label';
        }
        return null;
      },
    );
  }

  void _updateData() {
    if (_formKey.currentState!.validate()) {
      Fluttertoast.showToast(
        msg: "Datos actualizados correctamente.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0
      );

      // Limpiar los campos después de la actualización (opcional)
      _nombreController.clear();
      _apellidoController.clear();
      _direccionController.clear();
    }
  }
}
