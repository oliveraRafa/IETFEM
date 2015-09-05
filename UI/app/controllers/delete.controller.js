var app = angular.module('IETFEM');
	app.controller('deleteCtrl',['$scope','ModelService','SpaceService','LineaSelecService','PtoSelecService',function($scope,ModelService,SpaceService,LineaSelecService,PtoSelecService){
		this.existsLineToRemove= function(){
			return LineaSelecService.getLinea().id != 0;
		};

		this.existsPointToRemove= function(){
			return PtoSelecService.getPunto().id != 0;
		};

		this.deleteLine = function(){
			var lineToRemove= LineaSelecService.getLinea();
			var sceneObject =$scope.scene.getObjectById(lineToRemove.sceneId);
			
			ModelService.removeLineFromModel(lineToRemove.id,$scope.model);
			LineaSelecService.resetLineaSeleccionada();
			$scope.scene.remove(sceneObject);

			$scope.render();
		};

		this.deleteNode = function(){
			var nodeToRemove= PtoSelecService.getPunto();
			var sceneObjectFirst = $scope.scene.getObjectById(nodeToRemove.sceneId);

			var lineasImplicadas= getLinesByNode(nodeToRemove.id);
			for (var i = 0; i < lineasImplicadas.length ;i++){//Elimino tambien lineas que tenian ese nodo
				var lineToRemove= lineasImplicadas[i];
				var sceneObject =$scope.scene.getObjectById(lineToRemove.sceneId);
				
				ModelService.removeLineFromModel(lineToRemove.id,$scope.model);
				$scope.scene.remove(sceneObject);
			}

			PtoSelecService.resetPuntoSeleccionado();
			ModelService.removePointFromModel(nodeToRemove.id,$scope.model);
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