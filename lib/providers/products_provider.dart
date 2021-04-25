import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:formbloc_app/models/product_model.dart';
import 'package:formbloc_app/global/environments.dart';

class ProductsProvider {

  final String databaseUrl = Environments.databaseUrl;

  Future<bool> createProduct(ProductModel product) async{
    try {
      final String productsUrl = '$databaseUrl/products.json';
      final url = Uri.parse(productsUrl);
      final resp = await http.post(url, body: productModelToJson(product));

      final decodedData = json.decode(resp.body);

      // print(decodedData);
      return true;
    } catch (e) {
      print('error en createProduct');
      print(e);
      return false;
    }
  }

    Future<List<ProductModel>> getProducts() async{
      try {
        final String productsUrl = '$databaseUrl/products.json';
        final url = Uri.parse(productsUrl);
        final resp = await http.get(url);

        final Map<String, dynamic> decodedData = json.decode(resp.body);
        // print(decodedData);
        if (decodedData == null ) return [];
        List<ProductModel> products = [];
        decodedData.forEach((key, value) {
          ProductModel prodTemp = ProductModel.fromJson(value);
          prodTemp.id = key;
          products.add(prodTemp);
        });
        return products;
      } catch (e) {
        print('error en getProducts');
        print(e);
        return [];
      }
  }
  
}