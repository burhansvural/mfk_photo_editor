import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class RenkSecici {

  show(BuildContext context, {Color? backgroundColor, onPick}) {
    return showDialog(
      context: context,
      builder: (BuildContext context){
        Color tempColor=backgroundColor!;
        return StatefulBuilder(
          builder: (context, setState){
            return AlertDialog(
              title: const Text('Renk Seçiniz!'),
              content: SingleChildScrollView(
                child: HueRingPicker(
                  enableAlpha: false,
                  pickerColor: backgroundColor,
                  onColorChanged: (color){
                    tempColor=color;
                  },
                ),
                // Use Material color picker:
                //
                // child: MaterialPicker(
                //   pickerColor: pickerColor,
                //   onColorChanged: changeColor,
                //   showLabel: true, // only on portrait mode
                // ),
                //
                // Use Block color picker:
                //
                // child: BlockPicker(
                //   pickerColor: currentColor,
                //   onColorChanged: changeColor,
                // ),
                //
                // child: MultipleChoiceBlockPicker(
                //   pickerColors: currentColors,
                //   onColorsChanged: changeColors,
                // ),
              ),
              actions: <Widget>[
                ElevatedButton(
                  child: const Text('Seç'),
                  onPressed: () {
                    onPick(tempColor);
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

}
