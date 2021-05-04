import 'package:flutter/material.dart';

import 'package:formbloc_app/models/product_model.dart';
import 'package:formbloc_app/providers/products_provider.dart';
import 'package:formbloc_app/user_preferences/user_preferences.dart';

class HomePage extends StatefulWidget {

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final productsProvider = new ProductsProvider();
  UserPreferences userPreferences = new UserPreferences();
  bool isAdmin = false;

  @override
  Widget build(BuildContext context) {

    final bool isAdminArg = ModalRoute.of(context).settings.arguments;
    // paso de parametro en el navigator
    if (isAdminArg != null) {
      isAdmin = isAdminArg;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Products'),
        centerTitle: true,
        actions: [
          IconButton(icon: Icon(Icons.exit_to_app), onPressed: (){
            userPreferences.logout();
            Navigator.pushReplacementNamed(context, 'login_page');
          })
        ],
      ),
      body: showProducts(),
      floatingActionButton: isAdmin ? buildFloatingActionButton(context) : null,
    );
  }

  FloatingActionButton buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton(
      child: Icon(Icons.add),
      backgroundColor: Colors.deepPurple,
      onPressed: () {
        Navigator.pushNamed(context, 'product_page').then((value) => setState((){}));
      },
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
              if (isAdmin) {
                return Dismissible(
                  key: Key(product.id),
                  background: Container(color: Colors.purple[100],),
                  onDismissed: (DismissDirection direction) async{
                    await productsProvider.deleteProduct(product.id);
                  },
                  child: GestureDetector(
                    onTap: ()=> Navigator.pushNamed(context, 'product_page', arguments: product).then((value) => setState((){})),
                    child: buildCard(product),
                  )
                );
              } else {
                return buildCard(product);
              }
            },
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Card buildCard(ProductModel product) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      elevation: 8,
      shadowColor: Colors.black,
      color: Colors.grey[100],
      child: Column(
        children: [
          product.photoUrl == null 
            ? Image(image: AssetImage('assets/no-image.png'))
            : FadeInImage(
                placeholder: AssetImage('assets/jar-loading.gif'), 
                image: NetworkImage(product.photoUrl),
                height: 300,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
          ListTile(
            title: Text(product.title),
            subtitle: Text('\$${product.value}'),
            leading: Icon(
              Icons.check_circle,
              color: product.available ? Colors.deepPurple: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}