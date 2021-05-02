import 'package:flutter/material.dart';

import 'package:formbloc_app/pages/home_page.dart';
import 'package:formbloc_app/pages/loading_page.dart';
import 'package:formbloc_app/pages/login_page.dart';
import 'package:formbloc_app/pages/product_page.dart';
import 'package:formbloc_app/pages/register_page.dart';
 
final Map<String, Widget Function(BuildContext) > routes = {
  'home_page'    : (_) => HomePage(),
  'login_page'   : (_) => LoginPage(),
  'product_page' : (_) => ProductPage(),
  'register_page': (_) => RegisterPage(),
  'loading_page' : (_) => LoadingPage(),
};