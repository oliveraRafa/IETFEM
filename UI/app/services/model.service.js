angular.module('IETFEM')
.factory('ModelService',['DefaultsService',function(DefaultsService) {

	// Funciones internas

	//Genera un nuevo identificador
	var newPointIdentifier = function(model) {
		var id = 0;
		for (var i = 0; i < model.points.length; i++){
			if (model.points[i].id > id)
				id = model.points[i].id
		}
		return id+1;
	};

	var newLineIdentifier = function(model) {
		var id = 0;
		for (var i = 0; i < model.lines.length; i++){
			if (model.lines[i].id > id)
				id = model.lines[i].id
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

	//Obtener punto del modelo por id
	var getPointById = function(id, model) {
			for (var i = 0; i < model.points.length ;i++){
				if (model.points[i].id==id){
					return model.points[i];
				}
			};
	};

	//Obtener linea del modelo por id
	var getLineById = function(id, model) {
			for (var i = 0; i < model.lines.length ;i++){
				if (model.lines[i].id==id){
					return model.lines[i];
				}
			};
	};
	//Obtener punto del modelo por id de escena
	var getPointBySceneId = function(id, model) {
			for (var i = 0; i < model.points.length ;i++){
				if (model.points[i].sceneId==id){
					return model.points[i];
				}
			};
	};

	//Obtener linea del modelo por id de escena
	var getLineBySceneId = function(id, model) {
			for (var i = 0; i < model.lines.length ;i++){
				if (model.lines[i].sceneId==id){
					return model.lines[i];
				}
			};
	};
	
	//Agrega un punto al modelo
	var addPointToModel = function(pX,pY,pZ, sceneId, model) {
			
		if (pX != 0 || pY != 0 || pZ != 0){
		var point = {};
		point.id = newPointIdentifier( model);
		point.sceneId = sceneId;
		//Displacement conditions
		point.xCondicion='F';
		point.yCondicion='F';
		point.zCondicion='F';
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
	var addLineToModel = function(pX1, pY1, pZ1, pX2, pY2, pZ2, lineSceneId,model) {		
		var line = {};
		line.id = newLineIdentifier(model);
		line.sceneId= lineSceneId;
		line.material=DefaultsService.getLineMaterial();
		line.section=DefaultsService.getLineSection();
		line.start = getPointIdByCoords(pX1, pY1, pZ1,model);
		line.end = getPointIdByCoords(pX2, pY2, pZ2, model);
		
		model.lines.push(line);
	};

	var createGridInfo = function(modelGrids){
		//Obtengo el id del nuevo grid (max+1)
		var miGridId=0;
		for (var i = 0; i < modelGrids.length ;i++){
			if(modelGrids[i].gridId >= miGridId){
				miGridId=modelGrids[i].gridId;
			}
		}
		miGridId++;

		var gridInfo={};
		gridInfo.gridId=miGridId;
		gridInfo.viewStatus=true;
		gridInfo.objects= [];

		modelGrids.push(gridInfo);
		return gridInfo;
	};

		//Agrega un punto al modelo de las grillas
	var addGridPointToModel = function(pX,pY,pZ, sceneId, gridInfo) {
		var point = {};
		point.sceneId = sceneId;
		point.coords = {
			x: pX,
			y: pY,
			z: pZ
		}

		gridInfo.objects.push(point);
		
	};

	//Agrega una línea al modelo
	var addGridLineToModel = function(pX1, pY1, pZ1, pX2, pY2, pZ2, lineSceneId,gridInfo) {		
		var line = {};
		line.sceneId= lineSceneId;

		gridInfo.objects.push(line);
	};


	var removeLineFromModel = function(lineId,model){
		var index=null;
		for (var i = 0; i < model.lines.length ;i++){
			if(model.lines[i].id== lineId){
				index=i;
				break;
			}
		}
		if(index != null){
			model.lines.splice(index,1);
		}
	};

	// Para eliminar objetos de las estructuras auxiliares x sceneId (en realidad los objetos son de la scene Three)
	var removeObjFromArray = function(sceneId,aux){
		var index=null;
		for (var i = 0; i < aux.length ;i++){
			if(aux[i].id== sceneId){
				index=i;
				break;
			}
		}
		if(index != null){
			aux.splice(index,1);
		}
	};

	var removePointFromModel = function(pointId,model){
		var index=null;
		for (var i = 0; i < model.points.length ;i++){
			if(model.points[i].id== pointId){
				index=i;
				break;
			}
		}
		if(index != null){
			model.lines.splice(index,1);
		}
	};

	//Agrega un material al modelo
	var addMaterial = function(name,ym,g,a,nu,model) {		
		var material = {};
		
		material.name=name;
		material.youngModule=ym;
		material.gamma=g;
		material.alpha=a;
		material.nu=nu;
		
		model.materiales.push(material);
	};

	//Agrega un material al modelo
	var addSection = function(s,model) {		
		var section = {};
		
		section.section=s;
		
		model.secciones.push(section);
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
		text = 'Input for a 3D with large deformation (You must respect line breaks):' + '\n\n' + 'Force Magnitude' + '\n' + 'N' + '\n\n' + 'Length Magnitude' + '\n' + 'm' + '\n\n'
			   + 'Number of degrees of freedom per node' + '\n' + '3' + '\n\n' + 'Number of nodes per element' + '\n' + '2' + '\n\n';

		text +=  'Number of materials' + '\n' + model.materiales.length + '\n\n';
		
		text += 'Materials:' + '\n' + 'Young Modulus        Gamma         alpha (1/C)' + '\n';
		for (var i = 0; i < model.materiales.length ;i++){
			text += model.materiales[i].youngModule + '     ' + model.materiales[i].gamma + '     ' + model.materiales[i].alpha + '\n'; 
		}
		text += '\n' + 'Number of temperature cases' + '\n' + '0' + '\n\n' + 'Temperature cases:' + '\n' + 'Value' + '\n\n';
		
		text +=  'Number of sections' + '\n' + model.secciones.length + '\n\n';

		text += 'Sections:' + '\n' + 'Area' + '\n';
		for (var i = 0; i < model.secciones.length ;i++){
			text += model.secciones[i].section + '\n'; 
		}
		
		text += '\n' + 'Number of nodes' + '\n' + model.points.length + '\n\n';
		
		text += 'Node matrix ' + '\n';
		text += 'Xs     Ys     Zs' + '\n';
		for (var i = 0; i < model.points.length ;i++){
			text += model.points[i].coords.x + '     ' + model.points[i].coords.y + '     ' + model.points[i].coords.z + '\n'; 
		}
		text += '\n' + 'Conectivity matrix' + '\n';
		text += 'material     section     tempcase     start     end' + '\n';
		for (var i = 0; i < model.lines.length ;i++){
			text += model.lines[i].material + '     ' + model.lines[i].section + '     ' + 0 + '     ' + model.lines[i].start + '     ' + model.lines[i].end + '\n'; 
		}
		var displacementNodes = [];
		for (var i = 0; i < model.points.length ;i++){
			if (model.points[i].xCondicion != 'F' || model.points[i].yCondicion != 'F' || model.points[i].zCondicion != 'F'){
				displacementNodes.push(model.points[i]);
			}
		}
		text += '\n' + 'Number of displacement conditions nodes' + '\n' + displacementNodes.length + '\n\n' + 'Displacement node  X condition   Y condition   Z condition' + '\n'
		for (var i = 0; i < displacementNodes.length ;i++){
			text += i + '     ' + displacementNodes[i].xCondicion + '     ' + displacementNodes[i].yCondicion + '     ' + displacementNodes[i].zCondicion + '\n'; 
		}
		
		var loadNodes = [];
		for (var i = 0; i < model.points.length ;i++){
			if (model.points[i].xForce != 0 || model.points[i].yForce != 0 || model.points[i].zForce != 0){
				loadNodes.push(model.points[i]);
			}
		}
		text += '\n' + 'Puntual loads conditions nodes matrix' + '\n' + loadNodes.length + '\n\n' + 'Load node       FX            FY           FZ' + '\n'
		for (var i = 0; i < loadNodes.length ;i++){
			text += i + '     ' + loadNodes[i].xForce + '     ' + loadNodes[i].yForce + '     ' + loadNodes[i].zForce + '\n'; 
		}
	
		
		//Agrega las opciones de salida al final
		text += '\n' + 'Number of dead volume load conditions' + '\n' + '0' +'\n\n' + 'Dead volume loads conditions matrix' + '\n' + 'Element           bx                  by                  bz' + '\n\n' + 'Number of springs conditions nodes' + '\n' + '0' + '\n\n' + 'Springs conditions nodes matrix' + '/n' + 'Spring node  X condition   Y condition   Z condition' + '\n\n' + 'Scale Factor' + '\n' + 'SD_Deformed   Supports    Areas    Forces    Frames    Numbers' + '\n' + '   70           1         1         1         0.05         1' + '\n\n' + 'What you wanna see? (Yes=1, No=0)' + '\n' + 'Indeformed   SD_Deformed   SD_Axial' + '\n' + '1                 1            1' + '\n\n' + 'Wich of the plots selected above do you want to print (.png image)? (Yes=1, No=0)' + '\n' + 'Indeformed   SD_Deformed  SD_Axial' + '\n' + '1                 1            1' + '\n\n' + 'How many images do you wanna see for small deformation?' + '\n' + 'SD_Deformed   SD_Axial' + '\n' + '1                 1            1' + '\n\n' + 'What you wanna see in plots? (Yes=1, No=0)' + '\n' + 'Supports   Node_Numbers   Elements_Numbers   Forces          Axial_Force_Value' + '1               0                0              1                   0' + '\n\n' + 'For 3D plots, what you wanna see? (Yes=1, No=0)' + '\n' + 'If you choose Dif_View=1 IETFEM use default AZIMUTH and ELEVATION, if you choose Dif_View=0 you must type aximuth and elevation in degrees.' + '\n' + 'XY_plane    XZ_plane    YZ_plane    Dif_View   AZIMUTH(degree)   ELEVATION(degree)' + '\n' + '1            1           1           0           150               15' + '\n\n' + 'Text output format (Yes=1, No=0)' + '\n' + 'TXT  TEX' + '\n' + '1     1' + '\n';

		return text;
		
	};

	var validModel = function(model) {
		var validObj = {
			valid:true,
			emptyStructure:false,
			invalidStructure:false
		};
		if (model.lines.length == 0){
			validObj.emptyStructure = true
			validObj.valid = false
		}
		for (var i = 0; i < model.lines.length ;i++){
			if(!model.lines[i].material || !model.lines[i].section) {
				validObj.invalidStructure = true;
				validObj.valid = false
			}
		}
		return validObj;
	};

	var setModelMaterial = function(scene, model, material){
		for (var i = 0; i < model.points.length ;i++){
			SpaceService.setMaterial(model.points[i].sceneId, scene, material);
		};
		for (var i = 0; i < model.lines.length ;i++){
			SpaceService.setMaterial(model.lines[i].sceneId, scene, material);
		};
	};

	var setModelOpaque = function(scene, model){
		if (model.points.length > 0){
			var material = SpaceService.getMaterial(model.points[0].sceneId, scene);
			material = new THREE.MeshBasicMaterial( {color: material.color} );
			for (var i = 0; i < model.points.length ;i++){
				SpaceService.setMaterial(model.points[i].sceneId, scene, material);
			};
			for (var i = 0; i < model.lines.length ;i++){
				SpaceService.setMaterial(model.lines[i].sceneId, scene, material);
			};
		};	
	};

	var setModelTransparent = function(scene, model){
		if (model.points.length > 0){
			var material = SpaceService.getMaterial(model.points[0].sceneId, scene);
			material = new THREE.MeshBasicMaterial( {color: material.color, transparent: true, opacity: 0.15} );
			for (var i = 0; i < model.points.length ;i++){
				SpaceService.setMaterial(model.points[i].sceneId, scene, material);
			};
			for (var i = 0; i < model.lines.length ;i++){
				SpaceService.setMaterial(model.lines[i].sceneId, scene, material);
			};
		};	
	};

	return {
		addMaterial: addMaterial,
		addSection: addSection,
		getPointById: getPointById,
		getLineById: getLineById,
		getPointBySceneId: getPointBySceneId,
		getLineBySceneId: getLineBySceneId,
		getPointIdByCoords: getPointIdByCoords,
		removeLineFromModel: removeLineFromModel,
		removeObjFromArray: removeObjFromArray,
		removePointFromModel: removePointFromModel,
		addPointToModel: addPointToModel,
		addLineToModel: addLineToModel,
		isInModel: isInModel,
		getText: getText,
		validModel: validModel,
		setModelMaterial: setModelMaterial,
		setModelTransparent: setModelTransparent,
		setModelOpaque: setModelOpaque,
		addGridLineToModel: addGridLineToModel,
		addGridPointToModel: addGridPointToModel,
		createGridInfo: createGridInfo

	};
}]);