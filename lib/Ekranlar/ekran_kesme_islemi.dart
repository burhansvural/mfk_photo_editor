import 'dart:typed_data';
import "dart:ui" as ui;
import 'package:crop_image/crop_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Saglayicilar/resim_saglayici.dart';

class EkranKesmeIslemi extends StatefulWidget {
  const EkranKesmeIslemi({super.key});

  @override
  State<EkranKesmeIslemi> createState() => _KesmeIslemiEkraniState();
}

class _KesmeIslemiEkraniState extends State<EkranKesmeIslemi> {
  final controller = CropController(aspectRatio: 1, defaultCrop: const Rect.fromLTRB(0.1, 0.1, 0.9, 0.9));
  late ResimSaglayici resimSaglayici;

  @override
  void initState() {
    resimSaglayici=Provider.of<ResimSaglayici>(context,listen:false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const CloseButton(),
        title: const Text("Resim Kırpma İşlemi"),
        actions: [
          IconButton(onPressed: () async {
            ui.Image bitmap = await controller.croppedBitmap();
            ByteData? data = await bitmap.toByteData(format: ui.ImageByteFormat.png);
            if(data!=null){
              Uint8List bytes=data.buffer.asUint8List();
              resimSaglayici.resimDegistirKesmeIslemiSonucu(bytes);
            }
            if (context.mounted) {
              Navigator.of(context).pop();
            }
          }, icon: const Icon(Icons.done)),
        ],
      ),
      body: Center(
        child: Consumer<ResimSaglayici>(
          builder: (BuildContext context, ResimSaglayici value, Widget? child) {
            if (value.suankiResim != null) {
              return CropImage(
                controller: controller,
                image: Image.memory(value.suankiResim!),
                paddingSize: 15.0,
                alwaysMove: true,
              );
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
      bottomNavigationBar: Container(
        height: 100,
        width: double.infinity,
        color: Colors.blue,
        child: SafeArea(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _kirpmaIslemiPencereAltMenu(child: const Icon(Icons.rotate_90_degrees_ccw_outlined,color: Colors.white,), onPress: () {
                  controller.rotateLeft();
                }),
                _kirpmaIslemiPencereAltMenu(child: const Icon(Icons.rotate_90_degrees_cw_outlined,color: Colors.white,), onPress: () {
                  controller.rotateRight();
                }),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Container(color: Colors.white38,height: 23,width: 1,),
                ),
                _kirpmaIslemiPencereAltMenu(child: const Text("0:0",style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: ui.FontWeight.bold),), onPress: () {
                  controller.aspectRatio=null;
                  controller.crop=const Rect.fromLTRB(0.1, 0.1, 0.9, 0.9);
                }),
                _kirpmaIslemiPencereAltMenu(child: const Text("1:1",style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: ui.FontWeight.bold),), onPress: () {
                  controller.aspectRatio=1.0;
                  controller.crop=const Rect.fromLTRB(0.1, 0.1, 0.9, 0.9);
                }),
                _kirpmaIslemiPencereAltMenu(child: const Text("2:1",style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: ui.FontWeight.bold),), onPress: () {
                  controller.aspectRatio=2.0;
                  controller.crop=const Rect.fromLTRB(0.1, 0.1, 0.9, 0.9);
                }),
                _kirpmaIslemiPencereAltMenu(child: const Text("1:2",style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: ui.FontWeight.bold),), onPress: () {
                  controller.aspectRatio=1/2;
                  controller.crop=const Rect.fromLTRB(0.1, 0.1, 0.9, 0.9);
                }),
                _kirpmaIslemiPencereAltMenu(child: const Text("4:3",style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: ui.FontWeight.bold),), onPress: () {
                  controller.aspectRatio=4/3;
                  controller.crop=const Rect.fromLTRB(0.1, 0.1, 0.9, 0.9);
                }),
                _kirpmaIslemiPencereAltMenu(child: const Text("3:4",style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: ui.FontWeight.bold),), onPress: () {
                  controller.aspectRatio=3/4;
                  controller.crop=const Rect.fromLTRB(0.1, 0.1, 0.9, 0.9);
                }),
                _kirpmaIslemiPencereAltMenu(child: const Text("16:9",style: TextStyle(color: Colors.white,fontSize: 18,fontWeight: ui.FontWeight.bold),), onPress: () {
                  controller.aspectRatio=16/9;
                  controller.crop=const Rect.fromLTRB(0.1, 0.1, 0.9, 0.9);
                }),
                _kirpmaIslemiPencereAltMenu(child: const Text("9:16",style: TextStyle(color: Colors.white,fontSize: 18,fontWeight: ui.FontWeight.bold),), onPress: () {
                  controller.aspectRatio=9/16;
                  controller.crop=const Rect.fromLTRB(0.1, 0.1, 0.9, 0.9);
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _kirpmaIslemiPencereAltMenu({required child, required onPress}) {
    return InkWell(
      onTap: onPress,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
        ),
        child: Center(
          child: child,
        ),
      ),
    );
  }
}
