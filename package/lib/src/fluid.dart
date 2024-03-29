import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'fluidable.dart';

class Fluid extends MultiChildRenderObjectWidget {
  /// `Fluid` is like a `Wrap` with a fluid layout algorithm.
  ///
  /// Like a normal `Wrap` widget with `direction = Axis.horizontal`,
  /// `Fluid` displays its children in rows, but resizes it to fit
  /// `fluid` and `minWidth`.
  ///
  /// It will leave `spacing` horizontal space between each child,
  /// and it will leave `lineSpacing` vertical space between each line.
  ///
  Fluid({
    Key? key,
    this.spacing = 0.0,
    this.lineSpacing = 0.0,
    this.textDirection,
    List<Fluidable> children = const <Fluidable>[],
  }) : super(key: key, children: children);

  /// Defaults to 0.0.
  final double spacing;

  /// Defaults to 0.0.
  final double lineSpacing;

  /// Determines the order to lay children out horizontally.
  ///
  /// Defaults to the ambient [Directionality].
  ///
  /// If [textDirection] is [TextDirection.rtl], then the direction in which
  /// text flows starts from right to left. Otherwise, if [textDirection] is
  /// [TextDirection.ltr], then the direction in which text flows starts from
  /// left to right.
  final TextDirection? textDirection;

  /// The value to pass to [_RenderFluid.textDirection].
  ///
  /// This value is derived from the [textDirection] property and the ambient
  /// [Directionality]. The value is null if there is no need to specify the
  /// text direction.
  @protected
  TextDirection? _getEffectiveTextDirection(BuildContext context) {
    return textDirection ?? Directionality.maybeOf(context);
  }

  @override
  _RenderFluid createRenderObject(BuildContext context) {
    return _RenderFluid(
      spacing: spacing,
      lineSpacing: lineSpacing,
      textDirection: _getEffectiveTextDirection(context),
    );
  }

  @override
  void updateRenderObject(BuildContext context, _RenderFluid renderObject) {
    renderObject
      ..spacing = spacing
      ..lineSpacing = lineSpacing
      ..textDirection = _getEffectiveTextDirection(context);
  }
}

class _RenderFluid extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, FluidParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, FluidParentData> {
  _RenderFluid({
    List<RenderBox>? children,
    double spacing = 0.0,
    double lineSpacing = 0.0,
    TextDirection? textDirection,
  })  : _spacing = spacing,
        _lineSpacing = lineSpacing,
        _textDirection = textDirection {
    addAll(children);
  }

  /// Defaults to 0.0.
  double get spacing => _spacing;
  double _spacing;

  set spacing(double value) {
    if (_spacing == value) return;
    _spacing = value;
    markNeedsLayout();
  }

  /// Defaults to 0.0.
  double get lineSpacing => _lineSpacing;
  double _lineSpacing;

  set lineSpacing(double value) {
    if (_lineSpacing == value) return;
    _lineSpacing = value;
    markNeedsLayout();
  }

  /// Determines the order to lay children out horizontally.
  TextDirection? get textDirection => _textDirection;
  TextDirection? _textDirection;
  set textDirection(TextDirection? value) {
    if (_textDirection != value) {
      _textDirection = value;
      markNeedsLayout();
    }
  }

  @override
  void setupParentData(RenderBox child) {
    if (child.parentData is! FluidParentData)
      child.parentData = FluidParentData();
  }

  double _computeIntrinsicHeightForWidth(double width) {
    int runCount = 0;
    double height = 0.0;
    double runWidth = 0.0;
    double runHeight = 0.0;
    int childCount = 0;
    RenderBox? child = firstChild;
    while (child != null) {
      final double childWidth = child.getMaxIntrinsicWidth(double.infinity);
      final double childHeight = child.getMaxIntrinsicHeight(childWidth);
      if (runWidth + childWidth > width) {
        height += runHeight;
        if (runCount > 0) height += lineSpacing;
        runCount += 1;
        runWidth = 0.0;
        runHeight = 0.0;
        childCount = 0;
      }
      runWidth += childWidth;
      runHeight = max(runHeight, childHeight);
      if (childCount > 0) runWidth += spacing;
      childCount += 1;
      child = childAfter(child);
    }
    if (childCount > 0) height += runHeight + lineSpacing;
    return height;
  }

  @override
  double computeMinIntrinsicWidth(double height) {
    double width = 0.0;
    RenderBox? child = firstChild;
    while (child != null) {
      width = max(width, child.getMinIntrinsicWidth(double.infinity));
      child = childAfter(child);
    }
    return width;
  }

  @override
  double computeMaxIntrinsicWidth(double height) {
    double width = 0.0;
    RenderBox? child = firstChild;
    while (child != null) {
      width += child.getMaxIntrinsicWidth(double.infinity);
      child = childAfter(child);
    }
    return width;
  }

  @override
  double computeMinIntrinsicHeight(double width) {
    return _computeIntrinsicHeightForWidth(width);
  }

  @override
  double computeMaxIntrinsicHeight(double width) {
    return _computeIntrinsicHeightForWidth(width);
  }

  @override
  double? computeDistanceToActualBaseline(TextBaseline baseline) {
    return defaultComputeDistanceToHighestActualBaseline(baseline);
  }

  List<double> _fluidWidths({
    required _RunLine line,
    required double availableWidth,
    required List<_ChildInfo> children,
    required List<double> widths,
  }) {
    final List<double> fluidWidths = List.from(widths, growable: false);

    int totalFluid = 0;
    for (var lineIndex in line.indexes) {
      if (children[lineIndex].fluid != null) {
        totalFluid += children[lineIndex].fluid!;
      }
    }
    final double spacePerFluid = max(0.0, availableWidth / totalFluid);

    int minWidthCount = 0;
    double totalWidth = 0;
    double restWidth = availableWidth;
    for (var lineIndex in line.indexes) {
      final int fluid = (children[lineIndex].fluid != null)
          ? children[lineIndex].fluid!.clamp(1, totalFluid)
          : 1;
      final double minWidth = widths[lineIndex];

      double width = (fluid * spacePerFluid);
      if (width > restWidth) width = restWidth;
      if (width < minWidth) {
        width = minWidth;
        minWidthCount++;
      }

      fluidWidths[lineIndex] = width;
      restWidth -= width;
      totalWidth += width;
    }

    final int deltaCount = (line.indexes.length - minWidthCount);
    if ((deltaCount > 0) && (totalWidth > availableWidth)) {
      final double delta = (totalWidth - availableWidth) / deltaCount;
      for (var lineIndex in line.indexes) {
        if (fluidWidths[lineIndex] > widths[lineIndex]) {
          fluidWidths[lineIndex] -= delta;
        }
      }
    }

    return fluidWidths;
  }

  @override
  void performLayout() {
    final double availableWidth = constraints.maxWidth;

    final List<_ChildInfo> children = [];
    List<double> widths = [];
    final List<double> heights = [];
    final List<_RunLine> lines = [];

    // Collect child data and calculate fluid
    int totalFluid = 0;
    RenderBox? child = firstChild;
    while (child != null) {
      final FluidParentData childParentData =
          child.parentData as FluidParentData;
      if (childParentData.fluid != null) {
        totalFluid += childParentData.fluid!;
      }

      children.add(
        _ChildInfo(
          child: child,
          parentData: childParentData,
          fluid: childParentData.fluid,
          minWidth: childParentData.minWidth ?? 0,
        ),
      );

      child = childParentData.nextSibling;
    }
    final double minAvailableWidth = max(0.0, availableWidth / totalFluid);

    // Calculate child width & height
    for (var item in children) {
      double minWidth = item.child.getMinIntrinsicWidth(constraints.maxHeight);
      double maxWidth = item.child.getMaxIntrinsicWidth(constraints.maxHeight);
      double height = constraints.maxHeight;

      // If not a fixed size (TextField, etc.)
      if (minWidth != maxWidth) {
        item.child.layout(
          BoxConstraints(
            maxWidth: max(minAvailableWidth, item.minWidth),
            maxHeight: constraints.maxHeight,
          ),
          parentUsesSize: true,
        );
        minWidth = item.child.size.width;
        height = item.child.size.height;
      }

      widths.add(minWidth);
      heights.add(height);
    }

    // Now calculate which widgets go in which lines
    double x = 0;
    _RunLine line = _RunLine();
    lines.add(line);

    for (int index = 0; index < children.length; index++) {
      double width = widths[index];

      // Next line
      if (x > 0 && (x + width) > availableWidth) {
        widths = _fluidWidths(
          line: line,
          availableWidth:
              availableWidth - ((line.indexes.length - 1) * spacing),
          children: children,
          widths: widths,
        );

        x = 0;
        line = _RunLine();
        lines.add(line);
      }

      line.indexes.add(index);
      x += width + spacing;
    }

    // Calculating widths for the last line
    widths = _fluidWidths(
      line: line,
      availableWidth: availableWidth - ((line.indexes.length - 1) * spacing),
      children: children,
      widths: widths,
    );

    // Relayout children to fill the width and calculating the height
    for (_RunLine line in lines) {
      for (int index in line.indexes) {
        children[index].child.layout(
              BoxConstraints(
                maxWidth: widths[index],
                maxHeight: constraints.maxHeight,
              ),
              parentUsesSize: true,
            );
        heights[index] = children[index].child.size.height;
      }
    }

    // Calculation of the top and width of run lines
    double lineY = 0;
    for (_RunLine line in lines) {
      double maxY = 0;
      double lineX = 0;

      for (int index in line.indexes) {
        maxY = max(maxY, heights[index]);
        lineX += widths[index] + spacing;
      }

      line.width = lineX - spacing;
      line.top = lineY;

      lineY += maxY + lineSpacing;
    }

    // Positioning children
    for (_RunLine line in lines) {
      double x = (_textDirection == TextDirection.ltr) ? 0 : availableWidth;

      for (int index in line.indexes) {
        var childParentData = children[index].parentData;
        if (_textDirection == TextDirection.ltr) {
          childParentData.offset = Offset(x, line.top);
          x += widths[index] + spacing;
        } else {
          x -= widths[index];
          childParentData.offset = Offset(x, line.top);
          x -= spacing;
        }
      }
    }

    size = constraints.constrain(Size(availableWidth, lineY - lineSpacing));
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    return defaultHitTestChildren(result, position: position);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    defaultPaint(context, offset);
  }
}

class _RunLine {
  List<int> indexes = [];
  double width = 0;
  double top = 0;
}

class _ChildInfo {
  final RenderBox child;
  final FluidParentData parentData;
  final int? fluid;
  final double minWidth;

  _ChildInfo({
    required this.child,
    required this.parentData,
    required this.fluid,
    required this.minWidth,
  });
}
