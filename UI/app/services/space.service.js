angular.module('IETFEM')
.factory('SpaceService', function() {

	var colorRange = [
		{index:-5, color:0x610B0B},
		{index:-4, color:0xB40404},
		{index:-3, color:0xFF0000},
		{index:-2, color:0xFA5858},
		{index:-1, color:0xF5A9A9},
		{index:0, color:0x2E9AFE},
		{index:1, color:0xA9F5A9},
		{index:2, color:0x58FA58},
		{index:3, color:0x00FF00},
		{index:4, color:0x04B404},
		{index:5, color:0x0B610B},
	]

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
		var edgeGeometry = new THREE.CylinderGeometry( width, width, direction.length(), 4, 1);
		
		var edge = new THREE.Mesh( edgeGeometry, 
				material);

		edge.applyMatrix(orientation)
		edge.applyMatrix( new THREE.Matrix4().makeTranslation((point1.x + point2.x)/2,(point1.y + point2.y)/2,(point1.z + point2.z)/2) );
		return edge;
	};

	var	pyramidMesh = function( point1, point2, material, width){

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
		//var edgeGeometry = new THREE.CylinderGeometry( 1, width, 3, 4);
		var edgeGeometry = new THREE.CylinderGeometry( 0.1, 0, direction.length(), 4);
		
		var edge = new THREE.Mesh( edgeGeometry, 
				material);

		edge.applyMatrix(orientation)
		edge.applyMatrix( new THREE.Matrix4().makeTranslation((point1.x + point2.x)/2,(point1.y + point2.y)/2,(point1.z + point2.z)/2) );
		return edge;
	};

	var	rotateCylinder = function( point1, point2, material, width){

		var direction = new THREE.Vector3().subVectors( point2, point1 );
		var orientation = new THREE.Matrix4();

		orientation.lookAt(point1, point2, new THREE.Object3D().up);

		var matrix4 = new THREE.Matrix4();
		 matrix4.set(1,0,0,0,
		 			0,0,1,0, 
		 			0,-1,0,0,
		 			0,0,0,1);
		 orientation.multiply(matrix4);

		var edgeGeometry = new THREE.CylinderGeometry( width, width, direction.length(), 8, 1);

		return {
				geometry: edgeGeometry, 
				orientation: orientation
			};
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
		var sphereGeometry = new THREE.SphereGeometry( 0.1, 4, 4 );
		var sphere = new THREE.Mesh( sphereGeometry, sphereMaterial );
		sphere.position.x = x
		sphere.position.y = y
		sphere.position.z = z
		scene.add(sphere);
		
		puntosEscena.push(sphere);	
		helpObjects.push(sphere);	

		return sphere.id;	
	};

	// Se le pasa las coordenadas de un punto y un booleano para el eje que es el apoyo
	var drawPyramidSupport = function(x,y,z,isX,isY,isZ,scene){
		var material = new THREE.MeshBasicMaterial( {color: 0x610B0B} );
		if(isX){
			if(x>=0){
				var pyramid = pyramidMesh(new THREE.Vector3(x-0.1, y, z), new THREE.Vector3(x-0.3, y, z), material,2);
			}else{
				var pyramid = pyramidMesh(new THREE.Vector3(x+0.1, y, z), new THREE.Vector3(x+0.3, y, z), material,2);
			}
			scene.add(pyramid);
			return pyramid.id;
		}else if(isY){
			if(y>=0){
				var pyramid = pyramidMesh(new THREE.Vector3(x, y-0.1, z), new THREE.Vector3(x, y-0.3, z), material,2);
			}else{
				var pyramid = pyramidMesh(new THREE.Vector3(x, y+0.1, z), new THREE.Vector3(x, y+0.3, z), material,2);
			}
			scene.add(pyramid);
			return pyramid.id;
		}else if(isZ){
			if(z>=0){
				var pyramid = pyramidMesh(new THREE.Vector3(x, y, z-0.1), new THREE.Vector3(x, y, z-0.3), material,2);
			}else{
				var pyramid = pyramidMesh(new THREE.Vector3(x, y, z+0.1), new THREE.Vector3(x, y, z+0.3), material,2);
			}
			scene.add(pyramid);
			return pyramid.id;
		}
	};

	//Dibuja el modelo entero
	var drawModel = function(scene, model, puntosEscena, lineasEscena, helpObjects){

		var material = new THREE.MeshBasicMaterial( {color: 0x000000} );
		var start = {};
		var end = {};

		for (i=0; i<model.points.length; i++){
			model.points[i].sceneId = drawPoint(model.points[i].coords.x, model.points[i].coords.y, model.points[i].coords.z, scene, puntosEscena, material, helpObjects.grilla);	
			$('#toggle-event').click();
			$('#toggle-event').click();
			$('#toggle-event2').click();
			$('#toggle-event2').click();
		}

		for (i=0; i<model.lines.length; i++){

			for (j=0; j<model.points.length; j++){
				if (model.lines[i].start==model.points[j].id){
					start.x = model.points[j].coords.x;
					start.y = model.points[j].coords.y;
					start.z = model.points[j].coords.z;
				}
				if (model.lines[i].end==model.points[j].id){
					end.x = model.points[j].coords.x;
					end.y = model.points[j].coords.y;
					end.z = model.points[j].coords.z;
				}
			};
			model.lines[i].sceneId = drawLine(start.x, start.y, start.z, end.x, end.y, end.z, material, 0.05, scene ,lineasEscena);
		}
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


	var getMaterial = function(id, scene) {
		return getScenePointById(id, scene).material;
	};

	var setMaterial = function(id, scene, material) {
		getScenePointById(id, scene).material = material;
	};

	var movePoint = function(id, scene, x, y, z) {
		getScenePointById(id, scene).position.x = x;
		getScenePointById(id, scene).position.y = z;
		getScenePointById(id, scene).position.z = y;
	};

	var moveLine = function(id, scene, x1, y1, z1, x2, y2, z2) {

		var material = getMaterial(id, scene);
		var rotated = cylinderMesh(new THREE.Vector3(x1, z1, y1), new THREE.Vector3(x2, z2, y2), material, 0.05);
		
		scene.add(rotated);

		for (var i = 0; i < scene.children.length ;i++){
			if (scene.children[i] instanceof THREE.Mesh && scene.children[i].id == id)
				scene.remove(scene.children[i]);
		};

		return scene.children[scene.children.length-1].id;

		//drawLine(x1, y1, z1, x2, y2, z2, material, 0.05, scene,[])

	};
	var hideShowObject =  function(id,visible,scene){
		var obj= scene.getObjectById( id, true );
		if(obj != null){
			obj.visible=visible;
		}

	};

	var removeObjectById = function(id,scene){
		var obj= scene.getObjectById( id, true );
		scene.remove(obj);
	};

	var getColor = function(index){
		for (var i = 0; i < colorRange.length ;i++){
			if (colorRange[i].index === index)
				return colorRange[i].color;
		};
	};


	
	return {
		drawLine: drawLine,
		drawPoint: drawPoint,
		drawPyramidSupport: drawPyramidSupport,
		drawModel: drawModel,
		getSceneLineById:getSceneLineById,
		getScenePointById: getScenePointById,
		getScenePointIdByCoords: getScenePointIdByCoords,
		getMaterial: getMaterial,
		setMaterial: setMaterial,
		movePoint: movePoint,
		moveLine: moveLine,
		hideShowObject: hideShowObject,
		removeObjectById: removeObjectById,
		getColor: getColor
	};

});