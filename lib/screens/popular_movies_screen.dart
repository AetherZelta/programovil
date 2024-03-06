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
        body: FutureBuilder(
      future: apiPopular!.getPopularMovie(),
      builder: (context, AsyncSnapshot<List<PopularModel>?> snapshot) {
        if (snapshot.hasData) {
          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
            ),
            itemBuilder: (context, index) {
              return Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: NetworkImage(
                            "https://image.tmdb.org/t/p/w500/${snapshot.data![index].posterPath}"))),
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