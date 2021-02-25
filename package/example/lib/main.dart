import 'package:fluid_box/fluid_box.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fluid Demo',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: DemoScreen(),
    );
  }
}

class DemoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Fluid(
          children: [
            Fluidable(
              fluid: 1,
              minWidth: 300,
              child: Container(
                color: Color(0xFF25B2BD),
                height: 200,
                child: Placeholder(),
              ),
            ),
            Fluidable(
              fluid: 2,
              child: Container(
                constraints: BoxConstraints(
                  minWidth: 320,
                ),
                color: Color(0xFFC42690),
                height: 200,
                child: Placeholder(),
              ),
            ),
            Fluidable(
              fluid: 1,
              minWidth: 200,
              child: Container(
                color: Color(0xFF256BBD),
                height: 200,
                child: Placeholder(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
