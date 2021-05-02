import 'dart:io';

import 'package:formbloc_app/user_preferences/user_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'dart:convert';
import 'package:formbloc_app/models/product_model.dart';
import 'package:formbloc_app/global/environments.dart';
import 'package:mime_type/mime_type.dart';

class ProductsProvider {

  final String databaseUrl  = Environments.databaseUrl;
  final String uploadPreset = Environments.uploadPreset;
  final String cloudName    = Environments.cloudName;
  final _userPreferences     = new UserPreferences();

  Future<bool> createProduct(ProductModel product) async{
    try {
      final String productsUrl = '$databaseUrl/products.json?auth=${_userPreferences.token}';
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
      final String productsUrl = '$databaseUrl/products.json?auth=${_userPreferences.token}';
      final url = Uri.parse(productsUrl);
      final resp = await http.get(url);

      final Map<String, dynamic> decodedData = json.decode(resp.body);
      // print(decodedData);
      if (decodedData == null ) return [];
      if (decodedData['error'] != null ) return [];
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

  Future<int> deleteProduct(String id) async{
    try {
      final String productUrl = '$databaseUrl/products/$id.json?auth=${_userPreferences.token}';
      final url = Uri.parse(productUrl);
      final resp = await http.delete(url);
      print(resp);
      print(resp.body);
      return 1;
    } catch (e) {
      print('error en deleteProduct');
      print(e);
      return 0;
    }
  }

  Future<bool> updateProduct(ProductModel product) async{
    try {
      final String productUrl = '$databaseUrl/products/${product.id}.json?auth=${_userPreferences.token}';
      final url = Uri.parse(productUrl);
      final resp = await http.put(url, body: productModelToJson(product));
      final decodedData = json.decode(resp.body);
      print(decodedData);
      return true;
    } catch (e) {
      print('error en updateProduct');
      print(e);
      return false;
    }
  }

  Future<String> uploadImage(File image) async{
    try {
      if (image.existsSync()) {
        final url = Uri.parse('https://api.cloudinary.com/v1_1/$cloudName/image/upload?upload_preset=$uploadPreset');
        final mimeType = mime(image.path).split('/');// ['image','jpg']
        final request = http.MultipartRequest('POST', url);
        final file = await http.MultipartFile.fromPath(
          'file',
          image.path,
          contentType: MediaType(mimeType[0], mimeType[1])
        );
        request.files.add(file);
        final streamedResponse = await request.send();
        final resp = await http.Response.fromStream(streamedResponse);
        if (!(resp.statusCode == 200 || resp.statusCode == 201 )) {
          print('error en uploadImage');
          print(resp.body);
          return null;
        }
        final decodedData = json.decode(resp.body);
        print(decodedData);
        return decodedData['secure_url'];

      } else {
        print('error en uploadImage');
        print('Archivo no existe');
        return null;
      }
    } catch (e) {
      print('error en uploadImage');
      print(e);
      return null;
    }
  }
  
}