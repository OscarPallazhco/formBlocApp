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
        title: Text('Products'),
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
              return Dismissible(
                key: Key(product.id),
                background: Container(color: Colors.purple[100],),
                onDismissed: (DismissDirection direction) async{
                  await productsProvider.deleteProduct(product.id);
                },
                child: GestureDetector(
                  onTap: (){
                    Navigator.pushNamed(context, 'product_page', arguments: product).then((value) => setState((){}));
                    // paso de argumentos en el navigator
                  },
                  child: Card(
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
                  ),
                )
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