import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

import 'package:http/http.dart' as http;

class ImgChamado extends StatefulWidget {
  
  const ImgChamado({Key key, this.chamado}) : super(key: key);

  final String chamado;

  @override  ImgChamadoState createState() => new ImgChamadoState();
}

class ImgChamadoState extends State<ImgChamado> {
  
  List<Asset> images = List<Asset>();  
  String _error = 'No Error Dectected';
  @override  void initState(){
    super.initState();  
  }

  Widget buildGridView() {
    return GridView.count(
      crossAxisCount: 3, 
      padding: EdgeInsets.all(10.0),
      children: List.generate(images.length, (index){
        Asset asset = images[index];        
        return Stack(
          children: <Widget>[
            AssetThumb(
              asset: asset,
              width: 300,
              height: 300,
            ),
          ],
        );
      }),
    );
  }

  _upload() async {
    
    Uri uri = Uri.parse('http://construtoraeletricaluz.com.br/gerencial/Flutter/carregaImg');
    MultipartRequest request = http.MultipartRequest("POST", uri);

    for (int i = 0; i < images.length; i++) {
      Asset asset = images[i];
      ByteData byteData = await asset.getByteData();
      List<int> imageData = byteData.buffer.asUint8List();

      MultipartFile multipartFile = MultipartFile.fromBytes(
        'photo',
        imageData,
        filename: 'some-file-name.jpg',
        contentType: MediaType("image", "jpg")
      );
      
      // add file to multipart
      request.files.add(multipartFile);
      
      // send
      var response = await request.send();
    }
  }

  Future<void> loadAssets() async {
    
    setState(() {
      images = List<Asset>();    
    });
    
    List<Asset> resultList = List<Asset>();    
    String error = 'No Error Dectected';
    try{
      resultList = await MultiImagePicker.pickImages(
        maxImages: 300,        
        enableCamera: false,
        selectedAssets: images,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          actionBarColor: "#4474B0",
          actionBarTitle: "Fotos",
          allViewTitle: "All Photos",
          useDetailsView: false,
          selectCircleStrokeColor: "#4474B0",
        ),      
      );    
    } on PlatformException catch (e){
      error = e.message;    
    }
    
    if (!mounted) return;

    setState(() {
      images = resultList;
      _error = error;
    });  
  }

  @override Widget build(BuildContext context) {
    var chamado = widget.chamado;
    return new Scaffold(
      appBar: new AppBar(
        title: Text("Carregar imagens",
        style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xFF4474B0),
      ),        
      body: 
      Container(
        margin: EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text('Selecione as fotos do chamado: '+chamado), 
                RaisedButton(
                  child: Text("Carregar",
                    style: TextStyle(color: Colors.white)
                  ),                  
                  color: Colors.blue,                  
                  onPressed: loadAssets,                
                ),
                // con(Icons.camera_alt,color: Colors.blue,)              
              ],
            ),
            Expanded(
              child: buildGridView(),            
            )
          ],
        ),
      ),
    );
  }
}