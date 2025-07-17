import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp()); // tells Flutter to run the app defined in MyApp
}

/* The MyApp class extends StatelessWidget. 
Widgets are the elements from which you build every Flutter app. 
As you can see, even the app itself is a widget.

The code in MyApp sets up the whole app. 
It creates the app-wide state (more on this later), 
names the app, defines the visual theme, 
and sets the "home" widget—the starting point of your app. */
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Fluttering Attempts',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

/* The app-wide state for the MyApp widget

Next, the MyAppState class defines the app's...well...state.
There are many powerful ways to manage app state in Flutter. 

One of the easiest to explain is ChangeNotifier, the approach taken by this app.

    - MyAppState defines the data the app needs to function. 
      Right now, it only contains a single variable with the current random word pair.
      You will add to this later.

    - The state class extends ChangeNotifier,
      which means that it can notify others about its own changes.
      For example, if the current word pair changes, some widgets in the app need to know.

    - The state is created and provided to the whole app
      using a ChangeNotifierProvider (see code above in MyApp).
      This allows any widget in the app to get hold of the state.

                 +-----------------+         +--------------+
                 |           |X|---|---------|  MyAppState  |
                 |      MyApp      |         +--------------+
                 |                 |                 
                 +-----------------+                 ^
                        |                            |
                        v                            |
                 +-----------------+                 |
                 |   MyHomePage    |              watches &
                 +-----------------+                uses
                   /           \                     |
                  v             v                    |
           +-------------+  +-------------+          |
           | SomeWidget  |  | OtherWidget |----------|
           +-------------+  +-------------+
  
 */
class MyAppState extends ChangeNotifier {
  var current = WordPair.random();

  void getNext() {
    current = WordPair.random();
    notifyListeners(); // Notifies all widgets that are listening to this state (a method of ChangeNotifier)
    // ensures that anyone watching MyAppState is notified.
  }
}

class MyHomePage extends StatelessWidget {

  /* Every widget defines a build() method
  that's automatically called every time the widget's circumstances change
  so that the widget is always up to date. */
  @override
  Widget build(BuildContext context) {
    /* MyHomePage tracks changes to the app's current state using the watch method.*/
    var appState = context.watch<MyAppState>();

    /* Every build method must return a widget
    or (more typically) a nested tree of widgets.
    In this case, the top-level widget is Scaffold.
    You aren't going to work with Scaffold in this guide,
    but it's a helpful widget and is found in the vast majority of real-world Flutter apps.*/
    return Scaffold(
      /* Column is one of the most basic layout widgets in Flutter.
      It takes any number of children and puts them in a column from top to bottom.
      By default, the column visually places its children at the top.
      You'll soon change this so that the column is centered.*/
      body: Column(
        children: [
          Text('A random AWESOME idea:'),
          Text(appState.current.asLowerCase),

          ElevatedButton(
            onPressed: () {
              // print("button pressed"); // This prints to the console
              appState
                  .getNext(); // Calls the getNext method in MyAppState to get a new word pair
            },
            child: Text("next"),
          ),
        ],
      ),
    );
  }
}
