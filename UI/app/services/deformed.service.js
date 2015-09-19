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
			
		if (pX != 0 || pY != 0 || pZ != 0){
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
		}
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

	return {
		getDeformedPointById: getDeformedPointById,
		getDeformedLineById: getDeformedLineById,
		addPointToDeformed: addPointToDeformed,
		addLineToDeformed: addLineToDeformed,
	};
})