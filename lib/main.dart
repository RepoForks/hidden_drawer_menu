import 'package:flutter/material.dart';
import 'package:hidden_drawer_menu/HiddenDrawerMenu/HiddenDrawerMenu.dart';
import 'package:hidden_drawer_menu/HiddenDrawerMenu/HiddenMenu.dart';
import 'package:hidden_drawer_menu/HiddenDrawerMenu/ScreenHiddenDrawer.dart';
import 'package:hidden_drawer_menu/Screens/HomeScreen.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {

  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  List <ScreenHiddenDrawer> itens = new List();

  @override
  void initState() {

    itens.add(
        new ScreenHiddenDrawer(
            new ItemHiddenMenu(
              name: "Home",
              colorLineSelected: Colors.orange,
            ),
            HomeScreen()
        )
    );

    itens.add(
        new ScreenHiddenDrawer(
            new ItemHiddenMenu(
              name: "Categorias",
            ),
            Container()
        )
    );

    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    return HiddenDrawerMenu(
      initPositionSelected: 0,
      screens: itens,
      backgroundColorMenu: Colors.blueGrey,
      backgroundMenu: new DecorationImage(
        image: new AssetImage('assets/bg_livros.jpg'),
        fit: BoxFit.cover,
      ),
    );

  }
}