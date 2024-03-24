//import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:programovil/model/popular_model.dart';
import 'package:programovil/model/video_model.dart';

class ApiPopular {
  final URL =
      "https://api.themoviedb.org/3/movie/popular?api_key=73c295392359efe7df0a34433173fd7e&language=es-MX&page=1";
  final dio = Dio();
  Future<List<PopularModel>?> getPopularMovie() async {
    Response response = await dio.get(URL);
    if (response.statusCode == 200) {
      //print(response.data['results'].runtimeType);
      final listMoviesMap = response.data['results'] as List;
      return listMoviesMap.map((movie) => PopularModel.fromMap(movie)).toList();
    }
    return null;
  }
}

class ApiCast {
  final URL = "https://api.themoviedb.org/3/movie/";
  final api_key = "/credits?api_key=73c295392359efe7df0a34433173fd7e";
  final dio = Dio();
  Future<List<Cast>?> getCast(String endpoint) async {
    var consultUrl = URL + endpoint + api_key;
    Response response = await dio.get(consultUrl);
    if (response.statusCode == 200) {
      final List<dynamic> castData = response.data['cast'];
      final List<dynamic> actingCastData = castData
          .where((cast) => cast['known_for_department'] == 'Acting')
          .toList();
      return actingCastData.map((cast) => Cast.fromMap(cast)).toList();
    }
    return null;
  }
}

class ApiVideo {
  final URL = "https://api.themoviedb.org/3/movie/";
  final api_key = "/videos?api_key=73c295392359efe7df0a34433173fd7e";
  final dio = Dio();
  Future<List<VideoModel>?> getTrailer(String endpoint) async {
    var consultUrl = URL + endpoint + api_key;
    Response response = await dio.get(consultUrl);
    if (response.statusCode == 200) {
      //print(response.data['results'].runtimeType);
      final listTrailer = response.data['results'] as List;
      return listTrailer.map((trailer) => VideoModel.fromMap(trailer)).toList();
    }
    return null;
  }
}

class ApiMovieDetail {
  final URL = "https://api.themoviedb.org/3/movie/";
  final api_key = "?api_key=73c295392359efe7df0a34433173fd7e";
  final dio = Dio();

  Future<Map<String, dynamic>?> getMovieDetail(String endpoint) async {
    var consultUrl = URL + endpoint + api_key;
    Response response = await dio.get(consultUrl);
    if (response.statusCode == 200) {
      return response.data as Map<String, dynamic>;
    }
    return null;
  }
}

class ApiGetFav {
  final URL =
      "https://api.themoviedb.org/3/account/21061255/favorite/movies?api_key=73c295392359efe7df0a34433173fd7e&session_id=7830065d6e3615770524764247134c0ebd0e257f";
  final dio = Dio();
  Future<List<PopularModel>?> getFavMovie() async {
    var consultUrl = URL;
    Response response = await dio.get(consultUrl);
    if (response.statusCode == 200) {
      //print(response.data['results'].runtimeType);
      final listMoviesMap = response.data['results'] as List;
      return listMoviesMap.map((movie) => PopularModel.fromMap(movie)).toList();
    }
    return null;
  }
}

class ApiAddFav {
  final URL =
      "https://api.themoviedb.org/3/account/21061255/favorite?api_key=73c295392359efe7df0a34433173fd7e&session_id=7830065d6e3615770524764247134c0ebd0e257f";
  final dio = Dio();

  Future<void> postFavMovie(int mediaId) async {
    try {
      final String postUrl = URL;
      Map<String, dynamic> body = {
        "media_type": "movie",
        "media_id": mediaId,
        "favorite": true
      };
      Response response = await dio.post(postUrl, data: body);
      if (response.statusCode == 200) {
        print('Película marcada como favorita exitosamente.');
      } else {
        print(
            'Error al marcar la película como favorita. Código de estado: ${response.statusCode}');
      }
    } catch (e) {
      print('Error en la solicitud POST: $e');
    }
  }
}

class ApiDeleteFav {
  final URL =
      "https://api.themoviedb.org/3/account/21061255/favorite?api_key=73c295392359efe7df0a34433173fd7e&session_id=7830065d6e3615770524764247134c0ebd0e257f";
  final dio = Dio();

  Future<void> deleteFavMovie(int mediaId) async {
    try {
      final String postUrl = URL;
      Map<String, dynamic> body = {
        "media_type": "movie",
        "media_id": mediaId,
        "favorite": false
      };
      Response response = await dio.post(postUrl, data: body);
      if (response.statusCode == 200) {
        print('Película eliminada como favorita exitosamente.');
      } else {
        print(
            'Error al marcar la película como favorita. Código de estado: ${response.statusCode}');
      }
    } catch (e) {
      print('Error en la solicitud POST: $e');
    }
  }
}
