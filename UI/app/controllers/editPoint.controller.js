var app = angular.module('IETFEM');
	app.controller('editPointCtrl',['$scope','ModelService','PtoSelecService','SpaceService',function($scope,ModelService,PtoSelecService,SpaceService){
		$scope.miPunto=PtoSelecService.getPunto();//Es una copia del punto del modelo!
		this.updated= function(){
			var puntoModelo= PtoSelecService.getPuntoReal();
			if( typeof puntoModelo != 'undefined' &&
				puntoModelo.xCondicion== $scope.miPunto.xCondicion &&
				puntoModelo.yCondicion== $scope.miPunto.yCondicion &&
				puntoModelo.zCondicion== $scope.miPunto.zCondicion &&
				puntoModelo.xForce== $scope.miPunto.xForce &&
				puntoModelo.yForce== $scope.miPunto.yForce &&
				puntoModelo.zForce== $scope.miPunto.zForce
			){
				return true;
			}else{
				
				return false;
			}
		};
		
		this.updatePoint= function(){
			var puntoModelo= PtoSelecService.getPuntoReal();
			PtoSelecService.setInfoPuntoForm($scope.infoPuntoForm);
			if(typeof puntoModelo != 'undefined'){
				puntoModelo.xCondicion= $scope.miPunto.xCondicion;
				puntoModelo.yCondicion= $scope.miPunto.yCondicion;
				puntoModelo.zCondicion= $scope.miPunto.zCondicion;

				puntoModelo.xForce= parseFloat($scope.miPunto.xForce);
				puntoModelo.yForce= parseFloat($scope.miPunto.yForce);
				puntoModelo.zForce= parseFloat($scope.miPunto.zForce);
				PtoSelecService.resetForm();
			}
		};		

		this.existsPointToRemove= function(){
			return PtoSelecService.getPunto().id != 0;
		};

		this.deleteNode = function(){
			var nodeToRemove= PtoSelecService.getPuntoReal();
			var sceneObjectFirst = $scope.scene.getObjectById(nodeToRemove.sceneId);

			var lineasImplicadas= getLinesByNode(nodeToRemove.id);
			for (var i = 0; i < lineasImplicadas.length ;i++){//Elimino tambien lineas que tenian ese nodo
				var lineToRemove= lineasImplicadas[i];
				var sceneObject =$scope.scene.getObjectById(lineToRemove.sceneId);
				
				ModelService.removeLineFromModel(lineToRemove.id,$scope.model);
				ModelService.removeObjFromArray(lineToRemove.sceneId,$scope.spaceAux.sceneLines);
				$scope.scene.remove(sceneObject);
			}

			PtoSelecService.resetPuntoSeleccionado();
			ModelService.removePointFromModel(nodeToRemove.id,$scope.model);
			ModelService.removeObjFromArray(nodeToRemove.sceneId,$scope.spaceAux.scenePoints);
			if(nodeToRemove.forceArrowId != 0){
				SpaceService.removeObjectById(nodeToRemove.forceArrowId,$scope.scene);
			}
			$scope.scene.remove(sceneObjectFirst);
			$scope.render();

		};

		function getLinesByNode(nodeId){
			var allLines=[];
			for (var i = 0; i < $scope.model.lines.length ;i++){
				if($scope.model.lines[i].start == nodeId || $scope.model.lines[i].end == nodeId){
					allLines.push($scope.model.lines[i]);	
				}
			}
			return allLines;
		};

	}]);