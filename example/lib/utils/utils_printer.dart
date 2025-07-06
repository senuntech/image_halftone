import 'dart:typed_data';
import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
import 'package:image/image.dart' show decodeImage;

Future<List<int>> testTicket() async {
  final profile = await CapabilityProfile.load();
  final generator = Generator(PaperSize.mm58, profile);
  List<int> bytes = [];

  bytes += generator.text(
    'Regular: aA bB cC dD eE fF gG hH iI jJ kK lL mM nN oO pP qQ rR sS tT uU vV wW xX yY zZ',
  );

  bytes += generator.text('Bold text', styles: PosStyles(bold: true));
  bytes += generator.text('Reverse text', styles: PosStyles(reverse: true));
  bytes += generator.text(
    'Underlined text',
    styles: PosStyles(underline: true),
    linesAfter: 1,
  );
  bytes += generator.text(
    'Align left',
    styles: PosStyles(align: PosAlign.left),
  );
  bytes += generator.text(
    'Align center',
    styles: PosStyles(align: PosAlign.center),
  );

  bytes += generator.text(
    'Align center',
    styles: PosStyles(align: PosAlign.center, height: PosTextSize.size1),
  );

  bytes += generator.feed(2);
  bytes += generator.cut();
  return bytes;
}

Future<List<int>> printImage(Uint8List image) async {
  final profile = await CapabilityProfile.load();
  final generator = Generator(PaperSize.mm58, profile);
  List<int> bytes = [];
  final img = decodeImage(image);

  bytes += generator.imageRaster(img!, imageFn: PosImageFn.bitImageRaster);
  bytes += generator.text('Hello Word');
  bytes += generator.feed(2);
  bytes += generator.cut();
  return bytes;
}

extension PosTextSizeExtension on PosTextSize {
  static const size0 = 0;
}
