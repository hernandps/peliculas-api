import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'agregar_pelicula.dart';

void main() {
  runApp(MyApp());
}

const String apiUrl = "https://peliculas-api-6ak4.onrender.com/peliculas"; // para emulador Android

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mis Películas',
      home: PeliculasScreen(),
    );
  }
}

class PeliculasScreen extends StatefulWidget {
  @override
  _PeliculasScreenState createState() => _PeliculasScreenState();
}

class _PeliculasScreenState extends State<PeliculasScreen> {
  List peliculas = [];

    Future<void> fetchPeliculas() async {
      try {
        final response = await http.get(Uri.parse(apiUrl));
        print('Código: ${response.statusCode}');
        print('Respuesta: ${response.body}');

        if (response.statusCode == 200) {
          setState(() {
            peliculas = json.decode(response.body);
          });
        } else {
          throw Exception('Error HTTP: ${response.statusCode}');
        }
      } catch (e) {
        print('Error al conectar con la API: $e');
      }
    }

  @override
  void initState() {
    super.initState();
    fetchPeliculas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AgregarPeliculaScreen()),
          ).then((resultado) {
            if (resultado == true) {
              fetchPeliculas(); // Refresca al volver si se agregó algo
            }
          });
  },
  child: Icon(Icons.add),
),
      appBar: AppBar(title: Text('Mis Películas')),
      body: ListView.builder(
        itemCount: peliculas.length,
        itemBuilder: (context, index) {
          final p = peliculas[index];
          return ListTile(
            title: Text(p['titulo']),
            subtitle: Text('Calificación: ${p['calificacion']}'),
            trailing: Text(p['fecha_vista']),
          );
        },
      ),
    );
  }
}
