import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';

class ScreenSizeTest extends StatefulWidget {
  final Size? minSize;
  final Widget child;
  final Duration duration;

  const ScreenSizeTest({
    Key? key,
    required this.child,
    this.minSize,
    this.duration = const Duration(seconds: 3),
  }) : super(key: key);

  @override
  _ScreenSizeTestState createState() => _ScreenSizeTestState();
}

class _ScreenSizeTestState extends State<ScreenSizeTest> with SingleTickerProviderStateMixin {
  late AnimationController controller;

  double? _screenHeight;
  // double? _screenHeightMax;
  double? _screenWidth;
  double? _screenWidthMax;

  final double _sliderHeight = 50;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    controller.addListener(() {
      setState(() {
        _screenWidth = lerpDouble((widget.minSize?.width ?? 0), _screenWidthMax, (1 - controller.value));
        // _screenWidth =
        //     (widget.minSize?.width ?? 0) + ((_screenWidthMax - (widget.minSize?.width ?? 0)) * (1 - controller.value));
      });
    });
  }

  @override
  void dispose() {
    controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (_screenWidth == null) _screenWidthMax = _screenWidth = constraints.maxWidth;
        if (_screenHeight == null) _screenHeight = constraints.maxHeight - (_sliderHeight * 2);

        // if (_screenWidth == null) _screenWidthMax = _screenWidth = MediaQuery.of(context).size.width;
        // if (_screenHeight == null)
        //   _screenHeightMax = _screenHeight = MediaQuery.of(context).size.height - (_sliderHeight * 2);

        return Column(
          children: [
            Expanded(
              child: Column(
                children: [
                  Container(
                    width: _screenWidth,
                    height: _screenHeight,
                    decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.black, width: 2))),
                    child: widget.child,
                  ),
                ],
              ),
            ),
            _buildSlider(
                min: widget.minSize?.width ?? 0.0,
                max: _screenWidthMax ?? 0.0,
                value: _screenWidth ?? 0.0,
                label: 'W : ',
                onChange: (value) {
                  if (value != 0.0) setState(() => _screenWidth = value);
                }),
            /*
        _buildSlider(
            min: widget.minSize?.height ?? 0.0,
            max: _screenHeightMax,
            label: 'H : ',
            value: _screenHeight,
            onChange: (value) {
              if (value != 0.0) setState(() => _screenHeight = value);
            }),
        */
            Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.only(bottom: 16),
              child: OutlinedButton(
                child: Text('Automate'),
                onPressed: () {
                  controller.forward(from: 0);
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSlider({
    required String label,
    required double min,
    required double max,
    required double value,
    Function()? onTap,
    Function(double)? onChange,
  }) {
    return Container(
      alignment: Alignment.center,
      height: _sliderHeight,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      width: double.infinity,
      child: Builder(
        builder: (context) => Scaffold(
          body: InkWell(
            onTap: onTap,
            child: Row(
              children: [
                Text(label + value.round().toStringAsFixed(2)),
                Expanded(
                  child: Slider(
                    max: math.max(min, max),
                    min: math.min(max, min),
                    value: math.max(value, min),
                    onChanged: onChange,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
