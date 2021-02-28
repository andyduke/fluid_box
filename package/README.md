# Fluid

With the `Fluid` widget, you can build responsive interfaces based on width constraints and proportional fill space. For example, this is useful for creating responsive forms. 

## Explanation

The `Fluid` widget allows you to set the horizontal arrangement of widgets with a proportional division of the available width and the minimum width for each, if the widgets cannot be placed on one line due to lack of space, then the wrapping occurs and the width of the available space is distributed in a new line according to the specified constraint.

Children should always be wrapped in a `Fluidable` widget, in which you can set the fluid factor parameter `fluid` to specify the multiplier for the distribution of the parent's width (the default is 1), and the minimum width `minWidth` that the widget's width should not be less than (the minimum width can be omitted, then it will be determined based on the minimum width of the widget itself).

For Fluid, you can specify the horizontal `spacing` between items on the same line and the vertical `lineSpacing` between the lines.

## Examples

### Two widgets in a ratio of 50%/50%

![](https://github.com/andyduke/fluid_box/blob/master/screenshots/demo1.gif)

In this example, two widgets will be aligned horizontally and take up 50% of the parent's width if the parent's width is equal to or greater than the sum of the children minimum widths (400px). If the parent's width is less than 400px, then the second widget will be moved to a new line and each of them will occupy the entire width of the parent.

```dart
Fluid(
  children: [
    Fluidable(
      fluid: 1,
      minWidth: 200,
      child: Placeholder(),
    ),
    Fluidable(
      fluid: 1,
      minWidth: 200,
      child: Placeholder(),
    ),
  ],
),
```

### Two widgets in a ratio of 33%/66%

![](https://github.com/andyduke/fluid_box/blob/master/screenshots/demo2.gif)

In this example, two widgets will be lined up horizontally and the second widget will take up twice as much space as the first if the width of the parent is equal to or greater than the sum of the children minimum widths (650px). If the parent's width is less than 650px, then the second widget will be moved to a new line and each of them will occupy the entire width of the parent.

```dart
Fluid(
  children: [
    Fluidable(
      fluid: 1,
      minWidth: 200,
      child: Placeholder(),
    ),
    Fluidable(
      fluid: 2,
      minWidth: 450,
      child: Placeholder(),
    ),
  ],
),
```

### Three widgets in a ratio of 25%/60%/15%

![](https://github.com/andyduke/fluid_box/blob/master/screenshots/demo3.gif)

In this example, three widgets will be horizontally aligned and divide the parent's width in the following ratio 25%/60%/15% if the width of the parent is equal to or greater than the sum of the children minimum widths (600px). If the width of the parent is less than 600px, for example 520px, then the first and second widgets will divide the width of the parent in a ratio of 30%/70%, and the third widget will wrap to a new line and occupy the entire width of the parent.

```dart
Fluid(
  children: [
    Fluidable(
      fluid: 25,
      minWidth: 100,
      child: Placeholder(),
    ),
    Fluidable(
      fluid: 60,
      minWidth: 400,
      child: Placeholder(),
    ),
    Fluidable(
      fluid: 10,
      minWidth: 100,
      child: Placeholder(),
    ),
  ],
),
```
