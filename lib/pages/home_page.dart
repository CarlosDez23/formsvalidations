import 'package:flutter/material.dart';
import 'package:formsvalidations/blocs/provider.dart';
import 'package:formsvalidations/models/product_model.dart';
import 'package:formsvalidations/providers/productos_provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final productosProvider = new ProductosProvider();

  @override
  Widget build(BuildContext context) {
    
    final productosBloc = Provider.productosBlocOf(context);
    productosBloc.cargarProductos();

    return Scaffold(
      appBar: AppBar(
        title: Text('Home page'),
      ),
      body: _createProductList(productosBloc),
      floatingActionButton: _createFab(context),
    );
  }

  Widget _createProductList(ProductosBloc bloc) {
    //Con bloc 
    return StreamBuilder(
      stream: bloc.productosStream ,
      builder: (BuildContext context, AsyncSnapshot<List<Producto>> snapshot){
        if (snapshot.hasData) {
          final productos = snapshot.data;
          return ListView.builder(
            itemCount: productos.length,
            itemBuilder: (context, index) =>
                _createListItem(context, productos[index],bloc),
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      }
    );
    //Sin bloc
    // return FutureBuilder(
    //   future: productosProvider.listProducts(),
    //   builder: (BuildContext context, AsyncSnapshot<List<Producto>> snapshot) {
    //     if (snapshot.hasData) {
    //       final productos = snapshot.data;
    //       return ListView.builder(
    //         itemCount: productos.length,
    //         itemBuilder: (context, index) =>
    //             _createListItem(context, productos[index]),
    //       );
    //     } else {
    //       return Center(
    //         child: CircularProgressIndicator(),
    //       );
    //     }
    //   },
    // );
  }

  Widget _createListItem(BuildContext context, Producto producto, ProductosBloc bloc) {
    return Dismissible(
        key: UniqueKey(),
        background: Container(
          color: Colors.red,
        ),
        onDismissed: (direction) {
          //Sin bloc
          // productosProvider.deleteProduct(producto.id);
          //Con bloc
          bloc.borrarProducto(producto.id);
        },
        child: Card(
          child: Column(
            children: <Widget>[
              (producto.fotoUrl == null)
                ? Image(image: AssetImage('assets/img/no-image.png'))
                : FadeInImage(
                placeholder: AssetImage('assets/img/loading.gif'),
                image: NetworkImage(producto.fotoUrl)
              ),
              ListTile(
                title: Text('${producto.nombre} - ${producto.precio} euros'),
                subtitle: Text('${producto.id}'),
                onTap: () =>
                  Navigator.pushNamed(context, 'product', arguments: producto)
                      .then((value) {
                  setState(() {});
                  }),
              ),
            ],
          )
        )
      );
  }

  Widget _createFab(BuildContext context) {
    return FloatingActionButton(
      child: Icon(Icons.add),
      backgroundColor: Colors.deepPurple,
      onPressed: () => Navigator.pushNamed(context, 'product').then((value) {
        setState(() {});
      }),
    );
  }
}
