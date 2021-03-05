import 'package:fluid_kit_demo/display_size.dart';
import 'package:fluid_kit_demo/screen_size_test.dart';
import 'package:fluid_kit/fluid_kit.dart';
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
      debugShowCheckedModeBanner: false,
      home: DemoScreen(),
    );
  }
}

class DemoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: ScreenSizeTest(
          // minSize: Size.fromWidth(200),
          minSize: Size.fromWidth(450),
          // minSize: Size.fromWidth(400),
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Example 1
                // Fluid(
                //   children: [
                //     Fluidable(
                //       fluid: 1,
                //       minWidth: 200,
                //       child: DisplaySize(),
                //     ),
                //     Fluidable(
                //       fluid: 1,
                //       minWidth: 200,
                //       child: DisplaySize(),
                //     ),
                //   ],
                // ),

                // Example 2
                Fluid(
                  children: [
                    Fluidable(
                      fluid: 1,
                      minWidth: 200,
                      child: DisplaySize(),
                    ),
                    Fluidable(
                      fluid: 2,
                      minWidth: 450,
                      child: DisplaySize(),
                    ),
                  ],
                ),

                // Example 3
                // Fluid(
                //   children: [
                //     Fluidable(
                //       fluid: 25,
                //       minWidth: 100,
                //       child: DisplaySize(),
                //     ),
                //     Fluidable(
                //       fluid: 60,
                //       minWidth: 400,
                //       child: DisplaySize(),
                //     ),
                //     Fluidable(
                //       fluid: 15,
                //       minWidth: 100,
                //       child: DisplaySize(),
                //     ),
                //   ],
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
