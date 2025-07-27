import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AgregarPeliculaScreen extends StatefulWidget {
  @override
  _AgregarPeliculaScreenState createState() => _AgregarPeliculaScreenState();
}

class _AgregarPeliculaScreenState extends State<AgregarPeliculaScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _tituloController = TextEditingController();
  final TextEditingController _calificacionController = TextEditingController();
  final TextEditingController _comentarioController = TextEditingController();
  DateTime? _fechaSeleccionada;

  Future<void> _guardarPelicula() async {
    final url = Uri.parse('http://localhost:8000/peliculas');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'titulo': _tituloController.text,
        'fecha_vista': _fechaSeleccionada?.toIso8601String().split('T')[0],
        'calificacion': int.parse(_calificacionController.text),
        'comentario': _comentarioController.text,
      }),
    );

    if (response.statusCode == 200) {
      Navigator.pop(context); // Vuelve a la pantalla anterior
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al guardar la película')),
      );
    }
  }

  Future<void> _seleccionarFecha() async {
    final DateTime? fecha = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1980),
      lastDate: DateTime.now(),
    );
    if (fecha != null) {
      setState(() {
        _fechaSeleccionada = fecha;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Agregar Película')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _tituloController,
                decoration: InputDecoration(labelText: 'Título'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Ingresa un título' : null,
              ),
              TextFormField(
                controller: _calificacionController,
                decoration: InputDecoration(labelText: 'Calificación (1-10)'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  final n = int.tryParse(value ?? '');
                  if (n == null || n < 1 || n > 10) {
                    return 'Calificación entre 1 y 10';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _comentarioController,
                decoration: InputDecoration(labelText: 'Comentario'),
                maxLines: 3,
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: Text(_fechaSeleccionada == null
                        ? 'Fecha no seleccionada'
                        : 'Fecha: ${_fechaSeleccionada!.toLocal().toString().split(' ')[0]}'),
                  ),
                  ElevatedButton(
                    onPressed: _seleccionarFecha,
                    child: Text('Seleccionar fecha'),
                  ),
                ],
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate() &&
                      _fechaSeleccionada != null) {
                    _guardarPelicula();
                  }
                },
                child: Text('Guardar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
