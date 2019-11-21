import 'package:flutter/material.dart';
import 'package:formvalidation/src/bloc/productos_bloc.dart';
import 'package:formvalidation/src/bloc/provider.dart';
import 'package:formvalidation/src/models/producto_model.dart';


class HomePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    final productosBloc= Provider.productosBloc(context);
    productosBloc.cargarProductos();

    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      body: _crearListado(productosBloc),
      floatingActionButton: _crearBoton(context),
    );
  }

  Widget _crearListado(ProductosBloc bloc){
    return  StreamBuilder(
      stream: bloc.productoStream,

      builder: (BuildContext context, AsyncSnapshot<List<ProductoModel>> snapshot) {
        if( snapshot.hasData ){
          final productos= snapshot.data;

          return ListView.builder(
            itemBuilder: (BuildContext context, int index) => _crearItem(context, productos[index], bloc),
            itemCount: productos.length,
          );
        }else{
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Widget _crearItem(BuildContext context, ProductoModel producto, ProductosBloc bloc){
    return Dismissible(
      key: UniqueKey(),
      background: Container(
        color: Colors.red,
      ),
      onDismissed: (direccion){
        //productosProvider.borrarProducto(producto.id);
        bloc.borrarProducto(producto.id);
      },
      child: Container(
        padding: EdgeInsets.all(5.0),
        child: Column(
          children: <Widget>[
            (producto.fotoUrl == null) 
            ? Image( image: AssetImage('assets/no-image.png'))
            : FadeInImage(
              image: NetworkImage(producto.fotoUrl),
              placeholder: AssetImage('assets/jar-loading.gif'), 
              height: 300.0,
              width: double.infinity,
              fit: BoxFit.cover),

              ListTile(
                title: Text('${producto.titulo} - ${producto.valor}'),
                subtitle: Text(producto.id),
                onTap: () => Navigator.pushNamed(context, 'producto', arguments: producto),
              )



          ],
        ),
      ),
    );
  }
/*

*/
  FloatingActionButton _crearBoton(BuildContext context) {
    return FloatingActionButton(
      child: Icon(Icons.add), 
      backgroundColor: Colors.deepPurple,
      onPressed: () => Navigator.pushNamed(context, 'producto'),
    );


  }
}