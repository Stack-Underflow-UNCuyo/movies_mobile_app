import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:mobile_app_flutter/features/peliculas/data/models/movie_models.dart';
import 'package:mobile_app_flutter/features/peliculas/data/models/now_playing.dart';

/*
Usa el patrón Provider para manejar el estado.
MovieProvider guarda datos
ChangeNotifier permite avisar a la UI cuando algo cambia
*/
class MovieProvider extends ChangeNotifier {
  final String apiKey = "596cddc04350e3dce34625288079c32f";
  final String baseUrl = "api.themoviedb.org";
  final String language = "es-ES";

  List<MovieModels> onDisplayMovies = [];
  List<MovieModels> popularMovies = [];
  List<MovieModels> topRatedMovies = [];
  List<MovieModels> upcomingMovies = [];

  /*
  arma la URL
  hace la petición HTTP
  devuelve el JSON
  */
  Future<String> _getJsonData(String endpoint, [int page = 1]) async {
    final url = Uri.https(baseUrl, '/3$endpoint', {
      'api_key': apiKey,
      'language': language,
      'page': "$page",
    });

    final response = await get(url);
    print(response.statusCode);
    print(response.body);
    return response.body;
  }

  //control en la UI
  bool isLoading = false;
  
  /*
    Future representa un valor que todavía no existe, pero va a existir en el futuro.
    async / await:
      Son la forma de esperar a que un Future termine sin congelar la app.
   */
  Future<void> getOnDisplayMovies() async { //async = "esta función tiene esperas"
    try {
      isLoading = true;
      print("Iniciando petición a la API..."); 
    
      final jsonData = await _getJsonData('/movie/now_playing'); // await = "esperá aca hasta que llegue"
      final nowPlayingResponse = NowPlayingResponse.fromJson(jsonData);
      
      // Validamos que la respuesta traiga resultados antes de asignar
      onDisplayMovies = nowPlayingResponse.results;
      print("Películas cargadas: ${onDisplayMovies.length}");
      
    } catch (e) {
      debugPrint("Error en MovieProvider (getOnDisplayMovies): $e");
    } finally {
      isLoading = false;
      notifyListeners(); // Actualiza la UI pase lo que pase
    }
  }
}