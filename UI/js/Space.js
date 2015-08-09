var Space = {

	//Dibuja una linea entre 2 puntos
	drawLine: function(xi, yi, zi, xf, yf, zf, material){
		geometry = new THREE.Geometry();
		geometry.vertices.push(new THREE.Vector3(xi, yi, zi));
		geometry.vertices.push(new THREE.Vector3(xf, yf, zf));
		line = new THREE.Line(geometry, material);
		scene.add(line);			
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
			if (scene.children[i] instanceof THREE.Mesh && Model.isInModel(x,y,z) && scene.children[i].position.x == x && scene.children[i].position.y == y && scene.children[i].position.z == z)
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
	}
};