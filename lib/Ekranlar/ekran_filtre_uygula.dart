import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'package:foto_editor/models/model_filtre.dart';
import 'package:foto_editor/helper/ResimFiltre/resim_filtreleri.dart';
import 'package:provider/provider.dart';
import 'package:screen_shot/screenshot.dart';

import '../Saglayicilar/resim_saglayici.dart';

class EkranFiltreUygula extends StatefulWidget {
  const EkranFiltreUygula({super.key});

  @override
  State<EkranFiltreUygula> createState() => _EkranFiltreUygulaState();
}

class _EkranFiltreUygulaState extends State<EkranFiltreUygula> {
  late Filtre seciliFiltre;
  late List<Filtre> lstFiltreler;
  late ResimSaglayici resimSaglayici;
  ScreenshotController screenshotController = ScreenshotController();

  @override
  void initState() {
    super.initState();
    lstFiltreler = ResimFiltreleri().list();
    seciliFiltre = lstFiltreler[0];
    resimSaglayici = Provider.of<ResimSaglayici>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Filtre Uygulama Ekranı"),
        leading: CloseButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
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
              icon: const Icon(Icons.done)),
        ],
      ),
      body: Center(
        child: Consumer<ResimSaglayici>(
          builder: (BuildContext context, ResimSaglayici value, Widget? child) {
            if (value.suankiResim != null) {
              return Screenshot(
                  controller: screenshotController,
                  child: ColorFiltered(
                    colorFilter: ColorFilter.matrix(seciliFiltre.matrix),
                    child: Image.memory(value.suankiResim!),
                  ));
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
        color: Colors.transparent,
        child: SafeArea(child: Consumer<ResimSaglayici>(builder: (BuildContext context, ResimSaglayici value, Widget? child) {
          return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: lstFiltreler.length,
            itemBuilder: (BuildContext context, int index) {
              Filtre filtre = lstFiltreler[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 70,
                      height: 70,
                      child: FittedBox(
                        fit: BoxFit.fill,
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              seciliFiltre = filtre;
                            });
                          },
                          child: ColorFiltered(
                            colorFilter: ColorFilter.matrix(filtre.matrix),
                            child: Image.memory(value.suankiResim!),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 3,
                    ),
                    Text(
                      filtre.tip,
                      style: const TextStyle(color: Colors.white),
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                  ],
                ),
              );
            },
          );
        })),
      ),
    );
  }
}
