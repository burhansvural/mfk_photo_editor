import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:pixel_color_picker/pixel_color_picker.dart';

class PixelColorImage {


  show(BuildContext context, {Color? backgroundColor, Uint8List? image, onPick}) {
    return showDialog(
        context: context,
        builder: (BuildContext context){
          Color tempColor=backgroundColor!;
          return StatefulBuilder(
              builder: (context, setState){
                return AlertDialog(
                  backgroundColor: Colors.blue[50],
                  title: const Text("Mouse veya Parmağınızı Resim Üzerinde Basılı tutarak Gezdiriniz"),
                  content: SafeArea(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Expanded(
                          flex: 8,
                          child: PixelColorPicker(
                              child: Image.memory(image!,),
                              onChanged: (color,size,offset){
                                setState((){
                                  tempColor=color;
                                });
                              }
                          ),
                        ),
                        const SizedBox(height: 3,),
                        Expanded(
                          flex: 1,
                          child: Container(
                            width: double.infinity,
                            height: 80,
                            color: tempColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  actions: [
                    TextButton(
                        onPressed: (){
                          Navigator.of(context).pop();
                        },
                        child: const Text("ÇIK",style: TextStyle(color: Colors.black,fontSize: 16),)
                    ),
                    TextButton(
                        onPressed: (){
                          onPick(tempColor);
                          Navigator.of(context).pop();
                        },
                        child: const Text("SEÇ",style: TextStyle(color: Colors.black,fontSize: 16),)
                    ),
                  ],
                );
              },
          );
        },
    );
  }

}
