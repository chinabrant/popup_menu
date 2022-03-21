import 'package:flutter/material.dart';
import 'package:popup_menu/popup_menu.dart';
import 'package:popup_menu_example/gesture_demo.dart';

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
  GlobalKey btnKey2 = GlobalKey();
  GlobalKey btnKey3 = GlobalKey();
  GlobalKey btnKey4 = GlobalKey();

  @override
  void initState() {
    super.initState();
  }

  void onClickMenu(MenuItemProvider item) {
    print('Click menu -> ${item.menuTitle}');
  }

  void onDismiss() {
    print('Menu is dismiss');
  }

  void onShow() {
    print('Menu is show');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        alignment: Alignment.centerRight,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              color: Colors.blue,
              child: MaterialButton(
                height: 45.0,
                key: btnKey,
                onPressed: maxColumn,
                child: Text('Show Menu'),
              ),
            ),
            Container(
              child: MaterialButton(
                key: btnKey2,
                height: 45.0,
                onPressed: customBackground,
                child: Text('Show Menu'),
              ),
            ),
            Container(
              child: MaterialButton(
                key: btnKey3,
                height: 45.0,
                onPressed: onDismissOnlyBeCalledOnce,
                child: Text('Show Menu'),
              ),
            ),
            Container(
              child: MaterialButton(
                key: btnKey4,
                height: 45.0,
                onPressed: listMenu,
                child: Text('List Menu'),
              ),
            ),
            Container(
              child: MaterialButton(
                height: 30.0,
                child: Text('Gestures Demo'),
                onPressed: onGesturesDemo,
              ),
            )
          ],
        ),
      ),
    );
  }

  void onDismissOnlyBeCalledOnce() {
    menu = PopupMenu(
      context: context,
      items: [
        // MenuItem(title: 'Copy', image: Image.asset('assets/copy.png')),
        // MenuItem(title: 'Home', image: Icon(Icons.home, color: Colors.white,)),
        MenuItem(title: 'Mail', image: Icon(Icons.mail, color: Colors.white)),
        MenuItem(title: 'Power', image: Icon(Icons.power, color: Colors.white)),
        MenuItem(
            title: 'Setting', image: Icon(Icons.settings, color: Colors.white)),
        MenuItem(
            title: 'PopupMenu', image: Icon(Icons.menu, color: Colors.white))
      ],
      onClickMenu: onClickMenu,
      onDismiss: onDismiss,
    );
    menu.show(widgetKey: btnKey3);
  }

  void onGesturesDemo() {
    // return;
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => GestureDemo()),
    );
  }

  void maxColumn() {
    PopupMenu menu = PopupMenu(
      context: context,
      config: MenuConfig(maxColumn: 3),
      items: [
        MenuItem(title: 'Copy', image: Image.asset('assets/copy.png')),
        MenuItem(title: 'Power', image: Icon(Icons.power, color: Colors.white)),
        MenuItem(
            title: 'Setting', image: Icon(Icons.settings, color: Colors.white)),
        MenuItem(
            title: 'PopupMenu', image: Icon(Icons.menu, color: Colors.white))
      ],
      onClickMenu: onClickMenu,
      onDismiss: onDismiss,
    );
    menu.show(widgetKey: btnKey);
  }

  //
  void customBackground() {
    PopupMenu menu = PopupMenu(
        context: context,
        config: MenuConfig(
          backgroundColor: Color(0xffc1e0f7),
          lineColor: Colors.tealAccent,
        ),
        items: [
          MenuItem(title: 'Copy', image: Image.asset('assets/copy.png')),
          MenuItem(title: 'Home', image: Icon(Icons.home, color: Colors.white)),
          MenuItem(title: 'Mail', image: Icon(Icons.mail, color: Colors.white)),
          MenuItem(
              title: 'Power', image: Icon(Icons.power, color: Colors.white)),
          MenuItem(
              title: 'Setting',
              image: Icon(Icons.settings, color: Colors.white)),
          MenuItem(
              title: 'PopupMenu', image: Icon(Icons.menu, color: Colors.white))
        ],
        onClickMenu: onClickMenu,
        onDismiss: onDismiss);
    menu.show(widgetKey: btnKey2);
  }

  void listMenu() {
    PopupMenu menu = PopupMenu(
        context: context,
        config: MenuConfig.forList(),
        items: [
          // MenuItem.forList(
          //     title: 'Copy', image: Image.asset('assets/copy.png')),
          MenuItem.forList(
              title: 'Home',
              image: Icon(Icons.home, color: Color(0xFF181818), size: 20)),
          MenuItem.forList(
              title: 'Mail',
              image: Icon(Icons.mail, color: Color(0xFF181818), size: 20)),
          MenuItem.forList(
              title: 'Power',
              image: Icon(Icons.power, color: Color(0xFF181818), size: 20)),
          MenuItem.forList(
              title: 'Setting',
              image: Icon(Icons.settings, color: Color(0xFF181818), size: 20)),
          MenuItem.forList(
              title: 'PopupMenu',
              image: Icon(Icons.menu, color: Color(0xFF181818), size: 20))
        ],
        onClickMenu: onClickMenu,
        onShow: onShow,
        onDismiss: onDismiss);
    menu.show(widgetKey: btnKey4);
  }
}
