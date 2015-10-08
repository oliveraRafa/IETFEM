angular.module('IETFEM')
.factory('DeformedService', function(SpaceService) {
	
	//Obtener punto del deformado por id de escena
	var getDeformedPointById = function(id, deformed) {
			for (var i = 0; i < deformed.points.length ;i++){
				if (deformed.points[i].id==id){
					return deformed.points[i];
				}
			};
	};

	//Obtener linea del deformado por id de escena
	var getDeformedLineBySceneId = function(id, deformed) {
			for (var i = 0; i < deformed.lines.length ;i++){
				if (deformed.lines[i].id==id){
					return deformed.lines[i];
				}
			};
	};

	var getDeformedPointBySceneId = function(id, deformed) {
			for (var i = 0; i < deformed.points.length ;i++){
				if (deformed.points[i].sceneId==id){
					return deformed.points[i];
				}
			};
	};

	//Obtener linea del deformado por id de escena
	var getDeformedLineById = function(id, deformed) {
			for (var i = 0; i < deformed.lines.length ;i++){
				if (deformed.lines[i].sceneId==id){
					return deformed.lines[i];
				}
			};
	};
	
	//Agrega un punto al deformado
	var addPointToDeformed = function(pX,pY,pZ,uX,uY,uZ, id, sceneId, deformed) {
			
		var point = {};
		point.id = id;
		point.sceneId = sceneId;

		point.coords = {
			x: pX,
			y: pY,
			z: pZ
		};
		point.displacements = {
			x: uX,
			y: uY,
			z: uZ
		};
		deformed.points.push(point);
	};
	
	//Agrega una línea al deformado
	var addLineToDeformed = function(p1, p2, id, lineSceneId, deformation, force, tension, model) {		
		var line = {};
		line.id = id
		line.sceneId= lineSceneId;
		line.start = p1;
		line.end = p2;
		line.deformation= deformation;
		line.force= force;
		line.tension= tension;
		
		model.lines.push(line);
	};

	var setDeformedMaterial = function(scene, deformed, material){
		if (deformed.points.length > 0){
			for (var i = 0; i < deformed.points.length ;i++){
				SpaceService.setMaterial(deformed.points[i].sceneId, scene, material);
			};
			for (var i = 0; i < deformed.lines.length ;i++){
				SpaceService.setMaterial(deformed.lines[i].sceneId, scene, material);
			};
		};
	};

	var setDeformedOpaque = function(scene, deformed){
		if (deformed.points.length > 0){
			var material = SpaceService.getMaterial(deformed.points[0].sceneId, scene);
			material = new THREE.MeshBasicMaterial( {color: material.color} );
			for (var i = 0; i < deformed.points.length ;i++){
				SpaceService.setMaterial(deformed.points[i].sceneId, scene, material);
			};
			for (var i = 0; i < deformed.lines.length ;i++){
				SpaceService.setMaterial(deformed.lines[i].sceneId, scene, material);
			};
		};
	};

	var setDeformedTransparent = function(scene, deformed){
		var material = SpaceService.getMaterial(deformed.points[0].sceneId, scene);
		material = new THREE.MeshBasicMaterial( {color: material.color, transparent: true, opacity: 0.15} );
		for (var i = 0; i < deformed.points.length ;i++){
			SpaceService.setMaterial(deformed.points[i].sceneId, scene, material);
		};
		for (var i = 0; i < deformed.lines.length ;i++){
			SpaceService.setMaterial(deformed.lines[i].sceneId, scene, material);
		};
	};

	var scaleDeformed = function(scene, deformed, model, scaleFactor){
		//var material = SpaceService.getMaterial(deformed.points[0].sceneId, scene, scaleFactor) || null;
		var material = new THREE.MeshBasicMaterial( {color: 0x000000} );
		for (var i = 0; i < deformed.points.length ;i++){

			var x = parseFloat(deformed.points[i].coords.x) + parseFloat(deformed.points[i].displacements.x)*parseFloat(scaleFactor);
			var y = parseFloat(deformed.points[i].coords.y) + parseFloat(deformed.points[i].displacements.y)*parseFloat(scaleFactor);
			var z = parseFloat(deformed.points[i].coords.z) + parseFloat(deformed.points[i].displacements.z)*parseFloat(scaleFactor);

			SpaceService.movePoint(deformed.points[i].sceneId, scene, x, y, z);
		};
		for (var i = 0; i < deformed.lines.length ;i++){

			var start = getDeformedPointById(deformed.lines[i].start, deformed);
			var end = getDeformedPointById(deformed.lines[i].end, deformed);
			var x1 = parseFloat(start.coords.x) + parseFloat(start.displacements.x)*parseFloat(scaleFactor);
			var y1 = parseFloat(start.coords.y) + parseFloat(start.displacements.y)*parseFloat(scaleFactor);
			var z1 = parseFloat(start.coords.z) + parseFloat(start.displacements.z)*parseFloat(scaleFactor);
			var x2 = parseFloat(end.coords.x) + parseFloat(end.displacements.x)*parseFloat(scaleFactor);
			var y2 = parseFloat(end.coords.y) + parseFloat(end.displacements.y)*parseFloat(scaleFactor);
			var z2 = parseFloat(end.coords.z) + parseFloat(end.displacements.z)*parseFloat(scaleFactor);

			deformed.lines[i].sceneId = SpaceService.moveLine(deformed.lines[i].sceneId, scene, x1, y1, z1, x2, y2, z2);
		};
	};
	
	return {
		getDeformedPointById: getDeformedPointById,
		getDeformedLineById: getDeformedLineById,
		addPointToDeformed: addPointToDeformed,
		addLineToDeformed: addLineToDeformed,
		setDeformedMaterial: setDeformedMaterial,
		setDeformedTransparent: setDeformedTransparent,
		setDeformedOpaque: setDeformedOpaque,
		scaleDeformed: scaleDeformed,
	};
})