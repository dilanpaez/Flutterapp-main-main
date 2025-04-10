class CarMovie {
  final String id;
  final String carMovieName;
  final int carMovieYear;
  final int duration;

  CarMovie({
    required this.id,
    required this.carMovieName,
    required this.carMovieYear,
    required this.duration,
  });

  // Convertir JSON a objeto CarMovie
  factory CarMovie.fromJson(Map<String, dynamic> json) {
    return CarMovie(
      id: json['id'],
      carMovieName: json['carMovieName'],
      carMovieYear: int.tryParse(json['carMovieYear'].toString()) ?? 0,  // Conversión segura
      duration: json['duration'],
    );
  }

  // Convertir objeto CarMovie a JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'carMovieName': carMovieName,
      'carMovieYear': carMovieYear.toString(),  // Convertimos int a String si es necesario
      'duration': duration,
    };
  }
}