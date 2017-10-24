//_______________________________________________________________________________________________	
_root.rotacionTraslacion = function() //Implementar Rotación sobre x=K, y=K y z=K
{
	this.d = Number(300);
	this.v = Array(new Array(0,0,0,0),new Array(0,0,0,0),new Array(0,0,0,0),new Array(0,0,0,0));
	this.e = Array(0,0,0);
	this.theta_ = new Number();
	this.phi_ = new Number();
	this.rho_ = new Number();
	this.camara = new Array(0,0,0);
	this.superficies = new Number(0);
	this.lineas= new Number(0);
	this.Rx = function(array, alpha_)
	{
		var i;
		for (i=0;i<array.length;i++)
		{
			y=Number(array[i][1]);
			z=Number(array[i][2]);
			array[i][1]=y*Math.cos(alpha_)-z*Math.sin(alpha_);
			array[i][2]=y*Math.sin(alpha_)+z*Math.cos(alpha_);
		}
	}
	//-------------------------------
	this.Ry = function(array, alpha_)
	{
		var i,x,z;
		for (i=0;i<array.length;i++)
		{
			x=Number(array[i][0]);
			z=Number(array[i][2]);
			array[i][0]=+x*Math.cos(alpha_)+z*Math.sin(alpha_);
			array[i][2]=-x*Math.sin(alpha_)+z*Math.cos(alpha_);
		}
	}
	//-------------------------------
	this.Rz = function(array, alpha_)
	{
		var i,x,y;
		for (i=0;i<array.length;i++)
		{
			x=Number(array[i][0]);
			y=Number(array[i][1]);
			array[i][0]=x*Math.cos(alpha_)-y*Math.sin(alpha_);
			array[i][1]=x*Math.sin(alpha_)+y*Math.cos(alpha_);
		}
	}
	//-------------------------------
	this.Tdesplazamiento = function(array, d, eje)
	{
		for (i=0;i<array.length;i++)
			switch(eje)
			{	
				case 'x':{array[i][0]=Number(array[i][0])+Number(d);break;}
				case 'y':{array[i][1]=Number(array[i][1])+Number(d);break;}
				case 'z':{array[i][2]=Number(array[i][2])+Number(d);break;}
			}
	}
}
//_______________________________________________________________________________________________
_root.engine = function(id)
{
	this.movieClipID = id;
	this.paso = new Number(0.125);
	this.contador2 = new Number(20);
	this.contador = new Number(9);
	//_______________________________________________________________________________________________
	this.distancia = function(x1, y1, z1, x2, y2, z2)
	{
		return Math.sqrt(Math.pow(x1-x2,2)+Math.pow(y1-y2,2)+Math.pow(z1-z2,2));
	}
	//_______________________________________________________________________________________________
	this.eye_coordinates = function(x, y ,z)
	{
		this.e[0]=x*this.v[0][0]+y*this.v[1][0];
		this.e[1]=x*this.v[0][1]+y*this.v[1][1]+z*this.v[2][1];
		this.e[2]=x*this.v[0][2]+y*this.v[1][2]+z*this.v[2][2]+this.v[3][2];
	}
	//_______________________________________________________________________________________________
	this.screen = function(p, x, y, z)
	{
		this.eye_coordinates(x,y,z);
		p[0]=this.d*(this.e[0]/this.e[2])+180;
		p[1]=180-this.d*(this.e[1]/this.e[2]);
	}
	//_______________________________________________________________________________________________
	this.rho = function(x, y, z)
	{
		return Math.sqrt(Math.pow(x,2)+Math.pow(y,2)+Math.pow(z,2));
	}
	//_______________________________________________________________________________________________
	this.theta = function(x, y)
	{
		if (y!=0)
			if (x>0)
				return Math.atan(y/x);
			else if (x<0)
				return Math.PI+Math.atan(y/x);

		if (y==0 and x>0)
			return 0;
		else if (y>0 and x==0)
			return Math.PI/2;
		else if (y==0 and x<0)
			return Math.PI;
		else if (y<0 and x==0)
			return 3*Math.PI/2;
	}
	//_______________________________________________________________________________________________
	this.phi = function(x, y, z)
	{
		return Math.acos(z/this.rho(x,y,z));
	}
	//_______________________________________________________________________________________________
	this.posCamara0 = function(a_x, b_y, c_z)
	{
		this.camara[0]=a_x;
		this.camara[1]=b_y;
		this.camara[2]=c_z;
		this.phi_  =this.phi(a_x,b_y,c_z);
		this.rho_  =this.rho(a_x,b_y,c_z);
		this.theta_=this.theta(a_x,b_y);
	}
	//_______________________________________________________________________________________________
	this.posCamara1 = function(a_x, b_y, c_z)
	{
		this.phi_  =this.phi(a_x,b_y,c_z);
		this.rho_  =this.rho(a_x,b_y,c_z);
		this.theta_=a_x;
		this.camara[0]=this.rho_*Math.sin(this.phi_)*Math.cos(this.theta_);
		this.camara[1]=this.rho_*Math.sin(this.phi_)*Math.sin(this.theta_);
		this.camara[2]=this.rho_*Math.cos(this.phi_);
		//trace(this.theta_+" "+this.phi_+" "+this.rho_);
	}
	//_______________________________________________________________________________________________
	this.posCamara2 = function(a_x, b_y, c_z)
	{
		this.theta_=a_x;
		this.phi_  =b_y;
		this.rho_  =c_z;	
		this.camara[0]=this.rho_*Math.sin(this.phi_)*Math.cos(this.theta_);
		this.camara[1]=this.rho_*Math.sin(this.phi_)*Math.sin(this.theta_);
		this.camara[2]=this.rho_*Math.cos(this.phi_);
	}
	//_______________________________________________________________________________________________
	this.calculo_constantes = function()
	{
		this.v[0][0]=-Math.sin(this.theta_);
		this.v[1][0]=+Math.cos(this.theta_);
		this.v[0][1]=-Math.cos(this.phi_)*Math.cos(this.theta_);
		this.v[1][1]=-Math.cos(this.phi_)*Math.sin(this.theta_);
		this.v[2][1]=+Math.sin(this.phi_);
		this.v[0][2]=-Math.sin(this.phi_)*Math.cos(this.theta_);
		this.v[1][2]=-Math.sin(this.phi_)*Math.sin(this.theta_);
		this.v[2][2]=-Math.cos(this.phi_);
		this.v[3][2]=+this.rho_;
	}
	//_______________________________________________________________________________________________
	this.crearObj3D = function(tipo, arregloDePtos, anchoLinea, colorLinea, alphaLinea, colorRelleno, alphaRelleno)
	{
		obj = this.movieClipID.createEmptyMovieClip(tipo + this[tipo+"s"], this.lineas+this.superficies);
		obj.arregloDePtos = arregloDePtos;
		obj.anchoLinea    = anchoLinea;
		obj.colorLinea    = colorLinea;
		obj.alphaLinea    = alphaLinea;
		obj.colorRelleno  = colorRelleno;
		obj.alphaRelleno  = alphaRelleno;
		this[tipo+"s"]++;
	}
	//_______________________________________________________________________________________________
	this.dibujarObjs3D = function()
	{
		ptos = new Array(0,0);
		ptoMedio = new Array(0,0,0);
		nuevoNivel = new Number();
		limiteSuperior = new Number(Math.pow(10,9));
		limiteInferior = new Number(Math.pow(10,5));
		for (p=0;p<this.lineas;p++)
		{
			obj = this.movieClipID["linea"+p];
			obj.clear();
			obj.lineStyle(obj.anchoLinea, obj.colorLinea, obj.alphaLinea);
			for (j=0;j<obj.arregloDePtos.length-1;j++)
			{
				if (j==0)
				{
					this.screen(ptos,obj.arregloDePtos[j][0],obj.arregloDePtos[j][1],obj.arregloDePtos[j][2]);
					obj.moveTo(ptos[0],ptos[1]);
				}
				this.screen(ptos,obj.arregloDePtos[j+1][0],obj.arregloDePtos[j+1][1],obj.arregloDePtos[j+1][2]);
				obj.lineTo(ptos[0],ptos[1]);
			}	
			ptoMedio[0] = (obj.arregloDePtos[0][0]+obj.arregloDePtos[1][0])/2;
			ptoMedio[1] = (obj.arregloDePtos[0][1]+obj.arregloDePtos[1][1])/2;
			ptoMedio[2] = (obj.arregloDePtos[0][2]+obj.arregloDePtos[1][2])/2;
			nuevoNivel=(limiteSuperior-limiteInferior*this.distancia(this.camara[0],this.camara[1],this.camara[2],ptoMedio[0],ptoMedio[1],ptoMedio[2]));
			obj.swapDepths(nuevoNivel);
		}

		for (i=0;i<this.superficies;i++)
		{
			obj = this.movieClipID["superficie"+i];
			obj.clear();
			obj.lineStyle(obj.anchoLinea, obj.colorLinea, obj.alphaLinea);
			obj.beginFill(obj.colorRelleno, obj.alphaRelleno);
			for (j=0;j<obj.arregloDePtos.length-1;j++)
			{
				if (j==0)
				{
					this.screen(ptos,obj.arregloDePtos[j][0],obj.arregloDePtos[j][1],obj.arregloDePtos[j][2]);
					obj.moveTo(ptos[0],ptos[1]);
				}
				this.screen(ptos,obj.arregloDePtos[j+1][0],obj.arregloDePtos[j+1][1],obj.arregloDePtos[j+1][2]);
				obj.lineTo(ptos[0],ptos[1]);
			}
			obj.endFill();
			ptoMedio[0] = (obj.arregloDePtos[0][0]+obj.arregloDePtos[2][0])/2;
			ptoMedio[1] = (obj.arregloDePtos[0][1]+obj.arregloDePtos[2][1])/2;
			ptoMedio[2] = (obj.arregloDePtos[0][2]+obj.arregloDePtos[2][2])/2;
			nuevoNivel=(limiteSuperior-limiteInferior*this.distancia(this.camara[0],this.camara[1],this.camara[2],ptoMedio[0],ptoMedio[1],ptoMedio[2]));
			obj.swapDepths(nuevoNivel);
		}
		delete nuevoNivel;
		delete limiteSuperior;
		delete limiteInferior;
		delete ptoMedio;
		delete ptos;
	}
	//_______________________________________________________________________________________________
}
//_______________________________________________________________________________________________
_root.engine.prototype = new _root.rotacionTraslacion();
stop();
//_______________________________________________________________________________________________