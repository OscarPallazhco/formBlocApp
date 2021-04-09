import 'package:flutter/material.dart';

class ProductPage extends StatelessWidget {
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
    );
  }

  Widget _priceImputField(){
    return TextFormField(
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: 'Precio'
      ),
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
      onPressed: (){},
    );
  }


}