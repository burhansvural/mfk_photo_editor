import 'dart:io';

import 'package:flutter/material.dart';
import 'package:foto_editor/Saglayicilar/resim_saglayici.dart';
import 'package:foto_editor/helper/resim_secici.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class BaslangicEkrani extends StatefulWidget {
  const BaslangicEkrani({super.key});

  @override
  State<BaslangicEkrani> createState() => _BaslangicEkraniState();
}

class _BaslangicEkraniState extends State<BaslangicEkrani> {
  late ResimSaglayici resimSaglayici;

  @override
  void initState() {
    resimSaglayici = Provider.of<ResimSaglayici>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: AppBar(
            title: const Text("MFK"),
          ),
          body: Stack(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Image.asset(
                  "assets/images/p2.jpeg",
                  fit: BoxFit.fill,
                ),
              ),
              Column(
                children: [
                  const Expanded(
                      child: Center(
                    child: Text(
                      "Fotoğraf Editörü",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 5,
                        wordSpacing: 10,
                      ),
                    ),
                  )),
                  Expanded(
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        width: 120,
                        child: ElevatedButton(
                          onPressed: () {
                            ResimSecici(source: ImageSource.gallery).pick(onPick: (File? image) {
                              if (image != null) {
                                resimSaglayici.resimDegistirDosyadanOku(image);
                                Navigator.of(context).pushReplacementNamed("/home");
                              }
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
                          ),
                          child: const Text("Galeri"),
                        ),
                      ),
                      SizedBox(
                        width: 120,
                        child: ElevatedButton(
                            onPressed: () {
                              ResimSecici(source: ImageSource.camera).pick(onPick: (File? image) {
                                if (image != null) {
                                  resimSaglayici.resimDegistirDosyadanOku(image);
                                  Navigator.of(context).pushReplacementNamed("/home");
                                }
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
                            ),
                            child: const Text("Kamera")),
                      ),
                    ],
                  )),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
