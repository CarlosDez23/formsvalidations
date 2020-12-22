import 'dart:io';

import 'package:flutter/material.dart';
import 'package:formsvalidations/blocs/provider.dart';
import 'package:formsvalidations/models/product_model.dart';
import 'package:formsvalidations/providers/images_provider.dart' as UploadStorageUtil;
import 'package:formsvalidations/providers/productos_provider.dart';
import 'package:formsvalidations/utils/utils.dart' as utils;
import 'package:image_picker/image_picker.dart';

class ProductoPage extends StatefulWidget {

  @override
  _ProductoPageState createState() => _ProductoPageState();
}

class _ProductoPageState extends State<ProductoPage> {

  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final productosProvider = new ProductosProvider();
  ProductosBloc productosBloc;


  Producto producto = new Producto();
  bool _guardando = false;
  File image;

  @override
  Widget build(BuildContext context) {
    productosBloc = Provider.productosBlocOf(context);
    final Producto  prodArgs = ModalRoute.of(context).settings.arguments;
    if(prodArgs != null){
      producto = prodArgs;
    }
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text('Producto'),
        actions: [
          IconButton(
            icon: Icon(Icons.photo_size_select_actual),
            onPressed: _pickPhotoFromGallery,
          ),
          IconButton(
            icon: Icon(Icons.camera_alt),
            onPressed: _takePhoto,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(15.0),
          child: Form(
            key: formKey,
            child: Column(
              children: <Widget> [
                _showPhoto(),
                _createNameInput(),
                _createPrizeInput(),
                _createAvailable(),
                _createButton(),
              ],
            )
          ),
        ),
      ),
    );
  }

  Widget _createNameInput() {
    return TextFormField(
      initialValue: producto.nombre,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        labelText: 'Producto', 
      ),
      onSaved:(value) => producto.nombre = value,
      validator: (value){
        if(value.length < 3){
          //Si retornamos string hay error
          return 'Ingresa el número del producto';
        }else{
          //Si retornamos null, ha pasado la validación el value
          return null;
        }
      },
    );
  }

  Widget _createPrizeInput() {
    return TextFormField(
      initialValue: producto.precio.toString(),
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        labelText: 'Precio',
      ),
      onSaved: (value) => producto.precio = double.parse(value),
      validator: (value){
        if(utils.isANumber(value)){
          return null;
        }else{
          return 'Solo puedes ingresar números válidos';
        }
      },
    );
  }

  Widget _createAvailable() {
    return SwitchListTile(
      title: Text('Disponible'),
      activeColor: Colors.deepPurple,
      value: producto.disponible, 
      onChanged: (value){
        setState(() {
          producto.disponible = value;
        });
      }
    );
  }

  Widget _createButton() {
    return RaisedButton.icon(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0)
      ),
      color: Colors.deepPurple,
      textColor: Colors.white,
      label: Text('Guardar'),
      icon: Icon(Icons.save),
      onPressed:  (_guardando)
                ? null
                : _submit,
    );
  }

  Widget _showPhoto(){
    if(producto.fotoUrl != null){
      return FadeInImage(
        image: NetworkImage(producto.fotoUrl), 
        placeholder: AssetImage('assets/img/loading.gif'),
        height: 300.0,
        fit: BoxFit.contain,
      );
    }else{
      if(image != null){
        return Image.file(
          image,
          height: 300.0,
          fit: BoxFit.cover,
        );
      }
      return Image.asset('assets/img/no-image.png');
    }
  }

  void _submit() async{
    if(!formKey.currentState.validate()){
      //El formulario no es válido
      mostrarSnackbar('Tienes que rellenar todos los campos');
      return;
    }
    //Llamamos al onSaved de los distintos campos
    formKey.currentState.save();
    setState(() {
      _guardando = true;
    });
    if(image != null){
      producto.fotoUrl = await productosBloc.subirFoto(image, producto.nombre);
    }
    /*Si el id es nulo es que es un producto de nueva creación, 
    es decir, no nos ha llegado por los argumentos del navigator.
    Si el id no es nulo nos ha llegado del navigator desde la ventana
    con la lista de productos por lo que vamos a actulizarlo porque 
    ya existe en Firebase*/ 
    if(producto.id == null){
      productosBloc.agregarProducto(producto);
    }else{
      productosBloc.editarProducto(producto);
    }
    setState(() {
      _guardando = false;
    });
    mostrarSnackbar('Cambios guardados');
    //Volvemos a la pantalla anterior
    Navigator.pop(context);
  }

  void mostrarSnackbar(String mensaje){
    final snackbar = SnackBar(
      content: Text(mensaje),
      duration: Duration(milliseconds: 1500),
    );
    scaffoldKey.currentState.showSnackBar(snackbar);
  }

  _pickPhotoFromGallery() async{
    _handleImage(ImageSource.gallery);
  }
  _takePhoto() async{
    _handleImage(ImageSource.camera);
  }

  _handleImage(ImageSource origen) async{
    image = await ImagePicker.pickImage(
      source: origen
    );
    if(image != null){
      //Quitamos la imagen anterior
      producto.fotoUrl = null;
    }
    setState(() {});
  }
}