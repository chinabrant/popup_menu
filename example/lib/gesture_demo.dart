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
        PopUpMenuItem(title: 'Copy', image: Image.asset('assets/copy.png')),
        PopUpMenuItem(
            title: 'Home',
            // textStyle: TextStyle(fontSize: 10.0, color: Colors.tealAccent),
            image: Icon(
              Icons.home,
              color: Colors.white,
            )),
        PopUpMenuItem(
            title: 'Mail',
            image: Icon(
              Icons.mail,
              color: Colors.white,
            )),
        PopUpMenuItem(
            title: 'Power',
            image: Icon(
              Icons.power,
              color: Colors.white,
            )),
        PopUpMenuItem(
            title: 'Setting',
            image: Icon(
              Icons.settings,
              color: Colors.white,
            )),
        PopUpMenuItem(
            title: 'PopupMenu',
            image: Icon(
              Icons.menu,
              color: Colors.white,
            ))
      ],
      onClickMenu: onClickMenu,
      // stateChanged: stateChanged,
      onDismiss: onDismiss, context: context,
    );
    menu.show(widgetKey: btnKey);
  }

  void onClickMenu(MenuItemProvider item) {}

  void onDismiss() {}
}
