import 'package:i9shoppinglist/pages/about.dart';
import 'package:i9shoppinglist/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:i9shoppinglist/models/Lista.dart';

class Layout {
  
  static int currIntem = 0;

  static final pages = [
    HomePage.tag, 
    AboutPage.tag, 
  ];

  static Scaffold getContent(BuildContext context, content, [bool showBotton = true]) {

    // Variavel que carrega os botões do rodapé
    BottomNavigationBar bottonNavbar = BottomNavigationBar(
        currentIndex: currIntem,
        fixedColor: primary(),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home),  title: Text('Home')),
          BottomNavigationBarItem(icon: Icon(Icons.account_circle), title: Text('Sobre')),
        ],
        onTap: (int i) {
          currIntem = i;
          Navigator.of(context).pushReplacementNamed(pages[i]);
        },
    );


    return Scaffold(

      //Cabeçalho do aplicativo
      appBar: AppBar(
        backgroundColor: primary(),
        //Titulo no cabeçalho do aplicativo
        title: Text("i9 SHOPPING LIST"),

        //Função que tem a regra do botão + alertDialog
        actions: showBotton ? _getActions(context) : [], 
      ),

      // Conteúdo do aplicativo
      body: content,

      // Botões no rodapé do aplicativo
      bottomNavigationBar: showBotton ? bottonNavbar : null,
    );
  }

  // Ações do Layout 
  static List<Widget> _getActions(BuildContext context){
    List<Widget> items = List<Widget>();

    GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    TextEditingController _c = TextEditingController();
      // Essa condição controla a ação (+) se a pagina for diferente retorna o array de itens
      if(pages[currIntem] == HomePage.tag){
        
      items.add(
         GestureDetector(
            onTap: () {
              showDialog(
                  context: context,
                  // barrierDismissible: false,
                  builder: (BuildContext ctx) {
                    final input = Form(
                      key: _formKey,
                      child: TextFormField(
                      controller: _c,
                      autofocus: true,
                      decoration: InputDecoration(
                          hintText: 'Nome',
                          contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                          border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5)
                        )
                      ),
                    )
                  );


                  return AlertDialog(
                      title: Text('Nova lista'),
                      content: SingleChildScrollView(
                        child: ListBody(
                          children: <Widget>[
                            input
                          ],
                        ),
                      ),
                      actions: <Widget>[
                        RaisedButton(
                          color: warning(),
                          child: Text("Cancelar",style: TextStyle(color: Layout.light())),
                          onPressed: () {
                            Navigator.of(ctx).pop();
                          },
                        ),
                        RaisedButton(
                          color: primary(),
                          child: Text("Adicionar", style: TextStyle(color: Layout.light())),
                          onPressed: () {
                            ListaModel listBo = ListaModel();

                            // Inserir no banco de dados
                            listBo.insert({
                               'name': _c.text,
                               'created': DateTime.now().toString()
                            }).then((newRowId){
                              print(newRowId);
                                Navigator.of(ctx).pop();
                                Navigator.of(ctx).pushReplacementNamed(HomePage.tag);
                            });
                          },
                        )
                      ],
                    );
                  }
                  
                );
            },
            child: Icon(Icons.add),
          ),
        );
      }

      items.add(Padding(padding: EdgeInsets.only(right: 20)));
      return items;
          
  }

  static Color primary([double opacity = 1]) => Color.fromRGBO(62, 63, 89, opacity);
  static Color secondary([double opacity = 1]) => Color.fromRGBO(150, 150, 150, opacity);
  static Color light([double opacity = 1]) => Color.fromRGBO(242, 234, 228, opacity);
  static Color dark([double opacity = 1]) => Color.fromRGBO(51, 51, 51, opacity);

  static Color danger([double opacity = 1]) => Color.fromRGBO(217, 74, 74, opacity);
  static Color success([double opacity = 1]) => Color.fromRGBO(5, 100, 50, opacity);
  static Color info([double opacity = 1]) => Color.fromRGBO(100, 150, 255, opacity);
  static Color warning([double opacity = 1]) => Color.fromRGBO(166, 134, 0, opacity);
}


