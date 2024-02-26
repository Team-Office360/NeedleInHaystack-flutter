import "package:flutter/material.dart";
import "package:needle_in_haystack_flutter/screens/home_screen.dart";

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Padding(
          padding: EdgeInsets.fromLTRB(20, 55, 20, 10),
          child: HomeScreen(),
        ),
      ),
    );
  }
}
