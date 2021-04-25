import 'package:flutter/material.dart';
import 'package:formbloc_app/bloc/provider.dart';
import 'package:formbloc_app/models/product_model.dart';
import 'package:formbloc_app/providers/products_provider.dart';

class HomePage extends StatefulWidget {

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final productsProvider = new ProductsProvider();

  @override
  Widget build(BuildContext context) {
    final loginBloc = Provider.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile Page'),
        centerTitle: true,
      ),
      body: showProducts(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Colors.deepPurple,
        onPressed: () {
          Navigator.pushNamed(context, 'product_page').then((value) => setState((){}));
        },
      ),
    );
  }

  showProducts() {
    return FutureBuilder(
      future: productsProvider.getProducts(),
      builder: (BuildContext context, AsyncSnapshot<List<ProductModel>> snapshot) {
        if (snapshot.hasData) {
          List<ProductModel> products = snapshot.data;
          if (products.length == 0) {
            return Center(child: Text('No hay productos disponibles'),);
          }
          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (BuildContext context, int index) {
              final product = products[index];
              print(product.title);
              return Dismissible(
                key: Key(product.id),
                background: Container(color: Colors.purple[100],),
                onDismissed: (DismissDirection direction) async{
                  await productsProvider.deleteProduct(product.id);
                },
                child: ListTile(
                  title: Text(product.title),
                  subtitle: Text('\$${product.value}'),
                  leading: Icon(
                    Icons.check_circle,
                    color: product.available ? Colors.deepPurple: Colors.grey,
                  ),
                  onTap: (){
                    Navigator.pushNamed(context, 'product_page', arguments: product).then((value) => setState((){}));
                  },
                ),
              );
            },
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}