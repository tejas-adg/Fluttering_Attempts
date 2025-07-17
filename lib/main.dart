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
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
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

  /* Added a new property to MyAppState called favorites.
  This property is initialized with an empty set: {}.

  also specified that the set can only ever contain
  word pairs: <WordPair>{}, using generics. 
  This helps make your app more robust,
  Dart refuses to run your app if you try
  to add anything other than WordPair to it.
  
  In turn, you can use the favorites set
  knowing that there can never be any unwanted
  objects (like null) hiding in there.*/
  var favorites = <WordPair>{}; // A set to store favorite word pairs

  /* The toggleFavorite method adds the current word pair to the favorites set
  
  either removes the current word pair from the set
  of favorites (if it's already there), or adds it
  (if it isn't there yet). In either case, the code
  calls notifyListeners(); afterwards. */
  void toggleFavorite() {
    if (favorites.contains(current)) {
      favorites.remove(current);
    } else {
      favorites.add(current);
    }
    notifyListeners();
  }
}

// ...

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

/* The underscore (_) at the start of _MyHomePageState makes
the class private and is enforced by the compiler.
If you want to know more about privacy in Dart,
and other topics, read the Language Tour. https://dart.dev/language/libraries*/
class _MyHomePageState extends State<MyHomePage> {
  var currentIndex = 0;

  /* Every widget defines a build() method
  that's automatically called every time the widget's circumstances change
  so that the widget is always up to date. */
  @override
  Widget build(BuildContext context) {

    Widget page;
    switch (currentIndex) {
      case 0:
        page = GeneratorPage();
        break;
      case 1:
        page = Placeholder();
        break;
      default:
        throw UnimplementedError('no widget for $currentIndex');
    }

    /* Every build method must return a widget
    or (more typically) a nested tree of widgets.
    In this case, the top-level widget is Scaffold.
    You aren't going to work with Scaffold in this guide,
    but it's a helpful widget and is found in the vast majority of real-world Flutter apps.*/

    /*
    LayoutBuilder's builder callback is called every time the constraints change.
    
    This happens when, for example:
      - The user resizes the app's window
      - The user rotates their phone from portrait mode to landscape mode, or back
      - Some widget next to MyHomePage grows in size, making MyHomePage's constraints smaller
    */
    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          body: Row(
            children: [
              /* The SafeArea ensures that its child is
              not obscured by a hardware notch or a status bar.
              In this app, the widget wraps around NavigationRail
              to prevent the navigation buttons from being obscured
              by a mobile status bar, for example.*/
              SafeArea(
                child: NavigationRail(
                  /*change the extended: `false` 
                  line in NavigationRail to `true`.
                  This shows the labels next to the icons.
                  In a future step, you will learn how to
                  do this automatically when the app has
                  enough horizontal space.*/
                  extended: constraints.maxWidth >= 600,
                  destinations: [
                    NavigationRailDestination(
                      icon: Icon(Icons.home),
                      label: Text('Home'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.favorite),
                      label: Text('Favorites'),
                    ),
                  ],
                  /* A selected index of zero selects the first destination,
                  a selected index of one selects the second destination, and so on...
                  For now, it's hard coded to zero.*/
                  selectedIndex: currentIndex,
                  onDestinationSelected: (value) {
                    /*is similar to the notifyListeners() method used previously
                    it makes sure that the UI updates.*/
                    setState(() {
                      currentIndex = value;
                    });
                  },
                ),
              ),
              Expanded(
                child: Container(
                  color: Theme.of(context).colorScheme.primaryFixed,
                  child: page, // current page based on the selected index
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class GeneratorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    /* MyHomePage tracks changes to the app's current state using the watch method.*/
    var appState = context.watch<MyAppState>();
    var currentPair = appState.current;

    IconData favoriteIcon = appState.favorites.contains(currentPair)
        ? Icons.favorite
        : Icons.favorite_border;

    return Center(
      
      /* Column is one of the most basic layout widgets in Flutter.
      It takes any number of children and puts them in a column from top to bottom.
      By default, the column visually places its children at the top.
      You'll soon change this so that the column is centered.*/
      child: Column(
        // Centers the column's children vertically
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          PairDisplayCard(displayedPair: currentPair),
          SizedBox(height: 10),
          Row(
            // mainAxisSize.min is used so the row only takes up as much horizontal space as its children need.
            mainAxisSize: MainAxisSize.min, // Takes up space only as needed
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  // Calls the toggleFavorite method in MyAppState
                  appState.toggleFavorite();
                },
                icon: Icon(favoriteIcon),
                label: Text('favorite'),
              ),
              SizedBox(width: 10), // Adds space between the buttons
              ElevatedButton(
                onPressed: () {
                  // print("button pressed"); // This prints to the console
                  // Calls the getNext method in MyAppState to get a new word pair
                  appState.getNext();
                },
                child: Text('next'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ...

class PairDisplayCard extends StatelessWidget {
  const PairDisplayCard({super.key, required this.displayedPair});

  final WordPair displayedPair;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      color: theme.colorScheme.primary,
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Text(
          displayedPair.asLowerCase,
          style: theme.textTheme.displayMedium!.copyWith(
            color: theme.colorScheme.onPrimary,
          ),
          semanticsLabel: "${displayedPair.first} ${displayedPair.second}",
        ),
      ),
    );
  }
}
