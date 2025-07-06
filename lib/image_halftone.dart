import 'dart:io';
import 'dart:typed_data';
import 'package:image/image.dart' as img;

Future<Uint8List?> convertImageToHalftoneBlackAndWhite(File imageFile) async {
  final bytes = await imageFile.readAsBytes();
  img.Image? originalImage = img.decodeImage(bytes);

  if (originalImage == null) {
    print(
      "Erro ao decodificar a imagem. O arquivo pode estar corrompido ou não ser um formato suportado.",
    );
    return null;
  }

  final img.Image halftoneImage = img.Image(
    width: originalImage.width,
    height: originalImage.height,
    numChannels: 4,
  );

  final List<List<double>> brightnessValues = List.generate(
    originalImage.height,
    (y) => List.generate(originalImage.width, (x) {
      final pixel = originalImage.getPixel(x, y);
      final r = pixel.r;
      final g = pixel.g;
      final b = pixel.b;

      return (0.299 * r + 0.587 * g + 0.114 * b);
    }),
  );

  for (int y = 0; y < originalImage.height; y++) {
    for (int x = 0; x < originalImage.width; x++) {
      double oldBrightness = brightnessValues[y][x];
      int newBrightness;

      const int threshold = 128;
      if (oldBrightness < threshold) {
        newBrightness = 0;
      } else {
        newBrightness = 255;
      }

      halftoneImage.setPixelRgba(
        x,
        y,
        newBrightness,
        newBrightness,
        newBrightness,
        255,
      );

      double error = oldBrightness - newBrightness;

      if (x + 1 < originalImage.width) {
        brightnessValues[y][x + 1] += error * (7 / 16);
      }
      if (y + 1 < originalImage.height) {
        if (x - 1 >= 0) {
          brightnessValues[y + 1][x - 1] += error * (3 / 16);
        }
        brightnessValues[y + 1][x] += error * (5 / 16);
        if (x + 1 < originalImage.width) {
          brightnessValues[y + 1][x + 1] += error * (1 / 16);
        }
      }
    }
  }

  return Uint8List.fromList(img.encodePng(halftoneImage));
}
