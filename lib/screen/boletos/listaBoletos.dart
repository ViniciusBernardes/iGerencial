import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:iGerencial/screen/boletos/boletos.dart';
import 'package:iGerencial/servico/api.dart';
import 'package:iGerencial/util/util.dart';
import 'package:intl/intl.dart';

class ListaBoletos extends StatefulWidget {
  ListaBoletos({Key key, this.title}) : super(key: key);

  final String title;

  @override
  ListaBoletosState createState() => new ListaBoletosState();
}

class ListaBoletosState extends State<ListaBoletos> {
  
  @override
  void initState() {
    super.initState();
  }
  
  int _count = 0;
  var util = Util();
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Boletos a vencer",
        style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xFF4474B0),
      ),
      //body: _body(),
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

  Future<Null> _baixaBoleto(boleto) async{
    
    _setaLoading(true);
    Timer(Duration(seconds: 2), () => 

      Api.baixaBoleto(boleto).then((rest) => {
        util.alert(context, "Boleto baixado com sucesso", "Confirmação"),
        _setaLoading(false)
      })
    );
    return null;
  }

  //configura o AlertDialog
  confirmaBaixa(BuildContext context, idBoleto){
    showDialog(
      context: context,
      builder: (context){
        return AlertDialog(
          title: Text("Atenção"),
          content: Text("Deseja da baixa no boleto ?"),
          actions: [
            FlatButton(
              child: Text("Não"),
              onPressed:  () => { Navigator.of(context).pop() },
            ),
            FlatButton(
              child: Text("Sim"),
              onPressed:  () => { 
                  Navigator.of(context).pop(), 
                  _baixaBoleto(idBoleto) 
              },
            ),
          ],
        );
      }
    );
  }

  _body(){
    Future<List<Boletos>> boletos = Api.listaBoletos();
    return FutureBuilder(
      future: boletos,
      builder: (context, snapshot){
        if (snapshot.hasError) {
          return Center(child: Text("Erro ao acessar os dados"));
        } 
        
        if (!snapshot.hasData) {
          return Center(
            child: util.loading()
          );
        }
        
        List<Boletos> boletos = snapshot.data;
        if(boletos[0].id == "")
          return Center(
            child: Text(
              "Sem Boletos a Vencer", 
              style: TextStyle(
                fontWeight: FontWeight.bold, 
                color: Color(0xFF4474B0),
                fontSize: 18
              ),
              
            ),
          );

        return
        RefreshIndicator(
          child: _listView(boletos, _count + 2),
          onRefresh: _refreshhandle
        );
      }
    );
  }

  _listView(boletos, count) {
    print("counts: $count");
    return Container(
      padding: EdgeInsets.all(15),
      child: ListView.builder(
        itemCount: boletos.length,
        itemBuilder: (context, index){
          Boletos b = boletos[index];

          double value = double.parse(b.valor);

          final formatter = new NumberFormat("###,##0.00", "pt-br");

          String valor = formatter.format(value);

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
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Text(b.descricao, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        ],
                      )
                    ),
                    Container(
                      padding: EdgeInsets.only(bottom: 7),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Text("R\$ "+valor, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500), textAlign: TextAlign.left),
                          Text(b.data, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500), textAlign: TextAlign.left),
                        ],
                      )
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        SelectableText(
                          b.linha,
                          toolbarOptions: ToolbarOptions(
                            copy: true,
                            selectAll: true,
                            cut: false,
                            paste: false
                          ),
                        ),
                        //Text(b.linha, style: TextStyle(fontSize: 14), textAlign: TextAlign.left),
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
                    confirmaBaixa(context, b.id) 
                  },
                ),
              ],
            )
          );
        }
      ),
    );
  }
}