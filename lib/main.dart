import 'package:flutter/material.dart';
import 'package:foto_editor/Ekranlar/ekran_arkaplan_duzen.dart';
import 'package:foto_editor/Ekranlar/ekran_ayarlar.dart';
import 'package:foto_editor/Ekranlar/ekran_filtre_uygula.dart';
import 'package:foto_editor/Ekranlar/ekran_tek_resim.dart';
import 'package:foto_editor/Ekranlar/ekran_kesme_islemi.dart';
import 'package:foto_editor/Saglayicilar/resim_saglayici.dart';
import 'package:provider/provider.dart';

import 'Ekranlar/ekran_baslangic.dart';

void main() {
  runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_)=>ResimSaglayici()),
      ],
  child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Fotoğraf Editörü",
        theme: ThemeData(
          primarySwatch: Colors.blue,
          scaffoldBackgroundColor: Colors.black,
          appBarTheme: const AppBarTheme(
            elevation: 0,
            color: Colors.blue,
            foregroundColor: Colors.white,
            actionsIconTheme: IconThemeData(
              color: Colors.white,
            ),
            toolbarTextStyle: TextStyle(
              color: Colors.white,
            ),
            centerTitle: true,
          ),
          sliderTheme: const SliderThemeData(
            showValueIndicator: ShowValueIndicator.always,
          ),
        ),
        routes: <String,WidgetBuilder>{
          "/":(_)=> const BaslangicEkrani(),
          "/home":(_)=> const EkranTekResim(),
          "/kesme":(_)=> const EkranKesmeIslemi(),
          "/filtre":(_)=> const EkranFiltreUygula(),
          "/ayarlar":(_)=> const EkranAyarlar(),
          "/duzen":(_)=> const EkranArkaPlanDuzen(),
        },
        initialRoute:"/",
      ),
    );
  }
}
