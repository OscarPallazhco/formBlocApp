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

      print(decodedData);
      return true;
    } catch (e) {
      print('error en createProduct');
      print(e);
      return false;
    }
  }
  
}