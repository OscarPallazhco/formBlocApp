import 'package:flutter/material.dart';

import 'package:formbloc_app/models/product_model.dart';
import 'package:formbloc_app/providers/products_provider.dart';
import 'package:formbloc_app/utils/utils.dart' as utils;

class ProductPage extends StatefulWidget {

  // StatefulWidget para que funcione mejora la retroalimentación del Form

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final productsProvider = new ProductsProvider();
  ProductModel product = new ProductModel();
  bool _saving = false;

  @override
  Widget build(BuildContext context) {

    final ProductModel productArg = ModalRoute.of(context).settings.arguments;
    // cuando se quiera hacer un put vendrá un producto a través del Navigator 
    if (productArg != null) {
      product = productArg;
    }

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text('Product'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.photo_size_select_actual),
            onPressed: (){}
          ),
          IconButton(
            icon: Icon(Icons.camera_alt_rounded),
            onPressed: (){}
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(15),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                _nameImputField(),
                _priceImputField(),
                _availableSwitchField(),
                _buttonSave(),
              ],
            )
          ),
        ),
      ),
    );
  }

  Widget _nameImputField(){
    return TextFormField(
      initialValue: product.title,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        labelText: 'Producto'
      ),
      validator: (value){
        // si se devuelve un string, significa que es el error,
        // si se devuelve null tncs pasó la validación
        if (value.length < 3) {
          return 'Ingrese el nombre del producto';
        } else {
          return null;
        }
      },
      onSaved: (value){
        // onsaved se ejecuta cuando el validator es exitoso
        product.title = value;
      },
    );
  }

  Widget _priceImputField(){
    return TextFormField(
      initialValue: product.value.toString(),      
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: 'Precio'
      ),
      validator: (value){
        if (!utils.isNumeris(value)) {
          return 'Valor inválido';
        }
        else{
          return null;
        }
      },
      onSaved: (value){
        product.value = double.parse(value);
      },
    );
  }

  _availableSwitchField(){
    return SwitchListTile(
      contentPadding: EdgeInsets.only(left: 0),
      dense: true,            
      value: product.available,
      onChanged: (bool value){
        setState(() {
          product.available = value;
        });
      },
      title: Text('Disponilbe'),
      activeColor: Colors.deepPurple,
      
    );
  }

  Widget _buttonSave(){
    return ElevatedButton.icon(
      icon: Icon(Icons.save),
      label: Text('Guardar', style: TextStyle(color: Colors.white),),
      style: ElevatedButton.styleFrom(
        elevation: 0.0,
        primary: Colors.deepPurple,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20)
        ),
      ),
      onPressed: _saving ? null : _submit,
    );
  }

  _submit() async{
    if (!formKey.currentState.validate()) return null;
    formKey.currentState.save();
    // dispara todos los onsaved de los textformfield dentro del formulario
    
    bool result;
    setState(() {_saving = true;});
    //El botón será usado para crear o para actualizar
    if (product.id == null) {
      result = await productsProvider.createProduct(product);
    } else {
      result = await productsProvider.updateProduct(product);
    }
    setState(() {_saving = false;});
    String msgAction = (product.id == null) ? 'Registro guardado' : 'Registro actualizado';
    String msgResult = result ? msgAction : 'Error al guardar el registro';
    _showSnackbar(msgResult);
    Navigator.pop(context);
  }

  _showSnackbar(String msg){
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        duration: Duration(seconds: 2),        
      )
    );
  }
}