import 'package:flutter/material.dart';
import 'models/car_movie.dart';
import 'services/api_service.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final ApiService apiService = ApiService();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cars Movies Inventory',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: CarMoviesScreen(),
    );
  }
}

class CarMoviesScreen extends StatefulWidget {
  @override
  _CarMoviesScreenState createState() => _CarMoviesScreenState();
}

class _CarMoviesScreenState extends State<CarMoviesScreen> {
  final ApiService apiService = ApiService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cars Movies Inventory'),
        centerTitle: true,
        elevation: 4,
      ),
      body: FutureBuilder<List<CarMovie>>(
        future: apiService.fetchCarMovies(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No car movies found.'));
          } else {
            List<CarMovie> carMovies = snapshot.data!;
            return ListView.builder(
              padding: EdgeInsets.all(12),
              itemCount: carMovies.length,
              itemBuilder: (context, index) {
                final movie = carMovies[index];
                return Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  margin: EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    title: Text(
                      movie.carMovieName,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Text(
                        'Year: ${movie.carMovieYear} • Duration: ${movie.duration} min',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[700],
                        ),
                      ),
                    ),
                    leading: Icon(Icons.directions_car, color: Colors.indigo),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
