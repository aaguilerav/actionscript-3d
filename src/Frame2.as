//-----------------------------------------------------------------------------------------------
_root.instancia.contador2-=1.33*_root.instancia.paso;
_root.instancia.posCamara2(_root._xmouse/200,_root._ymouse/200,5);
_root.instancia.calculo_constantes();
//-----------------------------------------------------------------------------------------------
divisor=64;
//trace(_root.instancia.movieClipID.superficie0.arregloDePtos);
_root.instancia.Ry(_root.instancia.movieClipID.superficie0.arregloDePtos,Math.PI/divisor);
_root.instancia.Rz(_root.instancia.movieClipID.superficie1.arregloDePtos,Math.PI/divisor);
_root.instancia.Rx(_root.instancia.movieClipID.superficie2.arregloDePtos,Math.PI/divisor);
_root.instancia.dibujarObjs3D();
//stop();
if (_root.instancia.contador2<-1000)
{
	_root.instancia.posCamara2(_root._xmouse/200,_root._ymouse/200,5);
	_root.instancia.calculo_constantes();
	_root.instancia.dibujarObjs3D();
	stop();
	_root.instancia.contador2=0;
	_root.instancia.contador=0;
}