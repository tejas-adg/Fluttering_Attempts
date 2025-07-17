# Fluttering Attempts

My attempts at fluttering around and finding out

This is the branch where I created my first flutter app all on my own, by following the [guide](https://codelabs.developers.google.com/codelabs/flutter-codelab-first) of-course

The `pubspec.yaml` file specifies basic information about your app, such as its current version, its dependencies, and the assets with which it will ship.

Next, open another configuration file in the project, `analysis_options.yaml`. This file determines how strict Flutter should be when analyzing your code. Since this is your first foray into Flutter, you're telling the analyzer to take it easy. You can always tune this later. In fact, as you get closer to publishing an actual production app, you will almost certainly want to make the analyzer stricter than this.

Note: Flutter works with logical pixels as a unit of length. They are also sometimes called device-independent pixels. A padding of 8 pixels is visually the same regardless of whether the app is running on an old low-res phone or a newer ‘retina' device. There are roughly 38 logical pixels per centimeter, or about 96 logical pixels per inch, of the physical display.
