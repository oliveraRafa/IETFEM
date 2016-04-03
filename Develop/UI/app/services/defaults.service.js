angular.module('IETFEM')
.factory('DefaultsService',function() {

	var LineaMaterial=null;
	var LineaSection=null;

	//Geometrias
	var esferaEstandar= new THREE.SphereGeometry(  0.1, 4, 4  );
	var esferaGrande = new THREE.SphereGeometry( 0.15, 4, 4 );
	

	//Materiales
	var materialGrilla=new THREE.MeshBasicMaterial( {color: 0xFF0000, transparent: true, opacity: 0.15} );
	var materialNegro= new THREE.MeshBasicMaterial( {color: 0x000000} );
	var materialResaltado = new THREE.MeshBasicMaterial( {color: 0x0084ca} );
	var materialSeleccion = new THREE.MeshBasicMaterial( {color: 0x088A08} );
	var materialCreacionLinea = new THREE.MeshBasicMaterial( {color: 0x8B0000} );

	var getMaterialGrilla = function(){
		return materialGrilla;
	};

	var getMaterialNegro = function(){
		return materialNegro;
	};

	var getMaterialResaltado = function(){
		return materialResaltado;
	};

	var getMaterialSeleccion = function(){
		return materialSeleccion;
	};

	var getMaterialCreacionLinea = function(){
		return materialCreacionLinea;
	};

	var getEsferaEstandar = function(){
		return esferaEstandar;
	};

	var getEsferaGrande = function(){
		return esferaGrande;
	};

	//-------------------------------------------------------------------------

	var getLineMaterial = function(){
		return LineaMaterial;
	};

	var getLineSection = function(){
		return LineaSection;
	};

	var setLineMaterial = function(m){
		LineaMaterial=m;
	};

	var setLineSection = function(s){
		LineaSection=s;
	};

	return {
		getLineMaterial: getLineMaterial,
		getLineSection: getLineSection,
		setLineMaterial: setLineMaterial,
		setLineSection: setLineSection,
		getEsferaEstandar: getEsferaEstandar,
		getEsferaGrande: getEsferaGrande,
		getMaterialGrilla: getMaterialGrilla,
		getMaterialNegro: getMaterialNegro,
		getMaterialResaltado: getMaterialResaltado,
		getMaterialSeleccion: getMaterialSeleccion,
		getMaterialCreacionLinea: getMaterialCreacionLinea
	}

	});