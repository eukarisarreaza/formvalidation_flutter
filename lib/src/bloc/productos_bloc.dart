


import 'dart:io';

import 'package:formvalidation/src/models/producto_model.dart';
import 'package:formvalidation/src/provider/productos_provider.dart';
import 'package:rxdart/rxdart.dart';

class ProductosBloc{
  final _productosController = BehaviorSubject<List<ProductoModel>>();
  final _cargandoController = BehaviorSubject<bool>();

  final _productosProvider= new ProductosProvider();


  Stream<List<ProductoModel>> get productoStream => _productosController.stream;
  Stream<bool> get cargandoStream => _cargandoController.stream;


  void cargarProductos() async {
    final productos= await _productosProvider.obtenerProductos();
    _productosController.sink.add(productos);

  }

  void agregarProducto( ProductoModel productoModel) async {
    _cargandoController.sink.add(true);
    await _productosProvider.crearProducto(productoModel);
    _cargandoController.sink.add(false);
  }


  void editarProducto( ProductoModel productoModel) async {
    _cargandoController.sink.add(true);
    await _productosProvider.editarProducto(productoModel);
    _cargandoController.sink.add(false);
  }

  void borrarProducto( String id) async {
    await _productosProvider.borrarProducto(id);
  }

  Future<String> subirFoto(File file) async {
    _cargandoController.sink.add(true);
    final foto= await _productosProvider.subirImagen(file);
    _cargandoController.sink.add(false);
    return foto;
  }

  
  dispose(){
    _productosController?.close();
    _cargandoController?.close();
  }
}