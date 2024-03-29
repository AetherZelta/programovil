import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:programovil/model/popular_model.dart';
import 'package:programovil/network/api_popular.dart';

class PopularMoviesScreen extends StatefulWidget {
  const PopularMoviesScreen({super.key});

  @override
  State<PopularMoviesScreen> createState() => _PopularMoviesScreenState();
}

class _PopularMoviesScreenState extends State<PopularMoviesScreen> {
  ApiPopular? apiPopular;

  @override
  void initState() {
    super.initState();
    apiPopular = ApiPopular();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Peliculas Populares'),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.pushNamed(context, '/favorites');
              },
              icon: Icon(Icons.favorite),
            )
          ],
        ),
        body: FutureBuilder(
          future: apiPopular!.getPopularMovie(),
          builder: (context, AsyncSnapshot<List<PopularModel>?> snapshot) {
            if (snapshot.hasData) {
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
          },
        ));
  }
}
