import 'package:flutter/material.dart';
import 'package:foto_editor/Saglayicilar/resim_saglayici.dart';
import 'package:provider/provider.dart';


class EkranTekResim extends StatefulWidget {
  const EkranTekResim({super.key});

  @override
  State<EkranTekResim> createState() => _EkranTekResimState();
}

class _EkranTekResimState extends State<EkranTekResim> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Fotoğraf Editörü"),
        leading: CloseButton(
          onPressed: (){
            Navigator.of(context).pushReplacementNamed("/");
          },
        ),
        actions: [
          TextButton(
              onPressed: (){},
              child: const Text(
                  "Kaydet",
                style: TextStyle(
                  color: Colors.white,
                ),
              )
          ),
        ],
      ),
      body: Center(
        child: Consumer<ResimSaglayici>(
          builder: (BuildContext context, ResimSaglayici value, Widget? child){
            if(value.suankiResim!=null){
              return Image.memory(value.suankiResim!);
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
                _bottomBarItem(
                    Icons.crop_rotate,"Kes",
                    onPress: (){
                      Navigator.of(context).pushNamed("/kesme");
                    }),
                _bottomBarItem(
                    Icons.photo_filter_outlined,"Filtre Uygula",
                    onPress: (){
                      Navigator.of(context).pushNamed("/filtre");
                    }),
                _bottomBarItem(
                    Icons.tune,"Ayarlar",
                    onPress: (){
                      Navigator.of(context).pushNamed("/ayarlar");
                    }),
                _bottomBarItem(
                    Icons.fit_screen_sharp,"Arkaplan",
                    onPress: (){
                      Navigator.of(context).pushNamed("/duzen");
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }
  Widget _bottomBarItem(IconData ikon, String yazi,{required onPress}){
    return InkWell(
      onTap: onPress,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 21),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(ikon,color: Colors.white,),
            const SizedBox(height: 3,),
            Text(
                yazi,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white
              ),
            )
          ],
        ),
      ),
    );
  }
}
