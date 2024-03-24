//import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:programovil/model/popular_model.dart';
import 'package:programovil/model/video_model.dart';
import 'package:programovil/network/api_popular.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class DetailMovieScreen extends StatefulWidget {
  const DetailMovieScreen({super.key});

  @override
  State<DetailMovieScreen> createState() => _DetailMovieScreenState();
}

class _DetailMovieScreenState extends State<DetailMovieScreen> {
  bool isFavorite = false;
  bool isVideoPlayerOpen = false;

  late YoutubePlayerController _controller;
  List<VideoModel>? videoModel;
  late PopularModel popularModel;
  get snapshot => null;

  @override
  void initState() {
    super.initState();
    _loadFavoriteStatus();
    _controller = YoutubePlayerController(
      initialVideoId: '',
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
      ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadFavoriteStatus();
  }

  Future<void> _loadFavoriteStatus() async {
    popularModel = ModalRoute.of(context)!.settings.arguments as PopularModel;
    if (popularModel != null) {
      final String _favoriteKey = 'favorite_${popularModel.id}';
      final prefs = await SharedPreferences.getInstance();
      setState(() {
        isFavorite = prefs.getBool(_favoriteKey) ?? false;
      });
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();
    super.dispose();
  }

  void openVideoPlayer(String videoKey) {
    setState(() {
      isVideoPlayerOpen = true;
      _controller = YoutubePlayerController(
          initialVideoId: videoKey,
          flags: const YoutubePlayerFlags(
            autoPlay: true,
            mute: false,
          ));
    });
  }

  void closeVideoPlayer() {
    setState(() {
      isVideoPlayerOpen = false;
    });
  }

  Future<void> addFavorite(int movieId) async {
    try {
      await ApiAddFav().postFavMovie(movieId);
    } catch (e) {
      print('Error al marcar como favorita: $e');
    }
  }

  Future<void> removeFavorite(int movieId) async {
    try {
      await ApiDeleteFav().deleteFavMovie(movieId);
    } catch (e) {
      print('Error al eliminar como favorita: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    /*final popularModel =
        ModalRoute.of(context)!.settings.arguments as PopularModel;*/

    final String _favoriteKey = 'favorite_${popularModel.id}';

    return Scaffold(
      body: Stack(
        children: [
          Opacity(
            opacity: 0.5,
            child: CachedNetworkImage(
              imageUrl:
                  'https://image.tmdb.org/t/p/w500${popularModel.posterPath}',
              height: double.infinity,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          SingleChildScrollView(
            child: SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 25),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            isFavorite ? Icons.favorite : Icons.favorite_border,
                            color: Colors.white,
                            size: 30,
                          ),
                          onPressed: () async {
                            setState(() {
                              isFavorite = !isFavorite;
                            });
                            final prefs = await SharedPreferences.getInstance();
                            await prefs.setBool(_favoriteKey, isFavorite);
                            if (popularModel.id != null) {
                              if (isFavorite) {
                                await addFavorite(popularModel.id!);
                              } else {
                                await removeFavorite(popularModel.id!);
                              }
                            }
                          },
                        ),
                        /*InkWell(
                          onTap: () {},
                          child: const Icon(
                            Icons.favorite_border,
                            color: Colors.white,
                            size: 30,
                          ),
                        )*/
                      ],
                    ),
                  ),
                  SizedBox(height: 60),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Hero(
                          tag: 'poster_${popularModel.id}',
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.5),
                                    spreadRadius: 1,
                                    blurRadius: 8,
                                  )
                                ]),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: CachedNetworkImage(
                                imageUrl:
                                    'https://image.tmdb.org/t/p/w500${popularModel.posterPath}',
                                height: 250,
                                width: 180,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 120, right: 10),
                          height: 80,
                          width: 80,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(40),
                            color: Colors.blue,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.blue.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 8,
                              )
                            ],
                          ),
                          child: FutureBuilder<List<VideoModel>?>(
                              future:
                                  ApiVideo().getTrailer("${popularModel.id}"),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  videoModel = snapshot.data;
                                  //videoModel = snapshot.data as VideoModel?;
                                  return InkWell(
                                    onTap: () {
                                      //String? trailerKey =
                                      String? trailerKey = videoModel!
                                          .firstWhere(
                                            (video) =>
                                                video.site == 'YouTube' &&
                                                video.type == 'Trailer',
                                            orElse: () => videoModel!.first,
                                          )
                                          .key;
                                      if (trailerKey != null) {
                                        openVideoPlayer(trailerKey);
                                      }
                                    },
                                    child: Icon(
                                      Icons.play_arrow,
                                      color: Colors.white,
                                      size: 60,
                                    ),
                                  );
                                } else if (snapshot.hasError) {
                                  return Icon(
                                    Icons.error,
                                    color: Colors.white,
                                    size: 60,
                                  );
                                }
                                return CircularProgressIndicator();
                              }),
                          /*child: Icon(
                            Icons.play_arrow,
                            color: Colors.white,
                            size: 60,
                          ),*/
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Rating',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '${(popularModel.voteAverage)?.toStringAsFixed(1)}/10',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                            Text('${popularModel.releaseDate}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ))
                          ],
                        ),
                        SizedBox(height: 10),
                        FutureBuilder<Map<String, dynamic>?>(
                            future: ApiMovieDetail()
                                .getMovieDetail("${popularModel.id}"),
                            builder: (context,
                                AsyncSnapshot<Map<String, dynamic>?> snapshot) {
                              if (snapshot.hasData) {
                                final Map<String, dynamic>? data =
                                    snapshot.data;
                                final List<dynamic>? genres = data?['genres'];
                                return SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: genres?.map((genre) {
                                          return Padding(
                                            padding: const EdgeInsets.only(
                                                right: 8.0),
                                            child: Chip(
                                              label: Text(
                                                genre?['name'] ?? '',
                                                style: const TextStyle(
                                                    color: Colors.white),
                                              ),
                                              backgroundColor:
                                                  Colors.transparent,
                                              elevation: 0,
                                            ),
                                          );
                                        }).toList() ??
                                        [],
                                  ),
                                  /*child: ListView.builder(
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    itemCount: genres?.length ?? 0,
                                    itemBuilder: (context, index) {
                                      final genre = genres?[index];
                                      return ListTile(
                                        title: Text(
                                          genre?['name'] ?? '',
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.white,
                                          ),
                                        ),
                                      );
                                    },
                                  ),*/
                                );
                              } else if (snapshot.hasError) {
                                return const Center(
                                  child: Text("Ocurrio un error :"),
                                );
                              }
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            }),
                        SizedBox(height: 10),
                        Text(
                          popularModel.title.toString(),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 15),
                        Text(
                          popularModel.overview.toString(),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Cast',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                        SizedBox(height: 5),
                        FutureBuilder(
                          future: ApiCast().getCast("${popularModel.id}"),
                          builder:
                              (context, AsyncSnapshot<List<Cast>?> snapshot) {
                            if (snapshot.hasData) {
                              return Container(
                                height: 200,
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  itemCount: snapshot.data!.length,
                                  itemBuilder: (context, index) {
                                    return Container(
                                      height: 180,
                                      width: 110,
                                      child: Card(
                                        color: Colors.transparent,
                                        elevation: 1,
                                        margin: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 10,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(8),
                                          ),
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Expanded(
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.vertical(
                                                  top: Radius.circular(8.0),
                                                ),
                                                child: CachedNetworkImage(
                                                  //height: 120,
                                                  //width: 100,
                                                  imageUrl:
                                                      "https://image.tmdb.org/t/p/w500/${snapshot.data![index].profilePath}",
                                                  fit: BoxFit.fitWidth,
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 7),
                                              child: Text(
                                                snapshot
                                                    .data![index].originalName
                                                    .toString(),
                                                overflow: TextOverflow.fade,
                                                maxLines: 1,
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  left: 6, bottom: 2),
                                              child: Text(
                                                snapshot.data![index].character
                                                    .toString(),
                                                overflow: TextOverflow.fade,
                                                maxLines: 1,
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
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
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          if (isVideoPlayerOpen)
            GestureDetector(
              onTap: closeVideoPlayer,
              child: Container(
                color: Colors.black.withOpacity(0.8),
                child: Center(
                  child: YoutubePlayer(
                    controller: _controller,
                    showVideoProgressIndicator: true,
                    onReady: () {
                      print('Reproductor Listo');
                    },
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
