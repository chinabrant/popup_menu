import 'package:flutter/material.dart';
import 'package:popup_menu/popup_menu.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  /// Menu key. [GlobalKey].
  GlobalKey menuKey1 = GlobalKey();

  /// Menu key. [GlobalKey].
  GlobalKey menuKey2 = GlobalKey();

  /// Menu key. [GlobalKey].
  GlobalKey menuKey3 = GlobalKey();

  /// Menu key. [GlobalKey].
  GlobalKey menuKey4 = GlobalKey();

  /// Menu key. [GlobalKey].
  GlobalKey menuKey5 = GlobalKey();

  PopupMenu get menu1 => PopupMenu(
        context,
        menuKey1,
        maxRowItemLength: 3,
        itemHeight: 25.0,
        itemWidth: 30.0,
        boxDecoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(10.0),
        ),
        onPress: (index, menu) {
          print('$index');
        },
        menuActions: [
          PopupAction(
            item: const Icon(Icons.home),
          ),
          PopupAction(
            item: const Icon(Icons.settings),
          ),
          PopupAction(
            item: const Icon(Icons.person),
          ),
          PopupAction(
            item: const Icon(Icons.note_outlined),
          )
        ],
      );

  PopupMenu get menu2 => PopupMenu(
        context,
        menuKey2,
        maxRowItemLength: 1,
        onPress: (index, menu) {
          print('$index');
          menu.close();
        },
        mainAxisSpacing: 0.0,
        crossAxisSpacing: 0.0,
        color: Colors.red,
        itemWidth: 150.0,
        // offsetBox: const Offset(25.0, 0.0),
        duration: const Duration(seconds: 2),
        builder: (context, animation, child) {
          return ShaderMask(
            shaderCallback: (rect) => RadialGradient(
              colors: const [
                Colors.white,
                Colors.transparent,
              ],
              center: const FractionalOffset(0.0, .5),
              stops: const [1.0, 0.0],
              radius: Curves.easeOutCirc.transform(animation.value) * 1.5,
            ).createShader(rect),
            child: child,
          );
        },
        menuActions: [
          PopupAction(
            item: const Icon(Icons.settings),
            title: 'Settings screen',
            color: Colors.white,
          ),
          PopupAction(
            item: const Icon(Icons.home),
            title: 'Home Settings',
          ),
          PopupAction(
            item: const Icon(Icons.person),
            title: 'Person',
          ),
          PopupAction(
            item: const Icon(Icons.notification_add),
            title: 'Notifications',
          ),
          PopupAction(
            item: const Icon(Icons.umbrella),
            title: 'Umbrealla :)',
          ),
          PopupAction(
            item: const Icon(Icons.alarm),
            title: 'Alarms',
          ),
        ],
      );

  PopupMenu get menu3 => PopupMenu(
        context,
        menuKey3,
        maxRowItemLength: 1,
        boxDecoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.circular(10.0),
        ),
        onPress: (index, menu) {
          print('$index');
          menu.close();
        },
        mainAxisSpacing: 0.0,
        crossAxisSpacing: 10.0,
        itemWidth: 130.0,
        // offsetBox: const Offset(25.0, 0.0),
        duration: const Duration(seconds: 2),
        builder: (context, animation, child) {
          final anim = Tween<double>(begin: 0.5, end: 1.0).animate(
            CurvedAnimation(parent: animation, curve: Curves.easeOutCirc),
          );
          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..scale(
                anim.value,
                anim.value,
              ),
            child: Opacity(
              opacity: animation.value,
              child: child,
            ),
          );
        },
        menuActions: [
          PopupAction(
            item: const Icon(Icons.home),
            title: 'Home Settings',
          ),
          PopupAction(
            item: const Icon(Icons.person),
            title: 'Person',
          ),
          PopupAction(
            item: const Icon(Icons.notification_add),
            title: 'Notifications',
          ),
          PopupAction(
            item: const Icon(Icons.settings),
            title: 'Settings screen',
          ),
          PopupAction(
            item: const Icon(Icons.umbrella),
            title: 'Umbrealla :)',
          ),
          PopupAction(
            item: const Icon(Icons.alarm),
            title: 'Alarms',
          ),
        ],
      );

  PopupMenu get menu4 => PopupMenu(
        context,
        menuKey4,
        boxDecoration: BoxDecoration(
          color: Colors.orange,
          borderRadius: BorderRadius.circular(10.0),
        ),
        maxRowItemLength: 2,
        offsetBox: const Offset(0.0, -10.0),
        menuActions: [
          PopupAction(
            item: const Icon(Icons.set_meal),
            title: 'Home Home Home Home',
          ),
          PopupAction(
            item: const Icon(Icons.tab_outlined),
            title: 'Home',
          ),
          PopupAction(
            item: const Icon(Icons.face_retouching_natural),
            title: 'Home',
          ),
          PopupAction(
            item: const Icon(Icons.safety_divider_rounded),
            title: 'Home',
          ),
          PopupAction(
            item: const Icon(Icons.cable),
            title: 'Home',
          ),
          PopupAction(
            item: const Icon(Icons.umbrella_outlined),
            title: 'Home',
          ),
        ],
        onPress: (index, menu) {
          if (index == 0) {}
        },
      );

  PopupMenu get menu5 => PopupMenu(
        context,
        menuKey5,
        maxRowItemLength: 4,
        itemWidth: 60.0,
        boxDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: Colors.black.withOpacity(.3),
        ),
        onPress: (index, menu) {
          print('$index');
        },
        menuActions: [
          PopupAction(
            item: const Icon(Icons.home),
            title: 'Home',
            color: Colors.orange,
          ),
          PopupAction(
            item: const Icon(Icons.settings),
            title: 'Settings',
            color: Colors.blue,
          ),
          PopupAction(
            item: const Icon(Icons.person),
            title: 'Person',
            color: Colors.white,
          ),
          PopupAction(
            item: const Icon(Icons.note_outlined),
            title: 'Notes',
            color: Colors.indigoAccent,
          )
        ],
      );

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Text(
            'PopupMenu Example',
            style: TextStyle(
              color: Colors.black,
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            IconButton(
              key: menuKey4,
              onPressed: () {
                menu4.showMenu();
              },
              icon: const Icon(Icons.more_vert),
              color: Colors.black,
              iconSize: 30.0,
            )
          ],
        ),
        body: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: MaterialButton(
                key: menuKey1,
                onPressed: () {
                  menu1.showMenu();
                },
                child: const Text('MENU 1'),
                color: Colors.blue,
              ),
            ),
            Center(
              child: MaterialButton(
                key: menuKey2,
                onPressed: () {
                  menu2.showMenu();
                },
                child: const Text('MENU 2'),
                color: Colors.blue,
              ),
            ),
            Center(
              child: MaterialButton(
                key: menuKey3,
                onPressed: () {
                  menu3.showMenu();
                },
                child: const Text('MENU 3'),
                color: Colors.blue,
              ),
            ),
            Center(
              child: MaterialButton(
                key: menuKey5,
                onPressed: () {
                  menu5.showMenu();
                },
                child: const Text('MENU 4'),
                color: Colors.blue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
