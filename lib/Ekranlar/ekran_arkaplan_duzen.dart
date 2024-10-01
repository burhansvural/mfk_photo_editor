import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:foto_editor/helper/ResimKaplama/resim_kaplamalari.dart';
import 'package:foto_editor/helper/pixel_color_image.dart';
import 'package:foto_editor/helper/resim_secici.dart';
import 'package:foto_editor/models/model_doku.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:screen_shot/screenshot.dart';
import 'package:blur/blur.dart';

import '../Saglayicilar/resim_saglayici.dart';
import '../helper/renk_secici.dart';

class EkranArkaPlanDuzen extends StatefulWidget {
  const EkranArkaPlanDuzen({super.key});

  @override
  State<EkranArkaPlanDuzen> createState() => _EkranArkaPlanDuzenState();
}

class _EkranArkaPlanDuzenState extends State<EkranArkaPlanDuzen> {
  ScreenshotController screenshotController = ScreenshotController();
  late ResimSaglayici resimSaglayici;

  late ModelDoku suankiDoku;
  late List<ModelDoku> lstDokular;

  Uint8List? arkaplandakiResim;
  Uint8List? suankiResim;
  Color arkaplanRenk = Colors.white;

  int x = 1;
  int y = 1;

  double bulaniklik = 0;

  bool boolOranWidgetGoster = true;
  bool boolBulaniklikWidgetGoster = false;
  bool boolRenkWidgetGoster = false;
  bool boolDokuWidgetGoster = false;

  bool boolOranArkaplanAktif=true;
  bool boolBulaniklikArkaplanAktif = false;
  bool boolRenkArkaplanAktif = false;
  bool boolDokuArkaplanAktif = false;

  @override
  void initState() {
    lstDokular = ResimKaplamalari().listDoku();
    suankiDoku = lstDokular[0];
    resimSaglayici = Provider.of<ResimSaglayici>(context, listen: false);
    super.initState();
  }

  bottomMenuWidgetOlustur({oranGoster, bulaniklikGoster, renkGoster, dokuGoster}) {
    setState(() {
      boolOranWidgetGoster = oranGoster != null ? true : false;
      boolBulaniklikWidgetGoster = bulaniklikGoster != null ? true : false;
      boolRenkWidgetGoster = renkGoster != null ? true : false;
      boolDokuWidgetGoster = dokuGoster != null ? true : false;
    });
  }

  arkaplanGoster({oranArkaplanAktif,renkArkaplanAktif, resimArkaplanAktif, dokuArkaplanAktif}) {
    setState(() {
      boolOranArkaplanAktif = oranArkaplanAktif != null ? true : false;
      boolRenkArkaplanAktif = renkArkaplanAktif != null ? true : false;
      boolBulaniklikArkaplanAktif = resimArkaplanAktif != null ? true : false;
      boolDokuArkaplanAktif = dokuArkaplanAktif != null ? true : false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Arkaplan Düzenleme"),
        leading: CloseButton(onPressed: () {
          Navigator.of(context).pop();
        }),
        actions: [
          IconButton(
              onPressed: () async {
                Uint8List? bytes = await screenshotController.capture();
                resimSaglayici.resimDegistir(bytes!);
                if (context.mounted) {
                  Navigator.of(context).pop();
                }
              },
              icon: const Icon(Icons.done)),
        ],
      ),
      body: Center(
        child: Consumer<ResimSaglayici>(
          builder: (BuildContext context, ResimSaglayici value, Widget? child) {
            if (value.suankiResim != null) {
              suankiResim = value.suankiResim;
              arkaplandakiResim ??= value.suankiResim;
              return AspectRatio(
                aspectRatio: x / y,
                child: Screenshot(
                  controller: screenshotController,
                  child: Stack(children: [
                    if(boolOranArkaplanAktif)
                      Container(
                        color: arkaplanRenk,
                        child: Center(
                          child: Image.memory(
                            suankiResim!,
                          ),
                        ),
                      ),
                    if (boolRenkArkaplanAktif)
                      Container(
                        color: arkaplanRenk,
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.memory(
                              suankiResim!,
                            ),
                          ),
                        ),
                      ),
                    if (boolBulaniklikArkaplanAktif)
                      Stack(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height,
                            foregroundDecoration: BoxDecoration(
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: MemoryImage(suankiResim!),
                                alignment: Alignment.topLeft,
                              ),
                            ),
                          ).blurred(
                            colorOpacity: 0,
                            blur: bulaniklik,
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: Container(
                                padding: const EdgeInsets.all(20.0),
                                child: Image.memory(arkaplandakiResim!)
                            ),
                          ),
                        ]
                      ),

                    if (boolDokuArkaplanAktif)
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        foregroundDecoration: BoxDecoration(
                          color: Colors.white,
                          backgroundBlendMode: BlendMode.modulate,
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: AssetImage(suankiDoku.path!),
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Center(
                          child: Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: MemoryImage(
                                    value.suankiResim!
                                ),
                              )
                            ),
                          ),
                        ),
                      ),
                  ]),
                ),
              );
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
      bottomNavigationBar: Container(
        width: double.infinity,
        height: 110,
        color: Colors.blue,
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Stack(children: [
                  if (boolOranWidgetGoster) oranWidget(),
                  if (boolBulaniklikWidgetGoster) bulaniklikWidget(),
                  if (boolRenkWidgetGoster) renkWidget(),
                  if (boolDokuWidgetGoster) dokuWidget(),
                ]),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: _altMenuElemanWidget(
                        Icons.aspect_ratio,
                        "Oran",
                        onPress: () {
                          arkaplanGoster(oranArkaplanAktif: true);
                          bottomMenuWidgetOlustur(oranGoster: true);
                        },
                      ),
                    ),
                    Expanded(
                      child: _altMenuElemanWidget(
                        Icons.blur_linear,
                        "Bulanıklık",
                        onPress: () {
                          arkaplanGoster(resimArkaplanAktif: true);
                          bottomMenuWidgetOlustur(bulaniklikGoster: true);
                        },
                      ),
                    ),
                    Expanded(
                      child: _altMenuElemanWidget(
                        Icons.color_lens_outlined,
                        "Renk",
                        onPress: () {
                          arkaplanGoster(renkArkaplanAktif: true);
                          bottomMenuWidgetOlustur(renkGoster: true);
                        },
                      ),
                    ),
                    Expanded(
                      child: _altMenuElemanWidget(
                        Icons.texture,
                        "Doku",
                        onPress: () {
                          arkaplanGoster(dokuArkaplanAktif: true);
                          bottomMenuWidgetOlustur(dokuGoster: true);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _altMenuElemanWidget(IconData ikon, String yazi, {required onPress}) {
    return InkWell(
      onTap: onPress,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              ikon,
              color: Colors.white,
            ),
            const SizedBox(
              height: 3,
            ),
            Text(
              yazi,
              style: const TextStyle(color: Colors.white, fontSize: 12),
            )
          ],
        ),
      ),
    );
  }

  Widget oranWidget() {
    return Container(
      color: Colors.white,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () {
                setState(() {
                  x = 1;
                  y = 1;
                });
              },
              child: const Text("1:1"),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  x = 2;
                  y = 1;
                });
              },
              child: const Text("2:1"),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  x = 1;
                  y = 2;
                });
              },
              child: const Text("1:2"),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  x = 4;
                  y = 3;
                });
              },
              child: const Text("4:3"),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  x = 3;
                  y = 4;
                });
              },
              child: const Text("3:4"),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  x = 16;
                  y = 9;
                });
              },
              child: const Text("16:9"),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  x = 9;
                  y = 16;
                });
              },
              child: const Text("9:16"),
            ),
          ],
        ),
      ),
    );
  }

  Widget bulaniklikWidget() {
    return Container(
      color: Colors.white,
      child: Center(
        child: Row(
          children: [
            IconButton(
              onPressed: () {
                ResimSecici(source: ImageSource.gallery).pick(onPick: (File? image) async {
                  if (image != null) {
                    arkaplandakiResim = await image.readAsBytes();
                    setState(() {});
                  }
                });
              },
              icon: const Icon(Icons.photo_size_select_actual_outlined),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Slider(
                  label: bulaniklik.toStringAsFixed(2),
                  value: bulaniklik,
                  min: 0,
                  max: 16,
                  onChanged: (value) {
                    setState(() {
                      bulaniklik = value;
                    });
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget renkWidget() {
    return Container(
      color: Colors.black,
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              onPressed: () {
                RenkSecici().show(context, backgroundColor: arkaplanRenk, onPick: (color) {
                  setState(() {
                    arkaplanRenk = color;
                  });
                });
              },
              icon: const Icon(
                Icons.color_lens_outlined,
                color: Colors.white,
              ),
            ),
            IconButton(
              onPressed: () {
                PixelColorImage().show(context, backgroundColor: arkaplanRenk, image: suankiResim, onPick: (renk) {
                  setState(() {
                    arkaplanRenk = renk;
                  });
                });
              },
              icon: const Icon(
                Icons.colorize,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget dokuWidget() {
    return Container(
      color: Colors.black,
      child: Center(
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: lstDokular.length,
          itemBuilder: (BuildContext context, int index) {
            ModelDoku doku = lstDokular[index];
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 40,
                    height: 40,
                    child: FittedBox(
                      fit: BoxFit.fill,
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            suankiDoku = doku;
                          });
                        },
                        child: Image.asset(doku.path!),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
