angular.module('IETFEM')
.factory('SpaceService', function() {

	// Funciones internas
		var	cylinderMesh = function( point1, point2, material, width){

		/* edge from X to Y */
		var direction = new THREE.Vector3().subVectors( point2, point1 );
		var orientation = new THREE.Matrix4();
		/* THREE.Object3D().up (=Y) default orientation for all objects */
		orientation.lookAt(point1, point2, new THREE.Object3D().up);
		/* rotation around axis X by -90 degrees 
		 * matches the default orientation Y 
		 * with the orientation of looking Z */
		var matrix4 = new THREE.Matrix4();
		matrix4.set(1,0,0,0,
					0,0,1,0, 
					0,-1,0,0,
					0,0,0,1);
		orientation.multiply(matrix4);

		/* cylinder: radiusAtTop, radiusAtBottom, 
			height, radiusSegments, heightSegments */
		var edgeGeometry = new THREE.CylinderGeometry( width, width, direction.length(), 8, 1);
		
		var edge = new THREE.Mesh( edgeGeometry, 
				material);

		edge.applyMatrix(orientation)
		edge.applyMatrix( new THREE.Matrix4().makeTranslation((point1.x + point2.x)/2,(point1.y + point2.y)/2,(point1.z + point2.z)/2) );
		return edge;
	};
	//--- Fin internas
	
	//Dibuja una linea entre 2 puntos
	var drawLine = function(xi, yi, zi, xf, yf, zf, material, width, scene,lineasEscena){
		var cylinder = cylinderMesh(new THREE.Vector3(xi, yi, zi), new THREE.Vector3(xf, yf, zf), material, width);
		scene.add( cylinder );

		if(lineasEscena != null){//Se pasa null en la grilla x ejemplo
			lineasEscena.push(cylinder);
		}

		return cylinder.id;
	};

	//Dibuja un punto
	var drawPoint = function(x, y, z, scene, puntosEscena, sphereMaterial, helpObjects){
		var sphereGeometry = new THREE.SphereGeometry( 0.1, 20, 20 );
		var sphere = new THREE.Mesh( sphereGeometry, sphereMaterial );
		sphere.position.x = x
		sphere.position.y = y
		sphere.position.z = z
		scene.add(sphere);
		
		puntosEscena.push(sphere);	
		helpObjects.push(sphere);	

		return sphere.id;	
	};
	
	//Obtiene un punto dibujado dado el id
	var getScenePointById = function(id, scene) {
		var obj = null;
		for (var i = 0; i < scene.children.length ;i++){
			if (scene.children[i] instanceof THREE.Mesh && scene.children[i].id == id)
				obj = scene.children[i]
		};
		return obj;
	};

	//Obtiene una linea dibujada dado el id
	var getSceneLineById = function(id, scene) {
		var obj = null;
		for (var i = 0; i < scene.children.length ;i++){
			if (scene.children[i] instanceof THREE.Mesh && scene.children[i].id == id)
				return scene.children[i]
		};
	};
	
	//Obtiene el Id de un punto dibujado dadas sus coordenadas
	var getScenePointIdByCoords = function(x,y,z, scene) {
		var id = 0;
		for (var i = 0; i < scene.children.length ;i++){
			if (scene.children[i] instanceof THREE.Mesh && getScenePointById(i, scene) == null && scene.children[i].position.x == x && scene.children[i].position.y == y && scene.children[i].position.z == z)
				id = scene.children[i].id;
		};
		return id;
	};
	
	return {
		drawLine: drawLine,
		drawPoint: drawPoint,
		getSceneLineById:getSceneLineById,
		getScenePointById: getScenePointById,
		getScenePointIdByCoords: getScenePointIdByCoords,
	};

});