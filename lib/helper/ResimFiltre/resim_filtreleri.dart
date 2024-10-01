import "package:foto_editor/models/model_filtre.dart";
/*
R G B A
1 0 0 0 (-> Red Output)
0 1 0 0 (-> Green Output)
0 0 1 0 (-> Blue Output)
0 0 0 1 (-> Alpha Output)

     R G B A W            R G B A W             R   G   B   A   W

 R  [1 0 0 0 0]       R  [c 0 0 0 0]       R  [sr+s sr  sr  0   0]
 G  [0 1 0 0 0]       G  [0 c 0 0 0]       G  [ sg sg+s sg  0   0]
 B  [0 0 1 0 0]   X   B  [0 0 c 0 0]   X   B  [ sb  sb sb+s 0   0]
 A  [0 0 0 1 0]       A  [0 0 0 1 0]       A  [ 0   0   0   1   0]
 W  [b b b 0 1]       W  [t t t 0 1]       W  [ 0   0   0   0   1]

Brightness Matrix     Contrast Matrix          Saturation Matrix


                        R      G      B      A      W

                 R  [c(sr+s) c(sr)  c(sr)    0      0   ]
                 G  [ c(sg) c(sg+s) c(sg)    0      0   ]
         ===>    B  [ c(sb)  c(sb) c(sb+s)   0      0   ]
                 A  [   0      0      0      1      0   ]
                 W  [  t+b    t+b    t+b     0      1   ]

                           Transformation Matrix

* */
class ResimFiltreleri{
  List<Filtre> list(){
    return <Filtre>[
      Filtre(
          "Filtresiz",
          [
            1,0,0,0,0,
            0,1,0,0,0,
            0,0,1,0,0,
            0,0,0,1,0
          ]
      ),
      Filtre(
        "Mor",
          [
            1,-0.2,0,0,0,
            0,1,0,-0.1,0,
            0,1.2,1,0.1,0,
            0,0,1.7,1,0
          ]
      ),
      Filtre(
          "Sarı",
          [
            1,0,0,0,0,
            -0.2,1.0,0.3,0.1,0,
            -0.1,0,1,0,0,
            0,0,0,1,0
          ]
      ),
      Filtre(
          "Camgöbeği",
          [
            1,0,0,1.9,-2.2,
            0,1,0,0.0,0.3,
            0,0,1,0,0.5,
            0,0,0,1,0.2
          ]
      ),
      Filtre(
          "Siyah&Beyaz",
          [
            0,1,0,0,0,
            0,1,0,0,0,
            0,1,0,0,0,
            0,1,0,1,0
          ]
      ),
      Filtre(
          "Nostalji",
          [
            1,0,0,0,0,
            -0.4,1.3,-0.4,0.2,-0.1,
            0,0,1,0,0,
            0,0,0,1,0
          ]
      ),
      Filtre(
          "Güz",
          [
            1,0,0,0,0,
            0,1,0,0,0,
            -0.2,-0.2,0.1,0.4,0,
            0,0,0,1,0
          ]
      ),
      Filtre(
          "Çok Işık",
          [
            1.3,-0.3,1.1,0,0,
            0,1.3,0.2,0,0,
            0,0,0.8,0.2,0,
            0,0,0,1,0
          ]
      ),
      Filtre(
          "Süt Beyazı",
          [
            0,1.0,0,0,0,
            0,1.0,0,0,0,
            0,0.6,1,0,0,
            0,0,0,1,0
          ]
      ),
      Filtre(
          "Gece",
          [
            1,0,0,0,0,
            0,1,0,0,0,
            0,0,1,0,0,
            0,0,-2,1,0
          ]
      ),
      Filtre(
          "Gri",
          [
            0,0,1,0,0,
            0,0,1,0,0,
            0,0,1,0,0,
            0,0,0,1,0
          ]
      ),
      Filtre(
          "Soldur",
          [
            0.9,0.5,0.1,0,0,
            0.3,0.8,0.1,0,0,
            0.2,0.3,0.5,0,0,
            0,0,0,1,0
          ]
      ),


    ];
  }
}