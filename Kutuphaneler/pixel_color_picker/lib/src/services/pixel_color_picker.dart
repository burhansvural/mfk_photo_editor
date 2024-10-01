import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/rendering.dart';
import 'package:image/image.dart' as img;

class ColorPicker {
  final Uint8List? bytes;

  img.Image? _decodedImage;

  ColorPicker({this.bytes});

  Size getSize() {
    _decodedImage ??= img.decodeImage(bytes!);

    return Size(
      _decodedImage!.width.toDouble(),
      _decodedImage!.height.toDouble(),
    );
  }

  Color getColor({required Offset pixelPosition}) {
    _decodedImage ??= img.decodeImage(bytes!);

    final abgrPixel = _decodedImage!.getPixelSafe(
      pixelPosition.dx.toInt(),
      pixelPosition.dy.toInt(),
    );

    return Color.fromARGB(
      abgrPixel.a.toInt(),
      abgrPixel.r.toInt(),
      abgrPixel.g.toInt(),
      abgrPixel.b.toInt(),
    );
  }
}