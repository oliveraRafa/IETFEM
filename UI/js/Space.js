var Space = {

	//Dibuja una linea entre 2 puntos
	drawLine: function(xi, yi, zi, xf, yf, zf, material){
		var cylinderMaterial = new THREE.MeshBasicMaterial( {color: 0x000000} );
		var cylinder = this.cylinderMesh(new THREE.Vector3(xi, yi, zi), new THREE.Vector3(xf, yf, zf), cylinderMaterial);
		scene.add( cylinder );
	},

	//Dibuja un punto
	drawPoint: function(x, y, z){
		var sphereGeometry = new THREE.SphereGeometry( 0.05, 50, 50 );
		var sphereMaterial = new THREE.MeshBasicMaterial( {color: 0x000000} );
		var sphere = new THREE.Mesh( sphereGeometry, sphereMaterial );
		sphere.position.x = x
		sphere.position.y = y
		sphere.position.z = z
		scene.add(sphere);
		
		puntosEscena.push(sphere);	
		helpObjects.push(sphere);		
	},
	
	//Cambia entre dibujado de puntos y lineas
	activateLinesDrawing: function () {
		var linesButton = document.getElementById("linesButton");
		if (addingLines) {
			addingLines = false;
			firsPointLine = null;
			linesButton.innerHTML = "Agregar líneas"
		} else {
			addingLines = true;
			linesButton.innerHTML = "Agregar puntos"
		}
	},
	
	//Obtiene el Id de un punto dibujado dadas sus coordenadas
	getScenePointIdByCoords: function(x,y,z) {
		var id = 0;
		for (var i = 0; i < scene.children.length ;i++){
			if (scene.children[i] instanceof THREE.Mesh && !Model.isInModel(x,y,z) && scene.children[i].position.x == x && scene.children[i].position.y == y && scene.children[i].position.z == z)
				id = scene.children[i].id;
		};
		return id;
	},
		
	//Obtiene un punto dibujado dado el id
	getScenePointById: function(id) {
		var obj = null;
		for (var i = 0; i < scene.children.length ;i++){
			if (scene.children[i] instanceof THREE.Mesh && scene.children[i].id == id)
				obj = scene.children[i]
		};
		return obj;
	},
	
		cylinderMesh : function( point1, point2 ){

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
		var edgeGeometry = new THREE.CylinderGeometry( 0.015, 0.015, direction.length(), 8, 1);
		
		var edge = new THREE.Mesh( edgeGeometry, 
				new THREE.MeshBasicMaterial( { color: 0x000000 } ) );

		edge.applyMatrix(orientation)
		edge.applyMatrix( new THREE.Matrix4().makeTranslation((point1.x + point2.x)/2,(point1.y + point2.y)/2,(point1.z + point2.z)/2) );
		return edge;
	},
};