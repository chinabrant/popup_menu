import 'package:flutter/material.dart';
import 'package:popup_menu/popup_menu.dart';

class GestureDemo extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _GestureDemoState();
  }
}

class _GestureDemoState extends State<GestureDemo> {
  GlobalKey btnKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scroll Gestures'),
      ),
      body: Stack(
        children: <Widget>[
          ListView.builder(
            itemCount: 20,
            itemBuilder: (context, index) {
              return Container(
                height: 50.0,
                child: Text('test'),
              );
            },
          ),
          Positioned(
            left: 100.0,
            top: 100.0,
            width: 100.0,
            height: 50.0,
            child: MaterialButton(
              key: btnKey,
              child: Text('show'),
              onPressed: onShow,
            ),
          )
        ],
      ),
    );
  }

  void onShow() {
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
          image: Icon(
            Icons.copy,
            color: Colors.white,
          ),
        ),
        MenuItem(
          title: 'Home',
          textAlign: TextAlign.center,
          textStyle: TextStyle(
            fontSize: 10.0,
            color: Colors.tealAccent,
          ),
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
          // userInfo: message,
        ),
        MenuItem(
          title: 'Power',
          textAlign: TextAlign.center,
          textStyle: TextStyle(color: Color(0xffc5c5c5), fontSize: 10.0),
          image: Icon(
            Icons.power,
            color: Colors.white,
          ),
          // userInfo: message,
        ),
        MenuItem(
          title: 'Setting',
          textAlign: TextAlign.center,
          textStyle: TextStyle(color: Color(0xffc5c5c5), fontSize: 10.0),
          image: Icon(
            Icons.settings,
            color: Colors.white,
          ),
          // userInfo: message,
        ),
        MenuItem(
          title: 'PopupMenu',
          textAlign: TextAlign.center,
          textStyle: TextStyle(color: Color(0xffc5c5c5), fontSize: 10.0),
          image: Icon(
            Icons.menu,
            color: Colors.white,
          ),
          // userInfo: message,
        )
      ],
      context: context,
      onClickMenu: onClickMenu,
      // stateChanged: stateChanged,
      // onDismiss: onDismiss,
    );
    menu.show(widgetKey: btnKey);
  }

  void onClickMenu(MenuItemProvider item) {}

  void onDismiss() {}
}
