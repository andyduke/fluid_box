import 'dart:math';
import 'dart:ui';
import 'package:flutter/foundation.dart';
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
    List<Fluidable> children = const <Fluidable>[],
  }) : super(key: key, children: children);

  /// Defaults to 0.0.
  final double spacing;

  /// Defaults to 0.0.
  final double lineSpacing;

  @override
  _RenderFluid createRenderObject(BuildContext context) {
    return _RenderFluid(
      spacing: spacing,
      lineSpacing: lineSpacing,
    );
  }

  @override
  void updateRenderObject(BuildContext context, _RenderFluid renderObject) {
    renderObject
      ..spacing = spacing
      ..lineSpacing = lineSpacing;
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
  })  : _spacing = spacing,
        _lineSpacing = lineSpacing {
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
    required List<FluidParentData> parentData,
    required List<double> widths,
  }) {
    final List<double> fluidWidths = List.from(widths, growable: false);

    int totalFluid = 0;
    for (var lineIndex in line.indexes) {
      if (parentData[lineIndex].fluid != null) {
        totalFluid += parentData[lineIndex].fluid!;
      }
    }
    final double spacePerFluid = max(0.0, availableWidth / totalFluid);

    int minWidthCount = 0;
    double totalWidth = 0;
    double restWidth = availableWidth;
    for (var lineIndex in line.indexes) {
      final int fluid = (parentData[lineIndex].fluid != null)
          ? parentData[lineIndex].fluid!.clamp(1, totalFluid)
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

    final List<RenderBox> children = [];
    final List<FluidParentData> parentData = [];
    List<double> widths = [];
    final List<double> heights = [];
    final List<_RunLine> lines = [];

    // Collect child data and minWidth
    RenderBox? child = firstChild;
    while (child != null) {
      final double minWidth = child.getMinIntrinsicWidth(constraints.maxHeight);
      final double height = constraints.maxHeight;

      final FluidParentData childParentData =
          child.parentData as FluidParentData;

      children.add(child);
      parentData.add(childParentData);
      widths.add(minWidth);
      heights.add(height);

      child = childParentData.nextSibling;
    }

    // Now calculate which widgets go in which lines
    double x = 0;
    _RunLine line = _RunLine();
    lines.add(line);

    for (int index = 0; index < children.length; index++) {
      double width = widths[index];

      if (x > 0 && (x + width + spacing) > availableWidth) {
        widths = _fluidWidths(
          line: line,
          availableWidth: availableWidth,
          parentData: parentData,
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
      availableWidth: availableWidth,
      parentData: parentData,
      widths: widths,
    );

    // Relayout children to fill the width and calculating the height
    for (_RunLine line in lines) {
      for (int index in line.indexes) {
        children[index].layout(
          BoxConstraints(
            maxWidth: widths[index],
            maxHeight: constraints.maxHeight,
          ),
          parentUsesSize: true,
        );
        heights[index] = children[index].size.height;
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
      double x = 0;

      for (int index in line.indexes) {
        var childParentData = parentData[index];
        childParentData.offset = Offset(x, line.top);
        x += widths[index] + spacing;
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
