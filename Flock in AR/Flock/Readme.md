# FlockOfBoids-Android-AR--VisualComputing-framesjs
## Flock in AR
### Authors
- Fernando Vargas - fevargasmo
- Omar Roa - oeroaq
### Using
- [framejs library](https://github.com/VisualComputing/framesjs/tree/geom)
- [Android processing](http://android.processing.org/)
- [ketai library](http://ketai.org/)
- [NyARToolkit for proce55ing](https://github.com/nyatla/NyARToolkit-for-Processing/blob/master/README.EN.md)

#### Problemas presentados
 - Añadir "precision mediump float;" en data/PickingBuffer.frag
 - Problemas al dimensionar la camara. Como Processing Android no dispone las herramientas para el tratado de la camara en Android, toca utilizar la libreria Ketai, pero da problemas al comunicar y utilizar con NyARToolkit, ademas de la mala calidad de la imagen y los fps.
 - Dimensionar el FlockOfBoids en la camara. No reconoce el los Flock dentro del contexto de la camara.
