var Model = {

	//Agrega un punto al modelo
	addPointToModel: function(pX,pY,pZ) {
			
		if (pX != 0 && pY != 0 && pZ != 0){
		var point = {};
		point.id = this.newIdentifier('POINT');
		point.sceneId = Space.getScenePointIdByCoords(pX,pY,pZ);
		//Displacemente conditions
		point.xCondition=0;
		point.coords = {
			x: pX,
			y: pY,
			z: pZ
		};
		model.points.push(point);
		}
	},
	
	//Agrega una línea al modelo
	addLineToModel: function(pX1, pY1, pZ1, pX2, pY2, pZ2) {		
		var line = {};
		line.id = this.newIdentifier('LINE');
		line.properties = [];
		line.start = this.getPointIdByCoords(pX1, pY1, pZ1);
		line.end = this.getPointIdByCoords(pX2, pY2, pZ2);
		
		model.lines.push(line);
	},
	
	//Verifica si un punto está en el modelo
	isInModel: function(x,y,z) {
		var drawed = true;
		for (var i = 0; i < model.points.length ;i++){
			if (model.points[i].coords.x == x && model.points[i].coords.y == y && model.points[i].coords.z == z)
				return true
		};
		return false;
	},
	
	//Obtener objeto por id
	getPointById: function(id) {
			
		for (var i = 0; i < model.points.length ;i++){
			if (model.points[i].sceneId==id){
				return model.points[i];
			}
		};
	},
	
	//Obtiene un punto del modelo dadas sus coordenadas
	getPointIdByCoords:	function(x,y,z) {
		var id = 0;
		for (var i = 0; i < model.points.length ;i++){
			if (model.points[i].coords.x == x && model.points[i].coords.y == y && model.points[i].coords.z == z)
				id = model.points[i].id;
		};
		return id;
	},
	
	//Genera un nuevo identificador
	newIdentifier: function(type) {
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
	},
	
	//Genera txt a partir del modelo
	getText: function() {
		console.log(scene);
		console.log(model);
		var textArea = document.getElementById('textModel')
		textArea.value = 'Node matrix ' + '\n';
		textArea.value += 'Id     Xs     Ys     Zs' + '\n';
		for (var i = 0; i < model.points.length ;i++){
			textArea.value += model.points[i].id + '     ' + model.points[i].coords.x + '     ' + model.points[i].coords.y + '     ' + model.points[i].coords.z + '\n'; 
		}
		textArea.value += '\n' + 'Conectivity matrix' + '\n';
		textArea.value += 'material     section     tempcase     start     end' + '\n';
		for (var i = 0; i < model.lines.length ;i++){
			textArea.value += 1 + '     ' + 1 + '     ' + 0 + '     ' + model.lines[i].start + '     ' + model.lines[i].end + '\n'; 
		}
	}

};