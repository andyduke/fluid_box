import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'fluid.dart';

class Fluidable extends ParentDataWidget<FluidParentData> {
  Fluidable({
    Key key,
    this.flex = 1,
    this.minWidth,
    @required Widget child,
  })  : assert(flex != null),
        assert(flex > 0),
        super(
          key: key,
          child: ConstrainedBox(
            child: child,
            constraints: BoxConstraints(minWidth: minWidth ?? 0),
          ),
        );

  final int flex;

  final double minWidth;

  @override
  void applyParentData(RenderObject renderObject) {
    assert(renderObject.parentData is FluidParentData);
    final FluidParentData parentData = renderObject.parentData as FluidParentData;
    bool needsLayout = false;

    if (parentData.flex != flex) {
      parentData.flex = flex;
      needsLayout = true;
    }

    if (parentData.minWidth != minWidth) {
      parentData.minWidth = minWidth;
      needsLayout = true;
    }

    if (needsLayout) {
      final AbstractNode targetParent = renderObject.parent;
      if (targetParent is RenderObject) targetParent.markNeedsLayout();
    }
  }

  @override
  Type get debugTypicalAncestorWidgetClass => Fluid;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IntProperty('flex', flex));
    properties.add(DoubleProperty('minWidth', minWidth));
  }
}

class FluidParentData extends ContainerBoxParentData<RenderBox> {
  int flex;

  double minWidth;

  @override
  String toString() => '${super.toString()}; flex=$flex; minWidth=$minWidth';
}
