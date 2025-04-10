import 'package:flutter/material.dart';
import '../models/car_movie.dart';
import '../services/api_service.dart';

class EditCarMovieForm extends StatefulWidget {
  final CarMovie movie;

  const EditCarMovieForm({Key? key, required this.movie}) : super(key: key);

  @override
  _EditCarMovieFormState createState() => _EditCarMovieFormState();
}

class _EditCarMovieFormState extends State<EditCarMovieForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _yearController;
  late TextEditingController _durationController;
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.movie.carMovieName);
    _yearController = TextEditingController(text: widget.movie.carMovieYear.toString());
    _durationController = TextEditingController(text: widget.movie.duration.toString());
  }

  @override
  void dispose() {
    _nameController.dispose();
    _yearController.dispose();
    _durationController.dispose();
    super.dispose();
  }

  void _updateMovie() async {
    if (_formKey.currentState!.validate()) {
      CarMovie updatedMovie = CarMovie(
        id: widget.movie.id,
        carMovieName: _nameController.text,
        carMovieYear: int.parse(_yearController.text),
        duration: int.parse(_durationController.text),
      );
      
      try {
        await _apiService.updateCarMovie(updatedMovie);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Película actualizada con éxito')),
        );
        Navigator.pop(context, updatedMovie);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al actualizar: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Editar Película')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Nombre de la película'),
                validator: (value) => value!.isEmpty ? 'Ingrese un nombre' : null,
              ),
              TextFormField(
                controller: _yearController,
                decoration: const InputDecoration(labelText: 'Año de lanzamiento'),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'Ingrese un año' : null,
              ),
              TextFormField(
                controller: _durationController,
                decoration: const InputDecoration(labelText: 'Duración (min)'),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'Ingrese la duración' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _updateMovie,
                child: const Text('Guardar Cambios'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
