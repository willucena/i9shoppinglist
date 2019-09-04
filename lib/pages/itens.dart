import 'package:i9shoppinglist/models/Item.dart';
import 'package:flutter/material.dart';
import 'package:i9shoppinglist/layout.dart';
import 'dart:async';
import 'package:i9shoppinglist/widgets/ItensList.dart';
import 'item-add.dart';
import 'package:i9shoppinglist/application.dart';

class ItensPage extends StatefulWidget {

  static final tag = 'itens-page';
  static int pkList;
  static String nameList;

  @override
  _ItensState createState() => _ItensState();
}

class _ItensState extends State<ItensPage> {
  //Variavel para pesquisa
  String filterText = "";

  @override
  final ItensListBloc itensListBloc = ItensListBloc();

  @override
  void dispose() {
    itensListBloc.dispose();
    super.dispose();
  }

  void refresher() {
    setState(() {
      itensListBloc.getList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final content = SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            color: Color.fromRGBO(230, 230, 230, 0.5),
            padding: EdgeInsets.only(left: 15, top: 10),
            child: Text(
              'Nome: ' + ItensPage.nameList,
              style: TextStyle(
                fontSize: 16,
                color: Layout.primary(),
              ),
            ),
          ),

          //NESTE CONTAINER EU ESTOU FAZENDO O FORMULARIO DE PESQUISA E BOTÃO ADCIONAR
          Container(
            color: Color.fromRGBO(230, 230, 230, 0.5),
            padding: EdgeInsets.only(bottom: 10),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    width: MediaQuery.of(context).size.width - 80,
                    child: TextField(
                      decoration: InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          hintText: 'Pesquisar',
                          contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(32))),
                      onChanged: (text) {
                        setState(() {
                          filterText = text;
                        });
                      },
                    ),
                  ),
                  SizedBox(width: 10),
                  SizedBox(
                    child: FloatingActionButton(
                      mini: true,
                      backgroundColor: Layout.info(),
                      onPressed: () {
                        Navigator.of(context).pushNamed(ItemAddPage.tag);
                      },
                      child: Icon(Icons.add),
                    ),
                  )
                ]),
          ),

          //NESTE CONTAINER ESTA OS ITENS DA LISTA
          Container(
            height: MediaQuery.of(context).size.height - 249,
            child: StreamBuilder<List<Map>>(
              stream: itensListBloc.lists,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                    return const Center(child: Text('carregando...'));
                  default:
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }

                    return ItensList(
                      items: snapshot.data,
                      filter: filterText,
                      refresher: this.refresher,
                    );
                }
              },
            ),
          ),

          // NESTE CONTAINER EU ESTOU CONFIGURANDO O FOOTER D RESUTADOS DESSA PAGINA
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10)),
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: <Color>[
                      Color.fromRGBO(150, 150, 150, 0.3),
                      Color.fromRGBO(255, 150, 240, 0.3)
                    ])),
            height: 80,

            //AQUI EU CRIO OS DOIS ELEMENTOS NO RODAPÉ QUE VÃO RECEBER OS TOTAIS ,
            child: StreamBuilder<List<Map>>(
              stream: itensListBloc.lists,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                    return const Center(child: Text('carregando...'));
                  default:
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }
                     // Recupera os itens
                      List<Map> items = snapshot.data;

                      // Total de itens
                      int qtdTotal = items.length;

                      // Total de itens marcados
                      int qtdChecked = 0;

                      // Valor total quando todos os items estiverem marcados
                      double subTotal = 0.0;

                      // Valor total de items marcados
                      double vlrTotal = 0.0;

                      for (Map item in items) {

                        double vlr = currencyToFloat(item['valor']) * item['quantidade'];
                        subTotal += vlr;
                        
                        if (item['checked'] == 1) {
                          qtdChecked++;
                          vlrTotal += vlr;
                        }
                      }

                      // Quando todos os items forem marcados
                      // o total devera ficar Verde (success)
                      bool isClosed = (subTotal == vlrTotal);


                    return Row(
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width / 2,
                          padding: EdgeInsets.all(12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Column(children: <Widget>[
                                Text('Itens'),
                                Text(qtdTotal.toString(), textScaleFactor: 1.2)
                              ]),
                              Column(children: <Widget>[
                                Text('Carrinho'),
                                Text(qtdChecked.toString(), textScaleFactor: 1.2)
                              ]),
                              Column(children: <Widget>[
                                Text('Faltando'),
                                Text((qtdTotal - qtdChecked).toString(), textScaleFactor: 1.2)
                              ]),
                            ],
                          ),
                        ),
                        Container(
                          color: Color.fromRGBO(0, 0, 0, 0.04),
                          width: MediaQuery.of(context).size.width / 2,
                          padding: EdgeInsets.only(left: 10, top: 10),
                          child: Column(
                            children: <Widget>[
                              Text('Sub: '+doubleToCurrency(subTotal),
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: Layout.dark(0.9),
                                      fontWeight: FontWeight.bold)),
                              SizedBox(height: 5),        
                              Text('Total: '+doubleToCurrency(vlrTotal),
                                  style: TextStyle(
                                      fontSize: 24,
                                      color: isClosed ? Layout.success() : Layout.info(),
                                      fontWeight: FontWeight.bold))
                            ],
                          ),
                        )
                      ],
                    );
                }
              },
            ),
          )
        ],
      ),
    );

    return Layout.getContent(context, content, false);
  }
}

class ItensListBloc {
  ItensListBloc() {
    getList();
  }

  ItemModel itemBo = ItemModel();

  final _controller = StreamController<List<Map>>.broadcast();

  get lists => _controller.stream;

  dispose() {
    _controller.close();
  }

  getList() async {
    _controller.sink.add(await itemBo.itemsByList(ItensPage.pkList));
  }
}
