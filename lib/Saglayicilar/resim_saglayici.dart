import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';

class ResimSaglayici extends ChangeNotifier{
  Uint8List? suankiResim;
  resimDegistirDosyadanOku(File resim){
    suankiResim=resim.readAsBytesSync();
    notifyListeners();
  }

  resimDegistirKesmeIslemiSonucu(Uint8List resim){
    suankiResim=resim;
    notifyListeners();
  }

  resimDegistir(Uint8List resim){
    suankiResim=resim;
    notifyListeners();
  }
}