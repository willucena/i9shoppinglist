import 'package:flutter/material.dart';
import 'package:i9shoppinglist/layout.dart';

class SettingsPage extends StatelessWidget {

  static String tag = 'settings';

  @override
  Widget build(BuildContext context) {
    
    final content = Center(
     child: Text("Pagia de configurações")
    );
    
    return Layout.getContent(context, content);
  }
}
