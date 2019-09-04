import 'package:i9shoppinglist/models/Item.dart';
import 'package:i9shoppinglist/pages/item-edit.dart';
import 'package:i9shoppinglist/pages/itens.dart';
import 'package:flutter/material.dart';
import 'package:i9shoppinglist/application.dart';
import 'package:i9shoppinglist/layout.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ItensList extends StatefulWidget {

  final List<Map> items;
  final String filter;
  final Function refresher;

  const ItensList({Key key, this.items, this.filter, this.refresher}) : super(key: key);

  _ItensListState createState() => _ItensListState();
}

class _ItensListState extends State<ItensList> {
  @override
  Widget build(BuildContext context) {
    if(widget.items.isEmpty){
      return ListView(
        children: <Widget>[
          ListTile(
            title: Text("Nenhum item encontrado"),
          )
        ],
      );
    }

    List<Map> filteredList = List<Map>();

    if(widget.filter.isNotEmpty){
        for(dynamic item in widget.items){
          String name = item['name'].toString().toLowerCase();
          if(name.contains(widget.filter.toLowerCase())){
            filteredList.add(item);
          }
        }
    }else{
      filteredList.addAll(widget.items);
    }

    if(filteredList.isEmpty){
      return ListView(
        children: <Widget>[
          ListTile(
            title: Text('Nenhum item encontrado...'),
          )
        ],
      );
    }

    ItemModel itemBo = ItemModel();

    return ListView.builder(
      itemCount: filteredList.length,
      itemBuilder: (BuildContext context, int i){

        Map item = filteredList[i];

        double realVal = currencyToDouble(item['valor']);
        String valorTotal = doubleToCurrency(realVal * item['quantidade']);

        return Slidable(
           actionPane: SlidableDrawerActionPane(),
           actionExtentRatio: 0.2,
           closeOnScroll: true,
           child: ListTile(
             leading: GestureDetector(
               child: Icon(
               ((item['checked'] == 1) ? Icons.check_box : Icons.check_box_outline_blank), 
               color: 
               ((item['checked'] == 1) ? Layout.success() : Layout.info()), 
               size: 42),
               onTap: (){
                 itemBo.update({
                   'checked': !(item['checked'] == 1)
                   }, item['pk_item']).then((bool updated){
                      if(updated){
                        widget.refresher();
                      }
                   });
               },
             ),
             title: Text(item['name']),
             subtitle: Text("${item['quantidade']} X ${item['valor']} =  $valorTotal"),
             trailing: Icon(Icons.arrow_forward_ios),
           ),
           secondaryActions: <Widget>[
             IconSlideAction(
               caption: 'Editar',
               icon: Icons.edit,
               color: Colors.black45,
               onTap: (){
                 itemBo.getItem(item['pk_item']).then((Map i){
                   ItemEditPage.item = i;
                   Navigator.of(context).pushNamed(ItemEditPage.tag);
                 });
               },
             ),
            IconSlideAction(
               caption: 'Excluir',
               icon: Icons.delete,
               color: Colors.red,
               onTap: (){
                  showDialog(
                  context: context,
                  barrierDismissible: true,
                  builder: (BuildContext ctx) {
                    return AlertDialog(
                      title: Text('Tem certeza?'),
                      content: Text('Esta ação irá remover o item selecionado e não poderá ser desfeita'),
                      actions: <Widget>[
                        RaisedButton(
                          color: Layout.secondary(),
                          child: Text('Cancelar', style: TextStyle(color: Layout.light())),
                          onPressed: () {
                            Navigator.of(ctx).pop();
                          },
                        ),
                        RaisedButton(
                          color: Layout.danger(),
                          child: Text('Remover', style: TextStyle(color: Layout.light())),
                          onPressed: () {
                            itemBo.delete(item['pk_item']);

                            Navigator.of(ctx).pop();
                            Navigator.of(ctx).pushReplacementNamed(ItensPage.tag);
                          }
                        )
                      ],
                    );
                  }
                );
               },
             )
           ],
        );

      },
    );

  }
}