import 'package:flutter/material.dart';
import 'package:formbloc_app/pages/home_page.dart';
 
final Map<String, Widget Function(BuildContext) > routes = {
  'home_page': (_) => HomePage(),
};