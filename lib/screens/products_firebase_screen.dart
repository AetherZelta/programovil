import 'package:flutter/material.dart';
import 'package:programovil/services/products_firebase.dart';

class ProductsFirebaseStream extends StatefulWidget {
  const ProductsFirebaseStream({super.key});

  @override
  State<ProductsFirebaseStream> createState() => _ProductsFirebaseState();
}

class _ProductsFirebaseState extends State<ProductsFirebaseStream> {
  final productsFirebase = ProductsFirebase();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hola'),
      ),
      body: StreamBuilder(
        stream: productsFirebase.consultar(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                return Image.network(snapshot.data!.docs[index].get('imagen'));
              },
            );
          } else {
            if (snapshot.hasError) {
              return Text('Error');
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          }
        },
      ),
    );
  }
}
