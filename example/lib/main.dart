import 'package:flutter/material.dart';
import 'package:popup_menu/popup_menu.dart';

import 'gesture_demo.dart';

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
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late PopupMenu menu;
  GlobalKey btnKey = GlobalKey();
  GlobalKey btnKey2 = GlobalKey();
  GlobalKey btnKey3 = GlobalKey();

  @override
  void initState() {
    super.initState();

    menu = PopupMenu(
      items: [
        // MenuItem(title: 'Copy', image: Image.asset('assets/copy.png')),
        // MenuItem(title: 'Home', image: Icon(Icons.home, color: Colors.white,)),
        MenuItem(
            title: 'Mail',
            textAlign: TextAlign.center,
            textStyle: TextStyle(
              color: Color(0xffc5c5c5),
              fontSize: 10.0,
            ),
            image: Icon(
              Icons.mail,
              color: Colors.white,
            )),
        MenuItem(
            title: 'Power',
            textAlign: TextAlign.center,
            textStyle: TextStyle(
              color: Color(0xffc5c5c5),
              fontSize: 10.0,
            ),
            image: Icon(
              Icons.power,
              color: Colors.white,
            )),
        MenuItem(
            title: 'Setting',
            textAlign: TextAlign.center,
            textStyle: TextStyle(
              color: Color(0xffc5c5c5),
              fontSize: 10.0,
            ),
            image: Icon(
              Icons.settings,
              color: Colors.white,
            )),
        MenuItem(
            title: 'PopupMenu',
            textAlign: TextAlign.center,
            textStyle: TextStyle(
              color: Color(0xffc5c5c5),
              fontSize: 10.0,
            ),
            image: Icon(
              Icons.menu,
              color: Colors.white,
            ))
      ],
      onClickMenu: onClickMenu,
      onDismiss: onDismiss,
      maxColumn: 4,
      context: context,
    );
  }

  void stateChanged(bool isShow) {
    print('menu is ${isShow ? 'showing' : 'closed'}');
  }

  void onClickMenu(MenuItemProvider item) {
    print('Click menu -> ${item.menuTitle}');
  }

  void onDismiss() {
    print('Menu is dismiss');
  }

  @override
  Widget build(BuildContext context) {
    PopupMenu.context = context;

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
    menu.show(widgetKey: btnKey3);
  }

  void onGesturesDemo() {
    menu.dismiss();
    return;
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => GestureDemo()),
    );
  }

  void checkState(BuildContext context) {
    final snackBar = new SnackBar(content: new Text('这是一个SnackBar!'));

    Scaffold.of(context).showSnackBar(snackBar);
  }

  void maxColumn() {
    PopupMenu menu = PopupMenu(
        // backgroundColor: Colors.teal,
        // lineColor: Colors.tealAccent,
        maxColumn: 3,
        items: [
          MenuItem(
            title: 'Copy',
            textAlign: TextAlign.center,
            textStyle: TextStyle(
              color: Color(0xffc5c5c5),
              fontSize: 10.0,
            ),
            image: Image.asset('assets/copy.png'),
          ),
          // MenuItem(
          //     title: 'Home',
          //     // textStyle: TextStyle(fontSize: 10.0, color: Colors.tealAccent),
          //     image: Icon(
          //       Icons.home,
          //       color: Colors.white,
          //     )),
          // MenuItem(
          //     title: 'Mail',
          //     image: Icon(
          //       Icons.mail,
          //       color: Colors.white,
          //     )),
          MenuItem(
            title: 'Power',
            textAlign: TextAlign.center,
            textStyle: TextStyle(
              color: Color(0xffc5c5c5),
              fontSize: 10.0,
            ),
            image: Icon(
              Icons.power,
              color: Colors.white,
            ),
          ),
          MenuItem(
            title: 'Setting',
            textAlign: TextAlign.center,
            textStyle: TextStyle(
              color: Color(0xffc5c5c5),
              fontSize: 10.0,
            ),
            image: Icon(
              Icons.settings,
              color: Colors.white,
            ),
          ),
          MenuItem(
            title: 'PopupMenu',
            textAlign: TextAlign.center,
            textStyle: TextStyle(
              color: Color(0xffc5c5c5),
              fontSize: 10.0,
            ),
            image: Icon(
              Icons.menu,
              color: Colors.white,
            ),
          )
        ],
        onClickMenu: onClickMenu,
        stateChanged: stateChanged,
        onDismiss: onDismiss,
        context: context);
    menu.show(widgetKey: btnKey);
  }

  //
  void customBackground() {
    PopupMenu menu = PopupMenu(
        // backgroundColor: Colors.teal,
        // lineColor: Colors.tealAccent,
        // maxColumn: 2,
        items: [
          MenuItem(
            title: 'Copy',
            textAlign: TextAlign.center,
            textStyle: TextStyle(
              color: Color(0xffc5c5c5),
              fontSize: 10.0,
            ),
            image: Image.asset('assets/copy.png'),
          ),
          MenuItem(
            title: 'Home',
            textAlign: TextAlign.center,
            textStyle: TextStyle(
              color: Color(0xffc5c5c5),
              fontSize: 10.0,
            ),
            // textStyle: TextStyle(fontSize: 10.0, color: Colors.tealAccent),
            image: Icon(
              Icons.home,
              color: Colors.white,
            ),
          ),
          MenuItem(
            title: 'Mail',
            textAlign: TextAlign.center,
            textStyle: TextStyle(
              color: Color(0xffc5c5c5),
              fontSize: 10.0,
            ),
            image: Icon(
              Icons.mail,
              color: Colors.white,
            ),
          ),
          MenuItem(
            title: 'Power',
            textAlign: TextAlign.center,
            textStyle: TextStyle(
              color: Color(0xffc5c5c5),
              fontSize: 10.0,
            ),
            image: Icon(
              Icons.power,
              color: Colors.white,
            ),
          ),
          MenuItem(
            title: 'Setting',
            textAlign: TextAlign.center,
            textStyle: TextStyle(
              color: Color(0xffc5c5c5),
              fontSize: 10.0,
            ),
            image: Icon(
              Icons.settings,
              color: Colors.white,
            ),
          ),
          MenuItem(
            title: 'PopupMenu',
            textAlign: TextAlign.center,
            textStyle: TextStyle(
              color: Color(0xffc5c5c5),
              fontSize: 10.0,
            ),
            image: Icon(
              Icons.menu,
              color: Colors.white,
            ),
          )
        ],
        onClickMenu: onClickMenu,
        stateChanged: stateChanged,
        onDismiss: onDismiss,
        context: context);
    menu.show(widgetKey: btnKey2);
  }
}
