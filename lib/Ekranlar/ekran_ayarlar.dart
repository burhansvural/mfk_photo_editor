import 'dart:typed_data';

import 'package:colorfilter_generator/addons.dart';
import 'package:colorfilter_generator/colorfilter_generator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:screen_shot/screenshot.dart';

import '../Saglayicilar/resim_saglayici.dart';

class EkranAyarlar extends StatefulWidget {
  const EkranAyarlar({super.key});

  @override
  State<EkranAyarlar> createState() => _EkranAyarlarState();
}

class _EkranAyarlarState extends State<EkranAyarlar> {
  late ResimSaglayici resimSaglayici;
  ScreenshotController screenshotController = ScreenshotController();

  double isik = 0;
  double kontrast = 0;
  double doygunluk = 0;
  double renkTonu = 0;
  double nostaljik = 0;

  bool isikAyarCubuguGoster = true;
  bool kontrastAyarCubuguGoster = false;
  bool doygunlukAyarCubuguGoster = false;
  bool renkTonuAyarCubuguGoster = false;
  bool nostaljikAyarCubuguGoster = false;

  String SeciliIslemYazi = "Işık";

  late ColorFilterGenerator colorFilterGenerator;

  @override
  void initState() {
    resimSaglayici = Provider.of<ResimSaglayici>(context, listen: false);
    ayarla();
    super.initState();
  }

  ayarla({paramIsik, paramKontrast, paramDoygunluk, paramRenkTonu, paramNostaljik}) {
    colorFilterGenerator = ColorFilterGenerator(name: "Ayarlar", filters: [
      ColorFilterAddons.brightness(paramIsik ?? isik),
      ColorFilterAddons.contrast(paramKontrast ?? kontrast),
      ColorFilterAddons.saturation(paramDoygunluk ?? doygunluk),
      ColorFilterAddons.hue(paramRenkTonu ?? renkTonu),
      ColorFilterAddons.sepia(paramNostaljik ?? nostaljik)
    ]);
  }

  ayarCubugunuGoster({prmIsik, prmKontrast, prmDoygunluk, prmRenkTonu, prmNostaljik}) {
    setState(() {
      isikAyarCubuguGoster = prmIsik != null ? true : false;
      kontrastAyarCubuguGoster = prmKontrast != null ? true : false;
      doygunlukAyarCubuguGoster = prmDoygunluk != null ? true : false;
      renkTonuAyarCubuguGoster = prmRenkTonu != null ? true : false;
      nostaljikAyarCubuguGoster = prmNostaljik != null ? true : false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const CloseButton(),
        title: const Text("Ayarlar"),
        actions: [
          IconButton(
              onPressed: () async {
                Uint8List? bytes = await screenshotController.capture();
                if (bytes != null) {
                  resimSaglayici.resimDegistir(bytes);
                }
                if (context.mounted) {
                  Navigator.of(context).pop();
                }
              },
              icon: const Icon(Icons.done))
        ],
      ),
      body: Stack(
        children: [
          Center(
            child: Consumer<ResimSaglayici>(
              builder: (BuildContext context, ResimSaglayici value, Widget? child) {
                if (value.suankiResim != null) {
                  return Screenshot(
                    controller: screenshotController,
                    child: ColorFiltered(
                      colorFilter: ColorFilter.matrix(colorFilterGenerator.matrix),
                      child: Image.memory(value.suankiResim!),
                    ),
                  );
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Visibility(
                          visible: isikAyarCubuguGoster,
                          child: ayarCubugu(
                            deger: isik,
                            onChangedOlayi: (paramDeger) {
                              setState(() {
                                isik = paramDeger;
                                ayarla(paramIsik: isik);
                              });
                            },
                          ),
                        ),
                        Visibility(
                          visible: kontrastAyarCubuguGoster,
                          child: ayarCubugu(
                            deger: kontrast,
                            onChangedOlayi: (paramDeger) {
                              setState(() {
                                kontrast = paramDeger;
                                ayarla(paramKontrast: kontrast);
                              });
                            },
                          ),
                        ),
                        Visibility(
                          visible: doygunlukAyarCubuguGoster,
                          child: ayarCubugu(
                            deger: doygunluk,
                            onChangedOlayi: (paramDeger) {
                              setState(() {
                                doygunluk = paramDeger;
                                ayarla(paramDoygunluk: doygunluk);
                              });
                            },
                          ),
                        ),
                        Visibility(
                          visible: renkTonuAyarCubuguGoster,
                          child: ayarCubugu(
                            deger: renkTonu,
                            onChangedOlayi: (paramDeger) {
                              setState(() {
                                renkTonu = paramDeger;
                                ayarla(paramRenkTonu: renkTonu);
                              });
                            },
                          ),
                        ),
                        Visibility(
                          visible: nostaljikAyarCubuguGoster,
                          child: ayarCubugu(
                            deger: nostaljik,
                            onChangedOlayi: (paramDeger) {
                              setState(() {
                                nostaljik = paramDeger;
                                ayarla(paramNostaljik: nostaljik);
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        isik = 0.0;
                        kontrast = 0.0;
                        doygunluk = 0.0;
                        renkTonu = 0.0;
                        nostaljik = 0.0;
                        ayarla(
                          paramIsik: isik,
                          paramKontrast: kontrast,
                          paramDoygunluk: doygunluk,
                          paramRenkTonu: renkTonu,
                          paramNostaljik: nostaljik
                        );
                      });
                    },
                    child: const Text(
                      "Ayarları Sıfırla",
                      style: TextStyle(
                        fontSize: 15,
                        height: 5,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
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
                _bottomBarItem(
                  Icons.light_mode_rounded,
                  "Işık",
                  color: isikAyarCubuguGoster ? Colors.black38 : null,
                  onPress: () {
                    ayarCubugunuGoster(prmIsik: true);
                  },
                ),
                _bottomBarItem(
                  Icons.contrast_rounded,
                  color: kontrastAyarCubuguGoster ? Colors.black38 : null,
                  "Kontrast",
                  onPress: () {
                    ayarCubugunuGoster(prmKontrast: true);
                  },
                ),
                _bottomBarItem(
                  Icons.water_drop_rounded,
                  color: doygunlukAyarCubuguGoster ? Colors.black38 : null,
                  "Doygunluk",
                  onPress: () {
                    ayarCubugunuGoster(prmDoygunluk: true);
                  },
                ),
                _bottomBarItem(
                  Icons.tonality_rounded,
                  "Renk Tonu",
                  color: renkTonuAyarCubuguGoster ? Colors.black38 : null,
                  onPress: () {
                    ayarCubugunuGoster(prmRenkTonu: true);
                  },
                ),
                _bottomBarItem(
                  Icons.motion_photos_on,
                  color: nostaljikAyarCubuguGoster ? Colors.black38 : null,
                  "Nostaljik",
                  onPress: () {
                    ayarCubugunuGoster(prmNostaljik: true);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _bottomBarItem(IconData ikon, String yazi, {Color? color, required onPress}) {
    return InkWell(
      onTap: onPress,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              ikon,
              color: color ?? Colors.white,
            ),
            const SizedBox(
              height: 3,
            ),
            Text(
              yazi,
              style: TextStyle(color: color ?? Colors.white70),
            )
          ],
        ),
      ),
    );
  }

  Widget ayarCubugu({required double deger, required onChangedOlayi}) {
    return Slider(
      label: deger.toStringAsFixed(2),
      value: deger,
      max: 1,
      min: -0.9,
      onChanged: onChangedOlayi,
    );
  }
}
