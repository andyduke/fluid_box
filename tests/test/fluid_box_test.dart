import 'package:flutter/widgets.dart';
import 'package:fluid_kit/fluid_kit.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

void main() {
  testGoldens('Two widgets fits width', (tester) async {
    await tester.pumpWidgetBuilder(
      Container(
        decoration: BoxDecoration(
          border: Border.all(color: Color(0xFFFF0000), width: 1),
        ),
        child: Fluid(
          children: [
            Fluidable(
              fluid: 1,
              minWidth: 200,
              child: Container(
                color: Color(0xFF25B2BD),
                height: 200,
                child: Placeholder(),
              ),
            ),
            Fluidable(
              fluid: 1,
              minWidth: 200,
              child: Container(
                color: Color(0xFFC42690),
                height: 200,
                child: Placeholder(),
              ),
            ),
          ],
        ),
      ),
      surfaceSize: const Size(402 /* + border */, 200),
    );

    await screenMatchesGolden(tester, 'two_widgets_fits_width');
  });

  testGoldens('Two widgets fits min width (1/2)', (tester) async {
    await tester.pumpWidgetBuilder(
      Container(
        decoration: BoxDecoration(
          border: Border.all(color: Color(0xFFFF0000), width: 1),
        ),
        child: Fluid(
          children: [
            Fluidable(
              fluid: 1,
              minWidth: 200,
              child: Container(
                color: Color(0xFF25B2BD),
                height: 200,
                child: Placeholder(),
              ),
            ),
            Fluidable(
              fluid: 2,
              minWidth: 200,
              child: Container(
                color: Color(0xFFC42690),
                height: 200,
                child: Placeholder(),
              ),
            ),
          ],
        ),
      ),
      surfaceSize: const Size(402 /* + border */, 200),
    );

    await screenMatchesGolden(tester, 'two_widgets_fits_min_width_1_2');
  });

  testGoldens('Two widgets fits width (1/2)', (tester) async {
    await tester.pumpWidgetBuilder(
      Container(
        decoration: BoxDecoration(
          border: Border.all(color: Color(0xFFFF0000), width: 1),
        ),
        child: Fluid(
          children: [
            Fluidable(
              fluid: 1,
              minWidth: 200,
              child: Container(
                color: Color(0xFF25B2BD),
                height: 200,
                child: Placeholder(),
              ),
            ),
            Fluidable(
              fluid: 2,
              minWidth: 200,
              child: Container(
                color: Color(0xFFC42690),
                height: 200,
                child: Placeholder(),
              ),
            ),
          ],
        ),
      ),
      surfaceSize: const Size(602 /* + border */, 200),
    );

    await screenMatchesGolden(tester, 'two_widgets_fits_width_1_2');
  });

  testGoldens('Three widgets, wrap to next line', (tester) async {
    await tester.pumpWidgetBuilder(
      Container(
        decoration: BoxDecoration(
          border: Border.all(color: Color(0xFFFF0000), width: 1),
        ),
        child: Fluid(
          children: [
            Fluidable(
              fluid: 1,
              minWidth: 200,
              child: Container(
                color: Color(0xFF25B2BD),
                height: 200,
                child: Placeholder(),
              ),
            ),
            Fluidable(
              fluid: 1,
              minWidth: 200,
              child: Container(
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
      surfaceSize: const Size(502 /* + border */, 400),
    );

    await screenMatchesGolden(tester, 'three_widgets_wrap_next_line');
  });

  testGoldens('Three widgets (1/2/1), wrap to next line', (tester) async {
    await tester.pumpWidgetBuilder(
      Container(
        decoration: BoxDecoration(
          border: Border.all(color: Color(0xFFFF0000), width: 1),
        ),
        child: Fluid(
          children: [
            Fluidable(
              fluid: 1,
              minWidth: 200,
              child: Container(
                color: Color(0xFF25B2BD),
                height: 200,
                child: Placeholder(),
              ),
            ),
            Fluidable(
              fluid: 2,
              minWidth: 200,
              child: Container(
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
      surfaceSize: const Size(502 /* + border */, 400),
    );

    await screenMatchesGolden(tester, 'three_widgets_1_2_1_wrap_next_line');
  });

  testGoldens('Three widgets (1/2/1), wrap to next line + spacing', (tester) async {
    await tester.pumpWidgetBuilder(
      Container(
        decoration: BoxDecoration(
          border: Border.all(color: Color(0xFFFF0000), width: 1),
        ),
        child: Fluid(
          spacing: 16,
          children: [
            Fluidable(
              fluid: 1,
              minWidth: 200,
              child: Container(
                color: Color(0xFF25B2BD),
                height: 200,
                child: Placeholder(),
              ),
            ),
            Fluidable(
              fluid: 2,
              minWidth: 200,
              child: Container(
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
      surfaceSize: const Size(416.0 + 2 /* + border */, 400),
    );

    await screenMatchesGolden(tester, 'three_widgets_1_2_1_wrap_next_line_and_spacing');
  });
}
