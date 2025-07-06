import 'dart:typed_data';

import 'package:bluetooth_print_plus/bluetooth_print_plus.dart';

abstract class PrinterPos {
  static final tscCommand = TscCommand();
  static final cpclCommand = CpclCommand();
  static final escCommand = EscCommand();

  /// tscImageCmd
  static Future<Uint8List?> tscImageCmd(Uint8List image) async {
    await tscCommand.cleanCommand();
    await tscCommand.size(width: 76, height: 130);
    await tscCommand.cls(); // most after size
    await tscCommand.image(image: image, x: 50, y: 60);
    await tscCommand.print(1);
    final cmd = await tscCommand.getCommand();
    return cmd;
  }

  /// tscTemplateCmd
  static Future<Uint8List?> tscTemplateCmd() async {
    await tscCommand.cleanCommand();
    await tscCommand.text(content: "Titulo");
    final cmd = await tscCommand.getCommand();
    return cmd;
  }
}
