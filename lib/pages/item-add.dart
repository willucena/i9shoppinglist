import 'package:flutter/material.dart';
import 'package:i9shoppinglist/layout.dart';
import 'package:i9shoppinglist/application.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:i9shoppinglist/models/Item.dart';
import 'package:i9shoppinglist/pages/itens.dart';

class ItemAddPage extends StatefulWidget {
  static String tag = 'item-add-page';

  @override
  _ItemAddPageState createState() => _ItemAddPageState();
}

class _ItemAddPageState extends State<ItemAddPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _controllerName = TextEditingController();
  final TextEditingController _controllerQtd = TextEditingController();
  final MoneyMaskedTextController _controllerValor = MoneyMaskedTextController(
      thousandSeparator: '.', decimalSeparator: ',', leftSymbol: 'R\$ ');

  @override
  Widget build(BuildContext context) {
    
    final inputName = TextFormField(
      controller: _controllerName,
      autofocus: true,
      decoration: InputDecoration(
          hintText: 'Nome do item',
          contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 10),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5))),
      validator: (value) {
        if (value.isEmpty) {
          return 'Campo obrigatório';
        }
      },
    );
    _controllerQtd.text = '1';
    final inputQuantidade = TextFormField(
      controller: _controllerQtd,
      autofocus: false,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
          hintText: 'Quantidade',
          contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 10),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5))),
      validator: (value) {
        if (int.parse(value) < 1) {
          return 'Informe um numero positivo';
        }
      },
    );

    final inputValor = TextFormField(
      controller: _controllerValor,
      autofocus: false,
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
          hintText: 'Valor R\$',
          contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 10),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5))),
      validator: (value) {
        if (currencyToDouble(value) < 0.0) {
          return 'Obrigatório';
        }
        return null;
      },
    );

    Container content = Container(
      child: Form(
      key: _formKey,
      child: ListView(
        shrinkWrap: true,
        padding: EdgeInsets.all(20),
        children: <Widget>[
          Text(
            'Adicionar item',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
          SizedBox(height: 20),
          inputName,
          SizedBox(height: 20),
          inputQuantidade,
          SizedBox(height: 20),
          inputValor,
          SizedBox(height: 50),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              RaisedButton(
                color: Layout.secondary(),
                child:
                    Text('Cancelar', style: TextStyle(color: Layout.light())),
                padding: EdgeInsets.only(left: 50, right: 50),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              RaisedButton(
                color: Layout.primary(),
                child: Text('Salvar', style: TextStyle(color: Layout.light())),
                padding: EdgeInsets.only(left: 50, right: 50),
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    ItemModel itemBo = ItemModel();

                    itemBo.insert({
                      'fk_lista': ItensPage.pkList,
                      'name': _controllerName.text,
                      'quantidade': _controllerQtd.text,
                      'valor': _controllerValor.text,
                      'created': DateTime.now().toString()
                    }).then((saved) {
                      Navigator.of(context).pop();
                      Navigator.of(context).pushReplacementNamed(ItensPage.tag);
                    });
                  }
                },
              )
            ],
          )
        ],
      ),
    )
 );

    return Layout.getContent(context, content, false);
  }
}
