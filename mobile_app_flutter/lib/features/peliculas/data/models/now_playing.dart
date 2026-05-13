import 'dart:convert';
import 'movie_models.dart';

/*
Contiene toda la respuesta entera del JSON de la API, no solo la lista de películas
*/
class NowPlayingResponse {
  Dates dates;
  int page;
  List<MovieModels> results;
  int totalPages;
  int totalResults;

  NowPlayingResponse({
    required this.dates, 
    required this.page,
    required this.results,
    required this.totalPages,
    required this.totalResults,
  });

  factory NowPlayingResponse.fromJson(String str) =>
      NowPlayingResponse.fromMap(json.decode(str));

  factory NowPlayingResponse.fromMap(Map<String, dynamic> json) =>
      NowPlayingResponse(
        dates: Dates.fromMap(json["dates"]),
        page: json["page"],
        results: List<MovieModels>.from(
          json["results"].map((x) => MovieModels.fromMap(x)),
        ),
        totalPages: json["total_pages"],
        totalResults: json["total_results"],
      );
}

//rango de fechas de las películas en cartelera
class Dates {
  DateTime maximum;
  DateTime minimum;

  Dates({
    required this.maximum,
    required this.minimum,
  });

  factory Dates.fromJson(String str) => Dates.fromMap(json.decode(str)); //recibe json devuelve objeto

  factory Dates.fromMap(Map<String, dynamic> json) => Dates(
        maximum: json["maximum"] == null
            ? DateTime.now()
            : DateTime.parse(json["maximum"]),
        minimum: json["minimum"] == null
            ? DateTime.now()
            : DateTime.parse(json["minimum"]),
      );
}