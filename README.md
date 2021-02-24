# fluid_box

Responsive helper for fluid layout. Allows you to control the layout of children based on constraints and grid.

## Getting Started

```dart
Fluid(
  children: [
    Fluidable(
      flex: 1,
      minWidth: 200,
      children: Placeholder(),
    ),
    Fluidable(
      flex: 2,
      minWidth: 450,
      children: Placeholder(),
    ),
  ],
),
```
