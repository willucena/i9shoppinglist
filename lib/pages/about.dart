import 'package:flutter/material.dart';
import 'package:i9shoppinglist/layout.dart';

class AboutPage extends StatelessWidget {

  static String tag = 'about';

  @override
  Widget build(BuildContext context) {
    
    final content = Center(
     child:Text("Aplicativo desenvolvido por Wilson Lucena")
    );
    
    return Layout.getContent(context, content);
  }
}
