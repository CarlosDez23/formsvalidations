import 'dart:io';

import 'package:formsvalidations/models/product_model.dart';
import 'package:formsvalidations/providers/images_provider.dart';
import 'package:formsvalidations/providers/productos_provider.dart';
import 'package:rxdart/rxdart.dart';


class ProductosBloc {

  final _productosController = new BehaviorSubject<List<Producto>>();
  final _cargandoController = new BehaviorSubject<bool>();

  final _productosProvider = new ProductosProvider();

  Stream<List<Producto>> get productosStream => _productosController.stream;
  Stream<bool> get cargandoStream => _cargandoController.stream;

  void cargarProductos() async{
    final productos = await _productosProvider.listProducts();
    _productosController.sink.add(productos);
  }

  void agregarProducto(Producto producto) async{
    _cargandoController.sink.add(true);
    await _productosProvider.createProducto(producto);
    _cargandoController.sink.add(false);
  }

  Future<String> subirFoto(File image, String productId) async{
    _cargandoController.sink.add(true);
    final url = await uploadImage(image, productId);
    _cargandoController.sink.add(false);
    return url;
  }

  void editarProducto(Producto producto) async{
    _cargandoController.sink.add(true);
    await _productosProvider.editProduct(producto);
    _cargandoController.sink.add(false);
  }

  void borrarProducto(String idProducto) async {
    await _productosProvider.deleteProduct(idProducto);
  }

  dispose(){
    _productosController?.close();
    _cargandoController?.close();
  }
}