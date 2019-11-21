import 'dart:io';

import 'package:flutter/material.dart';
import 'package:formvalidation/src/bloc/productos_bloc.dart';
import 'package:formvalidation/src/models/producto_model.dart';
import 'package:formvalidation/src/bloc/provider.dart';
import 'package:formvalidation/src/utils/utils.dart' as utils;
import 'package:image_picker/image_picker.dart';


class ProductoPage extends StatefulWidget {
  @override
  _ProductoPageState createState() => _ProductoPageState();
}

class _ProductoPageState extends State<ProductoPage> {
  final formKey     = GlobalKey<FormState>();
  final scaffolKey  = GlobalKey<ScaffoldState>();

  ProductosBloc productosBloc;
  ProductoModel producto= ProductoModel();
  bool _guardando= false;
  File foto;

  @override
  Widget build(BuildContext context) {
    productosBloc = Provider.productosBloc(context);

    final ProductoModel prodData= ModalRoute.of(context).settings.arguments;
    if(prodData != null){
      producto = prodData;
    }

    return Container(
      child: Scaffold(
        key: scaffolKey,
        appBar: AppBar(
          title: Text('Producto'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.photo_size_select_actual), 
              onPressed: _seleccionarFoto,
            ),
            IconButton(
              icon: Icon(Icons.camera_alt), 
              onPressed: _tomarFoto,
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(15.0),
            child: Form(
              key: formKey,
              child: Column(
                children: <Widget>[
                  _mostrarFoto(),
                  _crearNombre(),
                  _crearPrecio(),
                  _crearDisponible(),
                  _crearBoton()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _crearNombre() {
    return TextFormField(
      initialValue: producto.titulo,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        labelText: 'Producto'
      ),
      onSaved: (value){
        producto.titulo= value;
      },
      validator: (value) {
        if(value.length<3){
          return 'Ingrese el nombre del producto';
        }else return null;
      },
    );
  }

  Widget _crearPrecio() {
    return TextFormField(
      initialValue: producto.valor.toString(),
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        labelText: 'Precio'
      ),
      onSaved: (value){
        producto.valor= double.parse(value);
      },
      validator: (value) {
        if(utils.isNumeric(value)){
           return null; 
        } else
        return 'Sólo números';
      },
    );
  }

  Widget _crearBoton() {
    return RaisedButton.icon(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0)
      ),
      color: Colors.deepPurple,
      textColor: Colors.white,
      label: Text('Guardar'),
      icon: Icon(Icons.save),
      onPressed: (_guardando) ? null : _submit,
    );
  }

  void _submit() async {
    if(!formKey.currentState.validate()) return;

    setState(() {
     _guardando= true; 
    });

    formKey.currentState.save();
    print('todo ok');
    print(producto.titulo);
    print(producto.valor);
    print(producto.disponible);

    if(foto!= null){
      producto.fotoUrl= await  productosBloc.subirFoto(foto);
    }

    if( producto.id == null){
      productosBloc.agregarProducto(producto);
      
    }else
      productosBloc.editarProducto(producto);

    mostrarSnackBar('Registro guardado');
    setState(() {
     _guardando= false; 
    });
    Navigator.pop(context);
  }

  void mostrarSnackBar(String mensaje, ){
    final snackBar= SnackBar(
      content: Text(mensaje),
      duration: Duration(milliseconds: 1500),
    );

    scaffolKey.currentState.showSnackBar(snackBar);

  }

  Widget _crearDisponible() {
    return SwitchListTile(
      value: producto.disponible,
      title: Text('Disponible'),
      activeColor: Colors.deepPurple,
      onChanged: (value) => setState((){
        producto.disponible = value;
      }),
    );
  }

  Widget _mostrarFoto(){
    if(producto.fotoUrl != null ){
      return FadeInImage(
              image: NetworkImage(producto.fotoUrl),
              placeholder: AssetImage('assets/jar-loading.gif'), 
              height: 300.0,
              width: double.infinity,
              fit: BoxFit.contain);
    }else{
      return Image(
        image: AssetImage(foto?.path ?? 'assets/no-image.png'),
        height: 300.0,
        fit: BoxFit.cover,
      );
    }
  }


  void _seleccionarFoto() async {
    _procesarImage(ImageSource.gallery);
  }

  void _tomarFoto() async {
    _procesarImage(ImageSource.camera);
  }

  _procesarImage(ImageSource origen) async {
     foto= await ImagePicker.pickImage(
      source: origen,
    );
    if(foto != null){
      producto.fotoUrl=null;
    }
    setState(() {});
  }
}