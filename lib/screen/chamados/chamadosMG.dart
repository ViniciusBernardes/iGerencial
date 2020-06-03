import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:iGerencial/screen/chamados/chamados.dart';
import 'package:iGerencial/screen/chamados/imgChamado.dart';
import 'package:iGerencial/servico/api.dart';
import 'package:iGerencial/util/util.dart';

class ChamadosMG extends StatefulWidget {
  ChamadosMG({Key key, this.title}) : super(key: key);

  final String title;

  @override
  ChamadosMGState createState() => new ChamadosMGState();
}

class ChamadosMGState extends State<ChamadosMG> {
  
  int _count = 0;

  @override
  void initState() {
    super.initState();
  }
    
  var util = Util();
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lista de Chamados MG",
        style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xFF4474B0),
      ),
      
      body: Container(
        child: _loading ? util.loading() : _body()
      ),

    );
  }

  Future<Null> _refreshhandle() async {
    setState(() {
      _count++;
    });
    return null;
  }

  //habilita o carregando até retornar a requisição
  _setaLoading(bool status){
    return setState((){
          _loading = status;
    });
  }

  //configura o AlertDialog
  confirmaBaixa(BuildContext context, nChamado){
    showDialog(
      context: context,
      builder: (context){
        return AlertDialog(
          title: Text("Atenção"),
          content: Text("Deseja da baixa no chamado ?"),
          actions: [
            FlatButton(
              child: Text("Não"),
              onPressed:  () => { Navigator.of(context).pop() },
            ),
            FlatButton(
              child: Text("Sim"),
              onPressed:  () => { 
                  Navigator.of(context).pop(), 
                  _baixaChamado(nChamado) 
              },
            ),
          ],
        );
      }
    );
  }

  

  Future<Null> _baixaChamado(chamado) async{
    
    _setaLoading(true);
    Timer(Duration(seconds: 2), () => 

      Api.baixaChamado(chamado).then((rest) => {
        util.alert(context, "Chamado baixado com sucesso", "Confirmação"),
        _setaLoading(false)
      })
    );
    return null;
  }

  _body(){
    Future<List<Chamados>> chamados = Api.listaChamados();
    return FutureBuilder(
      future: chamados,
      builder: (context, snapshot){
        if (snapshot.hasError) {
          return Center(child: Text("Erro ao acessar os dados"));
        } 
        
        if (!snapshot.hasData) {
          return Center(
            child: util.loading()
          );
        }
        
        List<Chamados> chamados = snapshot.data;

        return
        RefreshIndicator(
          child: _listView(chamados, _count + 2),
          onRefresh: _refreshhandle
        );
      }
    );
  }

  _listView(chamados, count) {
    print("counts: $count");
    return Container(
      padding: EdgeInsets.all(15),
      child: ListView.builder(
        itemCount: chamados.length,
        itemBuilder: (context, index){
          Chamados c = chamados[index];
          var nChamado = c.numero;
          return Card(
            child: Slidable(
              actionPane: SlidableDrawerActionPane(),
              actionExtentRatio: 0.25,
              child: Container(
                padding: EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.only(bottom: 7),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Text(c.numero, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          Text(c.dataIni, style: TextStyle(fontSize: 14)),
                        ],
                      )
                    ),
                    Container(
                      padding: EdgeInsets.only(bottom: 7),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Text(c.local, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500), textAlign: TextAlign.left),
                        ],
                      )
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Text(c.detalhes, style: TextStyle(fontSize: 14), textAlign: TextAlign.justify),
                      ],
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                IconSlideAction(
                  caption: 'Baixar',
                  color: Color(0xFF4474B0),
                  icon: Icons.assignment_turned_in,
                  onTap: () => { 
                    confirmaBaixa(context, nChamado) 
                  },
                ),
              ],
              secondaryActions: <Widget>[
                IconSlideAction(
                  caption: 'Fotos',
                  color: Color(0xFF4474B0),
                  icon: Icons.camera_enhance,
                  onTap: () => { 
                    Navigator.push(
                      context, 
                      MaterialPageRoute(builder: (context) => ImgChamado(chamado: c.numero)),
                    )
                  },
                ),
              ],
            ),
          );
        }
      ),
    );
  }
}