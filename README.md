<img src="popupmenu.png" >

[![pub package](https://img.shields.io/badge/pub-v1.0.4-blue.svg)](https://pub.dev/packages/popup_menu)

This project was writed with pure dart code，which means it's support both iOS and Android.

# Screenshot
<code><img height="300" src="https://user-images.githubusercontent.com/37551474/143927682-cec191be-b252-40fe-b0a3-fe2202af82b3.gif"></code>
<code><img height="300" src="https://user-images.githubusercontent.com/37551474/143927870-4b0dd246-e17f-445d-98b2-e474182f26eb.gif"></code>
<code><img height="300" src="https://user-images.githubusercontent.com/37551474/143927920-a77c25dc-39aa-4051-860a-6bfb7081eb42.gif"></code>
<code><img height="300" src="https://user-images.githubusercontent.com/37551474/143927928-1eaafc16-2a48-4ec6-a6e3-3fd2c25dd10a.gif"></code> 
<code><img height="300" src="https://user-images.githubusercontent.com/37551474/143927938-d6c62c18-ace5-46d5-b40a-4944b26e066a.gif"></code> 


## Added
- ## ♣  show/hide animation
- ## ♦  custumize box menu

### <p>A Flutter implementation of animation popup menu.</p>

# Usage
First, add popup_action as a dev dependecy in your pubspec.yaml file.

## Example

- First we need to create the PopupMenu object and throw it into a variable.
- PopupMenu needs  context [BuildContext] and key [GlobalKey].
- Which widget displaying popup menu include the key and in widget and popup menu object.
- If you want to customize menu, many features are available.
- And If you want animation to display menu, box you need builder 
-  builder  [MenuActionsBuilder] => Widget Function(
    BuildContext context, Animation<double> animation, Widget child);
- Call showMenu() Function for display the menu.


### Without Animations Example.
```dart

GlobalKey key = GlobalKey();

 PopupMenu get menu => PopupMenu(
     context,
     key,
     menuActions: [
        PopupAction(
        item: const Icon(Icons.home),
        title: '',
        style: const TextStyle(),
        color: const Colors.orange,
        decoration: const BoxDecoration(),
        ),
        PopupAction(
        item: const Icon(Icons.home),
        color: Colors.orange,
        ),
        PopupAction(item: const Icon(Icons.home))
     ],
 );

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: MaterialButton(
                key: key,
                onPressed: () {
                  menu.showMenu();
                },
                child: const Text('MENU 1'),
                color: Colors.blue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

### With Animations Example.

 - Builder (BuildContext,Animation,child) returns widget

 ```dart
 builder: (context, animation, child) {
          return ShaderMask(
            shaderCallback: (rect) => RadialGradient(
              colors: const [
                Colors.white,
                Colors.transparent,
              ],
              center: const FractionalOffset(0.0, .5),
              stops: const [1.0, 0.0],
              radius: Curves.easeOutCirc.transform(animation.value) * 3.0,
            ).createShader(rect),
            child: child,
          );
        },
 ```

``` dart
 GlobalKey key = GlobalKey();

 PopupMenu get menu => PopupMenu(
        context,
        key,
        maxColumnItemLength: 4,
        onPress: (index, menu) {
          print('$index');
          menu.close(); // close the menu.
        },
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
              radius: Curves.easeOutCirc.transform(animation.value) * 3.0,
            ).createShader(rect),
            child: child,
          );
        },
        menuActions: [
          PopupAction(
            item: const Icon(Icons.home),
            title: 'Home Home Home Home',
          ),
          PopupAction(
            item: const Icon(Icons.home),
            title: 'Home',
          ),
          PopupAction(
            item: const Icon(Icons.home),
            title: 'Home',
          ),
          PopupAction(
            item: const Icon(Icons.home),
            title: 'Home',
          ),
          PopupAction(
            item: const Icon(Icons.home),
            title: 'Home',
          ),
        ],
      );

@override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: MaterialButton(
                key: key,
                onPressed: () {
                  menu.showMenu();
                },
                child: const Text('MENU 1'),
                color: Colors.blue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```