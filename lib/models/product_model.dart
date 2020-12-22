import 'dart:convert';

Producto productoFromJson(String str) => Producto.fromJson(json.decode(str));

String productoToJson(Producto data) => json.encode(data.toJson());

class Producto {
  
  String id;
  String nombre;
  double precio;
  bool disponible;
  String fotoUrl;

  Producto({
    this.id,
    this.nombre = '',
    this.precio = 0.0,
    this.disponible = true,
    this.fotoUrl,
  });

  //Mapeamos de un JSON recibido a nuestro modelo
  factory Producto.fromJson(Map<String, dynamic> json) => new Producto(
    id          : json["id"],
    nombre      : json["nombre"],
    precio      : json["precio"],
    disponible  : json["disponible"],
    fotoUrl     : json["fotoUrl"],
  );

  //De nuestro modelo a JSON
  Map<String, dynamic> toJson() => {
    //No mandamos el id porque si no se mete también en el objeto y eso sería
    //duplicar información
    // "id"          : id,
    "nombre"      : nombre,
    "precio"      : precio,
    "disponible"  : disponible,
    "fotoUrl"     : fotoUrl,
  };
}
