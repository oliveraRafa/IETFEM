angular.module('IETFEM')
.factory('ModelService', function(SpaceService) {

	// Funciones internas

	//Genera un nuevo identificador
	var newIdentifier = function(type, model) {
		var id = 0;
		if (type == 'POINT'){
			for (var i = 0; i < model.points.length; i++){
				if (model.points[i].id > id)
					id = model.points[i].id
			}
		} else { 
			for (var i = 0; i < model.lines.length; i++){
				if (model.lines[i].id > id)
					id = model.lines[i].id
			}					
		}
		return id+1;
	};
	
	//Obtiene un punto del modelo dadas sus coordenadas
	var getPointIdByCoords = function(x,y,z,model) {
		var id = 0;
		for (var i = 0; i < model.points.length ;i++){
			if (model.points[i].coords.x == x && model.points[i].coords.y == y && model.points[i].coords.z == z)
				id = model.points[i].id;
		};
		return id;
	};
	//--- Fin internas
	
	//Obtener objeto por id de escena
	var getPointById = function(id, model) {
			for (var i = 0; i < model.points.length ;i++){
				if (model.points[i].sceneId==id){
					return model.points[i];
				}
			};
	};
	
	//Agrega un punto al modelo
	var addPointToModel = function(pX,pY,pZ, sceneId, model) {
			
		if (pX != 0 || pY != 0 || pZ != 0){
		var point = {};
		point.id = newIdentifier('POINT', model);
		point.sceneId = sceneId;
		//Displacement conditions
		point.xCondicion=0;
		point.yCondicion=0;
		point.zCondicion=0;
		//Forces applied
		point.xForce=0;
		point.yForce=0;
		point.zForce=0;

		point.coords = {
			x: pX,
			y: pY,
			z: pZ
		};
		model.points.push(point);
		}
	};
	
	//Agrega una línea al modelo
	var addLineToModel = function(pX1, pY1, pZ1, pX2, pY2, pZ2, model) {		
		var line = {};
		line.id = newIdentifier('LINE', model);
		line.properties = [];
		line.start = getPointIdByCoords(pX1, pY1, pZ1,model);
		line.end = getPointIdByCoords(pX2, pY2, pZ2, model);
		
		model.lines.push(line);
	};
	
	//Verifica si un punto está en el modelo
	var isInModel = function(x,y,z, model) {
		var drawed = true;
		for (var i = 0; i < model.points.length ;i++){
			if (model.points[i].coords.x == x && model.points[i].coords.y == y && model.points[i].coords.z == z)
				return true
		};
		return false;
	};
	
	//Genera txt a partir del modelo
	var getText = function(model) {
		var text;
		text = 'Node matrix ' + '\n';
		text += 'Id     Xs     Ys     Zs' + '\n';
		for (var i = 0; i < model.points.length ;i++){
			text += model.points[i].id + '     ' + model.points[i].coords.x + '     ' + model.points[i].coords.y + '     ' + model.points[i].coords.z + '\n'; 
		}
		text += '\n' + 'Conectivity matrix' + '\n';
		text += 'material     section     tempcase     start     end' + '\n';
		for (var i = 0; i < model.lines.length ;i++){
			text += 1 + '     ' + 1 + '     ' + 0 + '     ' + model.lines[i].start + '     ' + model.lines[i].end + '\n'; 
		}
		return text;
	};

	return {
		getPointById: getPointById,
		addPointToModel: addPointToModel,
		addLineToModel: addLineToModel,
		isInModel: isInModel,
		getText: getText,
	};
});