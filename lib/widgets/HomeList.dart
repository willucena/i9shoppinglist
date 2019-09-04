import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../pages/home.dart';
import '../models/Lista.dart';
import '../pages/itens.dart';
import '../layout.dart';

enum ListAction { edit, delete }

class HomeList extends StatefulWidget {
  final List<Map> items;

  HomeList({this.items}) : super();

  @override
  _HomeListState createState() => _HomeListState();
}

class _HomeListState extends State<HomeList> {
  List<Widget> values = List<Widget>();

  ListaModel listBo = ListaModel();

  @override
  Widget build(BuildContext context) {
    print(widget.items.length);
    //Obs: QUando eu pego o atributo widget aqui dentro do _HomeListState eu estou pegando o
    // objeto HomeList ai eu tenho acesso a tudo neste obeto
    if (widget.items.length == 0) {
      return ListView(
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.pages),
            title: Text("Nenhuma lista cadastrada"),
          )
        ],
      );
    }

    DateFormat df = DateFormat('dd/MM/yy HH:mm');

    return ListView.builder(
      shrinkWrap: true,
      itemCount: widget.items.length,
      itemBuilder: (BuildContext context, int index) {
        print(widget.items.length);
        Map item = widget.items[index];

        DateTime created = DateTime.tryParse(item['created']);

        return ListTile(
            leading: Icon(Icons.pages, size: 42),
            title: Text(item['name']),
            subtitle: Text(df.format(created)),
            trailing: PopupMenuButton<ListAction>(
              onSelected: (ListAction result) {
                switch (result) {
                  case ListAction.edit:
                    this._showEditDialog(context, item); // Chama o metodo de edição
                    break;
                  case ListAction.delete:
                    listBo.delete(item['pk_lista']).then((deleted) {
                      if (deleted) {
                        Navigator.of(context)
                            .pushReplacementNamed(HomePage.tag);
                      }
                    });
                    break;
                }
              },
              itemBuilder: (BuildContext context) {
                return <PopupMenuEntry<ListAction>>[
                  PopupMenuItem<ListAction>(
                    value: ListAction.edit,
                    child: Row(
                        children: <Widget>[Icon(Icons.edit), Text("Editar")]),
                  ),
                  PopupMenuItem<ListAction>(
                    value: ListAction.delete,
                    child: Row(children: <Widget>[
                      Icon(Icons.delete),
                      Text("Excluir")
                    ]),
                  )
                ];
              },
            ),
            onTap:() {
              //Aponta pro item a qual esta selecionado
              ItensPage.pkList = item['pk_lista'];
              ItensPage.nameList = item['name'];

              Navigator.of(context).pushNamed(ItensPage.tag);
            },
            );
      },
    );
  }

// Metodo que abre a modal para edição 
  void _showEditDialog(BuildContext context, Map item) {
    TextEditingController _controllerEdit = TextEditingController();
    _controllerEdit.text = item['name'];

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext ctx) {
        final input = Form(
            child: TextFormField(
          controller: _controllerEdit,
          autofocus: true,
          decoration: InputDecoration(
              hintText: 'Nome',
              contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 10),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(5))),
        ));

        return AlertDialog(
          title: Text('Editar'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[input],
            ),
          ),
          actions: <Widget>[
            RaisedButton(
              color: Layout.warning(),
              child: Text("Cancelar", style: TextStyle(color: Layout.light())),
              onPressed: () {
                Navigator.of(ctx).pop();
              },
            ),
            RaisedButton(
              color: Layout.primary(),
              child: Text("Salvar", style: TextStyle(color: Layout.light())),
              onPressed: () {
                ListaModel listBo = ListaModel();

                // Inserir no banco de dados
                listBo.update({
                  'name': _controllerEdit.text,
                  'created': DateTime.now().toString(),
                }, item['pk_lista'] ).then((newRowId) {
                  print(newRowId);
                  Navigator.of(ctx).pop();
                  Navigator.of(ctx).pushReplacementNamed(HomePage.tag);
                });
              },
            )
          ],
        );
      },
    );
  }
}
