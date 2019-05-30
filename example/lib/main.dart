import 'package:flutter/material.dart';
import 'package:popup_menu/popup_menu.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: MyHomePage(title: 'Popup Menu Example'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  PopupMenu menu;
  GlobalKey btnKey = GlobalKey();

  @override
  void initState() {
    super.initState();

    menu = PopupMenu(
      items: [
        // MenuItem(title: 'Copy', image: Image.asset('assets/copy.png')), 
        // MenuItem(title: 'Home', image: Icon(Icons.home, color: Colors.white,)), 
        // MenuItem(title: 'Mail', image: Icon(Icons.mail, color: Colors.white,)), 
        // MenuItem(title: 'Power', image: Icon(Icons.power, color: Colors.white,)),
        // MenuItem(title: 'Setting', image: Icon(Icons.settings, color: Colors.white,)), 
        MenuItem(title: 'PopupMenu', image: Icon(Icons.menu, color: Colors.white,))], 
      onClickMenu: onClickMenu, 
      onDismiss: onDismiss);
    
  }

  void onClickMenu(MenuItemProvider item) {
    print('Click menu -> ${item.menu_title}');
  }

  void onDismiss() {
    print('Menu is closed');
  }

  @override
  Widget build(BuildContext context) {
    PopupMenu.context = context;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: MaterialButton(
          key: btnKey,
          onPressed: () {
            menu.show(rect: getWidgetGlobalRect(btnKey));
          },
          child: Text('Show Menu'),
        ),
      ),
    );
  }

  Rect getWidgetGlobalRect(GlobalKey key) {
    RenderBox renderBox = key.currentContext.findRenderObject();
    var offset =  renderBox.localToGlobal(Offset.zero);
    return Rect.fromLTWH(offset.dx, offset.dy, renderBox.size.width, renderBox.size.height);
  }
}
