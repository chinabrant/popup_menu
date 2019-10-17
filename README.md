<img src="popupmenu.png" >

[![pub package](https://img.shields.io/badge/pub-v1.0.4-blue.svg)](https://pub.dev/packages/popup_menu)

This project was writed with pure dart code，which means it's support both iOS and Android.

# Screenshot
<img src="https://wx2.sinaimg.cn/mw1024/acbce940gy1g6hsz8566vj20ek06waa9.jpg" width="20%"><img src="https://wx3.sinaimg.cn/mw1024/acbce940gy1g6hsz86ki9j209u0am74i.jpg" width="20%"><img src="https://wx2.sinaimg.cn/mw1024/acbce940gy1g6hsz8a1t2j20eg0ac74q.jpg" width="20%">

# Todo
- [ ] show/hide animation

# Usage


You can find the demo at the 'example' folder.

First, you should set the context at somewhere in you code. Like below:
```dart
PopupMenu.context = context;
```
```dart
PopupMenu menu = PopupMenu(
      items: [
        MenuItem(title: 'Copy', image: Image.asset('assets/copy.png')), 
        MenuItem(title: 'Home', image: Icon(Icons.home, color: Colors.white,)), 
        MenuItem(title: 'Mail', image: Icon(Icons.mail, color: Colors.white,)), 
        MenuItem(title: 'Power', image: Icon(Icons.power, color: Colors.white,)),
        MenuItem(title: 'Setting', image: Icon(Icons.settings, color: Colors.white,)), 
        MenuItem(title: 'Traffic', image: Icon(Icons.traffic, color: Colors.white,))], 
      onClickMenu: onClickMenu, 
      stateChanged: stateChanged,
      onDismiss: onDismiss);

menu.show(rect: rect);

void stateChanged(bool isShow) {
  print('menu is ${ isShow ? 'showing': 'closed' }');
}
```

or

```dart
PopupMenu menu = PopupMenu(
        backgroundColor: Colors.teal,
        lineColor: Colors.tealAccent,
        maxColumn: 3,
        items: [
          MenuItem(title: 'Copy', image: Image.asset('assets/copy.png')),
          MenuItem(
              title: 'Home',
              textStyle: TextStyle(fontSize: 10.0, color: Colors.tealAccent),
              image: Icon(
                Icons.home,
                color: Colors.white,
              )),
          MenuItem(
              title: 'Mail',
              image: Icon(
                Icons.mail,
                color: Colors.white,
              )),
          MenuItem(
              title: 'Power',
              image: Icon(
                Icons.power,
                color: Colors.white,
              )),
          MenuItem(
              title: 'Setting',
              image: Icon(
                Icons.settings,
                color: Colors.white,
              )),
          MenuItem(
              title: 'PopupMenu',
              image: Icon(
                Icons.menu,
                color: Colors.white,
              ))
        ],
        onClickMenu: onClickMenu,
        onDismiss: onDismiss);
    menu.show(widgetKey: btnKey2);
```
