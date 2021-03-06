import 'package:flutter/material.dart';
import 'package:hidden_drawer_menu/controllers/hidden_drawer_controller.dart';
import 'package:hidden_drawer_menu/hidden_drawer/hidden_drawer_bloc.dart';
import 'package:hidden_drawer_menu/hidden_drawer/screen_hidden_drawer.dart';
import 'package:hidden_drawer_menu/menu/hidden_menu.dart';
import 'package:hidden_drawer_menu/menu/item_hidden_menu.dart';


class HiddenDrawerMenu extends StatefulWidget {

  /// List item menu and respective screens
  final List<ScreenHiddenDrawer> screens;

  /// position initial item selected in menu( sart in 0)
  final int initPositionSelected;

  /// Decocator that allows us to add backgroud in the content(img)
  final DecorationImage backgroundContent;

  /// Decocator that allows us to add backgroud in the content(color)
  final Color backgroundColorContent;

  /// enable auto title in appbar with menu item name
  final bool whithAutoTittleName;

  /// Style of the title in appbar
  final TextStyle styleAutoTittleName;

  //AppBar
  /// change backgroundColor of the AppBar
  final Color backgroundColorAppBar;

  ///Change elevation of the AppBar
  final double elevationAppBar;

  ///Change iconmenu of the AppBar
  final Widget iconMenuAppBar;

  /// Add actions in the AppBar
  final List<Widget> actionsAppBar;

  /// Set custom widget in tittleAppBar
  final Widget tittleAppBar;

  //Menu
  /// Decocator that allows us to add backgroud in the menu(img)
  final DecorationImage backgroundMenu;

  /// that allows us to add backgroud in the menu(color)
  final Color backgroundColorMenu;

  /// that allows us to add shadow above menu items
  final bool enableShadowItensMenu;

  final Curve curveAnimation;

  HiddenDrawerMenu(
  { this.screens,
  this.initPositionSelected = 0,
  this.backgroundColorAppBar,
  this.elevationAppBar = 4.0,
  this.iconMenuAppBar = const Icon(Icons.menu),
  this.backgroundMenu,
  this.backgroundColorMenu,
  this.backgroundContent,
  this.backgroundColorContent = Colors.white,
  this.whithAutoTittleName = true,
  this.styleAutoTittleName,
  this.actionsAppBar,
  this.tittleAppBar,
  this.enableShadowItensMenu = false,
    this.curveAnimation = Curves.decelerate});

  @override
  _HiddenDrawerMenuState createState() => _HiddenDrawerMenuState();
}

class _HiddenDrawerMenuState extends State<HiddenDrawerMenu> with TickerProviderStateMixin{

  /// Curves to animations
  Curve _animationCurve;

  /// controlling block
  HiddenDrawerMenuBloc _bloc;

  @override
  void initState() {

    _bloc = HiddenDrawerMenuBloc(widget,this);
    _animationCurve = new Interval(0.0, 1.0, curve: widget.curveAnimation);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Stack(
      children: [
        StreamBuilder(
          stream: _bloc.listItensMenu.stream,
          initialData: new List<ItemHiddenMenu>(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.data.length > 0) {
              return HiddenMenu(
                itens: snapshot.data,
                background: widget.backgroundMenu,
                backgroundColorMenu: widget.backgroundColorMenu,
                initPositionSelected: widget.initPositionSelected,
                enableShadowItensMenu: widget.enableShadowItensMenu,
                selectedListern: (position) {
                  _bloc.positionSelected.sink.add(position);
                },
              );
            } else {
              return Container();
            }
          },
        ),
        createContentDisplay()
      ],
    );
  }

  createContentDisplay() {
    return animateContent(Container(
      decoration: BoxDecoration(
          image: widget.backgroundContent,
          color: widget.backgroundColorContent),
      child: new Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: widget.backgroundColorAppBar,
          elevation: widget.elevationAppBar,
          title: getTittleAppBar(),
          leading: new IconButton(
              icon: widget.iconMenuAppBar,
              onPressed: () {
                _bloc.toggle();
              }),
          actions: widget.actionsAppBar,
        ),
        body: StreamBuilder(
            stream: _bloc.screenSelected.stream,
            initialData: Container(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              return snapshot.data;
            }),
      ),
    ));
  }

  animateContent(Widget content) {
    return StreamBuilder(
        stream: _bloc.contollerAnimation.stream,
        initialData: new HiddenDrawerController(vsync: this),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          var animatePercent;
          var _controller = snapshot.data;

          switch (_controller.state) {
            case MenuState.closed:
              animatePercent = 0.0;
              break;
            case MenuState.open:
              animatePercent = 1.0;
              break;
            case MenuState.opening:
              animatePercent = _animationCurve.transform(_controller.percentOpen);
              break;
            case MenuState.closing:
              animatePercent = _animationCurve.transform(_controller.percentOpen);
              break;
          }

          final slideAmount = 275.0 * animatePercent;
          final contentScale = 1.0 - (0.2 * animatePercent);
          final contentPerspective = 0.4 * animatePercent;
          final cornerRadius = 10.0 * animatePercent;

          return Transform(
            transform: new Matrix4.translationValues(slideAmount, 0.0, 0.0)
              ..setEntry(3, 2, 0.001)
              ..rotateY(contentPerspective)
              ..scale(contentScale, contentScale),
            alignment: Alignment.centerLeft,
            child: Container(
              decoration: new BoxDecoration(
                boxShadow: [
                  new BoxShadow(
                    color: const Color(0x44000000),
                    offset: const Offset(0.0, 5.0),
                    blurRadius: 20.0,
                    spreadRadius: 10.0,
                  ),
                ],
              ),
              child: new ClipRRect(
                  borderRadius: new BorderRadius.circular(cornerRadius),
                  child: content),
            ),
          );
        });
  }

  getTittleAppBar() {
    if (widget.tittleAppBar == null) {
      return StreamBuilder(
          stream: _bloc.tittleAppBar.stream,
          initialData: "",
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            return widget.whithAutoTittleName
                ? Text(
              snapshot.data,
              style: widget.styleAutoTittleName,
            )
                : Container();
          });
    } else {
      return widget.tittleAppBar;
    }
  }

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }

}
