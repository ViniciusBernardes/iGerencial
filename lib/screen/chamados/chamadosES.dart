import 'dart:async';
import 'package:flutter/material.dart';
import 'package:iGerencial/screen/chamados/chamados.dart';
import 'package:iGerencial/servico/api.dart';
import 'package:iGerencial/util/util.dart';

class ChamadosES extends StatefulWidget {
  ChamadosES({Key key, this.title}) : super(key: key);

  final String title;

  @override
  ChamadosESState createState() => new ChamadosESState();
}

class ChamadosESState extends State<ChamadosES> {
  
  @override
  void initState() {
    super.initState();
  }
  
  int _count = 0;
  var util = Util();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lista de Chamados ES",
        style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xFF4474B0),
      ),
      body: _body(),
    );
  }

  Future<Null> _refreshhandle() async {
    setState(() {
      _count++;
    });
    return null;
  }

  _body(){
    Future<List<Chamados>> chamados = Api.listaChamadosES();
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

          return Card(
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
            )
          );
        }
      ),
    );
  }
}