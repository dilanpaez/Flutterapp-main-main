import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/car_movie.dart';

class ApiService {
  final String baseUrl =
  'https://cors-anywhere.herokuapp.com/https://carsmoviesinventoryproject-production.up.railway.app/api/v1/carsmovies?size=29';


  Future<List<CarMovie>> fetchCarMovies() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);

      if (jsonResponse.containsKey('Movies') && jsonResponse['Movies'] is List) {
        List<dynamic> moviesList = jsonResponse['Movies'];
        return moviesList.map((item) => CarMovie.fromJson(item)).toList();
      }

      throw Exception('Formato de respuesta inesperado');
    } else {
      throw Exception('Error al cargar los datos');
    }
  }



  Future<CarMovie> fetchCarMovieById(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/$id'));

    if (response.statusCode == 200) {
      return CarMovie.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load car movie');
    }
  }

  Future<CarMovie> createCarMovie(CarMovie carMovie) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(carMovie.toJson()),
    );

    if (response.statusCode == 201) {
      return CarMovie.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create car movie');
    }
  }

  Future<void> updateCarMovie(CarMovie movie) async {
    final url = Uri.parse('$baseUrl/${movie.id}');

    final response = await http.put(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(movie.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception("Error al actualizar la película: ${response.body}");
    }
  }

  Future<void> deleteCarMovie(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));

    if (response.statusCode != 200 && response.statusCode != 202 && response.statusCode != 204) {
      throw Exception('Failed to delete car movie');
    }
  }
}
