import 'package:flutter/material.dart';

class DisplaySize extends StatelessWidget {
  final Size fallbackSize;

  DisplaySize({
    Key? key,
    this.fallbackSize = const Size(1, 150),
  }) : super(key: key);

  final ValueNotifier<Size?> size = ValueNotifier(null);

  void _getSize(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final RenderBox rb = context.findRenderObject() as RenderBox;
      size.value = rb.size;
    });
  }

  @override
  Widget build(BuildContext context) {
    _getSize(context);

    return NotificationListener<SizeChangedLayoutNotification>(
      onNotification: (notification) {
        _getSize(context);
        return true;
      },
      child: SizeChangedLayoutNotifier(
        child: Container(
          width: double.infinity,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Placeholder(
                fallbackWidth: fallbackSize.width,
                fallbackHeight: fallbackSize.height,
              ),
              Container(
                color: Theme.of(context).scaffoldBackgroundColor,
                padding: const EdgeInsets.all(8.0),
                child: ValueListenableBuilder<Size?>(
                    valueListenable: size,
                    builder: (context, size, child) => Text(
                        (size != null) ? '${size.width.toStringAsFixed(1)}x${size.height.toStringAsFixed(1)}' : '')),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
