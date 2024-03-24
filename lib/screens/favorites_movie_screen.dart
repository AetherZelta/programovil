import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:programovil/model/popular_model.dart';
import 'package:programovil/network/api_popular.dart';

class FavoriteMovieScreen extends StatefulWidget {
  const FavoriteMovieScreen({super.key});

  @override
  State<FavoriteMovieScreen> createState() => _FavoriteMovieScreenState();
}

class _FavoriteMovieScreenState extends State<FavoriteMovieScreen> {
  ApiGetFav? apiGetFav;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    apiGetFav = ApiGetFav();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Peliculas Favoritas'),
        /*actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.favorite),
          )
        ],*/
      ),
      body: FutureBuilder(
          future: apiGetFav!.getFavMovie(),
          builder: (context, AsyncSnapshot<List<PopularModel>?> snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data?.length == 0) {
                return const Center(
                  child: Text('No tienes peliculas favoritas'),
                );
              }
              return GridView.builder(
                itemCount: snapshot.data!.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: .7,
                  mainAxisSpacing: 10,
                ),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () => Navigator.pushNamed(context, "/detail",
                        arguments: snapshot.data![index]),
                    child: Hero(
                      tag: 'poster_${snapshot.data![index].id}',
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: FadeInImage(
                          placeholder: const AssetImage('images/loading.gif'),
                          image: CachedNetworkImageProvider(
                              "https://image.tmdb.org/t/p/w500/${snapshot.data![index].posterPath}"),
                          /*image: NetworkImage(
                          "https://image.tmdb.org/t/p/w500/${snapshot.data![index].posterPath}"),*/
                        ),
                      ),
                    ),
                  );
                },
              );
            } else {
              if (snapshot.hasError) {
                return const Center(
                  child: Text("Ocurrio un error :"),
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            }
          }),
    );
  }
}
