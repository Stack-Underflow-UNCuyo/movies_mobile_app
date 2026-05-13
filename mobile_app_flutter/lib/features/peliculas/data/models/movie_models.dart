import 'package:flutter/foundation.dart';

class MovieModels {
  bool adult;
  String? backdropPath;
  List<int> genreIds;
  int id;
  String originalLanguage;
  String originalTitle;
  String overview;
  double popularity;
  String? posterPath;
  String? releaseDate;
  String title;
  bool video;
  double voteAverage;
  int voteCount;

  MovieModels({
    required this.adult,
    this.backdropPath,
    required this.genreIds,
    required this.id,
    required this.originalLanguage,
    required this.originalTitle,
    required this.overview,
    required this.popularity,
    this.posterPath,
    this.releaseDate,
    required this.title,
    required this.video,
    required this.voteAverage,
    required this.voteCount,
  });

    /*
    Factory es un constructor especial que da control sobre qué objeto se crea y cómo.
    Es como una fábrica que recibe materia prima (el JSON) y devuelve el producto terminado (el objeto). 
    Este método convierte el json que devuelve la api a un objeto MovieModels (traductor)
    */
  factory MovieModels.fromMap(Map<String, dynamic> json) => MovieModels(
      adult: json['adult'] ?? false,
      backdropPath: json['backdrop_path'] ?? '',
      genreIds: json['genre_ids'] != null 
          ? List<int>.from(json['genre_ids']) 
          : [],
      id: json['id'] ?? 0,
      originalLanguage: json['original_language'] ?? '',
      originalTitle: json['original_title'] ?? '',
      overview: json['overview'] ?? '',
      popularity: (json['popularity'] ?? 0).toDouble(),
      posterPath: json['poster_path'] ?? '',
      releaseDate: json['release_date'] ?? '',
      title: json['title'] ?? '',
      video: json['video'] ?? false,
      voteAverage: (json['vote_average'] ?? 0).toDouble(),
      voteCount: json['vote_count'] ?? 0,
    );

  // Mantenemos fromJson por compatibilidad, llamando internamente a fromMap
  factory MovieModels.fromJson(Map<String, dynamic> json) => MovieModels.fromMap(json);
  
  //Hace lo inverso al anterior objeto --> map
  Map<String, dynamic> toJson() => {
        'adult': adult,
        'backdrop_path': backdropPath,
        'genre_ids': genreIds,
        'id': id,
        'original_language': originalLanguage,
        'original_title': originalTitle,
        'overview': overview,
        'popularity': popularity,
        'poster_path': posterPath,
        'release_date': releaseDate,
        'title': title,
        'video': video,
        'vote_average': voteAverage,
        'vote_count': voteCount,
  };

  //para evitar errores de null, se puede crear un constructor vacío con valores por defecto
  MovieModels.empty()
      : adult = false,
        backdropPath = '',
        genreIds = [],
        id = 0,
        originalLanguage = '',
        originalTitle = '',
        overview = '',
        popularity = 0.0,
        posterPath = '',
        releaseDate = '',
        title = '',
        video = false,
        voteAverage = 0.0,
        voteCount = 0;
}