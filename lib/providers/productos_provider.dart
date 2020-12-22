
import 'dart:convert';

import 'package:formsvalidations/sharedpreferences/userprefs.dart';
import 'package:http/http.dart' as http;
import 'package:formsvalidations/models/product_model.dart';

class ProductosProvider{

  final String _url = 'https://flutterapps-417d3-default-rtdb.firebaseio.com';
  final _prefs = new UserPreferences();

  //Insertamos un producto en Firebase
  Future<bool> createProducto(Producto producto) async {
    final url = '$_url/productos.json?auth=${_prefs.token}';
    final resp = await http.post(url, body: productoToJson(producto));
    final decodedData = json.decode(resp.body);
    //Devuelve el id que asigna Firebase
    print(decodedData);
    return true;
  }

  //Listamos todos los productos de Firebase
  Future<List<Producto>> listProducts() async {

    final url = '$_url/productos.json?auth=${_prefs.token}';
    final resp = await http.get(url);
    final Map<String,dynamic> decodedData = json.decode(resp.body);
    final List<Producto> productos = List();

    if(decodedData == null){
      return [];
    }
    decodedData.forEach((id, producto) {
      final Producto prod = Producto.fromJson(producto);
      prod.id = id;
      productos.add(prod);
    });
    return productos;
  }

  //Borrar producto
  Future<int> deleteProduct(String id) async {
    final url = '$_url/productos/$id.json?auth=${_prefs.token}';
    final resp = await http.delete(url);
    print(json.decode(resp.body));
    return 1;
  }

  //Editar producto
  Future<bool> editProduct(Producto producto) async {
    final url = '$_url/productos/${producto.id}.json?auth=${_prefs.token}';
    final resp = await http.put(url, body: productoToJson(producto));
    final decodedData = json.decode(resp.body);
    //Devuelve el id que asigna Firebase
    print(decodedData);
    return true;
  }
}