import 'package:i9shoppinglist/pages/item-add.dart';
import 'package:i9shoppinglist/pages/item-edit.dart';
import 'package:i9shoppinglist/pages/itens.dart';
import 'package:flutter/material.dart';
import 'pages/home.dart';
import 'pages/about.dart';
import 'pages/settings.dart';
import 'pages/itens.dart';
import 'package:i9shoppinglist/layout.dart';

void main() => runApp(AppBase());

class AppBase extends StatelessWidget {

  final routes = <String , WidgetBuilder>{

    HomePage.tag: (context)   =>   HomePage(),
    AboutPage.tag:(context)   =>   AboutPage(),
    SettingsPage.tag:(context)=>   SettingsPage(),
    ItensPage.tag: (context)  =>   ItensPage(),
    ItemAddPage.tag: (context) => ItemAddPage(),
    ItemEditPage.tag: (context) => ItemEditPage()
    
  };

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App base',
      color: Layout.primary(),
      theme: ThemeData(
        primaryColor: Layout.primary(),
        accentColor: Layout.secondary(),
        textTheme: TextTheme(
          headline: TextStyle(fontSize: 45, fontWeight: FontWeight.bold),
          title: TextStyle(fontSize: 22, fontStyle: FontStyle.italic, color: Layout.primary()),
          body1: TextStyle(fontSize: 14)
        )
      ),
      home: HomePage(),
      routes: routes,
    );
  }
}

