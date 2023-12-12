import 'package:flutter/material.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:greengrocer/src/pages/commons_widgets/custom_text_field.dart';

void main() {
  testGoldens('Test input custom', (tester) async {
    //carrega as fontes usadas no widget
    await loadAppFonts();

    const widget = MaterialApp(
      home: Scaffold(
        body: CustomTextField(
          icon: Icons.home,
          label: 'e-mail',
          isSecret: false,
        ),
      ),
    );
    await tester.pumpWidgetBuilder(widget, surfaceSize: const Size(400, 800));
  });
}
