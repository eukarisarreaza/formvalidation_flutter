
import 'dart:convert';
import 'dart:io';

import 'package:formvalidation/src/preferencia_usuario/preferencia_usuario.dart';
import 'package:http/http.dart' as http;
import 'package:formvalidation/src/models/producto_model.dart';
import 'package:mime_type/mime_type.dart';
import 'package:http_parser/http_parser.dart';


class ProductosProvider{
  final String _url= 'https://flutter-varios-984b3.firebaseio.com';
  final pref = PreferenciasUsuario();

  Future<bool> crearProducto(ProductoModel producto) async {
    final url= '$_url/productos.json?auth=${pref.token}';
    final resp= await http.post(url, body: productoModelToJson(producto));
    final decodeData= json.decode(resp.body);

    print(decodeData);

    return false;
  }

  Future<bool> editarProducto(ProductoModel producto) async {

    final url= '$_url/productos/${producto.id}.json?auth=${pref.token}';

    final resp= await http.put(url, body: productoModelToJson(producto));
    final decodeData= json.decode(resp.body);

    print(decodeData);

    return false;
  }

    Future<List<ProductoModel>> obtenerProductos() async {
    final url= '$_url/productos.json?auth=${pref.token}';
    final resp= await http.get(url);
    final Map<String, dynamic> decodeData= json.decode(resp.body);
    final List<ProductoModel> productos= List();

    print(decodeData);

    if(decodeData == null) return [];

    if(decodeData['error'] != null) return [];


    decodeData.forEach((id, prod){
      print(prod);
      final prodTem= ProductoModel.fromJson(prod);
      prodTem.id= id;
      productos.add(prodTem);
    });

    print(productos);

    return productos;
  }


  Future<int> borrarProducto(String id) async {
    final url = '$_url/productos/$id.json?auth=${pref.token}';
    final resp= await http.delete(url);

    print( json.decode(resp.body));

    return 0;
  }

  Future<String> subirImagen(File imagen) async {
    final url= Uri.parse('https://api.cloudinary.com/v1_1/dyuwxljct/image/upload?upload_preset=bp3owfi0');
    final mimeType= mime(imagen.path).split('/');

    final imageUploadRequest= http.MultipartRequest(
      'POST',
      url
    );
    final file= await http.MultipartFile.fromPath(
      'file', 
      imagen.path,
      contentType: MediaType(mimeType[0], mimeType[1])
    );
    
    imageUploadRequest.files.add(file);

    final streamResponse = await imageUploadRequest.send();
    final resp= await http.Response.fromStream(streamResponse);

    if(resp.statusCode != 200 && resp.statusCode != 201){
      print('Algo salió mal');
      print(resp.body);
      return null;
    }

    final respData= json.decode(resp.body);
    return respData['secure_url'];

  }


}