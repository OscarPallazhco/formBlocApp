import 'package:flutter/material.dart';

import 'package:formbloc_app/utils/utils.dart' as utils;

class ProductPage extends StatefulWidget {

  // StatefulWidget para que funcione mejora la retroalimentación del Form

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  final formKey = GlobalKey<FormState>(); 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
    );
  }

  Widget _priceImputField(){
    return TextFormField(
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
      onPressed: _submit,
    );
  }

  _submit(){
    if (!formKey.currentState.validate()) return null;

  }
}