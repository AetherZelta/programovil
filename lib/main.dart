import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:programovil/screens/dashboard_screen.dart';
import 'package:programovil/screens/despensa_screen.dart';
import 'package:programovil/screens/detail_movie_screen.dart';
import 'package:programovil/screens/favorites_movie_screen.dart';
import 'package:programovil/screens/popular_movies_screen.dart';
import 'package:programovil/screens/products_firebase_screen.dart';
import 'package:programovil/screens/splash_screen.dart';
import 'package:programovil/settings/app_value_notifier.dart';
import 'package:programovil/settings/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey:
          "AIzaSyDG2e4nLEPLACUsxQlw6ifJzwcknh8Hnjw", // paste your api key here
      appId: "com.example.programovil", //paste your app id here
      messagingSenderId: "1074601179743", //paste your messagingSenderId here
      projectId: "programovil-45152",
    ), //paste your project id here
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: AppValueNotifier.banTheme,
        builder: (context, value, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: value
                ? ThemeApp.darkTheme(context)
                : ThemeApp.lightTheme(context),
            home: SplashScreen(),
            routes: {
              "/dash": (BuildContext context) => const DashboardScreen(),
              "/despensa": (BuildContext context) => const DespensaScreen(),
              "/productos": (BuildContext context) =>
                  const ProductsFirebaseStream(),
              "/movies": (BuildContext context) => const PopularMoviesScreen(),
              "/detail": (BuildContext context) => const DetailMovieScreen(),
              "/favorites": (BuildContext context) =>
                  const FavoriteMovieScreen(),
            },
          );
        });
  }
}

/*class MyApp extends StatefulWidget {
   MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int contador = 0;

  @override
  Widget build(BuildContext context) {
    
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Práctica 1', 
            style: TextStyle(
              fontSize: 30, 
              fontWeight: FontWeight.bold),
            ),
        ),
        drawer: Drawer(),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.red,
          onPressed: (){
            contador++;
            print(contador);
            setState(() {});
          },
          child: Icon(Icons.ads_click),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Image.network('https://celaya.tecnm.mx/wp-content/uploads/2021/02/cropped-FAV.png', 
              height: 250,),
            ),
            Text('Valor del Contador $contador')
          ],
        )
      ),
    );
  }
}*/