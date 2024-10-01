import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:pixel_color_picker/src/services/pixel_color_picker.dart';

class PixelColorPicker extends StatefulWidget {
  final Widget child;
  final void Function(Color color, Size size, Offset pixel) onChanged;
  final double maxScale;
  final double minScale;
  final bool panEnabled;
  final bool scaleEnabled;

  const PixelColorPicker({
    super.key,
    required this.child,
    required this.onChanged,
    this.maxScale = 10,
    this.minScale = 0.8,
    this.panEnabled = true,
    this.scaleEnabled = true,
  });

  @override
  State<PixelColorPicker> createState() => _PixelColorPickerState();
}

class _PixelColorPickerState extends State<PixelColorPicker> {
  ColorPicker? _colorPicker;

  final _repaintBoundaryKey = GlobalKey();
  final _interactiveViewerKey = GlobalKey();

  Future<ui.Image> _loadSnapshot() async {
    final RenderRepaintBoundary repaintBoundary =
    _repaintBoundaryKey.currentContext!.findRenderObject()
    as RenderRepaintBoundary;

    return repaintBoundary.toImage();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        RepaintBoundary(
          key: _repaintBoundaryKey,
          child: InteractiveViewer(
            key: _interactiveViewerKey,
            maxScale: widget.maxScale,
            minScale: widget.minScale,
            panEnabled: widget.panEnabled,
            scaleEnabled: widget.scaleEnabled,
            onInteractionUpdate: (details) {
              final _offset = details.focalPoint;

              _onInteract(_offset);
            },
            child: widget.child,
          ),
        ),
      ],
    );
  }

  Future<void> _onInteract(Offset offset) async {
    if (_colorPicker == null) {
      final _snapshot = await _loadSnapshot();

      final _imageByteData =
      await _snapshot.toByteData(format: ui.ImageByteFormat.png);

      final _imageBuffer = _imageByteData!.buffer;

      final _uint8List = _imageBuffer.asUint8List();

      _colorPicker = ColorPicker(bytes: _uint8List);

      _snapshot.dispose();
    }

    final localOffset = _findLocalOffset(offset);

    final color = _colorPicker!.getColor(pixelPosition: localOffset);
    final size = _colorPicker!.getSize();

    widget.onChanged(color, size, localOffset);
  }

  Offset _findLocalOffset(Offset offset) {
    final RenderBox interactiveViewerBox =
    _interactiveViewerKey.currentContext!.findRenderObject() as RenderBox;

    return interactiveViewerBox.globalToLocal(offset);
  }
}